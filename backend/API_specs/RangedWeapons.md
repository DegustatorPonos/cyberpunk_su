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
