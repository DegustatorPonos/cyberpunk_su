const std = @import("std");
const pg = @import("pg");

pub const Class = struct {
    Name: []const u8,

    // The book the class is from (idk if classes are actually distributed
    // across books like in DND but fuck it)
    Origin: []const u8,

    pub fn MapWithAlloc(allocator: std.mem.Allocator, row: *const pg.Row) !Class {
        return Class {
            .Name = try allocator.dupe(u8, try row.get([]const u8, 0)),
            .Origin = try allocator.dupe(u8, try row.get([]const u8, 1)),
        };
    }
};
