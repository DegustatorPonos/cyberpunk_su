// You are not supposed to include this file. To access this you should use
// Connection.RangedWeapons. 

const conn = @import("Connection.zig");
const std = @import("std");
const pg = @import("pg");
const model = @import("../Models/RangedWeapon.zig");

pub fn GetAll(alloc: std.mem.Allocator) !std.ArrayList(model.RangedWeaponType) {
    const query = "SELECT * FROM RangedWeapons";
    var result = try conn.pool.query(query, .{});
    defer _ = result.deinit();

    var outp: std.ArrayList(model.RangedWeaponType) = .empty;
    while (try result.next()) |row| {
        const newRW = try model.RangedWeaponType.MapWithAlloc(alloc, &row);
        try outp.append(alloc, newRW);
    }
    return outp;
}

pub fn GetByDisplayName(allocator: std.mem.Allocator, displayName: []const u8) !model.RangedWeaponType {
    const query = "SELECT * FROM RangedWeapons WHERE Id = $1";
    var row = try conn.pool.row(query, .{displayName}) orelse {
        return conn.ResultErrors.NotFound;
    };

    const outp = try model.RangedWeaponType.MapWithAlloc(allocator, &row.row);
    try row.deinit();
    return outp;
}
