const std = @import("std");

const SettingsFile = "Settings.json";

pub const errors = error {
    Uninitialized
};

pub const SettingsStruct = struct {
    Port: u16,
    FilesPath: []const u8,
    CacheTTL: u16,

    CorsParams: struct {
        Origin: []const u8,
        Methods: []const u8,
        Headers: []const u8,
        AllowCredentials: bool,
    },

    RedisParams: struct {
        Address: []const u8,
        Port: u16,
    },

    DbParams: struct {
        Address: []const u8,
        Port: u16,
    },
    
    Paths: struct {
        ArticlesPath: []const u8,
        ArticlesScript: []const u8,
    },
};

pub var Current: *SettingsStruct = undefined;

pub fn ReadConfig(allocator: std.mem.Allocator, io: std.Io) !void {
    const contents = try std.Io.Dir.cwd().readFileAlloc(io, SettingsFile, allocator, .limited(std.math.maxInt(usize)));
    defer allocator.free(contents);

    var parsed = std.json.parseFromSlice(
        SettingsStruct, 
        allocator, 
        contents, .{
            .ignore_unknown_fields = true,
        }) catch |err| {
        std.debug.print("Failed to parse settings: {any}\n", .{err});
        return err;
    };

    defer parsed.deinit();

    // There is no reason to free this value, it will be freed by OS at the end of the application
    Current = try allocator.create(SettingsStruct);
    Current.* = .{
        .Port = parsed.value.Port,
        .FilesPath = try allocator.dupe(u8, parsed.value.FilesPath),
        .CacheTTL = 300,
        
        .CorsParams = .{
            .Origin = try allocator.dupe(u8, parsed.value.CorsParams.Origin),
            .Methods = try allocator.dupe(u8, parsed.value.CorsParams.Methods),
            .Headers = try allocator.dupe(u8, parsed.value.CorsParams.Headers),
            .AllowCredentials = parsed.value.CorsParams.AllowCredentials,
        },

        .RedisParams = .{
            .Address = try allocator.dupe(u8, parsed.value.RedisParams.Address),
            .Port = parsed.value.RedisParams.Port,
        },

        .DbParams = .{
            .Address = try allocator.dupe(u8, parsed.value.DbParams.Address),
            .Port = parsed.value.DbParams.Port,
        },
        
        .Paths = .{
            .ArticlesPath = try allocator.dupe(u8, parsed.value.Paths.ArticlesPath),
            .ArticlesScript = try allocator.dupe(u8, parsed.value.Paths.ArticlesScript),
        }
    };
}

pub fn Deinit(allocator: std.mem.Allocator) void {
    allocator.free(Current.CorsParams.Origin);
    allocator.free(Current.CorsParams.Methods);
    allocator.free(Current.CorsParams.Headers);
    allocator.free(Current.RedisParams.Address);
    allocator.free(Current.DbParams.Address);
    allocator.free(Current.Paths.ArticlesPath);
    allocator.free(Current.Paths.ArticlesScript);
    allocator.destroy(Current);
}
