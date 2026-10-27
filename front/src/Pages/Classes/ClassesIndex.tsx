import { GetLocalizedString } from "../../Locales/Locales";
import { AllowedLanguage, LanguageContext } from "../../Locales/Context";
import { useContext, useState } from "react";
import { Class } from "../../Models/Class";
import { AuthContext } from "../../Authentication/ContextProvider";
import { GetClasses } from "./requests";

function ClassesIndex() {
    var user = useContext(AuthContext);
    const lang = useContext(LanguageContext);
    const [classList, setClassList] = useState<Class[] | null>(null);
    useState(() => {
        GetClasses().then(data => setClassList(data));
    });

    const isAdmin = user != null && user.Role === "editor";

    return (
        <div className="ClassesDiv">
            <h1> { GetLocalizedString("Classes", lang) } </h1>
            { generateClassList(classList, lang, isAdmin) }
        </div>
    );
}

function generateClassList(classes: Class[] | null, lang: AllowedLanguage, isAdmin: boolean): any {
    if (classes == null) return ( <div> </div> );

    const list = classes.map(x => {
        function adminData() {
            if (!isAdmin) return (<span> </span>);
            return ( <a href={ `/classes/${x.Name}/edit` }> edit </a> );
        };
        return (
            <li className="classPreview">
                <a href={ `/classes/${x.Name}` }>
                    <div>
                    <img className="classPreviewImage" 
                        src={x.PreviewPicture || "/classified.png"}
                        alt={GetLocalizedString(x.Name, lang)}
                    />
                    <h2 className="classPreviewName"> { GetLocalizedString(x.Name, lang) } </h2>
                    <p className="classPreviewOrigin"> { GetLocalizedString(x.Origin, lang) } </p>
                    </div>
                </a>
                { adminData() }
            </li>
        );
    });

    return (<ul className="classList"> {list} </ul>);
}

export default ClassesIndex;
