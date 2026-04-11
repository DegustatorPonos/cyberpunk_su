import Language from "./Language";

const lang = new Language();
lang.LocalizedStrings = new Map<string, string>([
    ["index", "главная"],
    ["classes", "классы"],
    ["contents", "содержание"],
]);

export default lang;
