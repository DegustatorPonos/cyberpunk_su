const std = @import("std");
const httpz = @import("httpz");
const model = @import("../Models/RangedWeapon.zig");
const db = @import("../Database/Connection.zig");
const errDesc = @import("ErrorDescription.zig");
const Handler = @import("../Handler.zig");

pub fn RegisterEndpoints(router: *httpz.Router(*Handler.Handler,*const fn (*Handler.RequestData, *httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.get("/weapons/ranged", getAllRangedWeapons, .{});
    router.post("/weapons/ranged", newRangedWeapon, .{});
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

fn newRangedWeapon(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
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

    res.setStatus(.created);
}

fn updateRangedWeapon(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
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
}

fn deleteRangedWeapon(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    const id = req.param("id") orelse {
        res.setStatus(.bad_request);
        return;
    };

    try db.RangedWeapons.Delete(id);
}
