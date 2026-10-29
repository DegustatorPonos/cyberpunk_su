const std = @import("std");

pub const errors = enum {
    NotFound,
};

pub fn unescapePath(allocator: std.mem.Allocator, input: []const u8) ![]u8 {
    var out = try allocator.alloc(u8, input.len);
    errdefer allocator.free(out);

    var i: usize = 0;
    var j: usize = 0;
    while (i < input.len) {
        if (input[i] == '%' and i + 2 < input.len) {
            const high = try std.fmt.charToDigit(input[i + 1], 16);
            const low = try std.fmt.charToDigit(input[i + 2], 16);
            out[j] = (high << 4) | low;
            i += 3;
        } else {
            out[j] = input[i];
            i += 1;
        }
        j += 1;
    }

    return allocator.realloc(out, j);
}
