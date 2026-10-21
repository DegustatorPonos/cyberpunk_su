const std = @import("std");
const settings = @import("../Settings.zig");
const Sha256 = std.crypto.hash.sha2.Sha256;

// Allocates the output slice
pub fn WriteFile(alloc: std.mem.Allocator, io: std.Io, data: []const u8, extention: []const u8) ![]const u8 {
    var sha = Sha256.init(.{});
    sha.update(data);
    const hash = sha.finalResult();
    const hash_hex = std.fmt.bytesToHex(hash, .lower);

    const file_name = try std.fmt.allocPrint(alloc, "{s}.{s}", .{ 
        hash_hex,
        extention,
    });

    const file_path = try std.fmt.allocPrint(alloc, "{s}/{s}", .{ 
        settings.Current.FilesPath,
        file_name
    });
    defer alloc.free(file_path);

    var cwd = std.Io.Dir.cwd();
    const file = try cwd.createFile(io, file_path, .{ .exclusive = true });
    defer file.close(io);

    var writer_buf: [4096]u8 = undefined;
    var file_writer = std.Io.File.Writer.initStreaming(file, io, &writer_buf);

    const writer = &file_writer.interface;
    try writer.writeAll(data);

    try writer.flush();
    return file_name;
}

/// Allocates the file contents. You are responcibe for freeing it
pub fn GetFile(alloc: std.mem.Allocator, io: std.Io, name: []const u8) ![]const u8 {
    var cwd = std.Io.Dir.cwd();

    var buf: [1024]u8 = undefined;
    const file_path = try std.fmt.bufPrint(&buf, "{s}/{s}", .{ 
        settings.Current.FilesPath,
        name
    });

    const contents = try cwd.readFileAlloc(io, file_path, alloc, .unlimited);
    return contents;
}
