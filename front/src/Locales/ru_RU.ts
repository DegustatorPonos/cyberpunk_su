import Language from "./Language";

const lang = new Language();
lang.LocalizedStrings = new Map<string, string>([
    ["index", "Главная"],
    ["classes", "Классы"],
    ["home", "Главная"],
    ["contents", "Содержание"],
    ["classes list", "Список классов"],
    ["weapons", "Оружие"],
]);

export default lang;
