Some errors return a generic error message:
```json
{
    "Message": string
}
```


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

# Articles

## Get all
- GET /index
- Query params:
- - len: the page length
- - page: the page number you want to access
- - lang: the language of the articles requested
Responses:
- 200: Success:
```json
{
    "Name": string,
    "Language": string,
    "FileLocation": string (you are free to ignore this field),
    "Contents": string,
    "CreatedAt": number
}
```

# Ranged weapons

## Get all
- GET /weapons/ranged
Responses:
- 200: Success:
```json
[
    {
        "Id": string,
        "Name": string,
        "WeaponType": string,
        "Accuracy": number,
        "Concealability": string,
        "Avaliability": string,
        "Damage": string,
        "Ammunition": string,
        "NumberOfShots": number,
        "RateOfFire": number,
        "Reliability": string,
        "CreatedAt": number,
        "UpdatedAt": number,
        "Origin": string
    }
]
```

## Get by ID
- GET /weapons/ranged/:id
- Params:
- - :id - Id of the ranged weapon. Provided in the Get all Id field
Responses:
- 404: Weapon not found
- 200: Success:
```json
{
    "Id": string,
    "Name": string,
    "WeaponType": string,
    "Accuracy": number,
    "Concealability": string,
    "Avaliability": string,
    "Damage": string,
    "Ammunition": string,
    "NumberOfShots": number,
    "RateOfFire": number,
    "Reliability": string,
    "CreatedAt": number,
    "UpdatedAt": number,
    "Origin": string
}
```

## New ranged weapon
- POST /weapons/ranged
- Requires authentication header with editor role
```json
{
    "Id": string,
    "Name": string,
    "WeaponType": string,
    "Accuracy": number,
    "Concealability": string,
    "Avaliability": string,
    "Damage": string,
    "Ammunition": string,
    "NumberOfShots": number,
    "RateOfFire": number,
    "Reliability": string,
    "CreatedAt": number,
    "UpdatedAt": number,
    "Origin": string
}
```
Responses:
- 400: Malformed request or weapon already exists (see the attached message)
- 201: Success

## Update ranged weapons
- PUT /weapons/ranged/:id
- Requires authentication header with editor role
- Params:
- - :id - Id of the ranged weapon. Provided in the Get all Id field
```json
{
    "Id": string,
    "Name": string,
    "WeaponType": string,
    "Accuracy": number,
    "Concealability": string,
    "Avaliability": string,
    "Damage": string,
    "Ammunition": string,
    "NumberOfShots": number,
    "RateOfFire": number,
    "Reliability": string,
    "CreatedAt": number,
    "UpdatedAt": number,
    "Origin": string
}
```
Responses:
- 401: The provided token is invalid
- 400: Malformed request or weapon already exists (see the attached message)
- 204: The weapon was not found
- 200: Success

## Delete a ranged weapon
- DELETE /weapons/ranged/:id
- Requires authentication header with editor role
- Params:
- - :id - Id of the ranged weapon. Provided in the Get all Id field
Responses:
- 401: The provided token is invalid
- 400: The weapon was not found
- 200: Success

## Get a ranged weapon description
- GET /weapons/ranged/:id/description
- Params:
- - :id - Id of the ranged weapon. Provided in the Get all Id field
- Query params:
- - lang: the language of the articles requested
Responces:
- 200: Success
```json
{
    "Id": string,
    "Language": string,
    "Contents": string
}
```

## Upsert a ranged weapon description
- GET /weapons/ranged/:id/description
- Requires authentication header with editor role
- Params:
- - :id - Id of the ranged weapon. Provided in the Get all Id field
```json
{
    "Id": string,
    "Language": string,
    "Contents": string
}
```
Responses:
- 400: Malformed request
- 200: Success

# Classes

## Get all
- GET /classes
Responses:
```json
[
    {
        "Name": string,
        "Origin": string,
        "PreviewPicture": string
    }
]
```

## Get by name
- GET /classes/:class
- Params:
- - :class - Name of the class. Proveded in the Get all Name field
Responses:
```json
{
    "Name": string,
    "Origin": string,
    "PreviewPicture": string
}
```

## New class
- POST /classes
- Requires authentication header with editor role
```json
{
    "Name": string,
    "Origin": string,
    "PreviewPicture": string
}
```
Responses:
- 400: Malformed request
- 200: Success

# Get class description
- GET /classes/:class/description
- Params:
- - :class - Name of the class. Proveded in the Get all Name field
- Query params:
- - lang: the language of the description requested. Default value: "en"
Responses:
- 400: Malformed path
- 404: The description does not exist
- 200: Success:
```json
{
  "ClassName": string,
  "Language": string,
  "Contents": string,
  "ImageURL": string
}
```

# Set class description
- PUT /classes/:class/description
- Requires authentication header with editor role
- Params:
- - :class - Name of the class. Proveded in the Get all Name field
```json
{
  "ClassName": string,
  "Language": string,
  "Contents": string,
  "ImageURL": string
}
```
Responses:
- 400: Malformed request
- 200: Success

# Skills

## Get all
