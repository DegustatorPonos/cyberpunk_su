import { useContext } from 'react';
import { AllowedLanguages, LanguageContext } from '../Locales/Context';
import { GetString } from '../Locales/Locales';
import './Elements.css';

type SidebarProps = {
    setLang: (newLang: AllowedLanguages) => void;
};

function Sidebar({setLang}: SidebarProps) {
    var language = useContext(LanguageContext);

    return (
        <nav className='Sidebar'>
            <div className='SidebarContents'>
                <button onClick={() => setLang("ru")}> ru </button>
                <button onClick={() => setLang("en")}> en </button>
                <h1> {GetString("contents", language)} </h1>
                <ul>
                </ul>
            </div>
        </nav>
    );
}

export default Sidebar;
