# Authentication

The authentication provides user with a bearer token. For protected endpoints 
you will need to include "Authentication": "Bearer <token>" header. It will be
specified as "Requires authentication header".

## Register
- POST /auth/register
```json
{
    "Username": string,
    "Password": string
}
```
Responses:
- 400: Malformed request
- 401: Login or password is incorrect
- 200: Success:
```json
{
    "Token": string,
    "User": {
        "Username": string,
        "Role": string
    }
}
```

## Login
- POST /auth/login
```json
{
    "Username": string,
    "Password": string
}
```
Responses:
- 400: Malformed request
- 401: Login or password is incorrect
- 200: Success:
```json
{
    "Token": string,
    "User": {
        "Username": string,
        "Role": string
    }
}
```

## User info
- GET /auth
- Requires authentication header
Responses:
- 401: The provided token is invalid
- 200: Success:
```json
{
    "Username": string,
    "Role": string
}
```
