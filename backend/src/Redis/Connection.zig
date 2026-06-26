const std = @import("std");
const settings = @import("../Settings.zig");
const redis = @cImport(
    @cInclude("hiredis/hiredis.h")
    );

var connection: ?*redis.redisContext = undefined;
const addr: [*]const u8 = "127.0.0.1";
const port: u16 = 6379;

var redis_mutex = std.Io.Mutex.init;

pub fn Connect() !void {
    connection = redis.redisConnect(
        settings.Current.RedisParams.Address.ptr,
        settings.Current.RedisParams.Port);

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

pub fn WriteToTopic(io: std.Io, topic: []const u8, message: Message) !void {
    try redis_mutex.lock(io);
    defer redis_mutex.unlock(io);

    const rep = redis.redisCommand(connection, "SET %b:%b %b EX %d", 
        topic.ptr, topic.len,
        message.Key.ptr, message.Key.len,
        message.Value.ptr, message.Value.len,
        message.SecondsToLive); 

    if (rep != null) {
        redis.freeReplyObject(rep);
    }
}

pub fn ReadFromTopic(io: std.Io, allocator: std.mem.Allocator, topic: []const u8, Key: []const u8) !?[]const u8 {
    try redis_mutex.lock(io);
    defer redis_mutex.unlock(io);

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

pub fn DeleteKey(io: std.Io, key: []const u8) !void {
    try redis_mutex.lock(io);
    defer redis_mutex.unlock(io);

    _ = redis.redisCommand(connection, "DEL %b", key.ptr, key.len,); 
}

pub fn QueryTopic(io: std.Io, allocator: std.mem.Allocator, topic: []const u8) !?std.ArrayList([]const u8) {
    try redis_mutex.lock(io);
    defer redis_mutex.unlock(io);

    const raw = redis.redisCommand(connection, "KEYS %b", topic.ptr, topic.len);
    if (raw == null) {
        std.debug.print("raw is null\n", .{});
        return null;
    }
    defer {
        redis.freeReplyObject(raw);
    }
    const resp: *redis.redisReply = @alignCast(@ptrCast(raw));
    if (resp.type != redis.REDIS_REPLY_ARRAY) {
        std.debug.print("wrong resp type\n", .{});
        return null;
    }

    const len = resp.elements;
    var outp: std.ArrayList([]const u8) = .empty;
    for (0..len) |i| {
        const element: *redis.redisReply = resp.element[i].?;
        const slice = element.str[0..@as(usize, @intCast(element.len))];
        try outp.append(allocator, try allocator.dupe(u8, slice));
    }
    return outp;
}

test "Redis connection" {
    const alloc = std.testing.allocator;
    const io = std.testing.io;

    try settings.ReadConfig(alloc, io);
    defer settings.Deinit(alloc);

    try Connect();
    defer Disconnect();

    try WriteToTopic(io, "test", Message {
        .Key = "key",
        .Value = "value",
        .SecondsToLive = 1,
    });


    var resp = try ReadFromTopic(io, alloc, "test", "key");
    try std.testing.expectEqualStrings("value", resp orelse "not found");

    try std.testing.io.sleep(.fromSeconds(2), .awake);

    // std.Thread.sleep(1_500_000_000);
    // KVP TTL check
    if (resp) |r|  {
        alloc.free(r);
    }
    resp = try ReadFromTopic(io, alloc, "test", "key");
    try std.testing.expectEqualStrings("not found", resp orelse "not found");
    if (resp) |r|  {
        defer alloc.free(r);
    }
}
