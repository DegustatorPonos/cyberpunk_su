const std = @import("std");
const httpz = @import("httpz");

pub const Handler = struct {
    pub fn dispatch(self: *Handler, action: httpz.Action(*Handler), req: *httpz.Request, res: *httpz.Response) !void {
        try action(self, req, res);
        std.debug.print("{any} {s}\n", .{req.method, req.url.raw});
    }
};
