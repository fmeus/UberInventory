--[[ =================================================================
    Description:
    All strings (Russian) used by UberInventory.
    2009/07/14 Translated by Gudvinus
    ================================================================= --]]

-- Strings used within UberInventory
if (GetLocale()=="ruRU") then
    -- Help information
    UBI_HELP = { "UberInventory commands:",
    " /ubi : открыть/закрыть окно UberInventory",
    " /ubi { help | ? }: показать список команд",
    " /ubi <string>: поиск вещей в пределах Вашего инвентаря",
    " /ubi { remchar | remguild } <name>: Удалить чара или данные Гильд Банка",
    " /ubi resetpos: Сброс настроек на стандартные" };
    
    -- Chatframe strings
    UBI_MONEY_MESSAGE = "У Вас теперь %s";
    UBI_STARTUP_MESSAGE = UBI_NAME.." ("..C_GREEN..UBI_VERSION..C_CLOSE..") Загружен.";
    UBI_LAST_BANK_VISIT = "Ваше последнее посещение банка было %s день(дней) назад, пожалуйста посетите банк.";
    UBI_VISIT_BANK = C_RED.."Пожалуйста посетите ближайший банк, чтобы обновить данные инвентаря."..C_CLOSE;
    UBI_LAST_GUILDBANK_VISIT = "Ваше последнее посещение Гильд Банк было %s день(дней) назад, пожалуйста посетите Гильд Банк.";
    UBI_VISIT_GUILDBANK = C_RED.."Пожалуйста посетите ближайший Гильд Банк, чтобы обновить данные инвентаря."..C_CLOSE;
    UBI_LAST_MAILBOX_VISIT = "Ваше последнее посещение почтового ящика было %s день(дней) назад, пожалуйста посетите почтовый ящик.";
    UBI_VISIT_MAILBOX = C_RED.."Пожалуйста посетите ближайший почтовый ящик, чтобы обновить данные инвентаря."..C_CLOSE;
    UBI_UPGRADE = "Модернизация данных UberInventory к последней версии.";
    UBI_MAIL_CASH = "У почты от %s с предметом '%s' был приложенный %s.";
    UBI_NEW_VERSION = "%s использует более новую версию UberInventory (%s). Пожалуйста загрузите новую версию UberInventory на curse.com";
    UBI_NEW_GBDATA = "Получение новых данных Гильд Банка (%s)";
    UBI_CASH_TOTAL = "Наличные деньги";
    UBI_MAIL_EXPIRES = C_RED.."%s (%s) имеет %d почту (ы), которая будет удалена в %d день (ни)."..C_CLOSE;
    UBI_MAIL_LOST = C_RED.."%s (%s) потерял %d почту (ы) который истекший %d день (ни) назад. Пожалуйста посетите почтовый ящик игроков и заберите оставшиеся вещи."..C_CLOSE;
    
    -- UI element titles
    UBI_OPTIONS_TITLE = UBI_NAME.." "..UBI_VERSION ;
    UBI_OPTIONS_SUBTEXT = "Здесь вы можете настроить "..UBI_NAME.."." ; -- Changed in 1.6
    UBI_TEXT_ITEM = "Вещи";
    UBI_TEXT_QUALITY = "Качество";
    UBI_TEXT_CLASSES = "Класс";
    UBI_TEXT_SEARCH = "Поиск";
    UBI_TEXT_CHARACTER = "Персонаж";
    UBI_ALT_CHARACTER = "Другие персонажи";
    UBI_TEXT_GUILDBANKS = "Гильд Банк";
    UBI_ALL_GUILDBANKS = "Гильд Банки"; -- New in 1.3
    UBI_ALL_CHARACTERS = "Персонажи"; -- New in 1.3
    UBI_USABLE_ITEMS = "Показывать подходящие вещи";
    UBI_USABLE_ITEMS_TIP = "Если включено, показываются вещи которые Вы можете использовать.";
    
    -- Dropdown box Locations
    UBI_ALL_LOCATIONS = "Все вещи";
    UBI_LOCATIONS = { "Сумки",
    "Банк",
    "Почта",
    "Одето" };
    
    -- Dropdown box classes
    UBI_ALL_CLASSES = "Все Классы";

    -- Button strings
    UBI_OPTIONS_BUTTON = "Настройки";
    UBI_CLOSE_BUTTON = "Закрыть";
    UBI_RESET_BUTTON = "Сброс";
    
    -- Item information strings
    UBI_FREE = "%d из %d";
    UBI_ITEM_SELL = "Продажа: ";
    UBI_ITEM_BUY = "Покупка: ";
    UBI_ITEM_RECIPE_SOLD_BY = "Продаётся за %s"; -- New in 1.3
    UBI_ITEM_RECIPE_REWARD_FROM = "Награда от поисков"; -- New in 1.3
    UBI_ITEM_RECIPE_DROP_BY = "Падает"; -- New in 1.3
    UBI_ITEM_COUNT = "Кол-во: %d (%d / %d / %d / %d / %d / %d)";
    UBI_ITEM_COUNT_SINGLE = "Кол-во: %d";
    UBI_ITEM_SEARCH = "Invertory search for '%s'";
    UBI_ITEM_SEARCH_NONE = "Никакие пункты не найдены";
    UBI_ITEM_SEARCH_DONE = "Поиск инвентаря закончен";
    UBI_ITEM_UNCACHED = "Uncached item";
    UBI_INVENTORY_COUNT = "Показано: "..UBI_FREE;
    UBI_MONEY_WALLET = "Деньги: "; -- Uses extra space to make the moneyframes align with UBI_MONEY_MAIL and UBI_MONEY_GUILDALT
    UBI_MONEY_MAIL = "Почта:";
    UBI_MONEY_GUILDALT = "ГБ/Чары:";
    UBI_NO_GUILDALT = "Нет гильдии/альт выбирать";
    UBI_BAG = "Сумка";
    UBI_BANK = "Банк";
    UBI_SLOT_BAGS = UBI_BAG..": "..UBI_FREE.." свободно";
    UBI_SLOT_BANK = UBI_BANK..": "..UBI_FREE.." свободно";
    UBI_ALL_QUALITIES = "Все";
    UBI_MAIL_CASH = "Полученный %s от %s (%s)";
    
    -- Data removal
    UBI_REM_CASESENSITIVE = "Будьте осведомленными последовательностями, с учетом регистра!";
    UBI_REM_WARNING = "Удаление данных не может быть уничтожено!!";
    UBI_REM_CHARNOTFOUND = "Чар '%s' не найден. "..UBI_REM_CASESENSITIVE;
    UBI_REM_GUILDNOTFOUND = "Гильд Банк '%s' не найден. "..UBI_REM_CASESENSITIVE;
    UBI_REM_CHARACTER = "Удалить данные для чара '%s'? "..UBI_REM_WARNING;
    UBI_REM_GUILDBANK = "Удалить данные для Гильд Банк '%s'? "..UBI_REM_WARNING;
    UBI_REM_DONE = "Data has been succesfully removed.";
    UBI_REM_NOTALLOWED = "Вы не можете удалить данные для текущего чара.";
    
    -- Checkbox strings (and tooltips)
    UBI_OPTION_MONEY = "Показывать сообщения о деньгах";
    UBI_OPTION_MONEY_TIP = "Если включено, в окно чата будут выводиться сообщения о Вашем текущем балансе.";
    UBI_OPTION_BALANCE = "Показывать текущий баланс";
    UBI_OPTION_BALANCE_TIP = "Если включено, Вы всегда будете видеть свой текущий баланс в верхнем левом углу интерфейса.";
    UBI_OPTION_SELLPRICES = "Показывать цену продажи";
    UBI_OPTION_SELLPRICES_TIP = "Если включено, Вы будете видеть цены продажи (если Вы были у торговца), даже когда Вы не у торговца.";
    UBI_OPTION_RECIPEPRICES = "Показывать цену рецепта"; -- New in 1.3
    UBI_OPTION_RECIPEPRICES_TIP = "Если включено, Вы будете видеть цены за рецепты у торговцев."; -- New in 1.3
    UBI_OPTION_QUESTREWARD = "Информация о Поиске рецепта"; -- New in 1.3
    UBI_OPTION_QUESTREWARD_TIP = "Если включено, Вы будете видеть доступен ли рецепт от поисков."; -- New in 1.3
    UBI_OPTION_RECIPEDROP = "Показывать рецепты дропа"; -- New in 1.3
    UBI_OPTION_RECIPEDROP_TIP = "Если включено Вы будете в видеть какие рецепты выбиваются."; -- New in 1.3
    UBI_OPTION_SHOWMAP = "Показывать иконку у миникарты";
    UBI_OPTION_SHOWMAP_TIP = "Если включено иконка будет показанна у миникарты.";
    UBI_OPTION_MINIMAP = "Позиция иконки (%d)";
    UBI_OPTION_MINIMAP_TIP = "Двигайте ползунок чтобы изменить положение иконки у миникарты.";
    UBI_OPTION_ALPHA = "Прозрачность (%d)";
    UBI_OPTION_ALPHA_TIP = "Двигайте ползунок чтобы изменить прозрачность окна.";
    UBI_OPTION_TAKEMONEY = "Брать деньги с входящих писем";
    UBI_OPTION_TAKEMONEY_TIP = "Если включено деньги лежащие на почте, будут автоматически собраны в Вашу сумку.";
    UBI_OPTION_GBSEND = "Посылать Гильд Банк данные"; -- New in 1.6
    UBI_OPTION_GBSEND_TIP = "Если включено Гильд Банк данные будут отсылаться другим участникам гильдии (онлайн)."; -- New in 1.6
    UBI_OPTION_GBRECEIVE = "Получать Гильд Банк данные"; -- New in 1.6
    UBI_OPTION_GBRECEIVE_TIP = "Если включено, данные полученные от других участников гильдии, обновят Вашу текущую информацию."; -- New in 1.6
    UBI_OPTION_WARN_MAILEXPIRE = "Предупреждать об удалении почты"; -- New in 1.6
    UBI_OPTION_WARN_MAILEXPIRE_TIP = "Если включено, Вы будете предупреждены о почте которая удалиться через "..UBI_MAIL_EXPIRE_WARNING.." дней."; -- New in 1.6
    UBI_OPTION_HIGHLIGHT = "Подсветка Сумок/Вещей"; -- New in 2.0
    UBI_OPTION_HIGHLIGHT_TIP = "Если включено, при навидении на вещь курсора в окне UberInventory, будут подсвечиваться сумки в которых она лежит, а также сама вещь."; -- New in 2.0
    
    -- Section headings
    UBI_SECTION_GENERAL = "Настройки"; -- New in 1.6
    UBI_SECTION_GUILDBANK = "Настройки Гильд Банка"; -- New in 1.6
    UBI_SECTION_TOOLTIP = "Настройки подсказок"; -- New in 1.6
    UBI_SECTION_MINIMAP = "Настройки Миникарты"; -- New in 1.6
    UBI_SECTION_WARNINGS = "Настройки Предупреждений"; -- News in 1.6
    
    -- Binding strings
    BINDING_HEADER_UBI = "UberInventory Привязки";
    BINDING_NAME_TOGGLEUBI = "Переключатель UberInventory";
end;