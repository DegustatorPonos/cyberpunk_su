import { createContext } from 'vm';
import { LanguageContext } from './Context';
import en_us from './en_US';
import Language from './Language';
import ru_ru from './ru_RU';


const defaultLocale: Language = en_us;

const nameToLocale = new Map<string, Language>([
    ['en', en_us],
    ['ru', ru_ru],
]);

function getCurrentLocale(lang: string): Language {
    const outp = nameToLocale.get(lang);
    if (outp == undefined) return defaultLocale;
    return outp;
}

export function GetString(query: string, lang: string): string {
    const locale = getCurrentLocale(lang);
    const found = locale.LocalizedStrings.get(query);
    if (found == undefined) return defaultLocale.LocalizedStrings.get(query) || query;
    return found;
}

export function SetLocale(locale: string, setLang: (x: string) => void) {
    if (nameToLocale.has(locale)) setLang(locale);
}
