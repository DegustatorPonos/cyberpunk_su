// You are not supposed to include this file. To access this you should use
// Connection.Users. 

const conn = @import("Connection.zig");
const std = @import("std");
const pg = @import("pg");
const model = @import("../Models/Classes/Skills.zig");
const pwd = @import("../Authentication/Password.zig");

pub fn GetAll(alloc: std.mem.Allocator) !std.ArrayList(model.Skill) {
    const query = 
        \\ SELECT name, type, category FROM skills
        \\ ORDER BY category ASC, name ASC
        ;
    var result = try conn.pool.query(query, .{});
    defer result.deinit();

    var outp: std.ArrayList(model.Skill) = .empty;
    while (try result.next()) |row| {
        const newSkill = try model.Skill.MapWithAlloc(alloc,  &row);
        try outp.append(alloc, newSkill);
    }

    return outp;
}

pub fn Exists(skillName: []const u8) !bool {
    const query = "SELECT name FROM Skills WHERE name = $1";
    var row = try conn.pool.row(query, .{ skillName }) orelse return false;
    try row.deinit();
    return true;
}

pub fn Create(skill: *model.Skill) !void {
    if (try Exists(skill.Name)) return conn.ResultErrors.AlreadyExists;
    const query = 
        \\ INSERT INTO Skills (name, type, category) 
        \\ VALUES ($1, $2, $3)
        ;
    _ = try conn.pool.exec(query, .{ 
        skill.Name, 
        skill.Type,
        skill.Category,
    });
}

pub fn Update(skill: *model.Skill) !void {
    if (try Exists(skill.Name)) return conn.ResultErrors.NotFound;
    const query = 
        \\ UPDATE Skills SET 
        \\ type = $1,
        \\ category = $2
        \\ WHERE name = $3
        ;

    _ = try conn.pool.exec(query, .{
        skill.Type,
        skill.Category,
        skill.Name
    });
}

pub fn GetDescription(allocator: std.mem.Allocator, skillName: []const u8, language: []const u8) !model.SkillDescription {
    const query =
        \\ SELECT skill_name, language, contents
        \\ FROM SkillDescriptions WHERE skill_name = $1 AND language = $2
        ;
    var row = try conn.pool.row(query, .{ skillName, language }) orelse {
        return conn.ResultErrors.NotFound;
    };

    const outp = try model.SkillDescription.MapWithAlloc(allocator, &row.row);
    try row.deinit();

    return outp;
}

pub fn SetDescription(desc: model.SkillDescription) !void {
    // std.debug.print("Inserting a desc for {s}\n", .{desc.ClassName});
    const query =
        \\ INSERT INTO skilldescriptions (skill_name, language, contents)
        \\ VALUES ($1, $2, $3)
        \\ ON CONFLICT (skill_name, language)
        \\ DO UPDATE SET
        \\     contents = EXCLUDED.contents
        ;

    _ = try conn.pool.exec(query, .{
        desc.SkillName,
        desc.Language,
        desc.Contents,
    });
}
