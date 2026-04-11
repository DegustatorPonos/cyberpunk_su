import Language from "./Language";

const lang = new Language();
lang.LocalizedStrings = new Map<string, string>([
    ["index", "index"],
    ["classes", "classes"],
    ["contents", "contents"],
]);

export default lang;
