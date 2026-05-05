import axios from "axios";
import { useContext, useState } from "react";
import { useNavigate } from "react-router";
import { BackendURL } from "../Config";
import { Authentication, SaveState } from "./ContextProvider";
import { GetLocalizedString } from "../Locales/Locales";
import { LanguageContext } from "../Locales/Context";

const LoginURL = `${BackendURL}/auth/login`;

function LoginPage() {
    const lang = useContext(LanguageContext);

    const [username, setUsername] = useState<string>("");
    const [passw, setPassw] = useState<string>("");
    const navigate = useNavigate();

    function SetAuthState(newAuthState: Authentication | null) {
        if (newAuthState) {
            console.log(`Logging in as ${newAuthState.User}...`);
        } else {
            console.log(`Logging out...`);
        }
        SaveState(newAuthState, (cookie: string) => {
            document.cookie = `X-AUTH-TOKEN=${cookie}; path=/;`;
        })
    }

    return (
        <div>
            <p> { GetLocalizedString("*acc-prompt*", lang) } <a href="/register"> { GetLocalizedString("Click here", lang) }. </a> </p>
            <div className="prompt">
                <h2> { GetLocalizedString("Username", lang) } </h2>
                <input onChange={ev => setUsername(ev.target.value)} />
            </div>
            <div className="prompt">
                <h2> { GetLocalizedString("Password", lang) } </h2>
                <input onChange={ev => setPassw(ev.target.value)} />
            </div>
            <button className="authButton" onClick={() => {
                Login(username, passw, (data) => {
                    SetAuthState(data);
                    navigate("/");
                    window.location.reload();
                });
            }}> { GetLocalizedString("Log in", lang) } </button>
        </div>
    );
}

async function Login(username: string, passw: string, onSuccess: (data: Authentication) => void) {
    await axios.post<Authentication>(
        LoginURL, {
            Username: username,
            Password: passw
        }
    ).then(resp => {
        onSuccess(resp.data);
    }).catch(err => {
        console.log(`Failed to send a login responce: ${err}`);
    });
}

export default LoginPage;
