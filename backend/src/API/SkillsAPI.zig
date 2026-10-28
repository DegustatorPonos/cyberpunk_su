const std = @import("std");
const httpz = @import("httpz");
const model = @import("../Models/Classes/Skills.zig");
const db = @import("../Database/Connection.zig");
const errDesc = @import("ErrorDescription.zig");
const Handler = @import("../Handler.zig");
const common = @import("common.zig");

pub fn RegisterEndpoints(router: *httpz.Router(*Handler.Handler,*const fn (*Handler.RequestData, *httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.get("/skills", getAllSkills, .{});
    router.post("/skills", addSkill, .{});
    router.put("/skills/:skill", updateSkill, .{});

    router.get("/skills/:skill/description", getSkillDescription, .{});
    router.put("/skills/:skill/description", setSkillDescription, .{});
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

fn updateSkill(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try data.CheckAccess(.editor);

    const name = req.param("skill") orelse {
        res.setStatus(.bad_request);
        return;
    };

    var body = try req.json(model.Skill) orelse {
        res.setStatus(.bad_request);
        return;
    };
    body.Name = name;

    try db.Skills.Update(&body);
}

fn getSkillDescription(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    const name_raw = req.param("skill") orelse {
        res.setStatus(.bad_request);
        return;
    };
    const name = try common.unescapePath(req.arena, name_raw);

    const query = try req.query();
    const lang = query.get("lang") orelse "en";

    const found = db.Skills.GetDescription(req.arena, name, lang) catch |err| switch (err) {
        db.ResultErrors.NotFound => {
            try res.json(errDesc.NotFoundDescriptor, .{});
            res.setStatus(.not_found);
            return;
        },
        else => return err,
    };

    try res.json(found, .{});
}

fn setSkillDescription(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try data.CheckAccess(.editor);
    const name_raw = req.param("skill") orelse {
        res.setStatus(.bad_request);
        return;
    };
    const name = try common.unescapePath(req.arena, name_raw);

    const query = try req.query();
    const lang = query.get("lang") orelse "en";

    const body = try req.json(model.SkillDescription) orelse {
        res.setStatus(.bad_request);
        return;
    };


    try db.Skills.SetDescription(.{
        .Language = lang,
        .SkillName = name,
        .Contents = body.Contents,
    });
}
