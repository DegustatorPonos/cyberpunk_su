const std = @import("std");
const pg = @import("pg");
const dotenv = @import("dotenv");
const settings = @import("../Settings.zig");

pub const ResultErrors = error {
    NotFound,
    AlreadyExists
};

pub var pool: *pg.Pool = undefined;

const EnvKeys = enum {
    PG_USERNAME,
    PG_PASSWORD,
};

pub fn Connect(init: std.process.Init) !void {
    var env = dotenv.init(init, EnvKeys);
    defer env.deinit();

    try env.load(.{
        .include_current_process_envs = true,
    });

    std.debug.print("Connecting to the db at {s}\n", .{settings.Current.DbParams.Address});
    pool = pg.Pool.init(init.io, init.gpa, .{
        .size = 5,
        .connect = .{
            .port = settings.Current.DbParams.Port,
            .host = settings.Current.DbParams.Address,
        },
        .auth = .{
            .database = "cyber2020",
            .username = env.key(.PG_USERNAME),
            .password = env.key(.PG_PASSWORD),
            .timeout = 10_000
        }
    }) catch |err| {
        std.debug.print("Failed to connect to postgres", .{});
        return err;
    };
}

pub fn Disconnect() void {
    pool.deinit();
}

pub const Users = @import("UserAccessLayer.zig");
pub const RangedWeapons = @import("RangedWeaponsAccessLayer.zig");
pub const Articles = @import("ArticlesAccessLayer.zig");
