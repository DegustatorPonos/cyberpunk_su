import './App.css';
import './Fonts.css';
import Sidebar from './Emelents/Sidebar';
import { createBrowserRouter, RouterProvider } from 'react-router';
import IndexElement from './Emelents/IndexElement';
import ClassesIndex from './Pages/Classes/ClassesIndex';
import Topbar from './Emelents/Topbar';
import { AllowedLanguage, LanguageContext } from './Locales/Context';
import { useEffect, useState } from 'react';
import { ReadCurrentLocale, SaveCurrentLocale } from './Locales/Locales';
import LegalNote from './Emelents/LegalNote';
import WeaponsIndex from './Pages/Weapons';
import { AuthContext, GetUserInfo } from './Authentication/ContextProvider';
import { useCookies } from 'react-cookie';
import LoginPage from './Authentication/LoginPage';
import LogoutPage from './Authentication/LogoutPage';
import { User } from './Authentication/Models';
import RegisterPage from './Authentication/RegisterPage';
import { EditRangedWeaponPage, RangedWeaponPage } from './Pages/RangedWeapon';
import ErrorHandler from './ErrorHandler';
import ClassPage from './Pages/Classes/ClassPage';

const router = createBrowserRouter([
    {
        index: true,
        errorElement: (<ErrorHandler />),
        element: (<IndexElement />),
    },
    {
        path: "/classes",
        element: (<ClassesIndex />),
    },
    {
        path: "/classes/:name",
        element: (<ClassPage />),
    },

    // Ranged weapons
    {
        path: "/weapons",
        element: (<WeaponsIndex />),
    },
    {
        path: "/weapons/ranged/:id/edit",
        errorElement: (<ErrorHandler />),
        element: (<EditRangedWeaponPage />),
    },
    {
        path: "/weapons/ranged/:id",
        element: (<RangedWeaponPage />),
    },

    // auth
    {
        path: "/login",
        element: (<LoginPage />),
    },
    {
        path: "/register",
        element: (<RegisterPage />),
    },
    {
        path: "/logout",
        element: (<LogoutPage />),
    },
]);

function App() {
    const [lang, setLang] = useState<AllowedLanguage>(ReadCurrentLocale());

    function SetLanguage(newLang: AllowedLanguage) {
        console.log(`Setting a new language ${newLang}...`);
        SaveCurrentLocale(newLang);
        setLang(newLang);
    }

    const [authCookie, ] = useCookies(['X-AUTH-TOKEN']);
    const [auth, setAuth] = useState<User | null>(null);
    useEffect(() => {
        GetUserInfo(authCookie['X-AUTH-TOKEN']).then(
            v => {
                console.log(v);
                if (!v || v == undefined)
                    document.cookie = "X-AUTH-TOKEN=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
                setAuth(v);
            }
        );
    }, []);

    return (
        <AuthContext.Provider value={auth}>
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
        </AuthContext.Provider>
    );
}

export default App; 
