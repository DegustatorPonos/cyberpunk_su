const std = @import("std");
const httpz = @import("httpz");
const userModel = @import("Models/User.zig");
const tokens = @import("Authentication/Tokens.zig");
const redis = @import("Redis/Connection.zig");
const settings = @import("Settings.zig");

const cacheTopicName = "cp2020_cache";
const cacheTopicQuery= "cp2020_cache:*";

pub const authError = error {
    Unauthorized,
    Forbidden,
};

pub const RequestData = struct {
    User: ?userModel.User,
    Io: std.Io,

    pub fn Init(req: *httpz.Request, io: std.Io) !RequestData {
        return .{
            .Io = io,
            .User = try getUser(io, req),
        };
    }

    fn getUser(io: std.Io, req: *httpz.Request) !?userModel.User {
        const header = req.header("authorization") orelse return null;
        const stripped = stripBearerPrefix(header);
        const parsed = tokens.GetUserFromToken(io,  req.arena, stripped) catch |err| {
            if (err == tokens.errors.NotFound) {
                return null;
            }
            std.debug.print("Failed to parse a user: {any}\n", .{ err });
            return err;
        } orelse {
            return null;
        };

        return parsed.value;
    }

    pub fn CanUserAccess(self: RequestData, minimalRole: userModel.Role) bool {
        if (self.User == null) return false;
        return self.User.?.Role >= minimalRole;
    }

    /// This function returns an error that is caught by a handler. Add this to
    /// the start of the handler to add an auth
    pub fn CheckAccess(self: RequestData, minimalRole: userModel.Role) authError!void {
        if (self.User == null) return authError.Unauthorized;
        if (@intFromEnum(self.User.?.Role) < @intFromEnum(minimalRole)) 
            return authError.Forbidden;
    }
};

pub const Handler = struct {
    io: std.Io,

    pub fn dispatch(self: *Handler, action: httpz.Action(*RequestData), req: *httpz.Request, res: *httpz.Response) !void {
        var data = try RequestData.Init(req, self.io);

        // checking the redis cache
        const cached = shouldCache(req);
        if (cached) {
            if (try redis.ReadFromTopic(self.io, req.arena, cacheTopicName, req.url.raw)) |found| {
                std.debug.print("{any} {s} (from cache): {d}\n", .{req.method, req.url.raw, res.status});
                res.body = found;
                res.content_type = .JSON;
                return;
            }
        }

        action(&data, req, res) catch |err| {
            switch (err) {
                authError.Forbidden => res.setStatus(.forbidden),
                authError.Unauthorized => res.setStatus(.unauthorized),
                else => return err
            }
        };

        std.debug.print("{any} {s}: {d}\n", .{req.method, req.url.raw, res.status});
        // refreshing the redis cache
        if (cached and res.status == 200) {
            redis.WriteToTopic(self.io, cacheTopicName, .{
                .Key = req.url.raw,
                .SecondsToLive = settings.Current.CacheTTL,
                .Value = res.buffer.written(),
            }) catch |err| {
                std.debug.print("Failed to cache the responce: {any}\n", .{ err });
            };
        }
        // std.debug.print("responce {s}\n", .{ res.buffer.written() });
    }
};

const headerPrefix = "Bearer ";

fn stripBearerPrefix(header: []const u8) []const u8 {
    if (std.mem.startsWith(u8, header, headerPrefix)) {
        return header[headerPrefix.len..];
    }
    return header;
}

const paths_to_cache = [_][]const u8 {
    "/static",
    "/index",
    "/classes",
    "/weapons/ranged",
};

fn shouldCache(req: *httpz.Request) bool {
    if (req.method != .GET) return false;
    const req_path = req.url.path;
    for (paths_to_cache) |path| {
        if (req_path.len >= path.len and std.mem.eql(u8, path, req_path[0..path.len]))
            return true;
    }
    return false;
}

pub fn clearCachedPages(io: std.Io, alloc: std.mem.Allocator) !void {
    const saved = try redis.QueryTopic(io, alloc, cacheTopicQuery) orelse return;
    for (saved.items) |el| {
        try redis.DeleteKey(io, el);
    }
}
