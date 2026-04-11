import { createContext } from "react";

export type AllowedLanguages = "en" | "ru";

export const LanguageContext = createContext<AllowedLanguages>("en");
