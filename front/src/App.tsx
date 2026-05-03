import './App.css';
import './Fonts.css';
import Sidebar from './Emelents/Sidebar';
import { createBrowserRouter, RouterProvider } from 'react-router';
import IndexElement from './Emelents/IndexElement';
import ClassesList from './Emelents/ClassList';
import Topbar from './Emelents/Topbar';
import { AllowedLanguages, LanguageContext } from './Locales/Context';
import { useEffect, useState } from 'react';
import { ReadCurrentLocale, SaveCurrentLocale } from './Locales/Locales';
import LegalNote from './Emelents/LegalNote';
import WeaponsIndex from './Pages/Weapons';
import RangedWeaponPage from './Pages/RangedWeapon';
import { AuthContext, Authentication, GetUserInfo } from './Authentication/ContextProvider';
import { useCookies } from 'react-cookie';
import LoginPage from './Authentication/LoginPage';
import LogoutPage from './Authentication/LogoutPage';
import { User } from './Authentication/Models';
import RegisterPage from './Authentication/RegisterPage';

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
    const [lang, setLang] = useState<AllowedLanguages>(ReadCurrentLocale());

    function SetLanguage(newLang: AllowedLanguages) {
        console.log(`Setting a new language ${newLang}...`);
        SaveCurrentLocale(newLang);
        setLang(newLang);
    }

    const [authCookie, ] = useCookies(['X-AUTH-TOKEN']);
    const [auth, setAuth] = useState<User | null>(null);
    useEffect(() => {
        GetUserInfo(authCookie['X-AUTH-TOKEN']).then(v => setAuth(v));
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
