const std = @import("std");
const pg = @import("pg");
const dotenv = @import("dotenv");

var pool: *pg.Pool = undefined;

pub fn Connect(alloc: std.mem.Allocator) !void {
    var env = try dotenv.init(alloc, ".env");
    defer env.deinit();

    pool = try pg.Pool.init(alloc, .{
        .size = 5,
        .connect = .{
            .port = 5432,
            .host = "localhost"
        },
        .auth = .{
            .database = "cyber2020",
            .username = env.get("PG_USERNAME") orelse unreachable,
            .password = env.get("PG_PASSWORD") orelse unreachable,
            .timeout = 10_000
        }
    });
}

pub fn Disconnect() void {
    pool.deinit();
}
