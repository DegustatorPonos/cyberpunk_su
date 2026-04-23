import { useContext, useState } from "react";
import { LanguageContext } from "../Locales/Context";
import { BackendURL } from "../Config";
import axios from "axios";
import { RangedWeapon } from "../Models/RangedWeapon";
import { Navigate, useParams } from "react-router";
import { GetLocalizedString } from "../Locales/Locales";
import "./Weapons.css"

const RangedWeaponsURL = `${BackendURL}/weapons/ranged`;

function RangedWeaponPage() {
    const { id } = useParams();
    const lang = useContext(LanguageContext);
    const [weapon, setWeapon] = useState<RangedWeapon | null>(null);

    useState(() => {
        getWeapon(id).then(data => setWeapon(data));
    });

    if (weapon == null) {
        return <h1> Not found </h1>; // <Navigate to="/404" replace />;
    }

    return (
        <div className="WeaponPage">
            <span> <h1> {weapon?.Name} </h1> </span>
            <h2> { GetLocalizedString(weapon.WeaponType, lang) } </h2>
            <table> 
                <tbody>
                    <tr> 
                        <td> { GetLocalizedString("Accuracy", lang) } </td>
                        <td> {weapon.Accuracy} </td>
                    </tr>
                    <tr>
                        <td> { GetLocalizedString("Concealability", lang) } </td>
                        <td> { GetLocalizedString(weapon.Concealability, lang) } </td>
                    </tr>
                    <tr>
                        <td> { GetLocalizedString("Avaliability", lang) } </td>
                        <td> { GetLocalizedString(weapon.Avaliability, lang) } </td>
                    </tr>
                    <tr>
                        <td> { GetLocalizedString("Damage/Ammunition", lang) } </td>
                        <td> {weapon.Damage}({weapon.Ammunition}) </td>
                    </tr>
                    <tr>
                        <td> { GetLocalizedString("Number Of Shots", lang) } </td>
                        <td> {weapon.NumberOfShots} </td>
                    </tr>
                    <tr>
                        <td> { GetLocalizedString("Rate Of Fire", lang) } </td>
                        <td> {weapon.RateOfFire} </td>
                    </tr>
                    <tr>
                        <td> { GetLocalizedString("Reliability", lang) } </td>
                        <td> { GetLocalizedString(weapon.Reliability, lang) } </td>
                    </tr>
                </tbody>
            </table>
        </div>
    );
}

async function getWeapon(id: string | undefined): Promise<RangedWeapon | null>  {
    if (id == undefined) return null;
    try {
        const {data, status} = await axios.get<RangedWeapon>(
            `${RangedWeaponsURL}/${id}`,
            {
                headers: { Accept: "application/json" }
            }
        );
        
        if (status != 200) return null; 

        return data;

    } catch (err) {
        console.log(`Failed to get ranged weapon: ${err}`);
        return null;
    }
}

export default RangedWeaponPage;
