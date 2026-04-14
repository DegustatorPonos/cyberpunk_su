const std = @import("std");
const httpz = @import("httpz");
const model = @import("../Models/RangedWeapon.zig");
const db = @import("../Database/Connection.zig");

pub fn RegisterEndpoints(router: *httpz.Router(void, *const fn (*httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.get("/weapons", testEndpoint, .{});
    router.post("/weapons/ranged", newRangedWeapon, .{});
    router.get("/weapons/ranged", getAllRangedWeapons, .{});
}

fn testEndpoint(_: *httpz.Request, res: *httpz.Response) !void {
    const testType: model.RangedWeaponType = .{
        .Id = 0,
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

fn getAllRangedWeapons(_: *httpz.Request, res: *httpz.Response) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var found = try db.RangedWeapons.GetAll(allocator);
    defer found.deinit(allocator);

    try res.json(found.items, .{});
}

fn newRangedWeapon(req: *httpz.Request, res: *httpz.Response) !void {
    if (try req.json(model.RangedWeaponType)) |new| {
        try res.json(new, .{});
        return;
    }
    res.status = 502;
}
