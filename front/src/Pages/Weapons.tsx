import axios from "axios";
import { useContext, useState } from "react";
import { BackendURL } from "../Config";
import { LanguageContext } from "../Locales/Context";
import { GetLocalizedString } from "../Locales/Locales";
import { AllowedLanguages } from "../Locales/Context";
import { RangedWeapon } from "../Models/RangedWeapon";

const RangedWeaponsURL = `${BackendURL}/weapons/ranged`;

function WeaponsIndex() {
    const lang = useContext(LanguageContext);
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
            {generatedRangedWeaponsList(rangedWeapons, lang)}
        </div>
    );
}

function generatedRangedWeaponsList(rangedWeapons: RangedWeapon[] | null, language: AllowedLanguages): any {
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
                <td> <a href={`/weapons/${w.Id}`}> {w.Name} </a> </td>
                <td> {w.Accuracy} </td>
                <td> {w.Concealability} </td>
                <td> {w.Avaliability} </td>
                <td> {w.Damage}({w.Ammunition}) </td>
                <td> {w.NumberOfShots} </td>
                <td> {w.RateOfFire} </td>
                <td> {w.Reliability} </td>
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

export default WeaponsIndex;
