const std = @import("std");
const pg = @import("pg");
const pwd = @import("../Authentication/Password.zig");

const RoleError = error {
    NotSupported
};

const RolesMap = std.static_string_map.StaticStringMap(Role).initComptime(.{
    .{ "user", .user },
    .{ "editor", .editor },
});

pub const Role = enum (u8) {
    user = 0,
    editor = 1,

    pub fn ToString(self: Role) []const u8 {
        return switch (self) {
            .user => "user",
            .editor => "editor"
        };
    }

    pub fn FromString(string: []const u8) !Role {
        return RolesMap.get(string) orelse RoleError.NotSupported;
    }
};

pub const User = struct {
    // UUID
    Id: []const u8,
    Username: []const u8,
    PasswordHash: []const u8,
    Role: Role,

    // Parses the db row and returns the result. You are expected to use the
    // actual DB schema and use * as a fields selector
    pub fn Map(row: *const pg.Row) !User {
        const role_record = try row.get([]const u8, 3);

        return User {
            .Id = try row.get([]const u8, 0),
            .Username = try row.get([]const u8, 1),
            .PasswordHash = try row.get([]const u8, 2),
            .Role = try Role.FromString(role_record),
        };
    }

    // Parses the db row and returns the result. You are expected to use the
    // actual DB schema and use * as a fields selector
    pub fn MapWithAllocator(allocator: std.mem.Allocator, row: *const pg.Row) !User {
        const role_record = try allocator.dupe(u8, try row.get([]const u8, 3));

        return User {
            .Id = try allocator.dupe(u8, try row.get([]const u8, 0)),
            .Username = try allocator.dupe(u8, try row.get([]const u8, 1)),
            .PasswordHash = try allocator.dupe(u8, try row.get([]const u8, 2)),
            .Role = try Role.FromString(role_record),
        };
    }
};


pub const RequestBody = struct {
    Username: []const u8,
    Password: []const u8,

    // You are expected to free the User.PasswordHash afterwards. 
    // Shouldn't be a problem since it's supposed to be called with httpz's
    // req.arena
    pub fn ToModel(self: RequestBody, allocator: std.mem.Allocator) !User {
        var buf: [60]u8 = undefined;
        const hashed = try pwd.HashPassword(self.Password, &buf);
        return User {
            .Id = "",
            .Username = self.Username,
            .PasswordHash = try allocator.dupe(u8, hashed),
            .Role = .user,
        };
    }
};

// ==================== tests ====================

test "Roles transformation" {
    const roleString = "user";
    const roleVar: Role = .editor;

    try std.testing.expectEqualStrings("editor", Role.ToString(roleVar));
    const actual = try Role.FromString(roleString);
    try std.testing.expectEqual(Role.user, actual);
}

test "Request to user" {
    const allocator = std.testing.allocator;
    const body = RequestBody {
        .Username = "login",
        .Password = "password",
    };

    const model = try body.ToModel(allocator);
    try std.testing.expectEqualStrings(model.Username, body.Username);
    try std.testing.expectEqual(model.Id.len, 0);
    try std.testing.expectEqual(model.Role, Role.user);
    try std.testing.expect(!std.mem.eql(u8, model.PasswordHash, body.Password));

    // Should be hashed correctly
    try std.testing.expect(pwd.CheckPasswordHash(model.PasswordHash, "password"));

    allocator.free(model.PasswordHash);
}
