export type RangedWeapon = {
    Id: string,
    Name: string,

    WeaponType: string,
    Accuracy: number,
    Concealability: string,
    Avaliability: string,
    Damage: string,
    Ammunition: string,
    NumberOfShots: number,
    RateOfFire: number,
    Reliability: string,

    CreatedAt: number,
    UpdatedAt: number,
};

export type RangedWeaponRequest = {
    Id: string,
    Name: string,
    WeaponType: string,
    Accuracy: number,
    Concealability: string,
    Avaliability: string,
    Damage: string,
    Ammunition: string,
    NumberOfShots: number,
    RateOfFire: number,
    Reliability: string,
};
