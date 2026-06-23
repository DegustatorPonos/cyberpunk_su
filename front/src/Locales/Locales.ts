import { AllowedLanguage } from './Context';
import en_us from './en_US';
import Language from './Language';
import ru_ru from './ru_RU';


const defaultLocale: Language = en_us;

const nameToLocale = new Map<string, Language>([
    ['en', en_us],
    ['ru', ru_ru],
]);

function getCurrentLocale(lang: AllowedLanguage): Language {
    const outp = nameToLocale.get(lang);
    if (outp == undefined) return defaultLocale;
    return outp;
}

export function GetLocalizedString(query: string, lang: AllowedLanguage): string {
    var lowerQuery = query.toLowerCase();
    const locale = getCurrentLocale(lang);
    const found = locale.LocalizedStrings.get(lowerQuery);
    if (found == undefined) return defaultLocale.LocalizedStrings.get(lowerQuery) || query;
    return found;
}

export function SetLocale(locale: string, setLang: (x: string) => void) {
    if (nameToLocale.has(locale)) setLang(locale);
}

const StorageLanguageName = "language";

export function SaveCurrentLocale(lang: AllowedLanguage) {
    localStorage.setItem(StorageLanguageName, lang)
}

export function ReadCurrentLocale(): AllowedLanguage {
    return localStorage.getItem(StorageLanguageName) as AllowedLanguage || "en"; 
}
