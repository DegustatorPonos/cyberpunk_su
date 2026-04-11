import { useContext } from "react";
import { LanguageContext } from "../Locales/Context";
import { GetLocalizedString } from "../Locales/Locales";

function ClassesList() {
    var lang = useContext(LanguageContext);

    return (
        <h1> {GetLocalizedString("Classes list", lang)} </h1>
    );
}

export default ClassesList;
