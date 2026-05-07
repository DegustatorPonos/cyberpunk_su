import { useContext, useEffect, useState } from "react";
import { AllowedLanguages, LanguageContext } from "../Locales/Context";
import { BackendURL } from "../Config";
import axios from "axios";
import { RangedWeapon, RangedWeaponRequest } from "../Models/RangedWeapon";
import { Description } from "../Models/Description";
import { useNavigate, useParams } from "react-router";
import { GetLocalizedString } from "../Locales/Locales";
import "./Weapons.css"
import { AuthContext } from "../Authentication/ContextProvider";
import { useCookies } from 'react-cookie';

const RangedWeaponsURL = `${BackendURL}/weapons/ranged`;

export function RangedWeaponPage() {
    var user = useContext(AuthContext);
    const { id } = useParams();
    const lang = useContext(LanguageContext);
    const [weapon, setWeapon] = useState<RangedWeapon | null>(null);
    const [description, setDescription] = useState<Description | null>(null);

    useState(() => {
        getWeapon(id).then(data => setWeapon(data));
        getWeaponDescription(id, lang).then(data => setDescription(data));
    });

    if (weapon == null) {
        return <h1> Not found </h1>; // <Navigate to="/404" replace />;
    }

    function editButton() {
        if (!user || user.Role != "editor") {
            return (<p></p>);
        } else {
            return ( <a href={`${id}/edit`}> Edit </a> );
        }
    }

    return (
        <div className="WeaponPage">
            <span> <h1> {weapon?.Name} </h1> </span>
            <h2> { GetLocalizedString(weapon.WeaponType, lang) } </h2>
            <table> 
                <tbody>
                    <tr> 
                        <td> { GetLocalizedString("Accuracy", lang) } </td>
                        <td> { weapon.Accuracy } </td>
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
                        <td> { weapon.Damage }({ weapon.Ammunition }) </td>
                    </tr>
                    <tr>
                        <td> { GetLocalizedString("Number Of Shots", lang) } </td>
                        <td> { weapon.NumberOfShots } </td>
                    </tr>
                    <tr>
                        <td> { GetLocalizedString("Rate Of Fire", lang) } </td>
                        <td> { weapon.RateOfFire } </td>
                    </tr>
                    <tr>
                        <td> { GetLocalizedString("Reliability", lang) } </td>
                        <td> { GetLocalizedString(weapon.Reliability, lang) } </td>
                    </tr>
                    <tr>
                        <td> { GetLocalizedString("Origin", lang) } </td>
                        <td> { GetLocalizedString(weapon.Origin, lang) } </td>
                    </tr>
                </tbody>
            </table>

            <p>
                {description?.Contents}
            </p>
            { editButton() }
        </div>
    );
}
async function getWeaponDescription(id: string | undefined, lanuage: AllowedLanguages): Promise<Description | null> {
    if (id == undefined) return null;
    try {
        const {data, status} = await axios.get<Description>(
            `${RangedWeaponsURL}/${id}/description?lang=${lanuage}`,
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

const defaultNewRangedWeapon: RangedWeapon = {
    Id: "",
    Name: "",
    WeaponType: "Light pistol",
    Accuracy: 0,
    Concealability: "Pocket",
    Avaliability: "Common",
    Damage: "1d6",
    Ammunition: "9mm",
    NumberOfShots: 0,
    RateOfFire: 0,
    Reliability: "Standard",
    Origin: "Corebook",
    CreatedAt: 0,
    UpdatedAt: 0,
}

export function EditRangedWeaponPage() {
    var user = useContext(AuthContext);
    const [isLoading, setIsLoading] = useState(true);
    const { id } = useParams();
    const lang = useContext(LanguageContext);
    var [weapon, setWeapon] = useState<RangedWeapon | null>(null);
    const [description, setDescription] = useState<Description | null>(null);
    const [authCookie, ] = useCookies(['X-AUTH-TOKEN']);

    const [Name, setName] = useState<string>();
    const [WeaponType, setWeaponType] = useState<string>();
    const [Accuracy, setAccuracy] = useState<number>();
    const [Concealability, setConcealability] = useState<string>();
    const [Avaliability, setAvaliability] = useState<string>();
    const [Damage, setDamage] = useState<string>();
    const [Ammunition, setAmmunition] = useState<string>();
    const [NumberOfShots, setNumberOfShots] = useState<number>();
    const [RateOfFire, setRateOfFire] = useState<number>();
    const [Reliability, setReliability] = useState<string>();
    const [Origin, setOrigin] = useState<string>();
    const navigate = useNavigate();

    useState(() => {
        if (id == 'new') {
            setWeapon(defaultNewRangedWeapon);
            return
        }
        getWeapon(id).then(data => setWeapon(data));
        getWeaponDescription(id, lang).then(data => setDescription(data));
    });

    useEffect(() => {
        if (user !== null) {
            setIsLoading(false);
        }
    }, [user]);

    useEffect(() => {
        if (weapon) {
            setName(weapon.Name);
            setWeaponType(weapon.WeaponType);
            setAccuracy(weapon.Accuracy);
            setConcealability(weapon.Concealability);
            setAvaliability(weapon.Avaliability);
            setDamage(weapon.Damage);
            setAmmunition(weapon.Ammunition);
            setNumberOfShots(weapon.NumberOfShots);
            setRateOfFire(weapon.RateOfFire);
            setReliability(weapon.Reliability);
            setOrigin(weapon.Origin);
        }
    }, [weapon]);

    function getUpdatedWeapon(): RangedWeaponRequest {
        var outp: RangedWeaponRequest = {
            Id: id || "",
            Name: Name || "",
            WeaponType: WeaponType || "",
            Accuracy: Accuracy || 0,
            Concealability: Concealability || "",
            Avaliability: Avaliability || "",
            Damage: Damage || "",
            Ammunition: Ammunition || "",
            NumberOfShots: NumberOfShots || 0,
            RateOfFire: RateOfFire || 0,
            Reliability: Reliability || "",
            Origin: Origin || "",
        };
        return outp;
    }

    if (isLoading) {
        return <div>Loading...</div>;
    }

    if (!user || user.Role != "editor") {
        throw new Response("Forbidden", { status: 403 });
    }

    if (weapon == null) {
        return <h1> Not found </h1>; // <Navigate to="/404" replace />;
    }

    return (
        <div className="WeaponPage">
            <span> 
            <input value={Name} onChange={(val) => {
                setName(val.target.value);
            }} /> 
            </span>
            <select 
            value={WeaponType}
            onChange={ (val) => {
                const newWeaponType = val.target.value;
                setWeaponType(newWeaponType);
            }}> 
                <option value="Light pistol"> Light pistol </option>
                <option value="Medium pistol"> Medium pistol </option>
                <option value="Heavy pistol"> Heavy pistol </option>
                <option value="Very heavy pistol"> Very heavy pistol </option>

                <option value="Light submachinegun"> Light submachinegun </option>
                <option value="Medium submachinegun"> Medium submachinegun </option>
                <option value="Heavy submachinegun"> Heavy submachinegun </option>

                <option value="Assault rifle"> Assault rifle </option>
                <option value="Heavy weapon"> Heavy weapon </option>
                <option value="Exotic"> Exotic </option>

            </select>
            <table> 
                <tbody>
                    <tr> 
                        <td> { GetLocalizedString("Accuracy", lang) } </td>
                        <td> 
                            <input value={Accuracy} type="number" onChange={(val) => {
                                setAccuracy(+val.target.value);
                            }} /> 
                        </td>
                    </tr>

                    <tr>
                        <td> { GetLocalizedString("Concealability", lang) } </td>
                        <td> 
                            <select 
                                value={Concealability}
                                onChange={ (val) => {
                                    const newConcealability = val.target.value;
                                    setConcealability(newConcealability);
                                }}> 
                                <option value="Pocket"> Pocket </option>
                                <option value="Jacket"> Jacket </option>
                                <option value="Long"> Long </option>
                                <option value="Nothing"> Nothing </option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td> { GetLocalizedString("Avaliability", lang) } </td>
                        <td>
                            <select 
                                value={Avaliability}
                                onChange={ (val) => {
                                    const newAvaliability = val.target.value;
                                    setAvaliability(newAvaliability);
                                }}> 
                                <option value="Excellent"> Excellent </option>
                                <option value="Common"> Common </option>
                                <option value="Poor"> Poor </option>
                                <option value="Rare"> Rare </option>
                            </select>
                        </td>
                    </tr>
                    
                    <tr>
                        <td> { GetLocalizedString("Damage/Ammunition", lang) } </td>
                        <td>
                        <input 
                        className="DmgInput"
                        value={Damage}
                        onChange={val => {
                            setDamage(val.target.value);
                        }}/> (
                            <input 
                            className="DmgInput"
                            value={Ammunition}
                            onChange={val => {
                                setAmmunition(val.target.value);
                            }}/>
                        ) 
                        </td>
                    </tr>

                    <tr>
                        <td> { GetLocalizedString("Number Of Shots", lang) } </td>
                        <td> 
                            <input value={NumberOfShots} type="number" onChange={(val) => {
                                setNumberOfShots(+val.target.value);
                            }} /> 
                        </td>
                    </tr>

                    <tr>
                        <td> { GetLocalizedString("Rate Of Fire", lang) } </td>
                        <td> 
                            <input value={RateOfFire} type="number" onChange={(val) => {
                                setRateOfFire(+val.target.value);
                            }} /> 
                        </td>
                    </tr>

                    <tr>
                        <td> { GetLocalizedString("Reliability", lang) } </td>
                        <td> 
                            <select 
                                value={Reliability}
                                onChange={ (val) => {
                                    const newReliability = val.target.value;
                                    setReliability(newReliability);
                                }}> 
                                <option value="Very reliable"> Very reliable </option>
                                <option value="Standard"> Standard </option>
                                <option value="Unreliable"> Unreliable </option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td> { GetLocalizedString("Origin", lang) } </td>
                        <td> 
                            <select 
                                value={Origin}
                                onChange={ (val) => {
                                    const newOrigin = val.target.value;
                                    setOrigin(newOrigin);
                                }}> 
                                <option value="Corebook"> Corebook </option>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>

            <button onClick={ () => {
                const updated = getUpdatedWeapon();
                if (id == "new") {
                    CreateRangedWeapon(updated, authCookie['X-AUTH-TOKEN']);
                } else {
                    UpdateRangedWeapon(id, updated, authCookie['X-AUTH-TOKEN']);
                }
                navigate('/weapons');
                document.location.reload();
            }}> Update </button> 
            <button onClick={ () => {
                if (id == "new") return;
                DeleteRangedWeapon(id, authCookie['X-AUTH-TOKEN']);
                navigate('/weapons');
                document.location.reload();
            }}> Delete </button> 

            <p>
                {description?.Contents}
            </p>
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

async function UpdateRangedWeapon(id: string | undefined, model: RangedWeaponRequest, token: string) {
    if (id == undefined) return null;
    const uri = `${RangedWeaponsURL}/${id}`;

    await axios.put(uri, model, {
        headers: {
            Authorization: `Bearer ${token}`
        }
    })
    .then(resp => {
        console.log(resp);
    })
    .catch(err => {
        console.log(`Failed to update the model: ${err}`)
    });
}

function generateId(Name: string): string {
    return Name.toLowerCase().replaceAll(' ', '_');
}

async function CreateRangedWeapon(model: RangedWeaponRequest, token: string) {
    if (model.Name.length == 0) {
        throw new Error('The model name should not be empty');
    }
    model.Id = generateId(model.Name);
    if (model.Id == "new") {
        throw new Error("Forbidden name");
    }

    await axios.post(RangedWeaponsURL, model, {
        headers: {
            Authorization: `Bearer ${token}`
        }
    })
    .then(resp => {
        console.log(resp);
    })
    .catch(err => {
        console.log(`Failed to create the model: ${err}`)
    });
}

async function DeleteRangedWeapon(id: string | undefined, token: string) {
    if (id == undefined || id == "new" || id.length < 1) {
        throw new Error("Invalid ID");
    }

    const uri = `${RangedWeaponsURL}/${id}`;
    await axios.delete(uri, {
        headers: {
            Authorization: `Bearer ${token}`
        }
    })
    .then(resp => {
        console.log(resp);
    })
    .catch(err => {
        console.log(`Failed to create the model: ${err}`)
    });
}
