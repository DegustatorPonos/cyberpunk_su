// You are not supposed to include this file. To access this you should use
// Connection.Classes 

const conn = @import("Connection.zig");
const std = @import("std");
const pg = @import("pg");
const model = @import("../Models/Classes/Class.zig");

pub fn GetByName(alloc: std.mem.Allocator, name: []const u8) !model.Class {
    const query = 
        \\ SELECT name, origin, preview_picture_url 
        \\ FROM Classes WHERE name = $1
        ;
    var row = try conn.pool.row(query, .{ name }) 
        orelse return conn.ResultErrors.NotFound;

    const outp = model.Class.MapWithAlloc(alloc, &row.row) catch |err| {
        try row.deinit();
        return err;
    };

    try row.deinit();
    return outp;
}

pub fn GetAll(alloc: std.mem.Allocator) !std.ArrayList(model.Class) {
    const query = "SELECT name, origin, preview_picture_url FROM Classes ORDER BY name";
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
    const query = 
        \\ INSERT INTO Classes (name, origin, preview_picture_url) 
        \\ VALUES ($1, $2, $3)
        ;
    _ = try conn.pool.exec(query, .{ 
        newClass.Name, 
        newClass.Origin,
        newClass.PreviewPicture,
    });
}

pub fn Update(class: *model.Class) !void {
    if (!try Exists(class.Name)) return conn.ResultErrors.AlreadyExists;
    const query = 
        \\ UPDATE Classes SET 
        \\ origin = $1,
        \\ preview_picture_url = $2
        \\ WHERE name = $3
        ;

    _ = try conn.pool.exec(query, .{
        class.Origin,
        class.PreviewPicture,
        class.Name,
    });
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
    // std.debug.print("Inserting a desc for {s}\n", .{desc.ClassName});
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
