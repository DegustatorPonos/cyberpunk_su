import axios from "axios"
import { createContext } from "react"
import { BackendURL } from "../Config"
import { User } from "./Models"

export type Authentication = {
    User: User
    Token: string
}

const UserInfoURL = `${BackendURL}/auth`;

export const AuthContext = createContext<User | null>(null);

export function SaveState(data: Authentication | null, setCookie: (cookie: string) => void) {
    if (data == null) return;
    setCookie(data.Token);
}

export async function GetUserInfo(displayToken: string): Promise<User | null> {
    if (!displayToken || displayToken.length == 0) return null;
    try {
        const { data, status } = await axios.get<User>(
            UserInfoURL,
            {
                headers: { 
                    Accept: "application/json",
                    Authorization: `Bearer ${displayToken}`
                }
            }
        );
        if (status != 200) return null;
        return data;
    } catch (err) {
        console.log(`Failed to get user info: ${err}`);
        return null;
    }
}
