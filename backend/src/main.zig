const std = @import("std");
const backend = @import("backend");
const httpz = @import("httpz");
const tests = @import("tests.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var server = try httpz.Server(void).init(allocator, .{
        .address = .all(6969),
    }, {});

    defer {
        server.stop();
        server.deinit();
    }

    var router = try server.router(.{});
    router.get("/", index, .{});

    try server.listen();
}

fn index(_: *httpz.Request, res: *httpz.Response) !void {
    res.status = 200;
    try res.json(.{.status = "OK"}, .{});
}

test "TestRunner" {
    std.testing.refAllDecls(@This());
}
