// You are not supposed to include this file. To access this you should use
// Connection.RangedWeapons. 

const conn = @import("Connection.zig");
const std = @import("std");
const pg = @import("pg");
const model = @import("../Models/Article.zig");

pub fn GetAll(alloc: std.mem.Allocator) !std.ArrayList(model.Article) {
    const query = "SELECT * FROM Articles ORDER BY updated_at";
    var result = try conn.pool.query(query, .{});
    defer _ = result.deinit();

    var outp: std.ArrayList(model.Article) = .empty;
    while (try result.next()) |row| {
        var newArticle = try model.Article.MapWithAlloc(alloc, &row);
        try newArticle.init_body(alloc);
        try outp.append(alloc, newArticle);
    }
    return outp;
}
