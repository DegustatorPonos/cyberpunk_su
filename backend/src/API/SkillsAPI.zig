const std = @import("std");
const httpz = @import("httpz");
const model = @import("../Models/Classes/Skills.zig");
const db = @import("../Database/Connection.zig");
const errDesc = @import("ErrorDescription.zig");
const Handler = @import("../Handler.zig");

pub fn RegisterEndpoints(router: *httpz.Router(*Handler.Handler,*const fn (*Handler.RequestData, *httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.get("/skills", getAllSkills, .{});
    router.post("/skills", addSkill, .{});
}


fn getAllSkills(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    var found = try db.Skills.GetAll(req.arena);
    defer found.deinit(req.arena);

    try res.json(found.items, .{});
}

fn addSkill(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try data.CheckAccess(.editor);

    var body = try req.json(model.Skill) orelse {
        res.setStatus(.bad_request);
        return;
    };

    if (!body.is_valid()) {
        res.setStatus(.bad_request);
        try res.json(errDesc.ErrorDescriptor {
            .Message = "The passed skill is not valid",
        }, .{});
        return;
    }

    db.Skills.Create(&body) catch |err| switch (err) {
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
