import { useContext, useEffect, useState } from "react";
import { useParams } from "react-router";
import { LanguageContext } from "../../Locales/Context";
import { ClassDescription } from "../../Models/Class";
import { GetClassDescription } from "./requests";

function ClassPage() {
    const lang = useContext(LanguageContext);
    const { name } = useParams();
    const [desc, setDesc] = useState<ClassDescription | null>(null);

    useState(() => {
        GetClassDescription(name || "", lang).then(res => setDesc(res));
    });

    return (
        <div className="classPage">
            <span> <h1> {name} </h1> </span>
            <p> {desc?.Contents} </p>
        </div>
    );
}

export default ClassPage;
