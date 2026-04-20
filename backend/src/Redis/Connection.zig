const std = @import("std");
const redis = @cImport(
    @cInclude("hiredis/hiredis.h")
    );

var connection: ?*redis.redisContext = undefined;
const addr: [*]const u8 = "127.0.0.1";
const port: u16 = 6379;

pub fn Connect() !void {
    connection = redis.redisConnect(addr, port);
    if (connection == null or connection.?.err != 0) {
        if (connection != null) {
            @panic(&connection.?.errstr);
        }
        @panic("The redis connection failed: general error");
    }
}

pub fn Disconnect() void {
    redis.redisFree(connection);
}

pub const Message = struct {
    Key: []const u8,
    Value: []const u8,
    SecondsToLive: u16
};

pub fn WriteToTopic(topic: []const u8, message: Message) !void {
    const rep = redis.redisCommand(connection, "SET %b:%b %b EX %d", 
        topic.ptr, topic.len,
        message.Key.ptr, message.Key.len,
        message.Value.ptr, message.Value.len,
        message.SecondsToLive); 

    if (rep != null) {
        redis.freeReplyObject(rep);
    }
}

pub fn ReadFromTopic(allocator: std.mem.Allocator, topic: []const u8, Key: []const u8) !?[]const u8 {
    const raw = redis.redisCommand(connection, "GET %b:%b", 
            topic.ptr, topic.len,
            Key.ptr, Key.len);
    if (raw == null) {
        return null;
    }
    defer {
        redis.freeReplyObject(raw);
    }
    const resp: *redis.redisReply = @alignCast(@ptrCast(raw));
    if (resp.type != redis.REDIS_REPLY_STRING) {
        return null;
    }
    return try allocator.dupe(u8, resp.str[0..resp.len]);
}

test "Redis connection" {
    try Connect();
    defer Disconnect();

    try WriteToTopic("test", Message {
        .Key = "key",
        .Value = "value",
        .SecondsToLive = 1,
    });

    const alloc = std.testing.allocator;

    var resp = try ReadFromTopic(alloc, "test", "key");
    try std.testing.expectEqualStrings("value", resp orelse "not found");
    std.Thread.sleep(1_500_000_000);
    // KVP TTL check
    if (resp) |r|  {
        alloc.free(r);
    }
    resp = try ReadFromTopic(alloc, "test", "key");
    try std.testing.expectEqualStrings("not found", resp orelse "not found");
    if (resp) |r|  {
        defer alloc.free(r);
    }
}
