import { Class, ClassDescription, ClassDescriptionFull, ClassTranslation, ClassView } from "../../Models/Class";
import { BackendURL } from "../../Config";
import axios from "axios";
import { AllowedLanguage } from "../../Locales/Context";
import { Skill } from "../../Models/Skill";

const ClassesURL = `${BackendURL}/classes`;

export async function GetClasses(lang: AllowedLanguage): Promise<ClassView[]> {
    const url = `${ClassesURL}?lang=${lang}`

    try {
        const { data, status } = await axios.get<ClassView[]>(
            url, {
                headers: { Accept: "application/json" }
            }
        );

        if (status != 200) return new Array<ClassView>();

        return data;
    } catch (err) {
        console.log(`Failed to get class list: ${err}`);
        return new Array<ClassView>();
    }
}

export async function GetClassInfo(name: string | undefined): Promise<Class | null> {
    const uri = `${ClassesURL}/${name}`;
    try {
        const {data, status} = await axios.get<Class>(
            uri,
            {
                headers: { Accept: "application/json" }
            }
        );

        if (status !== 200) return null; 
        return data;
    } catch (err) {
        console.log(`Failed to get class info: ${err}`);
        return null;
    }
}

export async function UpdateClassInfo(data: Class | null, token: string) {
    const url = `${ClassesURL}/${data?.Name}`;
    await axios.put(url, data, {
        headers: {
            Authorization: `Bearer ${token}`
        }
    });
}

export async function CreateClassInfo(data: Class | null, token: string) {
    await axios.post(ClassesURL, data, {
        headers: {
            Authorization: `Bearer ${token}`
        }
    });
}

export async function GetClassDescription(name: string, lang: AllowedLanguage): Promise<ClassDescriptionFull | null> {
    const uri = `${ClassesURL}/${name}/description?lang=${lang}`;
    try {
        const {data, status} = await axios.get<ClassDescriptionFull>(
            uri,
            {
                headers: { Accept: "application/json" }
            }
        );

        if (status !== 200) return null; 
        return data;
    } catch (err) {
        console.error(`Failed to get class description: ${err}`);
        return null;
    }
}

export async function UpsertDescription(desc: ClassDescription | null, token: string) {
    const url = `${ClassesURL}/${desc?.ClassName}/description`;
    await axios.put(url, desc, {
        headers: {
            Authorization: `Bearer ${token}`
        }
    });
}

export type SkillLinkType = "specialization" | "career"

export async function GetAttachedSkills(className: string, type: SkillLinkType): Promise<Skill[] | null> {
    const url = `${ClassesURL}/${className}/${type}`;
    try {
        const res = await axios.get<Skill[]>(url);

        if (res.status != 200) return null;
        return res.data;
    } catch (err) {
        console.error(`Failed to get attached skills with type ${type}: ${err}`);
        return new Array<Skill>();
    }
}

export function DeleteLinkedSkill(
    skill: Skill,
    className: string,
    type: SkillLinkType,
    token: string
    ) {
    const url = `${ClassesURL}/${className}/${type}/${skill.Name}`;
    try {
        axios.delete(url, {
            headers: {
                Authorization: `Bearer ${token}`
            }
        });
    } catch (err) {
        console.error(`Failed to delete a linked skill: ${err}`);
    }
}

export async function AddLinkedSkill(
    skillName: string,
    className: string,
    type: SkillLinkType,
    token: string
): Promise<boolean> {
    const url = `${ClassesURL}/${className}/${type}`;

    const body: { SkillName: string } = {
        SkillName: skillName,
    };

    try {
        const res = await axios.post(url, body, {
            headers: {
                Authorization: `Bearer ${token}`
            }
        });

        return res.status == 200;
    } catch (err) {
        console.error(`Failed to add an attached skill with type ${type}: ${err}`);
        return false;
    }
}

export async function GetClassNameTranslation(
    className: string,
    lang: AllowedLanguage
): Promise<string> {
    const url = `${ClassesURL}/${className}/translation?lang=${lang}`;
    try {
        const res = await axios.get<ClassTranslation>(url);
        if (res.status != 200) return className;

        return res.data.Translation;
    } catch (err) {
        console.error(`Failed to get the class translation: ${err}`);
        return className;
    }
}

export async function SetClassNameTranslation(
    className: string,
    lang: AllowedLanguage,
    translated: string,
    token: string
) {
    const url = `${ClassesURL}/${className}/translation`;
    const body = {
        Language: lang,
        Translation: translated,
    };

    try {
        await axios.put(url, body, {
            headers: {
                Authorization: `Bearer ${token}`
            }
        });
    } catch (err) {
        console.error(`Failed to upsert the class translation: ${err}`);
    }
}
