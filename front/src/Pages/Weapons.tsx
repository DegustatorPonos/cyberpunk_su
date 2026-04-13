import { useContext } from "react";
import { LanguageContext } from "../Locales/Context";
import { GetLocalizedString } from "../Locales/Locales";

function WeaponsIndex() {
    var lang = useContext(LanguageContext);

    return (
        <div>
            <h1> {GetLocalizedString("Weapons index", lang)} </h1>
        </div>
    );
}

function WeaponsType() {
}

export default WeaponsIndex;
