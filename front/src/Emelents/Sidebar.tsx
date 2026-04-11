import { useContext } from 'react';
import { AllowedLanguages, LanguageContext } from '../Locales/Context';
import { GetLocalizedString } from '../Locales/Locales';
import './Elements.css';

type SidebarProps = {
    setLang: (newLang: AllowedLanguages) => void;
};

function Sidebar({setLang}: SidebarProps) {
    var language = useContext(LanguageContext);

    return (
        <nav className='Sidebar'>
            <div className='SidebarContents'>
                <h1> {GetLocalizedString("contents", language)} </h1>
                <ul>
                </ul>
                <button onClick={() => setLang("ru")}> ru </button>
                <button onClick={() => setLang("en")}> en </button>
            </div>
        </nav>
    );
}

export default Sidebar;
