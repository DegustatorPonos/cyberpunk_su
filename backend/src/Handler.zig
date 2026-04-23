const std = @import("std");
const httpz = @import("httpz");
const userModel = @import("Models/User.zig");
const tokens = @import("Authentication/Tokens.zig");

pub const RequestData = struct {
    User: ?userModel.User,

    pub fn Init(req: *httpz.Request) !RequestData {
        return .{
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
};

pub const Handler = struct {
    pub fn dispatch(_: *Handler, action: httpz.Action(*RequestData), req: *httpz.Request, res: *httpz.Response) !void {
        var data = try RequestData.Init(req);
        // std.debug.print("Data: {any}\n", .{ data });
        try action(&data, req, res);
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
