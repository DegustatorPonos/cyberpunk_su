const std = @import("std");
const httpz = @import("httpz");
const model = @import("../Models/RangedWeapon.zig");
const db = @import("../Database/Connection.zig");

pub fn RegisterEndpoints(router: *httpz.Router(void, *const fn (*httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.get("/weapons", testEndpoint, .{});
    router.post("/weapons/ranged", newRangedWeapon, .{});
    router.get("/weapons/ranged/:id", getRangedWeaponById, .{});
    router.get("/weapons/ranged", getAllRangedWeapons, .{});
}

fn testEndpoint(_: *httpz.Request, res: *httpz.Response) !void {
    const testType: model.RangedWeaponType = .{
        .Id = "any",
        .Name = "BudgetArms C-13",
        .WeaponType = "P",
        .Accuracy = -1,
        .Concealability = "P",
        .Avaliability = "E",
        .Damage = "1D6",
        .Ammunition = "5mm",
        .NumberOfShots = 8,
        .RateOfFire = 2,
        .Reliability = "ST",
        .CreatedAt = 0,
        .UpdatedAt = 0,
    };

    res.status = 200;
    try res.json(testType, .{});
}

fn getAllRangedWeapons(req: *httpz.Request, res: *httpz.Response) !void {
    var found = try db.RangedWeapons.GetAll(req.arena);
    defer found.deinit(req.arena);

    try res.json(found.items, .{});
}

fn getRangedWeaponById(req: *httpz.Request, res: *httpz.Response) !void {
    const id = req.param("id") orelse {
        res.status = 400;
        return;
    };

    const found = db.RangedWeapons.GetByDisplayName(req.arena, id) catch |err| {
        // Empty result handling
        if (err == db.ResultErrors.NotFound) {
            res.status = 204;
            return;
        }
        return err;
    };

    try res.json(found, .{});
}

fn newRangedWeapon(req: *httpz.Request, res: *httpz.Response) !void {
    if (try req.json(model.RangedWeaponType)) |new| {
        try res.json(new, .{});
        return;
    }
    res.status = 502;
}
