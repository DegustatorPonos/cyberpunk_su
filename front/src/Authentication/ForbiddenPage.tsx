import { useContext } from "react";
import { LanguageContext } from "../Locales/Context";
import { GetLocalizedString } from "../Locales/Locales";

function ForbidenPage() {
    const lang = useContext(LanguageContext);
    return (
        <div>
            <h1> { GetLocalizedString("Forbidden", lang) } </h1>
            <p> { GetLocalizedString("*forbidden*", lang) } </p>
        </div>
    );
}

export default ForbidenPage;
