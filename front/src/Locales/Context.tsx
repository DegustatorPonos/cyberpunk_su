import { createContext } from "react";

export type AllowedLanguage = "en" | "ru";

export const LanguageContext = createContext<AllowedLanguage>("en");
