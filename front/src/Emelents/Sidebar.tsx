import { useContext } from 'react';
import { AuthContext } from '../Authentication/ContextProvider';
import { User } from '../Authentication/Models';
import { AllowedLanguage, LanguageContext } from '../Locales/Context';
import { GetLocalizedString } from '../Locales/Locales';
import './Elements.css';
import SidebarListElement from './SidebarElement';

type SidebarProps = {
    setLang: (newLang: AllowedLanguage) => void;
};

function Sidebar({setLang}: SidebarProps) {
    var user = useContext(AuthContext);
    var lang = useContext(LanguageContext);

    return (
        <nav className='Sidebar'>
            <div className='SidebarContents'>
                <h1> {GetLocalizedString("contents", lang)} </h1>
                <ul className='ContentsList'>
                    <SidebarListElement Href='/' Text='Home' />
                    <SidebarListElement Href='/classes' Text='Classes' />
                    <SidebarListElement Href='/weapons' Text='Weapons' />
                    { AuthElement(user) }
                </ul>
                <button onClick={() => {
                    setLang("ru");
                    // window.location.reload();
                }}> ru </button>
                <button onClick={() => {
                    setLang("en");
                    // window.location.reload();
                }}> en </button>
            </div>
        </nav>
    );
}

function AuthElement(user: User | null) {
    if (user != null) {
        return (
            <SidebarListElement Href='/logout' Text='Logout' />
        );
    }
    return (
        <SidebarListElement Href='/login' Text='Login' />
    );
}

export default Sidebar;
