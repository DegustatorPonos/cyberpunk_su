# Skills

## Get all
- GET /skills
Gets the skill names and descriptions. Translates the name
- Query params:
- - lang: the language of the articles requested
Responses:
- 200: Success:
```json
[
    {
         "Name": string,
         "DisplayName": string,
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

## Set translation
- PUT /skills/:skill/translation
- Requires authentication header with editor role
```json
{
    "Language": string,
    "Translation": string
}
```
Responses:
- 400: Malformed request
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
