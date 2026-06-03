const std = @import("std");
const backend = @import("backend");
const httpz = @import("httpz");
const db = @import("Database/Connection.zig");
const handler = @import("Handler.zig");
const tokens = @import("Authentication/Tokens.zig");
const redis = @import("Redis/Connection.zig");
const settings = @import("Settings.zig");

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;

    try settings.ReadConfig(allocator, init.io);

    try tokens.Init(init.io);
    
    // PSQL connection
    try db.Connect(init);
    defer db.Disconnect();

    try redis.Connect();
    defer redis.Disconnect();

    var httpHandler = handler.Handler {
        .io = init.io,
    };

    var server = try httpz.Server(*handler.Handler).init(init.io, allocator, .{
        .address = .all(settings.Current.Port),
    }, &httpHandler);

    const cors = try server.middleware(httpz.middleware.Cors, .{
        .origin = settings.Current.CorsParams.Origin,
        .methods = settings.Current.CorsParams.Methods,
        .headers = settings.Current.CorsParams.Headers,
    });

    defer {
        server.stop();
        server.deinit();
    }
   
    var router = try server.router(.{
        .middlewares = &.{
            cors
        }
    });
    router.get("/", index, .{});

    @import("API/WeaponsAPI.zig").RegisterEndpoints(router);
    @import("API/AuthenticationAPI.zig").RegisterEndpoints(router);

    try server.listen();
    settings.Deinit(allocator);
}

fn index(_: *handler.RequestData, _: *httpz.Request, res: *httpz.Response) !void {
    try res.json(.{.Message = "Ok"}, .{});
}

test "TestRunner" {
    _ = @import("Models/RangedWeapon.zig");
    _ = @import("Models/User.zig");
    _ = @import("Authentication/Password.zig");
    _ = redis;
}
