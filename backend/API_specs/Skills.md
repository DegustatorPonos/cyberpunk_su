# Skills

## Get all
- GET /skills
Responses:
- 200: Success:
```json
[
    {
         "Name": string,
         "Type": string,
         "Category": string,
         "Description": string
    }
]
```

## New skill
- POST /skills
- Requires authentication header with editor role
```json
{
    "Name": string,
    "Type": string, // "career" | "pickup" | "special"
    "Category": string
}
```
Responses:
- 400: Malformed request
- 200: Success

## Update skill
- PUT /skills/:skill
- Requires authentication header with editor role
- Params:
- - :skill - Name of the skill. Proveded in the Get all Name field
```json
{
    "Name": string, // can be whatever
    "Type": string, // "career" | "pickup" | "special"
    "Category": string
}
```
Responses:
- 400: Malformed request
- 404: Skill does not exist
- 200: Success

## Get description
- GET /skills/:skill/description
- Params:
- - :skill - Name of the skill. Proveded in the Get all Name field
Rsponses:
- 200: Success:
```json
{
  "SkillName": string,
  "Language": string,
  "Contents": string
}
```

## Upsert descripotion
- PUT /skills/:skill/description
- Params:
- - :skill - Name of the skill. Proveded in the Get all Name field
```json
{
  "SkillName": string, // can be whatever
  "Language": string,
  "Contents": string
}
```
Responses:
- 404: Skill does not exist
- 200: Success
