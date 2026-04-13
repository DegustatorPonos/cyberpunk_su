pub const packages = struct {
    pub const @"httpz-0.0.0-PNVzrNVOBwDlxyffzwONpI9j9dYqKWXxopU1ZCLt4C09" = struct {
        pub const build_root = "/home/physick/.cache/zig/p/httpz-0.0.0-PNVzrNVOBwDlxyffzwONpI9j9dYqKWXxopU1ZCLt4C09";
        pub const build_zig = @import("httpz-0.0.0-PNVzrNVOBwDlxyffzwONpI9j9dYqKWXxopU1ZCLt4C09");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "metrics", "metrics-0.0.0-W7G4eP2_AQAdJGKMonHeZFaY4oU4ZXPFFTqFCFXItX3O" },
            .{ "websocket", "websocket-0.1.0-ZPISdZJxAwAt6Ys_JpoHQQV3NpWCof_N9Jg-Ul2g7OoV" },
        };
    };
    pub const @"metrics-0.0.0-W7G4eP2_AQAdJGKMonHeZFaY4oU4ZXPFFTqFCFXItX3O" = struct {
        pub const build_root = "/home/physick/.cache/zig/p/metrics-0.0.0-W7G4eP2_AQAdJGKMonHeZFaY4oU4ZXPFFTqFCFXItX3O";
        pub const build_zig = @import("metrics-0.0.0-W7G4eP2_AQAdJGKMonHeZFaY4oU4ZXPFFTqFCFXItX3O");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
    pub const @"websocket-0.1.0-ZPISdZJxAwAt6Ys_JpoHQQV3NpWCof_N9Jg-Ul2g7OoV" = struct {
        pub const build_root = "/home/physick/.cache/zig/p/websocket-0.1.0-ZPISdZJxAwAt6Ys_JpoHQQV3NpWCof_N9Jg-Ul2g7OoV";
        pub const build_zig = @import("websocket-0.1.0-ZPISdZJxAwAt6Ys_JpoHQQV3NpWCof_N9Jg-Ul2g7OoV");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "httpz", "httpz-0.0.0-PNVzrNVOBwDlxyffzwONpI9j9dYqKWXxopU1ZCLt4C09" },
};
