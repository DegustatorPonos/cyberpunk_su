import { Class, ClassDescription } from "../../Models/Class";
import { BackendURL } from "../../Config";
import axios from "axios";
import { AllowedLanguage } from "../../Locales/Context";
import ClassPage from "./ClassPage";

const ClassesURL = `${BackendURL}/classes`;

export async function GetClasses(): Promise<Class[]> {
    try {
        const { data, status } = await axios.get<Class[]>(
            ClassesURL,
            {
                headers: { Accept: "application/json" }
            }
        );

        if (status != 200) return new Array<Class>();

        return data;
    } catch (err) {
        console.log(`Failed to get class list: ${err}`);
        return new Array<Class>();
    }
}

export async function GetClassInfo(name: string | undefined): Promise<Class | null> {
    const uri = `${ClassesURL}/${name}`;
    try {
        const {data, status} = await axios.get<Class>(
            uri,
            {
                headers: { Accept: "application/json" }
            }
        );

        if (status !== 200) return null; 
        return data;
    } catch (err) {
        console.log(`Failed to get class info: ${err}`);
        return null;
    }
}


export async function GetClassDescription(name: string, lang: AllowedLanguage): Promise<ClassDescription | null> {
    const uri = `${ClassesURL}/${name}/description?lang=${lang}`;
    try {
        const {data, status} = await axios.get<ClassDescription>(
            uri,
            {
                headers: { Accept: "application/json" }
            }
        );

        if (status !== 200) return null; 
        return data;
    } catch (err) {
        console.log(`Failed to get class description: ${err}`);
        return null;
    }
}

export async function UpdateClassInfo(data: Class | null, token: string) {
    const url = `${ClassesURL}/${data?.Name}`;
    await axios.put(url, data, {
        headers: {
            Authorization: `Bearer ${token}`
        }
    });
}

export async function UpsertDescription(desc: ClassDescription | null, token: string) {
    const url = `${ClassesURL}/${desc?.ClassName}/description`;
    await axios.put(url, desc, {
        headers: {
            Authorization: `Bearer ${token}`
        }
    });
}
