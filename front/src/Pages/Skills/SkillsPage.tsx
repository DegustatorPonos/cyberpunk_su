import { useContext, useEffect, useState } from "react";
import { LanguageContext } from "../../Locales/Context";
import { GetLocalizedString } from "../../Locales/Locales";
import { SkillView } from "../../Models/Skill";
import { GetAllSkills } from "./requests";
import "./skills.css";

function SkillsPage() {
    const lang = useContext(LanguageContext);
    const [skills, setSkills] = useState<SkillView[] | null>(null);

    useEffect(() => {
        GetAllSkills(lang).then(s => setSkills(s));
    }, [lang]);

    return (<div>
            <span> <h1> { GetLocalizedString("Skills", lang) } </h1> </span>
            { mapSkillViews(skills) }
            </div>);
}

function mapSkillViews(skills: SkillView[] | null) {
    if (skills == null) return (<div></div>);

    const categorized = new Map<string, SkillView[]>();

    skills.forEach(el => {
        if (!categorized.has(el.Type)) {
            categorized.set(el.Type, new Array<SkillView>());
        }
        categorized.get(el.Type)?.push(el);
    })

    const keys = Array.from(categorized.keys()).sort();
    const els = keys.map(k => {
        const els = categorized.get(k)?.map(s => {
            return (
                <div className="skillRecord">
                <div className="skillHeader">
                <a href={`/skills#${s.Name}`}> <h2> # </h2> </a>
                <h2 id={s.Name}> {s.DisplayName} </h2>
                </div>
                <p className="skillDesc"> {s.Description || "No description"} </p>
                </div>
            );
        });

        return (
            <div>
                <h1 className="skillCategoryName"> {k.toUpperCase()} </h1>
                { els }
            </div>
        )
    });

    return (
        <div className="skillList"> {els} </div>
    );
}

export default SkillsPage;
