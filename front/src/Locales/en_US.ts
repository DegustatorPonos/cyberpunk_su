import Language from "./Language";

const lang = new Language();
lang.LocalizedStrings = new Map<string, string>([
    ["classes", "Classes"],
    ["contents", "contents"],
    ["home", "Home"],
    ["weapons", "Weapons"],
    
    // Prompts
    ["*acc-prompt*", "Don't have an account?"],
    ["*security-warning*", `Listen, choom. We don't have that military grade ice behind the data fortress. What that means for you is any gonk or AI can probably get in and steal your data. Please don't use a password that you use on any important websites over here! Make a throwaway one!`],
    ["*forbidden*", "How did you even get here? You don't have access for this"],
]);

export default lang;
