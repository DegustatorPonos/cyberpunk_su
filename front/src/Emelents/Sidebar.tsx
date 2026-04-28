import { useContext } from 'react';
import { AllowedLanguages, LanguageContext } from '../Locales/Context';
import { GetLocalizedString } from '../Locales/Locales';
import './Elements.css';
import SidebarListElement from './SidebarElement';

type SidebarProps = {
    setLang: (newLang: AllowedLanguages) => void;
};

function Sidebar({setLang}: SidebarProps) {
    var lang = useContext(LanguageContext);

    return (
        <nav className='Sidebar'>
            <div className='SidebarContents'>
                <h1> {GetLocalizedString("contents", lang)} </h1>
                <ul className='ContentsList'>
                    <SidebarListElement Href='/' Text='Home' />
                    <SidebarListElement Href='/classes' Text='Classes' />
                    <SidebarListElement Href='/weapons' Text='Weapons' />
                    <SidebarListElement Href='/login' Text='Login' />
                </ul>
                <button onClick={() => {
                    setLang("ru");
                    window.location.reload();
                }}> ru </button>
                <button onClick={() => {
                    setLang("en");
                    window.location.reload();
                }}> en </button>
            </div>
        </nav>
    );
}

export default Sidebar;
