import './App.css';
import './Fonts.css';
import Sidebar from './Emelents/Sidebar';
import { createBrowserRouter, RouterProvider } from 'react-router';
import IndexElement from './Emelents/IndexElement';
import ClassesList from './Emelents/ClassList';
import Topbar from './Emelents/Topbar';
import { AllowedLanguages, LanguageContext } from './Locales/Context';
import { useState } from 'react';

const router = createBrowserRouter([
    {
        index: true,
        element: (<IndexElement />),
    },
    {
        path: "/classes",
        element: (<ClassesList />),
    },
]);

function App() {
    const [lang, setLang] = useState<AllowedLanguages>("en");

    function SetLanguage(newLang: AllowedLanguages) {
        console.log(`Setting a new language ${newLang}...`);
        setLang(newLang);
    }

    return (
        <LanguageContext.Provider value={lang}>
            <div className='App'>
                <Topbar />
                <div className='AppContents'>
                    <Sidebar 
                        setLang={SetLanguage}
                        />
                    <RouterProvider router={router} />
                </div>
            </div>
        </LanguageContext.Provider>
    );
}

export default App;
