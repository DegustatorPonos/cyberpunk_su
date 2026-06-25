const std = @import("std");
const pg = @import("pg");
const settings = @import("../Settings.zig");

const body_limit: std.Io.Limit = .unlimited;

const errors = error {
    NotFound,
};

pub const Article = struct {
    Name: []const u8,
    Language: []const u8,
    FileLocation: []const u8,
    Contents: []const u8,
    CreatedAt: i64,

    // Parses the db row and returns the result. You are expected to use the
    // actual DB schema and use * as a fields selector
    pub fn MapWithAlloc(allocator: std.mem.Allocator, row: *const pg.Row) !Article {
        return .{
            .Name = try allocator.dupe(u8, try row.get([]const u8, 0)),
            .Language = try allocator.dupe(u8, try row.get([]const u8, 1)),
            .FileLocation = try allocator.dupe(u8, try row.get([]const u8, 2)),
            .CreatedAt = try row.get(i64, 3),
            .Contents = "",
        };
    }

    pub fn init_body(self: *Article, alloc: std.mem.Allocator) !void {
        const cwd = std.Io.Dir.cwd();
        var threaded: std.Io.Threaded = .init_single_threaded;
        const io = threaded.io();
        const file_path = try std.fmt.allocPrint(alloc, "{s}/{s}", .{ 
            settings.Current.Paths.ArticlesPath,
            self.FileLocation,
        });
        defer alloc.free(file_path);
        const contents = try cwd.readFileAlloc(io, file_path, alloc, body_limit);
        self.Contents = try alloc.dupe(u8, contents);

        var file = try std.Io.Dir.cwd().openFile(io, file_path, .{});
        defer file.close(io);

        const stat = try file.stat(io);
        self.CreatedAt = stat.ctime.toSeconds();
    }

    /// Expects the same allocator used in the init function.
    /// You can avoid calling this function if you are using an arena
    pub fn deinit_body(self: *Article, alloc: std.mem.Allocator) void {
        alloc.free(self.Contents);
    }
};
