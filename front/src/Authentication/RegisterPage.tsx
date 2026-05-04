import axios, { AxiosError } from "axios";
import { useContext, useState } from "react";
import { useNavigate } from "react-router";
import { BackendURL } from "../Config";
import { Authentication, SaveState } from "./ContextProvider";
import { GetLocalizedString } from "../Locales/Locales";
import { LanguageContext } from "../Locales/Context";
import { BackendError } from "../Models/ErrorResponce";

const RegisterURL = `${BackendURL}/auth/register`;

function RegisterPage() {
    const lang = useContext(LanguageContext);

    const [username, setUsername] = useState<string>("");
    const [passw, setPassw] = useState<string>("");
    const [errMessage, setErrorMessage] = useState<string>("");
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
            <h2> { GetLocalizedString("Username", lang) } </h2>
            <input onChange={ev => setUsername(ev.target.value)} />
            <h2> { GetLocalizedString("Password", lang) } </h2>
            <input onChange={ev => setPassw(ev.target.value)} />
            <button onClick={() => {
                Register(username, passw, (data) => {
                    SetAuthState(data);
                    navigate("/");
                    window.location.reload();
                }, (err) => {
                    setErrorMessage(err);
                    console.log(err);
                });
            }}> { GetLocalizedString("Register", lang) } </button>
            <p> { errMessage } </p> 
        </div>
    );
}

async function Register(username: string, passw: string, onSuccess: (data: Authentication) => void, onError: (message: string) => void) {
    await axios.post<Authentication>(
        RegisterURL, {
            Username: username,
            Password: passw
        }
    ).then(resp => {
        onSuccess(resp.data);
    }).catch(err => {
        if (axios.isAxiosError(err)) {
            const parsedErr = err as AxiosError<BackendError>;
            if (parsedErr.response) {
                console.log(parsedErr.response);
                onError(parsedErr.response.data.Message);
                return
            }
        }
        return "An unexpected error occured"
    });
}

export default RegisterPage;
