pub const ErrorDescriptor = struct {
    Message: []const u8
};

pub const NotFoundDescriptor = ErrorDescriptor {
    .Message = "The requested object was not found"
};
