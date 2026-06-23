import axios from "axios";
import { useContext, useState } from "react";
import { BackendURL } from "../Config";
import { LanguageContext } from "../Locales/Context";
import { GetLocalizedString } from "../Locales/Locales";
import { AllowedLanguage } from "../Locales/Context";
import { RangedWeapon } from "../Models/RangedWeapon";
import { AuthContext } from "../Authentication/ContextProvider";
import { User } from "../Authentication/Models";

const RangedWeaponsURL = `${BackendURL}/weapons/ranged`;

function WeaponsIndex() {
    const lang = useContext(LanguageContext);
    var user = useContext(AuthContext);
    const [rangedWeapons, setRangedWeapons] = useState<RangedWeapon[] | null>(null);

    useState(() => {
        getRangedWeapons().then(data => setRangedWeapons(data));
    });

    return (
        <div className="WeaponsDiv">
        <span>
            <h1> {GetLocalizedString("Weapons index", lang)} </h1>
        </span>
            <h2> {GetLocalizedString("Ranged weapons", lang)} </h2>
            { generatedRangedWeaponsList(rangedWeapons, lang) }
            { adminButtons(user) }
        </div>
    );
}

function generatedRangedWeaponsList(rangedWeapons: RangedWeapon[] | null, language: AllowedLanguage): any {
    if (!rangedWeapons) {
        return (
            <div> </div>
        );
    }

    const categorized = new Map<string, RangedWeapon[]>();

    rangedWeapons.forEach(el => {
        if (!categorized.has(el.WeaponType)) {
            categorized.set(el.WeaponType, new Array<RangedWeapon>());
        }
        categorized.get(el.WeaponType)?.push(el);
    });

    const keys = Array.from(categorized.keys());
    const list = keys.map(x => {
        const elements = categorized.get(x)?.map(w => {
            return (
            <tr key={w.Id}>
                <td> <a href={`/weapons/ranged/${w.Id}`}> {w.Name} ({GetLocalizedString(w.Origin, language)}) </a> </td>
                <td> {w.Accuracy} </td>
                <td> { GetLocalizedString(w.Concealability, language) } </td>
                <td> { GetLocalizedString(w.Avaliability, language) } </td>
                <td> {w.Damage}({w.Ammunition}) </td>
                <td> {w.NumberOfShots} </td>
                <td> {w.RateOfFire} </td>
                <td> { GetLocalizedString(w.Reliability, language) } </td>
            </tr>
            )
        });

        return (
            <tbody key={x}>
                <tr> 
                    <td colSpan={8} className="CategoryName"> {GetLocalizedString(`${x}s`, language)} </td> 
                </tr>
                {elements}
            </tbody>
        );

    });

    return (
        <table className="WeaponTable"> 
        <colgroup>
            <col width={"10%"} />
            <col width={"2%"} />
            <col width={"10%"} />
            <col width={"10%"} />
            <col width={"10%"} />
            <col width={"2%"} />
            <col width={"2%"} />
            <col width={"10%"} />
        </colgroup>
        {list} 
        </table>
    );
}

async function getRangedWeapons(): Promise<RangedWeapon[]> { 
    try {
        const {data, status} = await axios.get<RangedWeapon[]>(
            RangedWeaponsURL,
            {
                headers: { Accept: "application/json" }
            }
        );
        
        if (status != 200) {
            return new Array<RangedWeapon>();
        }

        return data;

    } catch (err) {
        console.log(`Failed to get ranged weapons: ${err}`);
        return new Array<RangedWeapon>();
    }
}

function adminButtons(user: User | null) {
    if (!user || user.Role != "editor") {
        return (<p></p>);
    } else {
        return (
            <div>
               <a href="/weapons/ranged/new/edit"> New ranged weapon </a>
            </div>
        )
    }
}

export default WeaponsIndex;
