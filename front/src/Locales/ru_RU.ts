import Language from "./Language";

const lang = new Language();
lang.LocalizedStrings = new Map<string, string>([
    ["index", "Главная"],
    ["classes", "Классы"],
    ["home", "Главная"],
    ["forbidden", "Запрещено"],

    ["contents", "Содержание"],
    ["classes list", "Список классов"],
    ["weapons", "Оружие"],
    ["weapons index", "Список вооружения"],
    ["ranged weapons", "Дальнобойное оружие"],

    ["login", "Вход"],
    ["username", "Имя пользователя"],
    ["password", "Пароль"],
    ["log in", "Войти"],
    ["logout", "Выйти"],
    ["register", "Зарегистрироваться"],
    ["welcome", "Добро пожаловать"],

    ["light pistols", "Лёгкие пистолеты"],
    ["heavy pistols", "Тяжёлые пистолеты"],
    ["medium pistols", "Средние пистолеты"],
    ["very heavy pistols", "Очень тяжёлые пистолеты"],
    ["light submachineguns", "Лёгкие пистолеты-пулемёты"],
    ["medium submachineguns", "Средние пистолеты-пулемёты"],
    ["heavy submachineguns", "Тяжёлые пистолеты-пулемёты"],
    ["assault rifles", "Винтовки"],
    ["heavy weapons", "Тяжёлое вооружение"],
    ["exotics", "Экзотическое оружие"],

    ["light pistol", "Лёгкий пистолет"],
    ["heavy pistol", "Тяжёлый пистолет"],
    ["medium pistol", "Средний пистолет"],
    ["very heavy pistol", "Очень тяжёлый пистолет"],
    ["light submachinegun", "Лёгкий пистолет-пулемёт"],
    ["medium submachinegun", "Средний пистолет-пулемёт"],
    ["heavy submachinegun", "Тяжёлый пистолет-пулемёт"],
    ["assault rifle", "Винтовка"],
    ["heavy weapon", "Тяжёлое вооружение"],
    ["exotic", "Экзотическое оружие"],

    ["accuracy", "Точность"],
    ["concealability", "Возможность скрыть"],
    ["avaliability", "Доступность"],
    ["damage/ammunition", "Урон/Аммуниция"],
    ["number of shots", "Количество выстрелов"],
    ["rate of fire", "Скорострельность"],
    ["reliability", "Надёжность"],
    ["origin", "Источник"],

    // Concealabilities
    ["pocket", "Карман"],
    ["jacket", "Куртка"],
    ["long", "Длинный плащ"],
    ["nothing", "Невозможно спрятать"],

    // Avaliabilities
    ["excellent", "Отличная"],
    ["common", "Обычная"],
    ["poor", "Малая"],
    ["rare", "Редкая"],

    // Relicabilities
    ["very reliable", "Очень надёжное"],
    ["standard", "Обычное"],
    ["unreliable", "Ненадёжное"],

    // Origins
    ["corebook", "Книга игрока"],

    // Prompts
    ["*acc-prompt*", "Ещё нет аккаунта?"],
    ["*security-warning*", "Послушай, чум. У нас нет этого хвалёного военного льда за нашей информационной крепостью. Это значит, что любой придурок с улицы или ИИ, скорее всего, сможет проникнуть внутрь и украсть твои данные. Пожалуйста, не используй здесь пароль, который ты используешь на важных сайтах! Придумай одноразовый!"],
    ["click here", "Нажми сюда"],
    ["*forbidden*", "Как ты сюда попал? У тебя нет доступа к этой информации"],
]);

export default lang;
