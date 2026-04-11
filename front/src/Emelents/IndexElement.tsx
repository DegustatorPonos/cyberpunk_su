import { useContext, useState } from "react";
import { LanguageContext } from "../Locales/Context";
import { GetLocalizedString } from "../Locales/Locales";

function IndexElement() {
    var lang = useContext(LanguageContext);

    return (
        <div>
            <h1> {GetLocalizedString("index", lang)} </h1>
        </div>
    );
}

export default IndexElement;
