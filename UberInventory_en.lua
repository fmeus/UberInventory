--[[ =================================================================
    Description:
        All strings (English) used by UberInventory.
    ================================================================= --]]

-- Strings used within UberInventory
    -- Help information
    UBI_HELP = { "UberInventory commands:",
                 "    /ubi : open/close UberInventory dialog",
                 "    /ubi { help | ? }: show this list of commands",
                 "    /ubi <string>: search for items within your inventory",
                 "    /ubi { remchar | remguild } <name>: Remove character or guildbank data",
                 "    /ubi resetpos: Reset position of the main UberInventory frame",
                 "    /ubi sendgb: Force sending of guildbank data to other online guildmembers",
                 "    /ubi requestgb: Request guildbank data from other online guildmembers" };

    -- Chatframe strings
    UBI_MONEY_MESSAGE = "You now have %s";
    UBI_STARTUP_MESSAGE = UBI_NAME.." ("..C_GREEN..UBI_VERSION..C_CLOSE..") loaded.";
    UBI_LAST_BANK_VISIT = "Your last visit to the bank was %s day(s) ago, please visit a bank.";
    UBI_VISIT_BANK = C_RED.."Please visit the nearest bank to update inventory data."..C_CLOSE;
    UBI_LAST_GUILDBANK_VISIT = "Your last visit to the guildbank was %s day(s), please visit the guildbank.";
    UBI_VISIT_GUILDBANK = C_RED.."Please visit the nearest guildbank to update inventory data."..C_CLOSE;
    UBI_LAST_MAILBOX_VISIT = "Your last visit to a mailbox was %s day(s) ago, please visit a mailbox.";
    UBI_VISIT_MAILBOX = C_RED.."Please visit the nearest mailbox to update inventory data."..C_CLOSE;
    UBI_UPGRADE = "Upgrading UberInventory data to the current version.";
    UBI_MAIL_CASH = "A mail from %s with subject '%s' had %s attached.";
    UBI_NEW_VERSION = "%s is using a newer version of UberInventory (%s). Please download the latest version from curse.com";
    UBI_NEW_GBDATA = "Receiving new guildbank data (%s)";
    UBI_CASH_TOTAL = "Total cash";
    UBI_MAIL_EXPIRES = C_RED.."%s (%s) has %d mail(s) that will expire in %d day(s)."..C_CLOSE;
    UBI_MAIL_LOST = C_RED.."%s (%s) has lost %d mail(s) that expired %d day(s) ago. Please visit the players mailbox and save any remaining items."..C_CLOSE;
    UBI_SENDGB_VISIT = C_RED.."To be able to forcibly send guildbank data, the guildbank needs to be visited within the current session first."..C_CLOSE;
    UBI_SENDGB_ACCESS = C_RED.."To be able to send guildbank data at least 'View Tab'-permission for each of the guildbank tabs is required."..C_CLOSE;
    UBI_GB_SENDING = "Sending guildbank data to online guildmembers...";
    UBI_GB_REQUESTED = "Request for guildbank data has been sent to online guildmembers...";

    -- UI element titles
    UBI_OPTIONS_TITLE = UBI_NAME.." "..UBI_VERSION ;
    UBI_OPTIONS_SUBTEXT = "These options change the behaviour of "..UBI_NAME..".";
    UBI_TEXT_ITEM = "Items";
    UBI_TEXT_QUALITY = "Quality";
    UBI_TEXT_CLASSES = "Classes";
    UBI_TEXT_SEARCH = "Search";
    UBI_TEXT_CHARACTER = "Character";
    UBI_ALT_CHARACTER = "Other characters";
    UBI_TEXT_GUILDBANKS = "Guildbanks";
    UBI_ALL_GUILDBANKS = "All Guildbanks";
    UBI_ALL_CHARACTERS = "All Characters";
    UBI_USABLE_ITEMS = "Usable items only";
    UBI_USABLE_ITEMS_TIP = "When checked only usable items will be shown";

    -- Dropdown box Locations
    UBI_ALL_LOCATIONS = "All items                ";
    UBI_LOCATIONS = { "Bags",
                      "Bank",
                      "Mailbox",
                      "Equipped",
                      "Void Storage",
                      "Reagents Bank" };

    -- Dropdown box classes (result of GetAuctionItemClasses is already localized)
    UBI_CLASSES = { "All classes", GetAuctionItemClasses() };

    -- Button strings
    UBI_OPTIONS_BUTTON = "Options";
    UBI_CLOSE_BUTTON = "Close";
    UBI_RESET_BUTTON = "Reset";

    -- Item information strings
    UBI_FREE = "%d of %d";
    UBI_ITEM_SELL = "Sell: ";
    UBI_ITEM_BUY = "Buy: ";
    UBI_ITEM_BUYOUT = "Auction Buyout: ";
    UBI_ITEM_RECIPE_SOLD_BY = "Sold for %s by";
    UBI_ITEM_RECIPE_REWARD_FROM = "Reward from quest";
    UBI_ITEM_RECIPE_DROP_BY = "Dropped by";
    UBI_ITEM_COUNT = "Count: %d (%d / %d / %d / %d / %d / %d)";
    UBI_ITEM_COUNT_SINGLE = "Count: %d";
    UBI_ITEM_SEARCH = "Invertory search for '%s'";
    UBI_ITEM_SEARCH_NONE = "No items found";
    UBI_ITEM_SEARCH_DONE = "Inventory search completed";
    UBI_ITEM_UNCACHED = "Uncached item";
    UBI_INVENTORY_COUNT = "Inventory count: "..UBI_FREE;
    UBI_MONEY_WALLET = "Wallet:"; -- Uses extra space to make the moneyframes align with UBI_MONEY_MAIL and UBI_MONEY_GUILDALT
    UBI_MONEY_MAIL = "Mail:";
    UBI_MONEY_GUILDALT = "Guild/Alt:";
    UBI_NO_GUILDALT = "No guild/alt selected";
    UBI_BAG = "Bag";
    UBI_BANK = "Bank";
    UBI_REAGENT = "Reagent Bank";
    UBI_SLOT_BAGS = UBI_BAG.." slots: "..UBI_FREE.." free";
    UBI_SLOT_BANK = UBI_BANK.." slots: "..UBI_FREE.." free";
    UBI_SLOT_REAGENTBANK = UBI_REAGENT.." slots: "..UBI_FREE.." free";
    UBI_ALL_QUALITIES = "All qualities";
    UBI_MAIL_CASH = "Received %s from %s (%s)";

    -- Data removal
    UBI_REM_CASESENSITIVE = "Be aware strings are case-sensitive!";
    UBI_REM_WARNING = "Removal of data cannot be undone!!";
    UBI_REM_CHARNOTFOUND = "Character '%s' not found. "..UBI_REM_CASESENSITIVE;
    UBI_REM_GUILDNOTFOUND = "Guildbank '%s' not found. "..UBI_REM_CASESENSITIVE;
    UBI_REM_CHARACTER = "Remove data for character '%s'? "..UBI_REM_WARNING;
    UBI_REM_GUILDBANK = "Remove data for guildbank '%s'? "..UBI_REM_WARNING;
    UBI_REM_DONE = "Data has been succesfully removed.";
    UBI_REM_NOTALLOWED = "You can not remove data for the current character.";

    -- Checkbox strings (and tooltips)
    UBI_OPTION_MONEY = "Show money notifications";
    UBI_OPTION_MONEY_TIP = "If checked a message will be added to the default chat frame showing your current balance.";
    UBI_OPTION_BALANCE = "Show current balance";
    UBI_OPTION_BALANCE_TIP = "If checked you will always be able to see your current balance in the top left corner of the UI.";
    UBI_OPTION_SHOWTOOLTIP = "Show tooltip information";
    UBI_OPTION_SHOWTOOLTIP_TIP = "If checked information will be added to item tooltips|n|n";
    UBI_OPTION_SELLPRICES = "Show sell prices";
    UBI_OPTION_SELLPRICES_TIP = "If checked you will be able to see sell prices (if collected) even when you are not at a merchant.";
    UBI_OPTION_RECIPEPRICES = "Show recipe buying prices";
    UBI_OPTION_RECIPEPRICES_TIP = "If checked you will be able to see prices for recipes avialable from merchants.";
    UBI_OPTION_QUESTREWARD = "Show recipe quest reward info";
    UBI_OPTION_QUESTREWARD_TIP = "If checked you will be able to see whether or not a recipe is obtainable from a quest.";
    UBI_OPTION_RECIPEDROP = "Show recipe drop info";
    UBI_OPTION_RECIPEDROP_TIP = "If checked you will be able to see which mobs drop a recipe.";
    UBI_OPTION_ITEMCOUNT = "Show item count info";
    UBI_OPTION_ITEMCOUNT_TIP = "If checked item counts will be shown within item tooltips";
    UBI_OPTION_SHOWMAP = "Show minimap icon";
    UBI_OPTION_SHOWMAP_TIP = "If checked an icon will be show at the border of the minimap.";
    UBI_OPTION_MINIMAP = "Minimap icon position (%d)";
    UBI_OPTION_MINIMAP_TIP = "Slide to change the position of the minimap icon.";
    UBI_OPTION_ALPHA = "Alpha/Transparency (%d)";
    UBI_OPTION_ALPHA_TIP = "Slide to change the alpha (transparency) of the frames.";
    UBI_OPTION_TAKEMONEY = "Take inbox money";
    UBI_OPTION_TAKEMONEY_TIP = "If checked money attached to mail will automatically be collected into your bag.";
    UBI_OPTION_GBSEND = "Send guildbank data";
    UBI_OPTION_GBSEND_TIP = "If checked guildbank data will be sent to other online guild members.";
    UBI_OPTION_GBRECEIVE = "Receive guildbank data";
    UBI_OPTION_GBRECEIVE_TIP = "If checked data received from other guild members will overwrite your current data.";
    UBI_OPTION_WARN_MAILEXPIRE = "Warn if mails are about to expire";
    UBI_OPTION_WARN_MAILEXPIRE_TIP = "If checked you will be warned about mails that will expire within "..UBI_MAIL_EXPIRE_WARNING.." days.";
    UBI_OPTION_HIGHLIGHT = "Highlight bags/items";
    UBI_OPTION_HIGHLIGHT_TIP = "If checked bags and item slots will be higlighted based on the item you hover over in the inventory frame";
    UBI_OPTION_GBTRACK = "Track guildbank data";
    UBI_OPTION_GBTRACK_TIP = "If checked guildbank data for the current toon will not be stored.|nData already stored will not be removed.|nUse the command /ubi remguild <guild name> to delete unwanted data.";
    UBI_OPTION_PRICES_VENDOR = "Vendor";
    UBI_OPTION_PRICES_VENDOR_TIP = "Item overview will display Vendor sell and buy prices";
    UBI_OPTION_PRICES_AH = "Auction House";
    UBI_OPTION_PRICES_AH_TIP = "Item overview will display Auction House buyout prices from installed Auction House related Add Ons, like Auctioneer, AuctionLite, Auctionator, etc.";

    -- Section headings
    UBI_SECTION_GENERAL = "General Settings";
    UBI_SECTION_GUILDBANK = "Guildbank Settings";
    UBI_SECTION_TOOLTIP = "Tooltip Settings";
    UBI_SECTION_MINIMAP = "Minimap Settings";
    UBI_SECTION_WARNINGS = "Warning Settings";
    UBI_SECTION_PRICING = "Pricing info";

    -- Binding strings
    BINDING_HEADER_UBI = "UberInventory Bindings";
    BINDING_NAME_TOGGLEUBI = "Toggle UberInventory";
    BINDING_NAME_TOGGLEUBITOOLTIP = "Toggle tooltip ";

    -- Currencies
    UBI_TOKEN_CHAMPIONS_SEAL = "Champion's Seal";
    UBI_TOKEN_COOKING = "Dalaran Cooking Award";
    UBI_TOKEN_CHEFS_AWARD = "Chef's Award";
    UBI_TOKEN_JEWELCRAFTING_DALARAN = "Dalaran Jewelcrafter's Token";
    UBI_TOKEN_HONOR_POINTS = "Honor Points";
    UBI_TOKEN_JUSTICE_POINTS = "Justice Points"; -- New PvE currency
    UBI_TOKEN_CONQUEST_POINTS = "Conquest Points";
    UBI_TOKEN_JEWELCRAFTING = "Illustrious Jewelcrafter's Token";
    UBI_TOKEN_TOLBARAD = "Tol Barad Commendation";
    UBI_TOKEN_VALOR_POINTS = "Valor Points";
    UBI_TOKEN_WORLDTREE = "Mark of the World Tree";
    UBI_TOKEN_DARKMOONPRIZETICKET = "Darkmoon Prize Ticket";
    UBI_TOKEN_EPICURIAN = "Epicurean's Award";
    UBI_TOKEN_IRONPAW = "Ironpaw Token";
    UBI_TOKEN_ESSENCE_OF_DEATHWING = "Essence of Corrupted Deathwing";
    UBI_TOKEN_MOTE_OF_DARKNESS = "Mote of Darkness";
    UBI_TOKEN_ILLUSTRIOUS_JEWELCRAFTING = "Illustrious Jewelcrafter's Token";
    UBI_TOKEN_ZEN_JEWELCRAFTING = "Zen Jewelcrafter's Token";
    UBI_TOKEN_ELDER_CHARM = "Elder Charm of Good Fortune";
    UBI_TOKEN_LESSER_CHARM = "Lesser Charm of Good Fortune";
    UBI_TOKEN_TIMELESSCOIN = "Timeless Coin";
    UBI_TOKEN_WARFORGED_SEAL = "Warforged Seal";
    UBI_TOKEN_MOGU_RUNE_OF_FATE = "Mogu Rune of Fate";
    UBI_TOKEN_APEXIS_CRYSTAL = "Apexis Crystal";
    UBI_TOKEN_GARRISON_RESOURCE = "Garrison Resources";
    UBI_TOKEN_SEAL_OF_TEMPERED_FATE = "Seal of Tempered Fate";
    UBI_TOKEN_OIL, icon = 'Oil';
    UBI_TOKEN_SEAL_OF_INEVITABLE_FATE = 'Seal of Inevitable Fate';
    UBI_TOKEN_TIMEWARPED_BADGE = "Timewarped Badge";

    -- Miscellaneous
    UBI_MOVEMENT = "Hold down shift key to move frame to a different location";