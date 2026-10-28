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

CREATE TABLE IF NOT EXISTS Classes (
    name VARCHAR(255) PRIMARY KEY,
    origin VARCHAR(255) NOT NULL
    preview_picture_url VARCHAR(255) NOT NULL DEFAULT '',
    VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS ClassDescriptions (
    class_name VARCHAR(255) REFERENCES Classes(name) ON DELETE CASCADE,
    language VARCHAR(16) NOT NULL,
    imageurl VARCHAR(255) NOT NULL,
    contents TEXT NOT NULL,

    PRIMARY KEY (class_name, language)
);

CREATE TABLE IF NOT EXISTS Skills (
    name VARCHAR(255) PRIMARY KEY,
    type VARCHAR(32),
    category VARCHAR(32)
);


CREATE TABLE IF NOT EXISTS ClassDescriptions (
    skill_name VARCHAR(255) REFERENCES Skills(name) ON DELETE CASCADE,
    language VARCHAR(255) NOT NULL,
    contents TEXT NOT NULL,

    PRIMARY KEY (skill_name, language)
);
