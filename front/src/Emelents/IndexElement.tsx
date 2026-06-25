import axios from "axios";
import { useContext, useEffect, useState } from "react";
import { AllowedLanguage, LanguageContext } from "../Locales/Context";
import { GetLocalizedString } from "../Locales/Locales";
import { BackendURL } from "../Config";
import { Article } from "../Models/Article";

const IndexURL = `${BackendURL}/index`;

const pageLength = 10;

function IndexElement() {
    var lang = useContext(LanguageContext);
    const [articles, setArticles] = useState<Article[] | null>(null);
    const [page, setPage] = useState<number>(0);
    
    useState(() => {
        getArticles(lang, page, pageLength).then(data => setArticles(data));
    });

    useEffect(() => {
        getArticles(lang, page, pageLength).then(data => setArticles(data));
    }, [lang]);

    return (
        <div className="WeaponsDiv">
            <h1> {GetLocalizedString("Index", lang)} </h1>
            { generateArticlesList(articles) }
        </div>
    );
}

function generateArticlesList(articles: Article[] | null) { 
    if (!articles) {
        return (
            <div> </div>
        );
    }

    const records = articles.map(a => {
        return (
            <div className="article">
                <div> <h2 className="ArticleName"> { a.Name } </h2> </div>
                <p className="ArticleContents"> { a.Contents } </p>
                <p className="date"> - { new Date(a.CreatedAt/1000).toUTCString() } </p>
            </div>
        );
    })

    return (
        <div>
            {records}
        </div>
    )
}

async function getArticles(language: AllowedLanguage, page: number, pageLength: number): Promise<Article[]> {
    const {data, status} = await axios.get<Article[]>(
        `${IndexURL}?lang=${language}&page=${page}&len=${pageLength}`,
        {
            headers: { Accept: "application/json" }
        }
    );

    if (status != 200) {
        return new Array<Article>();
    }

    return data;
}

export default IndexElement;
