const std = @import("std");
const httpz = @import("httpz");
const model = @import("../Models/Classes/Class.zig");
const db = @import("../Database/Connection.zig");
const errDesc = @import("ErrorDescription.zig");
const Handler = @import("../Handler.zig");
const Tokens = @import("../Authentication/Tokens.zig");

pub fn RegisterEndpoints(router: *httpz.Router(*Handler.Handler,*const fn (*Handler.RequestData, *httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.get("/classes", getAllClasses, .{});
    router.post("/classes", newClass, .{});
}

fn getAllClasses(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    var found = try db.Classes.GetAll(req.arena);
    defer found.deinit(req.arena);
    
    try res.json(found.items, .{});
}

fn newClass(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try data.CheckAccess(.editor);

    var body = try req.json(model.Class) orelse {
        res.setStatus(.bad_request);
        return;
    };

    db.Classes.Create(&body) catch |err| switch (err) {
        db.ResultErrors.AlreadyExists => {
            res.setStatus(.bad_request);
            try res.json(errDesc.ErrorDescriptor {
                .Message = "Class with that name already exists",
            }, .{});
            return;
        },
        else => return err,
    };

    res.setStatus(.created);
}
