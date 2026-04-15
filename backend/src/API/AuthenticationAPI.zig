const std = @import("std");
const httpz = @import("httpz");
const model = @import("../Models/User.zig");
const db = @import("../Database/Connection.zig");
const errDesc = @import("ErrorDescription.zig");
const Handler = @import("../Handler.zig");

pub fn RegisterEndpoints(router: *httpz.Router(*Handler.Handler,*const fn (*Handler.Handler, *httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.post("/auth/register", register, .{});
}

fn register(_: *Handler.Handler, req: *httpz.Request, res: *httpz.Response) !void {
    var body = try req.json(model.RequestBody) orelse {
        res.setStatus(.bad_request);
        return;
    };

    var body_model = try body.ToModel(req.arena);

    db.Users.Create(&body_model) catch |err| {
        if (err == db.ResultErrors.AlreadyExists) {
            res.setStatus(.bad_request);
            try res.json(errDesc.AlreadyExistsDescriptor, .{});
            return;
        }
        res.setStatus(.internal_server_error);
        return;
    };
    res.setStatus(.created);
}
