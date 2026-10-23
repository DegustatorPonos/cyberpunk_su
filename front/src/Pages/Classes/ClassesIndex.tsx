import { GetLocalizedString } from "../../Locales/Locales";
import { AllowedLanguage, LanguageContext } from "../../Locales/Context";
import { useContext, useState } from "react";
import { Class } from "../../Models/Class";
import axios from "axios";
import { BackendURL } from "../../Config";

const ClassesURL = `${BackendURL}/classes`;

function ClassesIndex() {
    const lang = useContext(LanguageContext);
    const [classList, setClassList] = useState<Class[] | null>(null);
    useState(() => {
        getClasses().then(data => setClassList(data));
    });

    return (
        <div className="ClassesDiv">
            <h1> { GetLocalizedString("Classes", lang) } </h1>
            { generateClassList(classList, lang) }
        </div>
    );
}

function generateClassList(classes: Class[] | null, lang: AllowedLanguage): any {
    if (classes == null) return ( <div> </div> );

    const list = classes.map(x => {
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
            </li>
        );
    });

    return (<ul className="classList"> {list} </ul>);
}

async function getClasses(): Promise<Class[]> {
    try {
        const { data, status } = await axios.get<Class[]>(
            ClassesURL,
            {
                headers: { Accept: "application/json" }
            }
        );

        if (status != 200) return new Array<Class>();

        return data;
    } catch (err) {
        console.log(`Failed to get class list: ${err}`);
        return new Array<Class>();
    }
}

export default ClassesIndex;
