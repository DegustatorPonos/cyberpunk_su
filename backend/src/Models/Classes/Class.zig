const skills = @import("Skills.zig");
const std = @import("std");
const pg = @import("pg");

pub const Class = struct {
    Name: []const u8,

    // The book the class is from (idk if classes are actually distributed
    // across books like in DND but fuck it)
    Origin: []const u8,
    PreviewPicture: []const u8,

    pub fn MapWithAlloc(allocator: std.mem.Allocator, row: *const pg.Row) !Class {
        return Class {
            .Name = try allocator.dupe(u8, try row.get([]const u8, 0)),
            .Origin = try allocator.dupe(u8, try row.get([]const u8, 1)),
            .PreviewPicture = try allocator.dupe(u8, try row.get([]const u8, 2)),
        };
    }
};

pub const ClassDescription = struct {
    ClassName: []const u8,
    Language: []const u8,
    Contents: []const u8,
    ImageURL: []const u8,

    pub fn MapWithAlloc(allocator: std.mem.Allocator, row: *const pg.Row) !ClassDescription {
        return ClassDescription {
            .ClassName = try allocator.dupe(u8, try row.get([]const u8, 0)),
            .Language = try allocator.dupe(u8, try row.get([]const u8, 1)),
            .ImageURL = try allocator.dupe(u8, try row.get([]const u8, 2)),
            .Contents = try allocator.dupe(u8, try row.get([]const u8, 3)),
        };
    }
};

pub const ClassDescriptionView = struct {
    ClassName: []const u8,
    Language: []const u8,
    Contents: []const u8,
    ImageURL: []const u8,
    
    SpecizalizationSkills: []skills.Skill,
    CareerSkills: []skills.Skill,
};
