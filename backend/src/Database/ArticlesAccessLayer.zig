// You are not supposed to include this file. To access this you should use
// Connection.RangedWeapons. 

const conn = @import("Connection.zig");
const std = @import("std");
const pg = @import("pg");
const model = @import("../Models/Article.zig");

/// Gets `pageLength` elements with the offset `page*pageLength`. Page indexing strats with 0
pub fn GetAll(alloc: std.mem.Allocator, pageLength: u16, page: u16) !std.ArrayList(model.Article) {
    const query = "SELECT * FROM Articles ORDER BY updated_at LIMIT $1 OFFSET $2";
    var result = try conn.pool.query(query, .{
        pageLength,
        page * pageLength,
    });
    defer _ = result.deinit();

    var outp: std.ArrayList(model.Article) = .empty;
    while (try result.next()) |row| {
        var newArticle = try model.Article.MapWithAlloc(alloc, &row);
        try newArticle.init_body(alloc);
        try outp.append(alloc, newArticle);
    }
    return outp;
}

/// Gets `pageLength` elements with the offset `page*pageLength`. Page indexing strats with 0
pub fn GetByLanguage(alloc: std.mem.Allocator, language: []const u8, pageLength: u16, page: u16) !std.ArrayList(model.Article) {
    std.debug.print("Searching articles in {s}...\n", .{ language });
    const query = 
        \\ SELECT * FROM Articles 
        \\ WHERE language LIKE $1 
        \\ ORDER BY updated_at
        \\ LIMIT $2
        \\ OFFSET $3
        ;
    var result = try conn.pool.query(query, .{
        language,
        pageLength,
        page * pageLength,
    });
    defer _ = result.deinit();

    var outp: std.ArrayList(model.Article) = .empty;
    while (try result.next()) |row| {
        var newArticle = try model.Article.MapWithAlloc(alloc, &row);
        try newArticle.init_body(alloc);
        try outp.append(alloc, newArticle);
    }
    return outp;
}

pub fn InitializeData(script: []const u8) !void {
    _ = try conn.pool.exec(script, .{});
}
