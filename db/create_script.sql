CREATE TABLE weapons (
    id SERIAL PRIMARY KEY,
    weapon_type VARCHAR(255) NOT NULL,
    accuracy SMALLINT CHECK (accuracy BETWEEN -128 AND 127),
    concealability VARCHAR(255) NOT NULL,
    availability VARCHAR(255) NOT NULL,
    damage VARCHAR(255) NOT NULL,
    ammunition VARCHAR(255) NOT NULL,
    number_of_shots SMALLINT CHECK (number_of_shots BETWEEN 0 AND 255),
    rate_of_fire SMALLINT CHECK (rate_of_fire BETWEEN 0 AND 255),
    reliability VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
