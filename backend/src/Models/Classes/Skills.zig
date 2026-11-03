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
    /// The name of the skill in the database
    Name: []const u8,
    /// The name of the skill visible to the user. Is affected by language
    DisplayName: []const u8,
    /// Should be either 'pickup' or 'career'
    Type: []const u8,
    Category: []const u8,
    Description: []const u8,

    /// Expects the following fields:
    /// - Name (skill PK)
    /// - DisplayName (translated)
    /// - Type
    /// - Category
    /// - Description
    pub fn MapWithAlloc(allocator: std.mem.Allocator, row: *const pg.Row) !SkillView {
        return .{
            .Name = try allocator.dupe(u8, try row.get([]const u8, 0)),
            .DisplayName = try allocator.dupe(u8, try row.get([]const u8, 1)),
            .Type = try allocator.dupe(u8, try row.get([]const u8, 2)),
            .Category = try allocator.dupe(u8, try row.get([]const u8, 3)),
            .Description = try allocator.dupe(u8, try row.get([]const u8, 4)),
        };
    }

    pub fn is_valid(self: *Skill) bool {
        if (self.Name.len == 0) return false;
        if (!std.mem.eql(u8, self.Type, "pickup") 
            and !std.mem.eql(u8, self.Type, "career")
            and !std.mem.eql(u8, self.Type, "special")) {
            return false;
        }
        return true;
    }
};

pub const ClassSkillLink = struct {
    ClassName: []const u8,
    SkillName: []const u8,

    pub fn MapWithAlloc(allocator: std.mem.Allocator, row: *const pg.Row) !ClassSkillLink {
        return .{
            .ClassName = try allocator.dupe(u8, try row.get([]const u8, 0)),
            .SkillName = try allocator.dupe(u8, try row.get([]const u8, 1)),
        };
    }
};
