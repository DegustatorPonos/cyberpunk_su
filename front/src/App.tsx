import './App.css';
import './Fonts.css';
import Sidebar from './Emelents/Sidebar';
import { createBrowserRouter, RouterProvider } from 'react-router';
import IndexElement from './Emelents/IndexElement';
import ClassesList from './Emelents/ClassList';
import Topbar from './Emelents/Topbar';
import { AllowedLanguages, LanguageContext } from './Locales/Context';
import { useState } from 'react';
import { ReadCurrentLocale, SaveCurrentLocale } from './Locales/Locales';
import LegalNote from './Emelents/LegalNote';
import WeaponsIndex from './Pages/Weapons';
import RangedWeaponPage from './Pages/RangedWeapon';

const router = createBrowserRouter([
    {
        index: true,
        element: (<IndexElement />),
    },
    {
        path: "/classes",
        element: (<ClassesList />),
    },
    {
        path: "/weapons",
        element: (<WeaponsIndex />),
    },
    {
        path: "/weapons/:id",
        element: (<RangedWeaponPage />),
    },
]);

function App() {
    const [lang, setLang] = useState<AllowedLanguages>(ReadCurrentLocale());

    function SetLanguage(newLang: AllowedLanguages) {
        console.log(`Setting a new language ${newLang}...`);
        SaveCurrentLocale(newLang);
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
                <LegalNote />
            </div>
        </LanguageContext.Provider>
    );
}

export default App;
