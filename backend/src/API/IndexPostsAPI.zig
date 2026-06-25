const std = @import("std");
const httpz = @import("httpz");
const model = @import("../Models/Article.zig");
const Handler = @import("../Handler.zig");
const db = @import("../Database/Connection.zig");

pub fn RegisterEndpoints(router: *httpz.Router(*Handler.Handler,*const fn (*Handler.RequestData, *httpz.request.Request, *httpz.response.Response) anyerror!void)) void {
    router.get("/index", getArticles, .{});
}

fn getArticles(_: *Handler.RequestData, req: *httpz.Request, res: *httpz.Response) !void {
    const query = try req.query();
    var articles: std.ArrayList(model.Article) = undefined; 

    if (query.get("lang")) |lang| {
        articles = try db.Articles.GetByLanguage(req.arena, lang);
    } else articles = try db.Articles.GetAll(req.arena);

    return try res.json(articles.items, .{});
}
