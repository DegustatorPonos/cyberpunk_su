import Language from "./Language";

const lang = new Language();
lang.LocalizedStrings = new Map<string, string>([
    ["index", "index"],
    ["classes", "Classes"],
    ["contents", "contents"],
    ["home", "Home"],
    ["weapons", "Weapons"],
]);

export default lang;
