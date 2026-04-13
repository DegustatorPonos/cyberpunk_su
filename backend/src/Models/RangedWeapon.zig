const std = @import("std");

pub const RangedWeaponType = struct {
    Name: []const u8,

    WeaponType: []const u8,
    Accuracy: i8,
    Concealability: []const u8,
    Avaliability: []const u8,
    Damage: []const u8,
    Ammunition: []const u8,
    NumberOfShots: u8,
    RateOfFire: u8,
    Reliability: []const u8,

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
};

// ==================== tests ====================

fn getTestType() RangedWeaponType {
    return .{
        .Name = "any",
        .WeaponType = "P",
        .Accuracy = -1,
        .Concealability = "P",
        .Avaliability = "E",
        .Damage = "1D6",
        .Ammunition = "5mm",
        .NumberOfShots = 8,
        .RateOfFire = 2,
        .Reliability = "ST"
    };
}

test "CompactNotation" {
    var testType = getTestType();

    try std.testing.expectEqualStrings(
        "P/-1/P/E/1D6(5mm)/8/2/ST", 
        try testType.GetCompactNotation('/'));
}
