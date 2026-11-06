import { useContext, useEffect, useState } from "react";
import { useCookies } from "react-cookie";
import { useParams } from "react-router";
import { AuthContext } from "../../Authentication/ContextProvider";
import { AllowedLanguage, LanguageContext } from "../../Locales/Context";
import { GetLocalizedString } from "../../Locales/Locales";
import { Class, ClassDescriptionFull } from "../../Models/Class";
import { SkillView, Skill } from "../../Models/Skill";
import { GetAllSkills } from "../Skills/requests";
import { AddLinkedSkill, CreateClassInfo, DeleteLinkedSkill, GetAttachedSkills, GetClassDescription, GetClassInfo, SkillLinkType, UpdateClassInfo, UpsertDescription } from "./requests";

interface avaliableSkillSelector {
    onChange: (selected: string) => void;
}

function AvaliableSkillSelector(data: avaliableSkillSelector) {
    const lang = useContext(LanguageContext);
    const [allSkills, setAllSkills] = useState<string[] | null>(null);

    useState(() => {
        GetAllSkills(lang).then(res => {
            setAllSkills(res.map(x => x.Name));
        });
    });

    const els = allSkills?.map(x => {
        return (
            <option value={x}> {x} </option>
        );
    });

    return (
        <select 
            onChange={(val: React.ChangeEvent<HTMLSelectElement>) => { 
                data.onChange(val.target.value) 
            }}>
        {els}
        </select>
    );
}

interface skillsEditInfo  {
    /// Used in determening the relation of the class to the skill
    SkillSetName: SkillLinkType;
    ClassName: string;
}

function SkillsEdit(data: skillsEditInfo) {
    const lang = useContext(LanguageContext);
    const [skills, setSkills] = useState<Skill[] | null>(null);
    const [skillToAdd, setskillToAdd] = useState<string | null>(null);
    const [authCookie] = useCookies(['X-AUTH-TOKEN']);

    useState(() => {
        GetAttachedSkills(data.ClassName, data.SkillSetName).then(res => {
            setSkills(res);
        });
    });

    if (!skills) return (
        <div> 
            <h2> { GetLocalizedString(data.SkillSetName, lang) } </h2>
        </div>
    );

    const els = skills.map(x => {
        return (
            <tr>
                <td> { GetLocalizedString(x.Name, lang) } </td>
                <td>
                    <button className="classSkillBtn" onClick={() => {
                        DeleteLinkedSkill(x, 
                                          data.ClassName,
                                          data.SkillSetName,
                                          authCookie['X-AUTH-TOKEN']);

                        const idx = skills.indexOf(x);
                        setSkills(Array.prototype.concat(
                            skills.slice(0, idx),
                            skills.slice(idx + 1, skills.length),
                        ));
                    }}> Delete </button>
                </td>
            </tr>
        )
    });

    return (
        <div>
            <h2 className="skillEditTypeHeader"> { GetLocalizedString(data.SkillSetName, lang) } </h2>
            <table> 
                <tbody>
                    {els} 
                    <tr>
                        <td>
                            <AvaliableSkillSelector onChange={(val) => {
                                setskillToAdd(val);
                            }} />
                        </td>
                        <td>
                            <button className="classSkillBtn" onClick={() => {
                                if (!skillToAdd) return;

                                AddLinkedSkill(skillToAdd, 
                                               data.ClassName,
                                               data.SkillSetName,
                                               authCookie['X-AUTH-TOKEN'])
                                .then(res => {
                                    if (res) setSkills([...skills, { 
                                        Name: skillToAdd,
                                        Type: "",
                                        Category: "",
                                    }]);
                                });
                            }}> Add </button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    );
}


