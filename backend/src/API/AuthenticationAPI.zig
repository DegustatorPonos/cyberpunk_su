const std = @import("std");
const httpz = @import("httpz");
const model = @import("../Models/User.zig");
const db = @import("../Database/Connection.zig");
const errDesc = @import("ErrorDescription.zig");
const Handler = @import("../Handler.zig");
const Tokens = @import("../Authentication/Tokens.zig");

pub fn RegisterEndpoints(router: *httpz.Router(*Handler.Handler,*const fn (*Handler.RequestData, *httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.post("/auth/register", register, .{});
    router.post("/auth/login", login, .{});
}

fn register(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
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

fn login(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    const body = try req.json(model.RequestBody) orelse {
        res.setStatus(.bad_request);
        return;
    };

    const username = body.Username;
    const pwd = body.Password;

    const user = db.Users.GetByCredentials(req.arena, username, pwd) catch |err| {
        if (err == db.ResultErrors.NotFound) {
            res.setStatus(.unauthorized);
            try res.json(errDesc.ErrorDescriptor {
                .Message = "Login or password is incorrect"
            }, .{});
            return;
        }
        return err;
    };

    const token = try Tokens.GenerateNewSession(res.arena, user);
    try res.json(.{ .Token = token } , .{});
}
