# Static file

## Get a file
- GET /static/:file
- Params:
- - :file - The name of the file
Responces:
- 400: Malformed request
- 404: File not found
- 200: Success. The file should be in the body.

## Upload a file
- POST /static
- Requires authentication header with editor role
The file should be in the request body. You can also add the Content-Type with
a raw extention of the file you are uploading
Responses:
- 400: The exact same file already exists on the server. You can use SHA-256 to get its name
- 200: Success
