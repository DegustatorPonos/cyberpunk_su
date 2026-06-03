const std = @import("std");
const httpz = @import("httpz");
const userModel = @import("Models/User.zig");
const tokens = @import("Authentication/Tokens.zig");

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
            .User = try getUser(req),
        };
    }

    fn getUser(req: *httpz.Request) !?userModel.User {
        const header = req.header("authorization") orelse return null;
        const stripped = stripBearerPrefix(header);
        const parsed = tokens.GetUserFromToken(req.arena, stripped) catch |err| {
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
        // std.debug.print("Data: {any}\n", .{ data });
        action(&data, req, res) catch |err| {
            switch (err) {
                authError.Forbidden => {
                    res.setStatus(.forbidden);
                },
                authError.Unauthorized => {
                    res.setStatus(.unauthorized);
                },
                else => {
                    return err;
                }
            }
        };
        std.debug.print("{any} {s}: {d}\n", .{req.method, req.url.raw, res.status});
    }
};

const headerPrefix = "Bearer ";

fn stripBearerPrefix(header: []const u8) []const u8 {
    if (std.mem.startsWith(u8, header, headerPrefix)) {
        return header[headerPrefix.len..];
    }
    return header;
}
