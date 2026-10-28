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
    defer settings.Deinit(allocator);

    try tokens.Init(init.io);

    // PSQL connection
    try db.Connect(init);
    defer db.Disconnect();

    try redis.Connect();
    defer redis.Disconnect();

    try handler.clearCachedPages(init.io, init.gpa);

    // Inititalizing the articles
    const articlesInitScript = try LoadArticleConfigFile(init.io, init.gpa);
    defer init.gpa.free(articlesInitScript);
    try db.Articles.InitializeData(articlesInitScript);

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
        .credentials = if (settings.Current.CorsParams.AllowCredentials) "true" else "",
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

    @import("FS/StaticFileServer.zig").RegisterEndpoints(router);

    @import("API/WeaponsAPI.zig").RegisterEndpoints(router);
    @import("API/AuthenticationAPI.zig").RegisterEndpoints(router);
    @import("API/IndexPostsAPI.zig").RegisterEndpoints(router);
    @import("API/ClassesAPI.zig").RegisterEndpoints(router);
    @import("API/SkillsAPI.zig").RegisterEndpoints(router);

    try server.listen();
}

fn index(_: *handler.RequestData, _: *httpz.Request, res: *httpz.Response) !void {
    try res.json(.{.Message = "Ok"}, .{});
}

fn LoadArticleConfigFile(io: std.Io, alloc: std.mem.Allocator) ![]const u8 {
    const cwd = std.Io.Dir.cwd();
    const contents = try cwd.readFileAlloc(
        io, 
        settings.Current.Paths.ArticlesScript, 
        alloc, .unlimited);
    return contents;
}

test "TestRunner" {
    _ = @import("Models/RangedWeapon.zig");
    _ = @import("Models/User.zig");
    _ = @import("Authentication/Password.zig");
    _ = redis;
}
