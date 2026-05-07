import { useContext } from "react";
import { useRouteError } from "react-router";
import { AllowedLanguages, LanguageContext } from "./Locales/Context";
import { GetLocalizedString } from "./Locales/Locales";

type RouteError = {
    status: number,
    statusText: string,
    internal: boolean,
    data: string
};

function ErrorHandler() {
  const language = useContext(LanguageContext);
  let error = useRouteError() as RouteError; 

  if (error.status == 403)
      return forbid(language);

  return (
      <div>
            <h1> {error.status} {error.statusText} </h1>
      </div>
  );
}


function forbid(language: AllowedLanguages) {
    return (
        <div>
            <h1> { GetLocalizedString("Forbidden", language) } </h1>
            <p> { GetLocalizedString("*forbidden*", language) } </p>
        </div>
    );
}

export default ErrorHandler;
