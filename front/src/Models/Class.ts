import { Skill } from "./Skill";

export type Class = {
    Name: string,
    PreviewPicture: string,
    Origin: string,
};

export type ClassDescription = {
    ClassName: string,
    Language: string,
    Contents: string,
    ImageURL: string,
};

export type ClassDescriptionFull = {
    ClassName: string,
    Language: string,
    Contents: string,
    ImageURL: string,

    SpecizalizationSkills: Skill[],
    CareerSkills: Skill[],
};
