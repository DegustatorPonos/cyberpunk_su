const std = @import("std");
const httpz = @import("httpz");
const model = @import("../Models/Classes/Class.zig");
const db = @import("../Database/Connection.zig");
const errDesc = @import("ErrorDescription.zig");
const Handler = @import("../Handler.zig");
const Tokens = @import("../Authentication/Tokens.zig");

pub fn RegisterEndpoints(router: *httpz.Router(*Handler.Handler,*const fn (*Handler.RequestData, *httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.get("/classes", getAllClasses, .{});
    router.get("/classes/:class", getClass, .{});
    router.post("/classes", newClass, .{});
    router.put("/classes/:class", updateClass, .{});
    router.get("/classes/:class/description", getClassDescription, .{});
    router.put("/classes/:class/description", setClassDescription, .{});
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

    try res.json(desc, .{});
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
