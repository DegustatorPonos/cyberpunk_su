const std = @import("std");
const httpz = @import("httpz");
const errDesc = @import("../API/ErrorDescription.zig");
const fs = @import("FSManager.zig");
const Handler = @import("../Handler.zig");

pub fn RegisterEndpoints(router: *httpz.Router(*Handler.Handler,*const fn (*Handler.RequestData, *httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.get("/static/:file", getFile, .{});
    router.post("/static", postFile, .{});
}

fn getContentType(file_name: []const u8) ?[]const u8 {
    if (std.mem.endsWith(u8, file_name, "png"))
        return "image/png";
    if (std.mem.endsWith(u8, file_name, "jpeg"))
        return "image/jpeg";
    if (std.mem.endsWith(u8, file_name, "gif"))
        return "image/gif";
    return null;
}

fn getFile(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    const file_name = req.param("file") orelse {
        res.setStatus(.bad_request);
        return;
    };

    const contents = fs.GetFile(req.arena, data.Io, file_name) catch |err| {
        if (err == error.FileNotFound) {
            res.setStatus(.not_found);
            return;
        }
        return err;
    };

    if (getContentType(file_name)) |header| {
        res.headers.add("Content-Type", header);
    }

    try res.writer().writeAll(contents);
}

fn postFile(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try data.CheckAccess(.editor);
    const extention = req.headers.get("Content-Type") orelse "data";

    if (req.body() == null) {
        res.setStatus(.bad_request);
        return;
    }
    
    const name = fs.WriteFile(req.arena, data.Io, req.body().?, extention) catch |err| {
        if (err == error.PathAlreadyExists) {
            res.setStatus(.bad_request);
            try res.json(errDesc.ErrorDescriptor {
                .Message = "This file has already been uploaded",
            }, .{});
            return;
        }
        return err;
    };

    try res.json(.{
        .FileName = name
    }, .{});
}
