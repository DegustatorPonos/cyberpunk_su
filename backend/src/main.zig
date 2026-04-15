const std = @import("std");
const backend = @import("backend");
const httpz = @import("httpz");
const db = @import("Database/Connection.zig");
const handler = @import("Handler.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var httpHandler = handler.Handler {
    };

    var server = try httpz.Server(*handler.Handler).init(allocator, .{
        .address = .all(6969),
    }, &httpHandler);

    defer {
        server.stop();
        server.deinit();
    }

    var router = try server.router(.{});
    router.get("/", index, .{});

    @import("API/WeaponsAPI.zig").RegisterEndpoints(router);
    @import("API/AuthenticationAPI.zig").RegisterEndpoints(router);
    
    // PSQL connection
    try db.Connect(allocator);
    defer db.Disconnect();

    var outp = try db.RangedWeapons.GetAll(allocator);
    outp.deinit(allocator);

    try server.listen();
}

fn index(_: *handler.Handler, _: *httpz.Request, res: *httpz.Response) !void {
    res.status = 200;
    try res.json(.{.status = "OK"}, .{});
}

test "TestRunner" {
    _ = @import("Models/RangedWeapon.zig");
    _ = @import("Models/User.zig");
    _ = @import("Authentication/Password.zig");
}
