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

## Get class description
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
  "ImageURL": string,
  "SpecizalizationSkills": [
    {
        "SkillName": string,
        "Language": string,
        "Contents": string
    }
  ],
  "CareerSkills": [
    {
        "SkillName": string,
        "Language": string,
        "Contents": string
    }
  ],
}
```

## Set class description
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

# Specialization skills

## Get specialization skill
- GET classes/:skill/specialization
- Params:
- - :class - Name of the class. Proveded in the Get all Name field
Responces:
- 400: Malformed request
- 200: Success
```json
[
    {
        "Name": string,
        "Type": string,
        "Category": string
    }
]
```

## Add specialization skill
- POST classes/:skill/specialization
- Requires authentication header with editor role
- Params:
- - :class - Name of the class. Proveded in the Get all Name field
```json
{
    "Name": string,
    "Type": string,
    "Category": string
}
```
Responces:
- 400: Malformed request
- 404: Class or skill nto found
- 201: Success


## Remove a specialization skill
- DELETE classes/:skill/specialization
- Requires authentication header with editor role
- Params:
- - :class - Name of the class. Proveded in the Get all Name field
```json
{
    "Name": string,
    "Type": string,
    "Category": string
}
```
Responces:
- 400: Malformed request
- 404: Class or skill nto found
- 201: Success

## Get specialization skill
- GET classes/:skill/specialization
- Params:
- - :class - Name of the class. Proveded in the Get all Name field
Responces:
- 400: Malformed request
- 200: Success
```json
[
    {
        "Name": string,
        "Type": string,
        "Category": string
    }
]
```

# Specialization skills

## Get specialization skill
- GET classes/:skill/specialization
- Params:
- - :class - Name of the class. Proveded in the Get all Name field
Responces:
- 400: Malformed request
- 200: Success
```json
[
    {
        "Name": string,
        "Type": string,
        "Category": string
    }
]
```

## Add career skill
- POST classes/:skill/career
- Requires authentication header with editor role
- Params:
- - :class - Name of the class. Proveded in the Get all Name field
```json
{
    "Name": string,
    "Type": string,
    "Category": string
}
```
Responces:
- 400: Malformed request
- 404: Class or skill nto found
- 201: Success


## Remove a career skill
- DELETE classes/:skill/career
- Requires authentication header with editor role
- Params:
- - :class - Name of the class. Proveded in the Get all Name field
```json
{
    "Name": string,
    "Type": string,
    "Category": string
}
```
Responces:
- 400: Malformed request
- 404: Class or skill nto found
- 201: Success
