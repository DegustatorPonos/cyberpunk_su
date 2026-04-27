// You are not supposed to include this file. To access this you should use
// Connection.RangedWeapons. 

const conn = @import("Connection.zig");
const std = @import("std");
const pg = @import("pg");
const model = @import("../Models/RangedWeapon.zig");
const descriptionModel = @import("../Models/Description.zig");

pub fn GetAll(alloc: std.mem.Allocator) !std.ArrayList(model.RangedWeaponType) {
    const query = "SELECT * FROM RangedWeapons ORDER BY weapon_type";
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

pub fn Update(displayName: []const u8, updatedModel: *model.RangedWeaponType) !void {
    if (!try Exists(displayName)) return conn.ResultErrors.NotFound;
    const query = 
        \\ UPDATE RangedWeapons SET
        \\ id = $1,
        \\ name = $2,
        \\ weapon_type = $3,
        \\ accuracy = $4,
        \\ concealability = $5,
        \\ availability = $6,
        \\ damage = $7,
        \\ ammunition = $8,
        \\ number_of_shots = $9,
        \\ rate_of_fire = $10,
        \\ reliability = $11,
        \\ updated_at = CURRENT_TIMESTAMP
        \\ WHERE id = $12
        ;

    _ = try conn.pool.exec(query, .{
        updatedModel.Id,
        updatedModel.Name,
        updatedModel.WeaponType,
        updatedModel.Accuracy,
        updatedModel.Concealability,
        updatedModel.Avaliability,
        updatedModel.Damage,
        updatedModel.Ammunition,
        updatedModel.NumberOfShots,
        updatedModel.RateOfFire,
        updatedModel.Reliability,
        displayName,
    });
}

pub fn Create(NewWeapon: *model.RangedWeaponType) !void {
    if (try Exists(NewWeapon.Id)) return conn.ResultErrors.AlreadyExists;
    const query = 
        \\ INSERT INTO RangedWeapons 
        \\ (id, name, weapon_type, accuracy, concealability, availability, damage, ammunition, number_of_shots, rate_of_fire, reliability)
        \\ VALUES
        \\ ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
        ;

    _ = try conn.pool.exec(query, .{
        NewWeapon.Id,
        NewWeapon.Name,
        NewWeapon.WeaponType,
        NewWeapon.Accuracy,
        NewWeapon.Concealability,
        NewWeapon.Avaliability,
        NewWeapon.Damage,
        NewWeapon.Ammunition,
        NewWeapon.NumberOfShots,
        NewWeapon.RateOfFire,
        NewWeapon.Reliability,
    });
}

pub fn Exists(displayName: []const u8) !bool {
    const query = "SELECT Id FROM RangedWeapons WHERE Id = $1";
    var row = try conn.pool.row(query, .{displayName}) orelse {
        return false;
    };
    try row.deinit();
    return true;
}

pub fn Delete(displayName: []const u8) !void {
    const query = "DELETE FROM RangedWeapons WHERE Id = $1";
    _ = try conn.pool.exec(query, .{
        displayName,
    });
}

pub fn GetDescription(allocator: std.mem.Allocator, displayName: []const u8, language: []const u8) !descriptionModel.Description {
    const query = "SELECT * FROM RangedWeaponsDescriptions WHERE id = $1 AND language = $2";
    var row = try conn.pool.row(query, .{displayName, language}) orelse {
        return conn.ResultErrors.NotFound;
    };
    const outp = try descriptionModel.Description.MapWithAlloc(allocator, &row.row);
    try row.deinit();
    return outp;
}

pub fn SetDescription(Model: descriptionModel.Description) !void {
    const query =
        \\ INSERT INTO RangedWeaponsDescriptions (id, language, contents)
        \\ VALUES ($1, $2, $3)
        \\ ON CONFLICT (id, language) 
        \\ DO UPDATE SET contents = EXCLUDED.contents
        ;

    _ = try conn.pool.exec(query, .{
        Model.Id,
        Model.Language,
        Model.Contents,
    });
}
