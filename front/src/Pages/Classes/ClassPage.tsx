import { useContext, useEffect, useState } from "react";
import { useParams } from "react-router";
import { AuthContext } from "../../Authentication/ContextProvider";
import { LanguageContext } from "../../Locales/Context";
import { ClassDescription } from "../../Models/Class";
import { GetClassDescription } from "./requests";

function ClassPage() {
    var user = useContext(AuthContext);
    const lang = useContext(LanguageContext);
    const { name } = useParams();
    const [desc, setDesc] = useState<ClassDescription | null>(null);

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
                { mapClassParagraphs(desc?.Contents || "") }
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
        <div className="classDescription"> {list} </div>
    );
}

export default ClassPage;
