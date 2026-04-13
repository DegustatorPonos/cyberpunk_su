const httpz = @import("httpz");
const model = @import("../Models/RangedWeapon.zig");

pub fn RegisterEndpoints(router: *httpz.Router(void, *const fn (*httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.get("/weapons", testEndpoint, .{});
}

fn testEndpoint(_: *httpz.Request, res: *httpz.Response) !void {
    const testType: model.RangedWeaponType = .{
        .Name = "BudgetArms C-13",
        .WeaponType = "P",
        .Accuracy = -1,
        .Concealability = "P",
        .Avaliability = "E",
        .Damage = "1D6",
        .Ammunition = "5mm",
        .NumberOfShots = 8,
        .RateOfFire = 2,
        .Reliability = "ST"
    };

    res.status = 200;
    try res.json(testType, .{});
}
