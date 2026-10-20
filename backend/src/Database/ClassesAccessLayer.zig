// You are not supposed to include this file. To access this you should use
// Connection.Classes 

const conn = @import("Connection.zig");
const std = @import("std");
const pg = @import("pg");
const model = @import("../Models/Classes/Class.zig");

pub fn GetAll(alloc: std.mem.Allocator) !std.ArrayList(model.Class) {
    const query = "SELECT name, origin FROM Classes";
    var result = try conn.pool.query(query, .{});
    defer _ = result.deinit();

    var outp: std.ArrayList(model.Class) = .empty;
    while (try result.next()) |row| {
        const newClass = try model.Class.MapWithAlloc(alloc, &row);
        try outp.append(alloc, newClass);
    }

    return outp;
}

pub fn Exists(className: []const u8) !bool {
    const query = "SELECT name FROM Classes WHERE name = $1";
    var row = try conn.pool.row(query, .{ className }) orelse return false;
    try row.deinit();
    return true;
}

pub fn Create(newClass: *model.Class) !void {
    if (try Exists(newClass.Name)) return conn.ResultErrors.AlreadyExists;
    const query = "INSERT INTO Classes (name, origin) VALUES ($1, $2)";
    _ = try conn.pool.exec(query, .{ newClass.Name, newClass.Origin });
}

pub fn GetDescription(allocator: std.mem.Allocator, className: []const u8, language: []const u8) !model.ClassDescription {
    const query = 
        \\ SELECT class_name, language, imageurl, contents 
        \\ FROM ClassDescriptions WHERE class_name = $1 AND language = $2
        ;
    var row = try conn.pool.row(query, .{ className, language }) orelse {
        return conn.ResultErrors.NotFound;
    };

    const outp = try model.ClassDescription.MapWithAlloc(allocator, &row.row);
    try row.deinit();

    return outp;
}

pub fn SetDescription(desc: model.ClassDescription) !void {
    std.debug.print("Inserting a desc for {s}\n", .{desc.ClassName});
    const query =
        \\ INSERT INTO ClassDescriptions (class_name, language, imageurl, contents)
        \\ VALUES ($1, $2, $3, $4)
        \\ ON CONFLICT (class_name, language)
        \\ DO UPDATE SET 
        \\     contents = EXCLUDED.contents,
        \\     imageurl = EXCLUDED.imageurl
        ;

    _ = try conn.pool.exec(query, .{
        desc.ClassName,
        desc.Language,
        desc.ImageURL,
        desc.Contents,
    });
}
