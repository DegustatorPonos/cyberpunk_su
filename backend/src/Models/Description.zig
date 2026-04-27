const std = @import("std");
const pg = @import("pg");

// Is suitable for those tables:
// - RangedWeaponsDescriptions
pub const Description = struct {
    Id: []const u8,
    Language: []const u8,
    Contents: []const u8,

    // Parses the db row and returns the result. You are expected to use the
    // actual DB schema and use * as a fields selector
    pub fn Map(row: *const pg.Row) !Description {
        return Description {
            .Id = try row.get([]const u8, 0),
            .Language = try row.get([]const u8, 1),
            .Contents = try row.get([]const u8, 2),
        };
    }

    // Parses the db row and returns the result. You are expected to use the
    // actual DB schema and use * as a fields selector
    pub fn MapWithAlloc(allocator: std.mem.Allocator, row: *const pg.Row) !Description {
        return Description {
            .Id = try allocator.dupe(u8, try row.get([]const u8, 0)),
            .Language = try allocator.dupe(u8, try row.get([]const u8, 1)),
            .Contents = try allocator.dupe(u8, try row.get([]const u8, 2)),
        };
    }

};

pub const RequestBody = struct {
    Language: []const u8,
    Contents: []const u8,
};