function ClassAdminPage() {
    var user = useContext(AuthContext);
    const { name } = useParams();
    const [currentLanguage, setCurrentLanguage] = useState<AllowedLanguage>("en");
    const [authCookie, ] = useCookies(['X-AUTH-TOKEN']);
    const [isNew, setIsNew] = useState(true);

    const [classData, setClassData] = useState<Class | null>(null);
    const [desc, setDesc] = useState<ClassDescriptionFull | null>(null);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        if (user !== null) {
            setIsLoading(false);
            GetClassInfo(name).then(res => { 
                setClassData(res); 
                setIsNew(res == null);
            });
            GetClassDescription(name || "", currentLanguage).then(res => setDesc(res));
        }
    }, [user]);

    useEffect(() => {
        GetClassDescription(name || "", currentLanguage).then(res => {
            setDesc(res);
        });
    }, [currentLanguage, name]);

    if (isLoading) {
        return <div>Loading...</div>;
    }

    if (user?.Role !== "editor") {
        throw new Response("Forbidden", { status: 403 });
    }

    function descriptionEditor() {
        if (isNew) return (
            <h2> Save a class to edit its description </h2>
        );
        return (
            <div>
                <div className="descPanel">
                    <span> Description update </span>
                        <select 
                        value={currentLanguage}
                        onChange={ (val) => {
                            setCurrentLanguage(val.target.value as AllowedLanguage);
                        }}> 
                        <option value="ru"> ru </option>
                        <option value="en"> en </option>
                    </select>

                    <button onClick={ () => {
                        if (isNew) return;
                        UpsertDescription(desc, authCookie['X-AUTH-TOKEN']);
                    }}> Update </button> 
                </div>

                <textarea className="descriptionInput" 
                    value={ desc == null ? "" : desc.Contents }
                    onChange={(val) => {
                        if (!desc) {
                            if (!name) return;
                            setDesc({
                                ClassName: name,
                                Language: currentLanguage,
                                ImageURL: "",
                                Contents: val.target.value,

                                SpecizalizationSkills: new Array<SkillView>(),
                                CareerSkills: new Array<SkillView>(),
                            });
                            return;
                        }
                        setDesc({...desc, Contents: val.target.value});
                    }}
                />

                <div className="classImageURL">
                    <p> Class image URL </p>
                    <input className="url" value={desc?.ImageURL} onChange={(val) => {
                        if (!desc) {
                            if (!name) return;
                            setDesc({
                                ClassName: name,
                                Contents: "",
                                Language: currentLanguage,
                                ImageURL: val.target.value,

                                SpecizalizationSkills: new Array<SkillView>(),
                                CareerSkills: new Array<SkillView>(),
                            });
                            return;
                        }
                        setDesc({...desc, ImageURL: val.target.value});
                    }} /> 
                </div>
            </div>
        );
    }

    return (
        <div className="WeaponPage">
        <h1> { isNew ? "Creating a new class" : "Editing a class" } </h1>
                <span>
                    <input className="NameEdit" value={classData?.Name || ""} onChange={(val) => {
                        if (!classData) {
                            setClassData({
                                Name: val.target.value,
                                Origin: "",
                                PreviewPicture: "",
                            });
                            return;
                        };
                        setClassData({...classData, Name: val.target.value});
                    }} /> 
                </span>
                <table>
                    <tbody>
                        <tr>
                            <td> Preview picture </td>
                            <td>
                                <input value={classData?.PreviewPicture || ""} onChange={(val) => {
                                    if (!classData) {
                                        setClassData({
                                            Name: "",
                                            Origin: "",
                                            PreviewPicture: val.target.value,
                                        });
                                        return;
                                    };
                                    setClassData({...classData, PreviewPicture: val.target.value});
                                }} /> 
                            </td>
                        </tr>
                        <tr>
                            <td> Origin </td>
                            <td>
                            <input 
                                value={classData?.Origin || ""} 
                                onChange={(val) => {
                                    if (!classData) {
                                        setClassData({
                                            Name: "",
                                            Origin: val.target.value,
                                            PreviewPicture: "",
                                        });
                                        return;
                                    };
                                    setClassData({...classData, Origin: val.target.value});
                            }} /> 
                            </td>
                        </tr>
                    </tbody>
                </table>
                <button onClick={() => {
                    if (!isNew) {
                        UpdateClassInfo(classData, authCookie['X-AUTH-TOKEN']);
                    } else {
                        CreateClassInfo(classData, authCookie['X-AUTH-TOKEN']);
                    }
                }}> 
                    { isNew ? "Create" : "Update" } 
                </button>

                <h2> Description update </h2>
                { descriptionEditor() }
                
                <SkillsEdit 
                    SkillSetName="specialization"
                    ClassName={desc?.ClassName || "new"}
                />

                <SkillsEdit 
                    SkillSetName="career"
                    ClassName={desc?.ClassName || "new"}
                />
        </div>
    );
}

export default ClassAdminPage;
