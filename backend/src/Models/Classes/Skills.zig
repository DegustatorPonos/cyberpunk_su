const std = @import("std");
const pg = @import("pg");

pub const Skill = struct {
    Name: []const u8,
    /// Should be either 'pickup' or 'career'
    Type: []const u8,
    Category: []const u8,

    pub fn MapWithAlloc(allocator: std.mem.Allocator, row: *const pg.Row) !Skill {
        return .{
            .Name = try allocator.dupe(u8, try row.get([]const u8, 0)),
            .Type = try allocator.dupe(u8, try row.get([]const u8, 1)),
            .Category = try allocator.dupe(u8, try row.get([]const u8, 2)),
        };
    }

    pub fn is_valid(self: *Skill) bool {
        if (self.Name.len == 0) return false;
        if (!std.mem.eql(u8, self.Type, "pickup") and !std.mem.eql(u8, self.Type, "career")) {
            return false;
        }
        return true;
    }
};

pub const SkillDescription = struct {
    SkillName: []const u8,
    Language: []const u8,
    Contents: []const u8,

    pub fn MapWithAlloc(allocator: std.mem.Allocator, row: *const pg.Row) !SkillDescription  {
        return .{
            .SkillName = try allocator.dupe(u8, try row.get([]const u8, 0)),
            .Language = try allocator.dupe(u8, try row.get([]const u8, 1)),
            .Contents = try allocator.dupe(u8, try row.get([]const u8, 2)),
        };
    }
};

/// The full info about the skill. Is composed of 2 tables
pub const SkillView = struct {
    Name: []const u8,
    /// Should be either 'pickup' or 'career'
    Type: []const u8,
    Category: []const u8,
    Language: []const u8,
    Contents: []const u8,

    pub fn MapWithAlloc(allocator: std.mem.Allocator, row: *const pg.Row) !SkillView {
        return .{
            .Name = try allocator.dupe(u8, try row.get([]const u8, 0)),
            .Type = try allocator.dupe(u8, try row.get([]const u8, 1)),
            .Category = try allocator.dupe(u8, try row.get([]const u8, 2)),
            .Language = try allocator.dupe(u8, try row.get([]const u8, 3)),
            .Contents = try allocator.dupe(u8, try row.get([]const u8, 4)),
        };
    }

    pub fn is_valid(self: *Skill) bool {
        if (self.Name.len == 0) return false;
        if (!std.mem.eql(u8, self.Type, "pickup") and !std.mem.eql(u8, self.Type, "career")) {
            return false;
        }
        return true;
    }
};
