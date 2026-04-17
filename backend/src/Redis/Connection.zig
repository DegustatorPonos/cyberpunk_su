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
    _ = redis.redisCommand(connection, "SET %s:%s %s EX %d", 
        topic.ptr,
        message.Key.ptr,
        message.Value.ptr,
        message.SecondsToLive); 
}

pub fn ReadFromTopic(topic: []const u8, Key: []const u8) ?[]const u8 {
    const raw = redis.redisCommand(connection, "GET %s:%s", 
            topic.ptr,
            Key.ptr);
    if (raw == null) {
        return null;
    }
    const resp: *redis.redisReply = @alignCast(@ptrCast(raw));
    if (resp.type != redis.REDIS_REPLY_STRING) {
        return null;
    }
    return std.mem.span(resp.str);
}
