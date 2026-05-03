import Language from "./Language";

const lang = new Language();
lang.LocalizedStrings = new Map<string, string>([
    ["index", "Главная"],
    ["classes", "Классы"],
    ["home", "Главная"],
    ["contents", "Содержание"],
    ["classes list", "Список классов"],
    ["weapons", "Оружие"],
    ["login", "Вход"],
    ["weapons index", "Список вооружения"],
    ["ranged weapons", "Дальнобойное оружие"],

    ["username", "Имя пользователя"],
    ["password", "Пароль"],
    ["log in", "Войти"],
    ["logout", "Выйти"],
    ["register", "Зарегистрироваться"],
    ["welcome", "Добро пожаловать"],

    ["heavy pistols", "Тяжёлые пистолеты"],
    ["medium pistols", "Средние пистолеты"],

    ["heavy pistol", "Тяжёлый пистолет"],
    ["medium pistol", "Средний пистолет"],

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

]);

export default lang;
