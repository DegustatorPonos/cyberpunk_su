const std = @import("std");
const pg = @import("pg");

const RoleError = error {
    NotSupported
};

const RolesMap = std.static_string_map.StaticStringMap(Role).initComptime(.{
    .{ "user", .user },
    .{ "editor", .editor },
});

pub const Role = enum {
    user,
    editor,

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
    Id: [36]u8,
    Username: []const u8,
    PasswordHash: []const u8,
    Role: []const u8

    // pub fn Map(row: *const pg.Row) !User {
    // }
};

test "Roles transformation" {
    const roleString = "user";
    const roleVar: Role = .editor;

    try std.testing.expectEqualStrings("editor", Role.ToString(roleVar));
    const actual = try Role.FromString(roleString);
    try std.testing.expectEqual(Role.user, actual);
}
