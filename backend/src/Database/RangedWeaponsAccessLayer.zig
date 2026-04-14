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
        const newRW = try model.RangedWeaponType.Map(&row);
        try outp.append(alloc, newRW);
    }
    return outp;
}
