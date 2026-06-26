const std = @import("std");
const httpz = @import("httpz");
const model = @import("../Models/RangedWeapon.zig");
const descModel = @import("../Models/Description.zig");
const db = @import("../Database/Connection.zig");
const errDesc = @import("ErrorDescription.zig");
const Handler = @import("../Handler.zig");

pub fn RegisterEndpoints(router: *httpz.Router(*Handler.Handler,*const fn (*Handler.RequestData, *httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.get("/weapons/ranged", getAllRangedWeapons, .{});
    router.post("/weapons/ranged", newRangedWeapon, .{});
    router.get("/weapons/ranged/:id/description", getRangedWeaponDescription, .{});
    router.post("/weapons/ranged/:id/description", setRangedWeaponDescription, .{});
    router.get("/weapons/ranged/:id", getRangedWeaponById, .{});
    router.put("/weapons/ranged/:id", updateRangedWeapon, .{});
    router.delete("/weapons/ranged/:id", deleteRangedWeapon, .{});
}

fn getAllRangedWeapons(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    var found = try db.RangedWeapons.GetAll(req.arena);
    defer found.deinit(req.arena);

    try res.json(found.items, .{});
}

fn getRangedWeaponById(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    const id = req.param("id") orelse {
        res.setStatus(.bad_request);
        return;
    };

    const found = db.RangedWeapons.GetByDisplayName(req.arena, id) catch |err| {
        // Empty result handling
        if (err == db.ResultErrors.NotFound) {
            res.setStatus(.no_content);
            try res.json(errDesc.NotFoundDescriptor, .{});
            return;
        }
        return err;
    };

    try res.json(found, .{});
}

fn newRangedWeapon(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try data.CheckAccess(.editor);

    var body = try req.json(model.RequestBody) orelse {
        res.setStatus(.bad_request);
        return;
    };

    var weapon = body.ToModel();
    db.RangedWeapons.Create(&weapon) catch |err| {
        if (err == db.ResultErrors.AlreadyExists) {
            res.setStatus(.bad_request);
            try res.json(errDesc.ErrorDescriptor { 
                .Message = "A weapon with that ID already exists"
            }, .{});
            return;
        }
        return err;
    }; 
    Handler.clearCachedPages(data.Io, req.arena) catch {};

    res.setStatus(.created);
}

fn updateRangedWeapon(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try data.CheckAccess(.editor);

    const id = req.param("id") orelse {
        res.setStatus(.bad_request);
        return;
    };

    var body = try req.json(model.RequestBody) orelse {
        res.setStatus(.bad_request);
        return;
    };

    var weapon = body.ToModel();
    db.RangedWeapons.Update(id, &weapon) catch |err| {
        if (err == db.ResultErrors.NotFound) {
            res.setStatus(.no_content);
            try res.json(errDesc.NotFoundDescriptor, .{});
            return;
        }
        return err;
    };  
    Handler.clearCachedPages(data.Io, req.arena) catch {};
}

fn deleteRangedWeapon(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try data.CheckAccess(.editor);

    const id = req.param("id") orelse {
        res.setStatus(.bad_request);
        return;
    };

    try db.RangedWeapons.Delete(id);
}

fn getRangedWeaponDescription(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    const id = req.param("id") orelse {
        res.setStatus(.bad_request);
        return;
    };

    const query = try req.query();
    const lang = query.get("lang") orelse "en";
    const desc = db.RangedWeapons.GetDescription(req.arena, id, lang) catch |err| {
        if (err == db.ResultErrors.NotFound) {
            // The description does not exist
            try res.json(descModel.Description {
                .Id = id,
                .Language = lang,
                .Contents = ""
            }, .{});
            return;
        }
        return err;
    };

    try res.json(desc, .{});
}

fn setRangedWeaponDescription(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    try data.CheckAccess(.editor);

    const id = req.param("id") orelse {
        res.setStatus(.bad_request);
        return;
    };

    const body = try req.json(descModel.RequestBody) orelse {
        res.setStatus(.bad_request);
        return;
    };

    try db.RangedWeapons.SetDescription(.{
        .Id = id,
        .Language = body.Language,
        .Contents = body.Contents
    });
    Handler.clearCachedPages(data.Io, req.arena) catch {};
}
