import { useContext, useEffect, useState } from "react";
import { useCookies } from "react-cookie";
import { useParams } from "react-router";
import { AuthContext } from "../../Authentication/ContextProvider";
import { AllowedLanguage } from "../../Locales/Context";
import { Class, ClassDescription } from "../../Models/Class";
import { GetClassDescription, GetClassInfo, UpdateClassInfo, UpsertDescription } from "./requests";

function ClassAdminPage() {
    var user = useContext(AuthContext);
    const { name } = useParams();
    const [currentLanguage, setCurrentLanguage] = useState<AllowedLanguage>("en");
    const [authCookie, ] = useCookies(['X-AUTH-TOKEN']);
    const [isNew, setIsNew] = useState(true);

    const [classData, setClassData] = useState<Class | null>(null);
    const [desc, setDesc] = useState<ClassDescription | null>(null);
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
                        if (!classData) return;
                        setClassData({...classData, Name: val.target.value});
                    }} /> 
                </span>
                <table>
                    <tbody>
                        <tr>
                            <td> Preview picture </td>
                            <td>
                                <input value={classData?.PreviewPicture || ""} onChange={(val) => {
                                    if (!classData) return;
                                    setClassData({...classData, PreviewPicture: val.target.value});
                                }} /> 
                            </td>
                        </tr>
                        <tr>
                            <td> Origin </td>
                            <td>
                                <input value={classData?.Origin || ""} onChange={(val) => {
                                    if (!classData) return;
                                    setClassData({...classData, Origin: val.target.value});
                                }} /> 
                            </td>
                        </tr>
                    </tbody>
                </table>
                <button onClick={() => {
                    if (!isNew) {
                        UpdateClassInfo(classData, authCookie['X-AUTH-TOKEN']);
                    }
                }}> 
                    { isNew ? "Create" : "Update" } 
                </button>

                <h2> Description update </h2>
                { descriptionEditor() }
        </div>
    );
}

export default ClassAdminPage;
