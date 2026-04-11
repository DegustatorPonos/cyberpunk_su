import { useState } from "react";
import { GetString } from "../Locales/Locales";

function IndexElement() {
    const [lang, setLang] = useState('en');
    return (
        <div>
            <h1> {GetString("index", lang)} </h1>
        </div>
    );
}

export default IndexElement;
