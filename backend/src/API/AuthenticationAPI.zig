const std = @import("std");
const httpz = @import("httpz");
const model = @import("../Models/User.zig");
const db = @import("../Database/Connection.zig");
const errDesc = @import("ErrorDescription.zig");
const Handler = @import("../Handler.zig");
const Tokens = @import("../Authentication/Tokens.zig");

pub fn RegisterEndpoints(router: *httpz.Router(*Handler.Handler,*const fn (*Handler.RequestData, *httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.get("/auth", getUser, .{});
    router.post("/auth/register", register, .{});
    router.post("/auth/login", login, .{});
}

fn getUser(data: *Handler.RequestData, _: *httpz.Request, res: *httpz.Response) !void { 
    if (data.User == null) {
        res.setStatus(.unauthorized);
        try res.json(.{.status = "Unauthnticated"}, .{});
        return;
    }

    try res.json(.{ 
        .Username = data.User.?.Username,
        .Role = data.User.?.Role,
    }, .{});
}

const authResult = struct {
    Token: []const u8,
    User: struct {
        Username: []const u8,
        Role: []const u8
    },
};

fn register(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    var body = try req.json(model.RequestBody) orelse {
        res.setStatus(.bad_request);
        return;
    };

    var body_model = try body.ToModel(req.arena, data.Io);

    db.Users.Create(&body_model) catch |err| {
        if (err == db.ResultErrors.AlreadyExists) {
            res.setStatus(.bad_request);
            try res.json(errDesc.ErrorDescriptor {
                .Message = "The user with that username already exists"
            }, .{});
            return;
        }
        res.setStatus(.internal_server_error);
        return;
    };

    const loginResult = loginAction(data.Io, req.arena, body) catch |err| {
        if (err == db.ResultErrors.NotFound) {
            res.setStatus(.unauthorized);
            try res.json(errDesc.ErrorDescriptor {
                .Message = "Login or password is incorrect"
            }, .{});
            return;
        }
        return err;
    };

    try res.json(loginResult, .{});
    res.setStatus(.created);
}

fn login(data: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    const body = try req.json(model.RequestBody) orelse {
        res.setStatus(.bad_request);
        return;
    };

    const loginResult = loginAction(data.Io, req.arena, body) catch |err| {
        if (err == db.ResultErrors.NotFound) {
            res.setStatus(.unauthorized);
            try res.json(errDesc.ErrorDescriptor {
                .Message = "Login or password is incorrect"
            }, .{});
            return;
        }
        return err;
    };

    try res.json(loginResult, .{});
}

/// Logs in with the given credentials
fn loginAction(io: std.Io, allocator: std.mem.Allocator, requetsed: model.RequestBody) !authResult {
    const username = requetsed.Username;
    const pwd = requetsed.Password;
    const user = try db.Users.GetByCredentials(allocator, username, pwd);

    const token = try Tokens.GenerateNewSession(io, allocator, user);

    return authResult {
        .Token = token,
        .User = .{
            .Username = user.Username,
            .Role = user.Role.ToString(),
        }
    };
}
