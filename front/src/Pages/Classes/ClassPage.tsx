import "./classStyles.css"
import { useContext, useEffect, useState } from "react";
import { useParams } from "react-router";
import { AuthContext } from "../../Authentication/ContextProvider";
import { LanguageContext } from "../../Locales/Context";
import { ClassDescriptionFull } from "../../Models/Class";
import { SkillView } from "../../Models/Skill";
import { GetClassDescription } from "./requests";
import { GetLocalizedString } from "../../Locales/Locales";

function ClassPage() {
    var user = useContext(AuthContext);
    const lang = useContext(LanguageContext);
    const { name } = useParams();
    const [desc, setDesc] = useState<ClassDescriptionFull | null>(null);

    useEffect(() => {
        GetClassDescription(name || "", lang).then(res => setDesc(res));
    }, [lang]);

    function editButton() {
        if (!user || user.Role !== "editor") {
            return (<p></p>);
        } else {
            return ( <a href={`${name}/edit`}> Edit </a> );
        }
    }

    return (
        <div className="classPage">
            <span> <h1> {name} </h1> </span>
            <div className="classPageBody">
                <div className="classImage">
                    <img src={desc?.ImageURL} />
                </div>
                <div className="classDescription">
                    { mapClassParagraphs(desc?.Contents || "") }
                    <h2 className="classSkillsListName"> { GetLocalizedString("Specialization", lang) } </h2>
                    { mapSkillList(desc?.SpecizalizationSkills || new Array<SkillView>()) }
                    <h2 className="classSkillsListName"> { GetLocalizedString("Career skills", lang) } </h2>
                    { mapSkillList(desc?.CareerSkills || new Array<SkillView>()) }
                </div>
            </div>
            { editButton() }
        </div>
    );
}

function mapClassParagraphs(contents: string) {
    const list = contents.split('\n').map(p => {
        return (<p>{p}</p>);
    });
    return (
        <div> {list} </div>
    );
}

function mapSkillList(skills: SkillView[]) { 
    const els = skills.map(s => {
        return (
            <li key={s.Name} className="classSkill"> 
                <a href={`/skills#${s.Name}`}> {s.DisplayName} </a>
            </li>
        );
    });

    return ( <ul className="classSkillsList"> { els } </ul> );
}

export default ClassPage;
