import { useContext } from "react";
import { LanguageContext } from "../Locales/Context";
import { GetLocalizedString } from "../Locales/Locales";

const defaultPathName = 'index';

function Topbar() {
    var language = useContext(LanguageContext);
    let path =  getTopbarElement(window.location.pathname);

    return (
        <div className="Topbar">
            <h1> View from the edge </h1>
            <div className="TopbarContents">
                <h2> {GetLocalizedString(path, language)} </h2>
            </div>
        </div>
    );
}

// Extracts the black part thing from the path
function getTopbarElement(fullPath: string): string {
    let path = fullPath.replace('/', '');
    if (path.length === 0) {
        path = defaultPathName;
    }
    
    return path.split('/')[0];
}

export default Topbar;
