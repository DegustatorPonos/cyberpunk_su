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
