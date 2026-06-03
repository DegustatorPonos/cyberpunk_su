const std = @import("std");
const pg = @import("pg");
const dotenv = @import("dotenv");

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

    pool = try pg.Pool.init(init.io, init.gpa, .{
        .size = 5,
        .connect = .{
            .port = 5432,
            .host = "localhost"
        },
        .auth = .{
            .database = "cyber2020",
            .username = env.key(.PG_USERNAME),
            .password = env.key(.PG_PASSWORD),
            .timeout = 10_000
        }
    });
}

pub fn Disconnect() void {
    pool.deinit();
}

pub const Users = @import("UserAccessLayer.zig");
pub const RangedWeapons = @import("RangedWeaponsAccessLayer.zig");
