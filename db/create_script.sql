CREATE TABLE IF NOT EXISTS RangedWeapons (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    weapon_type VARCHAR(255) NOT NULL,
    accuracy INTEGER,
    concealability VARCHAR(255) NOT NULL,
    availability VARCHAR(255) NOT NULL,
    damage VARCHAR(255) NOT NULL,
    ammunition VARCHAR(255) NOT NULL,
    number_of_shots INTEGER,
    rate_of_fire INTEGER,
    reliability VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    origin VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS RangedWeaponsDescriptions (
    id VARCHAR(255) REFERENCES RangedWeapons(id) ON DELETE CASCADE,
    language VARCHAR(16),
    /* This field is not used in the actual program and is used to order the articles */
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    contents TEXT,

    PRIMARY KEY (id, language)
);

CREATE TABLE IF NOT EXISTS Articles (
    name VARCHAR(255),
    language VARCHAR(16),
    file_location TEXT,

    PRIMARY KEY (name, language)
);

CREATE TABLE Users (
    Id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    Username TEXT NOT NULL UNIQUE,
    /* SHA512 encryption */
    PasswordHash VARCHAR(512) NOT NULL UNIQUE,
    Role TEXT NOT NULL
);
