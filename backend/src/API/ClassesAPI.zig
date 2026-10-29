const std = @import("std");
const httpz = @import("httpz");
const model = @import("../Models/Classes/Class.zig");
const skills = @import("../Models/Classes/Skills.zig");
const db = @import("../Database/Connection.zig");
const errDesc = @import("ErrorDescription.zig");
const Handler = @import("../Handler.zig");
const Tokens = @import("../Authentication/Tokens.zig");
const common = @import("common.zig");

pub fn RegisterEndpoints(router: *httpz.Router(*Handler.Handler,*const fn (*Handler.RequestData, *httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.get("/classes", getAllClasses, .{});
    router.post("/classes", newClass, .{});
    router.get("/classes/:class", getClass, .{});
    router.put("/classes/:class", updateClass, .{});

    router.get("/classes/:class/description", getClassDescription, .{});
    router.put("/classes/:class/description", setClassDescription, .{});

    router.get("/classes/:class/career", getClassCareeerSkills, .{});
    router.post("/classes/:class/career", addClassCareeerSkill, .{});
    router.delete("/classes/:class/career/:skill", deleteClassCareeerSkill, .{});

    router.get("/classes/:class/specialization", getClassSpecializations, .{});
    router.post("/classes/:class/specialization", addClassSpecialization, .{});
    router.delete("/classes/:class/specialization/:skill", deleteClassSpecialization, .{});
}

fn getAllClasses(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    var found = try db.Classes.GetAll(req.arena);
    defer found.deinit(req.arena);
    
    try res.json(found.items, .{});
}

fn getClass(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    const class = req.param("class") orelse {
        res.setStatus(.bad_request);
        return;
    };

    const found = try db.Classes.GetByName(req.arena, class);
    try res.json(found, .{});
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

fn updateClass(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try data.CheckAccess(.editor);

    const class = req.param("class") orelse {
        res.setStatus(.bad_request);
        return;
    };

    var body = try req.json(model.Class) orelse {
        res.setStatus(.bad_request);
        return;
    };

    body.Name = class;

    try db.Classes.Update(&body);
}

fn getClassDescription(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    const class = req.param("class") orelse {
        res.setStatus(.bad_request);
        return;
    };

    const query = try req.query();
    const lang = query.get("lang") orelse "en";

    const desc = db.Classes.GetDescription(req.arena, class, lang) catch |err| {
        switch (err) {
            db.ResultErrors.NotFound => {
                try res.json(errDesc.NotFoundDescriptor, .{});
                res.setStatus(.not_found);
                return;
            },
            else => return err,
        }
    };

    try res.json(model.ClassDescriptionView {
        .ClassName = desc.ClassName,
        .Language = desc.Language,
        .Contents = desc.Contents,
        .ImageURL = desc.ImageURL,


        .CareerSkills = (try getAttachedSkills(req, res, db.Skills.GetClassCareerSkills)).items,
        .SpecizalizationSkills = (try getAttachedSkills(req, res, db.Skills.GetClassSpecializations)).items,
    }, .{});
}

fn setClassDescription(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try data.CheckAccess(.editor);

    const class = req.param("class") orelse {
        res.setStatus(.bad_request);
        return;
    };

    const body = try req.json(struct {
        ClassName: []const u8,
        Language: []const u8,
        Contents: []const u8,
        ImageURL: []const u8,
    }) orelse {
        res.setStatus(.bad_request);
        return;
    };

    try db.Classes.SetDescription(.{
        .ClassName = class,
        .Language = body.Language,
        .Contents = body.Contents,
        .ImageURL = body.ImageURL,
    });
}

fn addAttachedSkill(
    data: *Handler.RequestData,
    req: *httpz.Request,
    res: *httpz.Response,
    insertFn: fn ([]const u8, []const u8) anyerror!void
    ) !void {

    try data.CheckAccess(.editor);

    const class = req.param("class") orelse {
        res.setStatus(.bad_request);
        return;
    };

    const body = try req.json(struct {
        SkillName: []const u8
    }) orelse {
        res.setStatus(.bad_request);
        return;
    };

    try insertFn(class, body.SkillName);
}

fn addClassSpecialization(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try addAttachedSkill(data, req, res, db.Skills.AddClassSpecialization);
}

fn addClassCareeerSkill(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try addAttachedSkill(data, req, res, db.Skills.AddClassCareerSkill);
}

fn deleteClassAttachedSkill(
    data: *Handler.RequestData,
    req: *httpz.Request,
    res: *httpz.Response,
    deleteFn: fn ([]const u8, []const u8) anyerror!void
    ) !void {

    try data.CheckAccess(.editor);

    const class = req.param("class") orelse {
        res.setStatus(.bad_request);
        return;
    };

    const skill_raw = req.param("skill") orelse {
        res.setStatus(.bad_request);
        return;
    };
    const skill = try common.unescapePath(req.arena, skill_raw);
    
    try deleteFn(class, skill);
}

fn deleteClassSpecialization(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try deleteClassAttachedSkill(data, req, res, db.Skills.DeleteClassSpecialization);
}

fn deleteClassCareeerSkill(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try deleteClassAttachedSkill(data, req, res, db.Skills.DeleteClassCareerSkill);
}

fn getAttachedSkills(
    req: *httpz.Request,
    res: *httpz.Response,
    retrieveFn: fn (std.mem.Allocator, []const u8) anyerror!std.ArrayList(skills.Skill)
    ) !std.ArrayList(skills.Skill) {

    const class = req.param("class") orelse {
        res.setStatus(.bad_request);
        return error.BadRequest;
    };

    return try retrieveFn(req.arena, class);
}

fn getClassSpecializations(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try res.json((try getAttachedSkills(req, res, db.Skills.GetClassSpecializations)).items, .{});
}

fn getClassCareeerSkills(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try res.json((try getAttachedSkills(req, res, db.Skills.GetClassCareerSkills)).items, .{});
}
