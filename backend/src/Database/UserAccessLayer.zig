// You are not supposed to include this file. To access this you should use
// Connection.Users. 

const conn = @import("Connection.zig");
const std = @import("std");
const pg = @import("pg");
const model = @import("../Models/User.zig");
const pwd = @import("../Authentication/Password.zig");

pub fn Create(NewUser: *model.User) !void {
    if (try ExistsByUsername(NewUser.Username)) 
        return conn.ResultErrors.AlreadyExists;
    const query = 
        \\ INSERT INTO Users
        \\ (Username, PasswordHash, Role)
        \\ VALUES
        \\ ($1, $2, $3)
        ;
    
    _ = try conn.pool.exec(query, .{
        NewUser.Username,
        NewUser.PasswordHash,
        model.Role.ToString(NewUser.Role),
    });
}

pub fn GetByCredentials(allocator: std.mem.Allocator, username: []const u8, passwordHash: []const u8) !model.User {
    const query = 
        \\ SELECT * FROM Users WHERE
        \\ Username = $1
        ;
    var row = try conn.pool.row(query, .{ username }) orelse {
        return conn.ResultErrors.NotFound;
    };

    const outp = try model.User.MapWithAllocator(allocator, &row.row);
    try row.deinit();

    if (!pwd.CheckPasswordHash(outp.PasswordHash, passwordHash)) {
        return conn.ResultErrors.NotFound;
    }

    return outp;
}

pub fn ExistsByUsername(username: []const u8) !bool {
    const query = "SELECT Id FROM Users WHERE Username = $1";
    var row = try conn.pool.row(query, .{username}) orelse {
        return false;
    };
    try row.deinit();
    return true;
}
