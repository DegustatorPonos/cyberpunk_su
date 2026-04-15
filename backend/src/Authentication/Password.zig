const std = @import("std");
const Sha512 = std.crypto.hash.sha2.Sha512;
const pg = @import("pg");

const alphabetChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[0..].*;

pub const HashingErr = error {
    InsufficientSalt,
};

// out_buf shound be [60]u8 to provide space for bcrypt
pub fn HashPassword(basePassword: []const u8, out_buf: []u8) ![]const u8 {
    return try std.crypto.pwhash.bcrypt.strHash(basePassword, .{
        .params = .{
            .rounds_log = 7, // TODO: Move this to config
            .silently_truncate_password = false,
        },
        .encoding = .crypt
    }, out_buf);
}

pub fn CheckPasswordHash(stored: []const u8, provided: []const u8) bool {
    std.crypto.pwhash.bcrypt.strVerify(stored, provided, .{
        .silently_truncate_password = false
    }) catch {
        return false;
    };
    return true;
}

test "Hash function" {
    var buf: [60]u8 = undefined;
    const data = "test_pasword_providedByUser";
    const hash = try HashPassword(data, &buf);
    const checkResult = CheckPasswordHash(hash, data);
    try std.testing.expect(checkResult);
}
