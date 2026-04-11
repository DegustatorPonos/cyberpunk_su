import { useContext } from 'react';
import { LanguageContext } from '../Locales/Context';
import { GetLocalizedString } from '../Locales/Locales';

type ElementProps = {
    Href: string;
    Text: string;
};

function SidebarListElement({Href, Text}: ElementProps) {
    var lang = useContext(LanguageContext);
    return (
        <li> 
            <span>
                <a href={Href}> {GetLocalizedString(Text, lang)} </a> 
                <span> ....................................................... </span>
            </span>
        </li>
    );
}

export default SidebarListElement;
