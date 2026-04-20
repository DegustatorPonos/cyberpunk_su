const std = @import("std");
const redis = @import("../Redis/Connection.zig");
const userModel = @import("../Models/User.zig");

const topicName = "cp2020_auth";
const token_ttl: u16 = 43_200; // 12 hours

var prng: std.Random.DefaultPrng= undefined;
var rnd: std.Random = undefined;

const errors = error {
    NotFound,
};

pub fn Init() !void {
    // Random enough
    var seed: u64 = undefined;
    try std.posix.getrandom(std.mem.asBytes(&seed));
    prng = std.Random.DefaultPrng.init(seed);
    rnd = prng.random();
}

/// Generates a new token in the stack. Expects [64]u8 as an input 
fn generateSessionToken(buf: []u8) []u8 {
    for (0..64) |i| {
        buf[i] = std.Random.intRangeAtMost(rnd, u8, 'A', 'z');
        if (buf[i] == '\\') {
            buf[i] = '@';
        }
    }
    return buf;
}

pub fn GenerateNewSession(allocator: std.mem.Allocator, user: userModel.User) ![]u8 {
    const token: []u8 = try allocator.alloc(u8, 64);
    const newToken = generateSessionToken(token);

    // Redis cache 
    var string: std.io.Writer.Allocating = .init(allocator);
    defer string.deinit();
    try string.writer.print("{f}", .{ std.json.fmt(user, .{}) });
    try redis.WriteToTopic(topicName, redis.Message {
        .Key = token,
        .Value = string.written(),
        .SecondsToLive = token_ttl,
    });

    return newToken;
}

pub fn GetUserFromToken(allocator: std.mem.Allocator, token: []const u8) !?std.json.Parsed(userModel.User) {
    const saved = try redis.ReadFromTopic(allocator, topicName, token) orelse {
        // std.debug.print("The token was not found \n", .{});
        return errors.NotFound;
    };

    const parsed = try std.json.parseFromSlice(
        userModel.User,
        allocator,
        saved, 
        .{ 
            .ignore_unknown_fields = true,
        });
    return parsed;
}
