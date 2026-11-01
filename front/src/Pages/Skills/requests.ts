import axios from "axios";
import { BackendURL } from "../../Config";
import { SkillView } from "../../Models/Skill";

const SkillURL = `${BackendURL}/skills`;

export async function GetAllSkills(lang: string): Promise<SkillView[]> {
    const url = `${SkillURL}?lang=${lang}`;
    try {
        const { data, status } = await axios.get<SkillView[]>(
            url,
            {
                headers: { Accept: "application/json" }
            }
        );

        if (status != 200) return new Array<SkillView>();

        return data;
    } catch (err) {
        return new Array<SkillView>();
    }
}
