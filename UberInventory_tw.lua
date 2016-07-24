--[[ =================================================================
    Description:
    All strings (Chinese Traditional) used by UberInventory.
    2008/10/23 Translated by Jamesz (zjames.tw dot gmail dot com)
    2010/01/03 Updated translations by spring64783 (curse.com)
    ================================================================= --]]

-- Strings used within UberInventory
if (GetLocale()=="zhTW") then
    -- Help information
    UBI_HELP = { "UberInventory 指令：",
                 " /ubi : 開啟/關閉 UberInventory 對話視窗",
                 " /ubi { help | ? } : 顯示指令列表",
                 " /ubi <名稱> : 在背包中搜尋含有輸入名稱的物品",
                 " /ubi { remchar | remguild } <角色名稱> : 移除該角色背包/公會銀行中的物品暫存資料",
                 " /ubi resetpos : Reset position of the main UberInventory frame" };

    -- Chatframe strings
    UBI_MONEY_MESSAGE = "現金：%s";
    UBI_STARTUP_MESSAGE = UBI_NAME.." ("..C_GREEN..UBI_VERSION..C_CLOSE..") 已載入。";
    UBI_LAST_BANK_VISIT = "你已經%s天沒去過銀行了，去銀行光顧一下吧！";
    UBI_VISIT_BANK = C_RED.."請到附近的銀行去更新銀行內物品的資料。"..C_CLOSE;
    UBI_LAST_GUILDBANK_VISIT = "你已經%s天沒去過公會銀行（倉庫）了，去光顧一下吧！";
    UBI_VISIT_GUILDBANK = C_RED.."請到附近的公會銀行（倉庫）去更新銀行內物品的資料。"..C_CLOSE;
    UBI_LAST_MAILBOX_VISIT = "你已經%s天沒開過信箱了，找個信箱開一下吧！";
    UBI_VISIT_MAILBOX = C_RED.."請開啟附近的信箱以更新銀行內物品的資料。"..C_CLOSE;
    UBI_UPGRADE = "更新 UberInventory 到目前的版本";
    UBI_MAIL_CASH = "%s寄來一封標題為「%s」，有附上%s作為附件的信件。";
    UBI_NEW_VERSION = "%s正在使用較新版本的 UberInventory (%s)。請到下列網址去下載最新版本。 curse.com";
    UBI_NEW_GBDATA = "正在接收公會銀行（倉庫）的物品新資料(%s)";
    UBI_CASH_TOTAL = "現金";
    UBI_MAIL_EXPIRES = C_RED.."%s(%s)有%d封信再過%d天就會超過存放期限。"..C_CLOSE;
    UBI_MAIL_LOST = C_RED.."%s(%s)已經失去%d封超過存放期限%d的信件。請到附近的信箱去收下尚未超過存放期限的信件。"..C_CLOSE;

    -- UI element titles
    UBI_OPTIONS_TITLE = UBI_NAME.." "..UBI_VERSION ;
    UBI_OPTIONS_SUBTEXT = UBI_NAME.."的設定選單" ; -- Changed in 1.6
    UBI_TEXT_ITEM = "物品";
    UBI_TEXT_QUALITY = "品質";
    UBI_TEXT_CLASSES = "物品類別";
    UBI_TEXT_SEARCH = "搜尋";
    UBI_TEXT_CHARACTER = "角色";
    UBI_ALT_CHARACTER = "其他角色";
    UBI_TEXT_GUILDBANKS = "公會銀行（倉庫）";
    UBI_ALL_GUILDBANKS = "所有公會銀行"; -- New in 1.3
    UBI_ALL_CHARACTERS = "所有角色"; -- New in 1.3
    UBI_USABLE_ITEMS = "僅顯示可使用的物品";
    UBI_USABLE_ITEMS_TIP = "勾選此項後，只會顯示能使用的物品";

    -- Dropdown box Locations
    UBI_ALL_LOCATIONS = "全部";
    UBI_LOCATIONS = { "背包",
                      "銀行",
                      "信箱",
                      "已裝備" };

    -- Dropdown box classes
    UBI_ALL_CLASSES = "全部";

    -- Button strings
    UBI_OPTIONS_BUTTON = "選項";
    UBI_CLOSE_BUTTON = "關閉";
    UBI_RESET_BUTTON = "重設";

    -- Item information strings
    UBI_FREE = "%d（共%d）";
    UBI_ITEM_SELL = "賣價：";
    UBI_ITEM_BUY = "買價：";
    UBI_ITEM_RECIPE_SOLD_BY = "賣價: %s 商人:"; -- New in 1.3
    UBI_ITEM_RECIPE_REWARD_FROM = "任務獎勵"; -- New in 1.3
    UBI_ITEM_RECIPE_DROP_BY = "掉落自"; -- New in 1.3
    UBI_ITEM_COUNT = "合計%d (%d / %d / %d / %d / %d / %d)";
    UBI_ITEM_COUNT_SINGLE = "合計%d";
    UBI_ITEM_SEARCH = "搜尋名稱為「%s」的物品";
    UBI_ITEM_SEARCH_NONE = "找不到物品";
    UBI_ITEM_SEARCH_DONE = "搜尋結束";
    UBI_ITEM_UNCACHED = "未建立暫存記錄的物品";
    UBI_INVENTORY_COUNT = "合計："..UBI_FREE;
    UBI_MONEY_WALLET = "錢包"; -- Uses extra space to make the moneyframes align with UBI_MONEY_MAIL and UBI_MONEY_GUILDALT
    UBI_MONEY_MAIL = "信箱：";
    UBI_MONEY_GUILDALT = "公會/分身";
    UBI_NO_GUILDALT = "未選擇公會或其他角色";
    UBI_BAG = "背包";
    UBI_BANK = "銀行";
    UBI_SLOT_BAGS = UBI_BAG.." "..UBI_FREE.."格";
    UBI_SLOT_BANK = UBI_BANK.." "..UBI_FREE.."格";
    UBI_ALL_QUALITIES = "全部";
    UBI_MAIL_CASH = "收到「%s」，來自%s(%s)";

    -- Data removal
    UBI_REM_CASESENSITIVE = "注意：物品名稱有大小寫區別。";
    UBI_REM_WARNING = "物品資料刪除後無法復原！";
    UBI_REM_CHARNOTFOUND = "找不到名為「%s」的角色。"..UBI_REM_CASESENSITIVE;
    UBI_REM_GUILDNOTFOUND = "找不到名為「%s」的公會銀行（倉庫）"..UBI_REM_CASESENSITIVE;
    UBI_REM_CHARACTER = "刪除角色「%s」的物品暫存資料？"..UBI_REM_WARNING;
    UBI_REM_GUILDBANK = "刪除公會銀行「%s」的物品暫存資料？"..UBI_REM_WARNING;
    UBI_REM_DONE = "資料已經刪除完成。";
    UBI_REM_NOTALLOWED = "無法刪除目前角色的物品資料。";

    -- Checkbox strings (and tooltips)
    UBI_OPTION_MONEY = "顯示金錢提示";
    UBI_OPTION_MONEY_TIP = "勾選此項後，每當現金數量有變動時，在聊天視窗中直接報告目前現金。";
    UBI_OPTION_BALANCE = "顯示現金";
    UBI_OPTION_BALANCE_TIP = "勾選此項後，在遊戲畫面的左上角將顯示角色的現金。";
    UBI_SHOWTOOLTIP = "顯示提示訊息"; -- New in 3.6
    UBI_SHOWTOOLTIP_TIP = "如果選中的訊息將被添加到項目的工具提示|n|n"; -- New in 3.6
    UBI_OPTION_SELLPRICES = "顯示賣價";
    UBI_OPTION_SELLPRICES_TIP = "勾選此項後，可直接顯示已蒐集到資料的物品賣價。";
    UBI_OPTION_RECIPEPRICES = "顯示配方售價"; -- New in 1.3
    UBI_OPTION_RECIPEPRICES_TIP = "勾選此項後，若有商人販賣此配方將可顯示配方售價。"; -- New in 1.3
    UBI_OPTION_QUESTREWARD = "顯示配方是否來自任務"; -- New in 1.3
    UBI_OPTION_QUESTREWARD_TIP = "勾選此項後，將可顯示該配方是否為任務獎勵。"; -- New in 1.3
    UBI_OPTION_RECIPEDROP = "顯示會掉落配方的 NPC"; -- New in 1.3
    UBI_OPTION_RECIPEDROP_TIP = "勾選此項後，將可顯示會掉落該配方的 NPC 名稱。"; -- New in 1.3
    UBI_OPTION_SHOWMAP = "顯示地圖旁小圖示";
    UBI_OPTION_SHOWMAP_TIP = "勾選此項後，在小地圖邊框上將顯示本 UI 的小圖示。";
    UBI_OPTION_MINIMAP = "小圖示位置 (%d)";
    UBI_OPTION_MINIMAP_TIP = "滑動此條可改變小圖示在小地圖邊框上的位置。";
    UBI_OPTION_ALPHA = "透明度 (%d)";
    UBI_OPTION_ALPHA_TIP = "滑動此條可改變對話視窗的透明度。";
    UBI_OPTION_TAKEMONEY = "直接領取信箱金錢";
    UBI_OPTION_TAKEMONEY_TIP = "若勾選此項，開啟信件時將自動收取信件附帶的金錢。";
    UBI_OPTION_GBSEND = "送出公會銀行資料"; -- New in 1.6
    UBI_OPTION_GBSEND_TIP = "若勾選此項，可主動發送公會銀行變動給線上的公會成員"; -- New in 1.6
    UBI_OPTION_GBRECEIVE = "接受公會銀行資料"; -- New in 1.6
    UBI_OPTION_GBRECEIVE_TIP = "若勾選此項，當其他會員更動公會銀行內容時，可同步更新"; -- New in 1.6
    UBI_OPTION_WARN_MAILEXPIRE = "未收取信件即將逾期通知"; -- New in 1.6
    UBI_OPTION_WARN_MAILEXPIRE_TIP = "若勾選此項，將自動通知信件將於"..UBI_MAIL_EXPIRE_WARNING.."天後逾期"; -- New in 1.6
    UBI_OPTION_HIGHLIGHT = "高亮度突顯背包／物品"; -- New in 2.0
    UBI_OPTION_HIGHLIGHT_TIP = "若勾選此項，當滑鼠移到背包內物品時會以高亮度顯示"; -- New in 2.0

    -- Section headings
    UBI_SECTION_GENERAL = "一般設定"; -- New in 1.6
    UBI_SECTION_GUILDBANK = "公會銀行設定"; -- New in 1.6
    UBI_SECTION_TOOLTIP = "提示訊息設定"; -- New in 1.6
    UBI_SECTION_MINIMAP = "小地圖設定"; -- New in 1.6
    UBI_SECTION_WARNINGS = "警示訊息設定"; -- News in 1.6

    -- Binding strings
    BINDING_HEADER_UBI = "UberInventory 快捷鍵";
    BINDING_NAME_TOGGLEUBI = "切換 UberInventory 視窗";
    BINDING_NAME_TOGGLEUBITOOLTIP = "切換提示"; -- New in 3.6

    -- Currencies
    UBI_TOKEN_CHAMPIONS_SEAL = "勇士徽印";
    UBI_TOKEN_COOKING = "達拉然烹飪獎勵";
    UBI_TOKEN_JEWELCRAFTING = "達拉然珠寶師徽章";
    UBI_TOKEN_HONOR_POINTS = "榮譽點數";
    UBI_TOKEN_JUSTICE_POINTS = "正義點數"; -- New PvE currency
    UBI_TOKEN_CONQUEST_POINTS = "征服點數"; -- New PvP currency

    -- Miscellaneous
    UBI_MOVEMENT = "按住 [SHIFT] 移動框架到不同的位置";
end;