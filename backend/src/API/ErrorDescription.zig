pub const ErrorDescriptor = struct {
    Message: []const u8
};

pub const NotFoundDescriptor = ErrorDescriptor {
    .Message = "The requested object was not found"
};

pub const AlreadyExistsDescriptor = ErrorDescriptor {
    .Message = "The object already exists in the database"
};
