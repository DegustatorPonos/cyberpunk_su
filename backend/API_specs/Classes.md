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
