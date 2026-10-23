import axios from "axios";
import { useContext, useEffect, useState } from "react";
import { useParams } from "react-router";
import { BackendURL } from "../../Config";
import { AllowedLanguage, LanguageContext } from "../../Locales/Context";
import { ClassDescription } from "../../Models/Class";

const ClasssesURL= `${BackendURL}/classes`

function ClassPage() {
    const lang = useContext(LanguageContext);
    const { name } = useParams();
    const [desc, setDesc] = useState<ClassDescription | null>(null);

    useEffect(() => {
        getClassDescription(name || "", lang).then(res => setDesc(res));
    });

    return (
        <div className="classPage">
            <span> <h1> {name} </h1> </span>
            <p> {desc?.Contents} </p>
        </div>
    );
}

async function getClassDescription(name: string, lang: AllowedLanguage): Promise<ClassDescription | null> {
    const uri = `${ClasssesURL}/${name}/description?lang=${lang}`;
    try {
        const {data, status} = await axios.get<ClassDescription>(
            uri,
            {
                headers: { Accept: "application/json" }
            }
        );

        if (status !== 200) return null; 
        return data;
    } catch (err) {
        console.log(`Failed to get class description: ${err}`);
        return null;
    }
}

export default ClassPage;
