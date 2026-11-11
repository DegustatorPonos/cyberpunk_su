import { SkillView } from "./Skill";

export type Class = {
    Name: string,
    PreviewPicture: string,
    Origin: string,
};

export type ClassView = {
    Name: string,
    DisplayName: string,
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
    ClassViewName: string,
    Language: string,
    Contents: string,
    ImageURL: string,

    SpecizalizationSkills: SkillView[],
    CareerSkills: SkillView[],
};
