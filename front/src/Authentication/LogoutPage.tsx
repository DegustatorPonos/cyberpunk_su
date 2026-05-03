import { useNavigate } from "react-router";

function LogoutPage() {
    const navigate = useNavigate();

    document.cookie = "X-AUTH-TOKEN=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    navigate("/");
    return (<p> Click <a href="/"> here </a> if you were not redirected already </p>);
}

export default LogoutPage;
