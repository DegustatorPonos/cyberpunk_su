const std = @import("std");
const pg = @import("pg");

pub const RangedWeaponType = struct {
    Id: []const u8,
    Name: []const u8,

    WeaponType: []const u8,
    Accuracy: i32,
    Concealability: []const u8,
    Avaliability: []const u8,
    Damage: []const u8,
    Ammunition: []const u8,
    NumberOfShots: u31,
    RateOfFire: u32,
    Reliability: []const u8,

    CreatedAt: i64,
    UpdatedAt: i64,

    pub fn GetCompactNotation(self: *RangedWeaponType, separator: u8) ![]const u8 {
        var b: [64]u8 = undefined;
        return try std.fmt.bufPrint(&b, 
            "{s}{c}{d}{c}{s}{c}{s}{c}{s}({s}){c}{d}{c}{d}{c}{s}", 
            .{
                self.WeaponType, separator,
                self.Accuracy, separator,
                self.Concealability, separator,
                self.Avaliability, separator,
                self.Damage,
                self.Ammunition, separator,
                self.NumberOfShots, separator,
                self.RateOfFire, separator,
                self.Reliability,
            });
    }

    // Parses the db row and returns the result. You are expected to use the
    // actual DB schema and use * as a fields selector
    pub fn Map(row: *const pg.Row) !RangedWeaponType {
        return RangedWeaponType {
            .Id = try row.get([]const u8, 0),
            .Name = try row.get([]const u8, 1),
            .WeaponType = try row.get([]const u8, 2),
            .Accuracy = try row.get(i32, 3),
            .Concealability = try row.get([]const u8, 4),
            .Avaliability = try row.get([]const u8, 5),
            .Damage = try row.get([]const u8, 6),
            .Ammunition = try row.get([]const u8, 7),
            .NumberOfShots = @intCast(try row.get(i32, 8)),
            .RateOfFire = @intCast(try row.get(i32, 9)),
            .Reliability = try row.get([]const u8, 10),
            .CreatedAt = try row.get(i64, 11),
            .UpdatedAt = try row.get(i64, 12),
        };
    }

    // Parses the db row and returns the result. You are expected to use the
    // actual DB schema and use * as a fields selector
    pub fn MapWithAlloc(allocator: std.mem.Allocator, row: *const pg.Row) !RangedWeaponType {
        return RangedWeaponType {
            .Id = try allocator.dupe(u8, try row.get([]const u8, 0)),
            .Name = try allocator.dupe(u8, try row.get([]const u8, 1)),
            .WeaponType = try allocator.dupe(u8, try row.get([]const u8, 2)),
            .Accuracy = try row.get(i32, 3),
            .Concealability = try allocator.dupe(u8, try row.get([]const u8, 4)),
            .Avaliability = try allocator.dupe(u8, try row.get([]const u8, 5)),
            .Damage = try allocator.dupe(u8, try row.get([]const u8, 6)),
            .Ammunition = try allocator.dupe(u8, try row.get([]const u8, 7)),
            .NumberOfShots = @intCast(try row.get(i32, 8)),
            .RateOfFire = @intCast(try row.get(i32, 9)),
            .Reliability = try allocator.dupe(u8, try row.get([]const u8, 10)),
            .CreatedAt = try row.get(i64, 11),
            .UpdatedAt = try row.get(i64, 12),
        };
    }

};


// The full model is causing error.MissingFields if we don't specify readonly
// CreatedAt and UpdatedAt fields
pub const RequestBody = struct {
    Id: []const u8,
    Name: []const u8,
    WeaponType: []const u8,
    Accuracy: i32,
    Concealability: []const u8,
    Avaliability: []const u8,
    Damage: []const u8,
    Ammunition: []const u8,
    NumberOfShots: u31,
    RateOfFire: u32,
    Reliability: []const u8,

    pub fn ToModel(this: RequestBody) RangedWeaponType {
        return RangedWeaponType {
            .Id = this.Id,
            .Name = this.Name,
            .WeaponType = this.WeaponType,
            .Accuracy = this.Accuracy,
            .Concealability = this.Concealability,
            .Avaliability = this.Avaliability,
            .Damage = this.Damage,
            .Ammunition = this.Ammunition,
            .NumberOfShots = this.NumberOfShots,
            .RateOfFire = this.RateOfFire,
            .Reliability = this.Reliability,
            .CreatedAt = 0,
            .UpdatedAt = 0
        };
    }
};

// ==================== tests ====================

fn getTestType() RangedWeaponType {
    return .{
        .Id = "any",
        .Name = "any",
        .WeaponType = "P",
        .Accuracy = -1,
        .Concealability = "P",
        .Avaliability = "E",
        .Damage = "1D6",
        .Ammunition = "5mm",
        .NumberOfShots = 8,
        .RateOfFire = 2,
        .Reliability = "ST",
        .CreatedAt = 0,
        .UpdatedAt = 0,
    };
}

test "CompactNotation" {
    var testType = getTestType();

    try std.testing.expectEqualStrings(
        "P/-1/P/E/1D6(5mm)/8/2/ST", 
        try testType.GetCompactNotation('/'));
}

test "Request to model" {
    var req: RequestBody = .{
        .Id = "any",
        .Name = "any",
        .WeaponType = "P",
        .Accuracy = -1,
        .Concealability = "P",
        .Avaliability = "E",
        .Damage = "1D6",
        .Ammunition = "5mm",
        .NumberOfShots = 8,
        .RateOfFire = 2,
        .Reliability = "ST",
    };

    const expected = getTestType();
    const result = req.ToModel();

    try std.testing.expectEqualStrings(expected.Id, result.Id);
    try std.testing.expectEqualStrings(expected.Name, result.Name);
    try std.testing.expectEqual(expected.Accuracy, result.Accuracy);
    try std.testing.expectEqual(0, result.CreatedAt);
    try std.testing.expectEqual(0, result.UpdatedAt);
}
