import { useContext } from "react";
import { AuthContext } from "../Authentication/ContextProvider";
import { LanguageContext } from "../Locales/Context";
import { GetLocalizedString } from "../Locales/Locales";

const defaultPathName = 'index';

function Topbar() {
    var language = useContext(LanguageContext);
    var user = useContext(AuthContext);
    let path =  getTopbarElement(window.location.pathname);

    function getTopText() {
        if (user == null) {
            return <h1> View from the edge </h1>;
        } else {
            return <h1> <img src={"/EBM.webp"} /> { `${GetLocalizedString("Welcome", language)}, ${user.Username}` } </h1>;
        }
    }

    return (
        <div className="Topbar">
            { getTopText() }
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
