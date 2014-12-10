--[[ =================================================================
    Description:
        Type /ubi or /uberinventory to see what you currently own,
        whether it is in the bank or in the bags you carry.
        So now where ever you are in the World of Warcraft you can
        get an overview of all your loot.

    Download:
        UberInventory - http://fmeus.wordpress.com/uberinventory/

    Contact:
        For questions, bug reports visit the website or send an email
        to the following address: wowaddon@xs4all.nl

    Dependencies:
        None

    Credits:
        A big 'Thank You' to all the people at Blizzard Entertainment
        for making World of Warcraft.
    ================================================================= --]]

-- Local globals
    local _G = _G;
    local strfind, strgsub, strlower = string.find, string.gsub, string.lower;
    local floor, ceil, abs, tonumber = math.floor, math.ceil, math.abs, tonumber;
    local pairs, tinsert, tsort, wipe = pairs, table.insert, table.sort, wipe;

-- Information on tokens
    local UBI_Currencies = { 
        --Player vs Player
        { id=-1, name = PLAYER_V_PLAYER, force = false },
        { id=390, name = UBI_TOKEN_CONQUEST_POINTS, icon = "PVPCurrency-Conquest-"..UBI_FACTION, force = true, texcoord = { 0, 1, 0, 1 } }, -- Conquest Points
        { id=392, name = UBI_TOKEN_HONOR_POINTS, icon = "PVPCurrency-Honor-"..UBI_FACTION, force = true, texcoord = { 0, 1, 0, 1 } }, -- Honor Points
        { id=391, name = UBI_TOKEN_TOLBARAD, icon = "achievement_zone_tolbarad", force = true, texcoord = { 0, 1, 0, 1 } }, -- Tol Barad Commendation

        -- Miscellaneous
        { id=-2, name = MISCELLANEOUS, force = false },
        { id=241, name = UBI_TOKEN_CHAMPIONS_SEAL, icon = "Ability_Paladin_ArtofWar", force = true, texcoord = { 0, 1, 0, 1 } }, -- Champion's Seal
        { id=61, name = UBI_TOKEN_JEWELCRAFTING_DALARAN, icon = "INV_Misc_Gem_Variety_01", force = true, texcoord = { 0, 1, 0, 1 } }, -- Dalaran Jewelcrafting Token
        { id=515, name = UBI_TOKEN_DARKMOONPRIZETICKET, icon = "inv_misc_ticket_darkmoon_01", force = true, texcoord = { 0, 1, 0, 1 } }, -- Darkmoon Prize Ticket
        { id=81, name = UBI_TOKEN_EPICURIAN, icon = "INV_Misc_Ribbon_01", force = true, texcoord = { 0, 1, 0, 1 } }, -- Epicurean's Award
        { id=402, name = UBI_TOKEN_IRONPAW, icon = "inv_relics_idolofferocity", force = true, texcoord = { 0, 1, 0, 1 } }, -- Ironpaw Token
        { id=416, name = UBI_TOKEN_WORLDTREE, icon = "INV_Misc_markoftheworldtree", force = true, texcoord = { 0, 1, 0, 1 } }, -- Mark of the World Tree

        -- Dungeon and Raid
        { id=-3, name = LFG_TYPE_DUNGEON.." & "..LFG_TYPE_RAID, force = false },
        { id=615, name = UBI_TOKEN_ESSENCE_OF_DEATHWING, icon = "inv_elemental_primal_shadow", force = true, texcoord = { 0, 1, 0, 1 } }, -- Mote of Darkness
        { id=395, name = UBI_TOKEN_JUSTICE_POINTS, icon = "pvecurrency-justice", force = true, texcoord = { 0, 1, 0, 1 } }, -- Justice Points
        { id=614, name = UBI_TOKEN_MOTE_OF_DARKNESS, icon = "spell_shadow_sealofkings", force = true, texcoord = { 0, 1, 0, 1 } }, -- Mote of Darkness
        { id=396, name = UBI_TOKEN_VALOR_POINTS, icon = "pvecurrency-valor", force = true, texcoord = { 0, 1, 0, 1 } }, -- Valor Points

        -- Cataclysm
        { id=-4, name = EXPANSION_NAME3, force = false },
        { id=361, name = UBI_TOKEN_ILLUSTRIOUS_JEWELCRAFTING, icon = "inv_misc_token_argentdawn3", force = true, texcoord = { 0, 1, 0, 1 } }, -- Illustrious Jewelcrafter's Token
        { id=698, name = UBI_TOKEN_ZEN_JEWELCRAFTING, icon = "trade_archaeology_titan_fragment", force = true, texcoord = { 0, 1, 0, 1 } }, -- Zen Jewelcrafter's Token

        -- Mist of Pandaria
        { id=-5, name = EXPANSION_NAME4, force = false },
        { id=738, name = UBI_TOKEN_LESSER_CHARM, icon = "inv_misc_coin_18", force = true, texcoord = { 0, 1, 0, 1 } }, -- Lesser Charm of Good Fortune
        { id=697, name = UBI_TOKEN_ELDER_CHARM, icon = "inv_misc_coin_17", force = true, texcoord = { 0, 1, 0, 1 } }, -- Elder Charm of Good Fortune
        { id=777, name = UBI_TOKEN_TIMELESSCOIN, icon = "timelesscoin", force = true, texcoord = { 0, 1, 0, 1 } }, -- Timeless Coin
        { id=776, name = UBI_TOKEN_WARFORGED_SEAL, icon = "inv_arcane_orb", force = true, texcoord = { 0, 1, 0, 1 } }, -- Warforged Seal
        { id=752, name = UBI_TOKEN_MOGU_RUNE_OF_FATE, icon = "archaeology_5_0_mogucoin", force = true, texcoord = { 0, 1, 0, 1 } }, -- Mogu Rune of Fate

        -- Warlords of Draenor
        { id=-6, name = EXPANSION_NAME5, force = false },
        { id=823, name = UBI_TOKEN_APEXIS_CRYSTAL, icon = "inv_apexis_draenor", force = true, texcoord = { 0, 1, 0, 1 } }, -- Apexis Crystal
        { id=824, name = UBI_TOKEN_GARRISON_RESOURCE, icon = "inv_garrison_resource", force = true, texcoord = { 0, 1, 0, 1 } }, -- Garrison Resources
        { id=994, name = UBI_TOKEN_SEAL_OF_TEMPERED_FATE, icon = "ability_animusorbs", force = true, texcoord = { 0, 1, 0, 1 } }, -- Seal of Tempered Fate

-- Seal of tempered fate
    };

-- Text and tooltips for checkbuttons
    UBI_CheckButtons = {
        { text = UBI_OPTION_MONEY, tooltip = UBI_OPTION_MONEY_TIP },
        { text = UBI_OPTION_BALANCE, tooltip = UBI_OPTION_BALANCE_TIP },
        { text = UBI_OPTION_SELLPRICES, tooltip = UBI_OPTION_SELLPRICES_TIP },
        { text = UBI_OPTION_RECIPEPRICES, tooltip = UBI_OPTION_RECIPEPRICES_TIP },
        { text = UBI_OPTION_QUESTREWARD, tooltip = UBI_OPTION_QUESTREWARD_TIP },
        { text = UBI_OPTION_RECIPEDROP, tooltip = UBI_OPTION_RECIPEDROP_TIP },
        { text = UBI_OPTION_TAKEMONEY, tooltip = UBI_OPTION_TAKEMONEY_TIP },
        { text = UBI_OPTION_SHOWMAP, tooltip = UBI_OPTION_SHOWMAP_TIP },
        { text = UBI_OPTION_GBSEND, tooltip = UBI_OPTION_GBSEND_TIP },
        { text = UBI_OPTION_GBRECEIVE, tooltip = UBI_OPTION_GBRECEIVE_TIP },
        { text = UBI_OPTION_WARN_MAILEXPIRE, tooltip = UBI_OPTION_WARN_MAILEXPIRE_TIP },
        { text = UBI_OPTION_HIGHLIGHT, tooltip = UBI_OPTION_HIGHLIGHT_TIP },
        { text = UBI_OPTION_SHOWTOOLTIP, tooltip = UBI_OPTION_SHOWTOOLTIP_TIP },
        { text = UBI_OPTION_ITEMCOUNT, tooltip = UBI_OPTION_ITEMCOUNT_TIP },
        { text = UBI_OPTION_GBTRACK, tooltip = UBI_OPTION_GBTRACK_TIP },
        { text = UBI_OPTION_PRICES_VENDOR, tooltip = UBI_OPTION_PRICES_VENDOR_TIP },
        { text = UBI_OPTION_PRICES_AH, tooltip = UBI_OPTION_PRICES_AH_TIP },
    };

-- Static dialogs
    StaticPopupDialogs["UBI_CONFIRM_DELETE"] = {
        text = "%s",
        button1 = YES,
        button2 = NO,
        timeout = 10,
        whileDead = 1,
        exclusive = 1,
        showAlert = 1,
        hideOnEscape = 1
    };

-- Enable/Disable an UI object
    function UberInventory_SetState( object, state )
        if ( object ) then
            if ( state ) then
                object:Enable();
            else
                object:Disable();
            end;
        end;
    end;

-- UberInventory task: Collect mailbox cash
    function UBI_Task_CollectCash( mailid )
        -- Mail info
        local _, _, mailSender, mailSubject, cashAttached = GetInboxHeaderInfo( mailid );
        local invoiceType, itemName, playerName, bid, buyout, deposit, consignment = GetInboxInvoiceInfo( mailid );

        if ( cashAttached > 0 ) then
            -- Report cash attached to message
            UberInventory_Message( UBI_MAIL_CASH:format( GetCoinTextureString( cashAttached ), mailSender, mailSubject ), true );

            -- Take the money
            TakeInboxMoney( mailid );
        end;
    end;

-- UberInventory task: Send stream end indication
    function UBI_Task_SendMessage( task, info )
        -- Define valid tasks
        local valid_tasks = { VERINFO=1, GBSTART=1, GBITEM=1, GBCASH=1, GBEND=1, GBREQUEST=1 };

        -- Only send message when in a guild and a valid task has been provided
        if ( IsInGuild() and valid_tasks[task] ) then
            if ( info ) then
                SendAddonMessage( "UBI", "UBI:"..task.." "..info, "GUILD" );
            else
                SendAddonMessage( "UBI", "UBI:"..task, "GUILD" );
            end;
        end;
    end;

-- Upgrade data structures
    function UberInventory_Upgrade()
        -- From global to local
        local UBI_Options = UBI_Options;
        local UBI_Data = UBI_Data;

        -- Upgrade process
        if ( UBI_Options["version"] ~= UBI_VERSION ) then
            -- Show upgrade message
            UberInventory_Message( UBI_UPGRADE, true );

            -- Upgrade to version 1.0
            if ( UBI_Options["version"] < "1.0" ) then
                if ( UBI_Data["ItemPrices"] ) then
                    UBI_Data["ItemPrices"] = nil;
                end;
            end;

            -- Upgrade to version 1.3
            if ( UBI_Options["version"] < "1.3" ) then
                if ( not UBI_Options["show_recipe_prices"] ) then
                    UBI_Options["show_recipe_prices"] = true;
                end;
                if ( not UBI_Options["show_recipe_reward"] ) then
                    UBI_Options["show_recipe_reward"] = true;
                end;
                if ( not UBI_Options["show_recipe_drop"] ) then
                    UBI_Options["show_recipe_drop"] = true;
                end;
            end;

            -- Upgrade to version 1.6
            if ( UBI_Options["version"] < "1.6" ) then
                if ( not UBI_Options["send_gb_data"] ) then
                    UBI_Options["send_gb_data"] = true;
                end;
                if ( not UBI_Options["receive_gb_data"] ) then
                    UBI_Options["receive_gb_data"] = true;
                end;
                if ( not UBI_Options["warn_mailexpire"] ) then
                    UBI_Options["warn_mailexpire"] = true;
                end;
            end;

            -- Upgrade to version 1.7
            if ( UBI_Options["version"] < "1.7" ) then
                for key, value in pairs( UBI_Data[UBI_REALM] ) do
                    if ( key ~= "Guildbank" ) then
                        -- Upgrade character data
                        for key, value in pairs( value["Items"] ) do
                            value["itemid"] = tonumber( value["itemid"] );
                        end;
                    else
                        -- Upgrade guildbank data
                        for key, value in pairs( value ) do
                            for key, value in pairs( value["Items"] ) do
                                value["itemid"] = tonumber( value["itemid"] );
                            end;
                        end;
                    end;
                end;
            end;

            -- Upgrade to version 2.0
            if ( UBI_Options["version"] < "2.0" ) then
                if ( not UBI_Options["show_highlight"] ) then
                    UBI_Options["show_highlight"] = true;
                end;
            end;

            -- Upgrade to version 3.1
            if ( UBI_Options["version"] < "3.1" ) then
                for key, value in pairs( UBI_Data[UBI_REALM] ) do
                    if ( key ~= "Guildbank" ) then
                        if ( not value["Money"]["Currencies"] ) then
                            value["Money"]["Currencies"] = {};
                        end;
                    end;
                end;
            end;

            -- Upgrade to version 3.6
            if ( UBI_Options["version"] < "3.6" ) then
                UBI_Options["guildbank_visit"] = nil;
                UBI_Options["bank_visit"] = nil;
                UBI_Options["mail_visit"] = nil;
                UBI_Options["show_tooltip"] = true;
            end;

            -- Upgrade to version 3.7
            if ( UBI_Options["version"] < "3.7" ) then
                for key, value in pairs( UBI_Data[UBI_REALM] ) do
                    if ( key ~= "Guildbank" ) then
                        if ( not value["Money"]["Currencies"] ) then
                            value["Money"]["Currencies"] = {};
                        end;
                    end;
                end;
            end;

            -- Upgrade to version 4.4
            if ( UBI_Options["version"] < "4.4" ) then
                for key, value in pairs( UBI_Data[UBI_REALM] ) do
                    if ( key ~= "Guildbank" ) then
                        if ( not value["Options"]["level"] ) then
                            value["Options"]["level"] = "??";
                        end;
                        if ( not value["Options"]["class"] ) then
                            value["Options"]["class"] = "??";
                        end;
                    end;
                end;
            end;

            -- Upgrade to version 4.7
            if ( UBI_Options["version"] < "4.7" ) then
                for key, value in pairs( UBI_Data[UBI_REALM] ) do
                    if ( key ~= "Guildbank" ) then
                        for key, value in pairs( UBI_Data[UBI_REALM][key]["Items"] ) do
                            value["keyring_count"] = nil;
                            value["total"] = value["bag_count"] + value["bank_count"] + value["mailbox_count"] + value["equip_count"] + value["void_count"];
                        end;
                    end;
                end;
            end;

            -- Upgrade to version 4.8
            if ( UBI_Options["version"] < "4.8" ) then
                if ( not UBI_Options["show_item_count"] ) then
                    UBI_Options["show_item_count"] = true;
                end;
            end;

            -- Upgrade to version 4.9
            if ( UBI_Options["version"] < "4.9" ) then
                for key, value in pairs( UBI_Data[UBI_REALM] ) do
                    if ( key ~= "Guildbank" ) then
                        -- Upgrade character data
                        for key, value in pairs( value["Items"] ) do
                            value["void_count"] = 0;
                        end;
                    else
                        -- Upgrade guildbank data
                        for key, value in pairs( value ) do
                            for key, value in pairs( value["Items"] ) do
                                value["void_count"] = 0;
                            end;
                        end;
                    end;
                end;
            end;

            -- Upgrade to version 6.1
            if ( UBI_Options["version"] < "6.1" ) then
                if ( not UBI_Options["track_gb_data"] ) then
                    UBI_Options["track_gb_data"] = true;
                end;
            end;

            -- Upgrade to version 6.2
            if ( UBI_Options["version"] < "6.2" ) then
                -- Overwrite and notify user (Ticket #15)
                UBI_Options["show_item_count"] = true;
                UberInventory_Message( C_RED.."The setting for "..C_CLOSE..C_WHITE.."'Show item count info"..C_CLOSE..C_RED.." has been reset to "..C_CLOSE..C_BLUE.."true"..C_CLOSE, true );
            end;

            -- Upgrade to version 6.4
            if ( UBI_Options["version"] < "6.4" ) then
                UBI_Options["pricing_data"] = "vendor";
            end;

            -- Set current version
            UBI_Options["version"] = UBI_VERSION;
        end;
    end;

-- Days since visit
    function UberInventory_DaysSince( visit )
        local timediff;
        local today = time( UberInventory_GetDateTime() );

        if ( type( visit ) == "table" ) then
            timediff = difftime( today, time( visit ) or today );
        else
            timediff = difftime( today, visit or today ) 
        end;

        return floor( timediff / UBI_SEC_IN_DAY ), SecondsToTime( timediff );
    end;

-- Send message to the default chat frame
    function UberInventory_Message( msg, prefix )
        -- Initialize
        local prefixText = "";

        -- Add application prefix
        if ( prefix and true ) then
            prefixText = C_GREEN.."UBI: "..C_CLOSE;
        end;

        -- Send message to chatframe
        DEFAULT_CHAT_FRAME:AddMessage( prefixText..( msg or "" ) );
    end;

-- Save cash owned
    function UberInventory_SaveMoney()
        if ( not UBI_ACTIVE ) then return; end;

        -- Save money
        UBI_Money["Cash"] = GetMoney();
    end;

-- Save other currencies owned ( Honor points, Arena points, Tokens, etc )
    function UberInventory_Save_Currencies()
        if ( not UBI_ACTIVE ) then return; end;

        -- Save other currencies
        for key, value in pairs( UBI_Currencies ) do
            if ( value.id > 0 ) then
                local name, amount, icon = GetCurrencyInfo( value.id );
                UBI_Money["Currencies"][value.id] = amount or 0;
            end;
        end;
    end;

-- Specialized SetTooltipMoney function (till internal Blizzard code for SetTooltipMoney is fixed)
    function UberInventory_SetTooltipMoney( tooltip, money, type, prefix, suffix )
        -- Initialize
        local moneystring = GetCoinTextureString( money );

        -- Build the string
        if ( prefix ) then moneystring = prefix..moneystring; end;
        if ( suffix ) then moneystring = moneystring..suffix; end;

        -- Add info to the tooltip
        tooltip:AddLine( moneystring.."  ", 1.0, 1.0, 1.0 );
    end;

-- Update slot count information
    function UberInventory_Update_SlotCount()
        UberInventoryFrameBagSlots:SetFormattedText( UBI_SLOT_BAGS, UBI_Options["bag_free"] , UBI_Options["bag_max"] );
        UberInventoryFrameBankSlots:SetFormattedText( UBI_SLOT_BANK, UBI_Options["bank_free"], UBI_Options["bank_max"] );
    end;

-- Fetch item prices (buy, sell)
    function UberInventory_GetItemPrices( itemid )
        -- Initialize
        local sellPrice = select( 11, GetItemInfo( itemid ) );
        local buyPrice = UBI_Prices_Buy[itemid];
        local buyoutPrice;

        -- Get Auction House buyout price (if available)
        if ( type( GetAuctionBuyout ) == "function" ) then
            -- AuctionLite, Auctionator, AuctionaMaster
            buyoutPrice = GetAuctionBuyout( itemid  ) or 0;
        elseif ( AucAdvanced ) then
            -- Auctioneer
            buyoutPrice = select( 6, AucAdvanced.Modules.Util.SimpleAuction.Private.GetItems( itemid ) ) or 0;
        end;

        return buyPrice, sellPrice, buyoutPrice;
    end;

-- Get Date and time (platform independed)
    function UberInventory_GetDateTime()
        local _, month_, day_, year_ = CalendarGetDate();
        local hour_, minute_ = GetGameTime();

        return { year=year_, month=month_, day=day_, hour=hour_, min=minute_, sec=00 };
    end;

-- Extract info from tooltip
    function UberInventory_Scan_Tooltip( itemid, color, searchtext )
        -- Rounding function
        local function round( x, digit )
            -- Positions to be shifted
            local shift = 10 ^ digit;

            -- Round the number to wanted decimals
            return floor( x * shift + 0.5 ) / shift;
        end;

        -- Initialize
        local digits = 4;
        local colorFound, textFound = false, false;
        local r, g, b, a, txtLeft, txtRight;

        -- Setup tooltip for extracting data
        local tooltip = UberInventory_ItemTooltip;
        tooltip:ClearLines();
        tooltip:SetHyperlink( UberInventory_GetLink( itemid ) );
        tooltip:Show();

        -- Correct color precision
        color.r = round( color.r, digits );
        color.g = round( color.g, digits );
        color.b = round( color.b, digits );

        -- Traverse tooltip lines
        for i = 1, tooltip:NumLines() do
            -- Get text
            txtLeft = _G[tooltip:GetName().."TextLeft"..i]:GetText();
            txtRight = _G[tooltip:GetName().."TextRight"..i]:GetText();

            -- Find the specified color
            if ( color ) then
                -- Check left color
                r, g, b, a = _G[tooltip:GetName().."TextLeft"..i]:GetTextColor();

                -- Check if requested color was used
                if ( ( round( r, digits ) == color.r ) and
                     ( round( g, digits ) == color.g ) and
                     ( round( b, digits ) == color.b ) and
                     txtLeft ) then
                    colorFound = true;
                end;

                -- Check right color
                local r, g, b, a = _G[tooltip:GetName().."TextRight"..i]:GetTextColor();

                -- Check if requested color was used
                if ( ( round( r, digits ) == color.r ) and
                     ( round( g, digits ) == color.g ) and
                     ( round( b, digits ) == color.b ) and
                     txtRight ) then
                    colorFound = true;
                end;
            end;

            -- Find the specified text
            if ( searchtext and txtLeft ) then
                textFound = txtLeft:match( searchtext );
            end;
            if ( searchtext and txtRight ) then
                textFound = txtRight:match( searchtext );
            end;

            -- Stop on first blank line or new-line char
            if ( txtLeft == "" or txtLeft:find( "\n" ) ) then
                return colorFound, textFound;
            end;
        end;

        return colorFound, textFound;
    end;

-- Can item used by current player
    function UberInventory_UsableItem( itemid )
        -- Initialize
        local TOOLTIP_RED = { r = 0.99999779462814, g = 0.12548992037773, b = 0.12548992037773 };

        -- Determine if the color red is used within the tooltip
        local colorFound, textFound = UberInventory_Scan_Tooltip( itemid, TOOLTIP_RED, ITEM_SPELL_KNOWN );

        -- Return result (usable or not)
        return ( ( not colorFound ) or textFound );
    end;

-- Build list of usable alts
    function UberInventory_GetAlts()
        -- Initialize
        local UBI_Characters = UBI_Characters;
        wipe( UBI_Characters );

        -- Traverse all players to determine valid alts
        for key, value in pairs( UBI_Data[UBI_REALM] ) do
            if ( key ~= "Guildbank" ) and
               ( key ~= UBI_PLAYER ) and
               ( ( UBI_Data[UBI_REALM][key]["Options"]["faction"] or "<Unknown>" ) == UBI_FACTION ) then
                -- Add alt to the list
                tinsert( UBI_Characters, key );
            end;
        end;

        -- Sort alts alphabetically
        tsort( UBI_Characters );
    end;

-- Build list of guildbanks
    function UberInventory_GetGuildbanks()
        -- Initialize
        local UBI_Guildbanks = UBI_Guildbanks;
        wipe( UBI_Guildbanks );

        -- Traverse all guildbanks
        for key, value in pairs( UBI_Guildbank ) do
            if ( ( value["Faction"] or "<Unknown>" ) == UBI_FACTION ) then
                -- Add alt to the list
                tinsert( UBI_Guildbanks, key );
            end;
        end;

        -- Sort alts alphabetically
        tsort( UBI_Guildbanks );
    end;

-- Populate locations internal list
    function UberInventory_Build_Locations()
        -- Initialize
        local UBI_Item, level;
        local UBI_LocationCounter = UBI_LocationCounter;

        -- Clear locations and reset counter
        wipe( UBI_LocationList );
        UBI_LocationCounter = 1;

        -- Custom function for adding items to dropdownbox
        local function UberInventory_AddLocation( item, itemtype )
            item.owner = UberInventoryFrameLocationDropDown;
            UBI_LocationList[UBI_LocationCounter] = { key = item.value, name = item.text, value = strtrim( item.text ), type = itemtype, object = item };
            UBI_LocationCounter = UBI_LocationCounter + 1;
        end;

        -- All items (inludes current characters, all guildbanks and all other characters)
        UBI_Item = { text = UBI_ALL_LOCATIONS,
                     value = UBI_LocationCounter,
                     notCheckable = 1,
                     func = UberInventory_Locations_OnClick,
                     colorCode = "|cFFFFFF00" };
        UberInventory_AddLocation( UBI_Item, "complete" );

        -- Insert divider
        UBI_Item = { text = "",
                     isTitle = 1,
                     notCheckable = 1 };
        UberInventory_AddLocation( UBI_Item, "title" );

        -- Current characters
        if ( UBI_Options["level"] ) then
            level = " ["..C_YELLOW..UBI_Options["level"]..C_CLOSE.."]";
        else
            level = "";
        end;

        UBI_Item = { text = UBI_PLAYER..level,
                     value = UBI_LocationCounter,
                     notCheckable = 1,
                     func = UberInventory_Locations_OnClick,
                     colorCode = "|cFFFFFF00" };
        UberInventory_AddLocation( UBI_Item, "current" );

        -- Add the basic locations (including Guildbank when member of a guild)
        for key, value in pairs( UBI_LOCATIONS ) do
            -- Set new item
            UBI_Item = { text = "  "..value,
                         value = UBI_LocationCounter,
                         icon = UBI_LOCATION_TEXTURE[key],
                         notCheckable = 1,
                         func = UberInventory_Locations_OnClick };

            -- Add item to dropdown
            UberInventory_AddLocation( UBI_Item, "current" );
        end;

        -- Add separator if there are guildbanks to be added
        if ( #UBI_Guildbanks > 0 ) then
            -- Set new item
            UBI_Item = { text = "",
                         isTitle = 1,
                         notCheckable = 1 };
            UberInventory_AddLocation( UBI_Item, "title" );

            UBI_Item = { text = UBI_ALL_GUILDBANKS,
                         value = UBI_LocationCounter,
                         notCheckable = 1,
                         func = UberInventory_Locations_OnClick,
                         colorCode = "|cFFFFFF00" };
            UberInventory_AddLocation( UBI_Item, "all_guildbank" );
        end;

        -- Add guildbanks (how to determine faction for image?)
        for key, value in pairs( UBI_Guildbanks ) do
            -- Set new item
            UBI_Item = { text = "  "..value,
                         value = UBI_LocationCounter,
                         icon = UBI_LOCATION_TEXTURE[6],
                         notCheckable = 1,
                         func = UberInventory_Locations_OnClick };

            -- Add highlight to current players guildbank
            if ( value == UBI_GUILD ) then
                UBI_Item.colorCode = ITEM_QUALITY_COLORS[5].hex;
            end;

            -- Add item to dropdown (Guildbank only added if in a guild)
            UberInventory_AddLocation( UBI_Item, "guildbank" );
        end;

        -- Add separator if there are alts to be added
        if ( #UBI_Characters > 0 ) then
            -- Set new item
            UBI_Item = { text = "",
                         isTitle = 1,
                         notCheckable = 1 };
            UberInventory_AddLocation( UBI_Item, "title" );

            UBI_Item = { text = UBI_ALL_CHARACTERS,
                         value = UBI_LocationCounter,
                         notCheckable = 1,
                         func = UberInventory_Locations_OnClick,
                         colorCode = "|cFFFFFF00" };
            UberInventory_AddLocation( UBI_Item, "all_character" );
        end;

        -- Add alts to the list from the same realm and faction (Alliance or Horde)
        for key, value in pairs( UBI_Characters ) do
            if ( UBI_Data[UBI_REALM][value]["Options"]["level"] ) then
                level = " ["..C_YELLOW..UBI_Data[UBI_REALM][value]["Options"]["level"]..C_CLOSE.."]";
            else
                level = "";
            end;

            UBI_Item = { text = "  "..value..level,
                         value = UBI_LocationCounter,
                         icon = UBI_LOCATION_TEXTURE[6], -- Faction icon
                         notCheckable = 1,
                         func = UberInventory_Locations_OnClick };

            -- Replace faction icon with class icon if the class is known
            if ( UBI_Data[UBI_REALM][value]["Options"]["class"] and UBI_Data[UBI_REALM][value]["Options"]["class"] ~= "??" ) then
                local tLeft, tRight, tTop, tBottom = unpack( CLASS_ICON_TCOORDS[ UBI_Data[UBI_REALM][value]["Options"]["class"] ] );

                UBI_Item.icon = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes";
                UBI_Item.tCoordLeft = tLeft;
                UBI_Item.tCoordRight = tRight;
                UBI_Item.tCoordTop = tTop;
                UBI_Item.tCoordBottom = tBottom;
            end;

            UberInventory_AddLocation( UBI_Item, "character" );
        end;
   end;

-- Populate locations dropdown box (Also contains items for alts on the same realm from the same faction (Alliance or Horde))
    function UberInventory_Locations_Init( self )
        -- Build list of locations
        UberInventory_Build_Locations();

        -- Add items to the dropdown box
        for key, value in pairs( UBI_LocationList ) do
            -- Add item to dropdown
            UIDropDownMenu_AddButton( value.object );
        end;
   end;

-- Resets position in scrollframe to the top
    function UberInventory_ScrollToTop()
       FauxScrollFrame_SetOffset( UberInventoryFrameScroll, 0 );
       UberInventoryFrameScrollScrollBar:SetValue( 0 );
    end;

-- Update locations dropdown box
    function UberInventory_Locations_OnClick( self )
        UBI_FILTER_LOCATIONS = self.value;
        UIDropDownMenu_SetText( self.owner, UBI_LocationList[UBI_FILTER_LOCATIONS].value );
        UberInventory_ScrollToTop();
        UberInventory_DisplayItems();

        -- Update token info on screen
        if ( UberInventoryTokens:IsVisible() ) then
            UberInventory_DisplayTokens();
        end;
    end;

-- Populate quality dropdown box
    function UberInventory_Quality_Init( self )
        -- Initialize
        local UBI_Item;
        local UBI_QUALITY = UBI_QUALITY;

        for key, value in pairs( UBI_QUALITY ) do
            -- Set new item
            UBI_Item = { text = value,
                         value = key,
                         owner = UberInventoryFrameQualityDropDown,
                         notCheckable = 1,
                         func = UberInventory_Quality_OnClick,
                         colorCode = ITEM_QUALITY_COLORS[key-2].hex };

            -- Correct color for 'All qualities'
            if (key-2 == -1) then
                UBI_Item.colorCode = ITEM_QUALITY_COLORS[1].hex;
            end;

            -- Add item to dropdown
            UIDropDownMenu_AddButton( UBI_Item );
        end;
    end;

-- Update quality dropdown box
    function UberInventory_Quality_OnClick( self )
        UBI_FILTER_QUALITY = self.value;
        UIDropDownMenu_SetText( self.owner, UBI_QUALITY[UBI_FILTER_QUALITY] );
        UberInventory_ScrollToTop();
        UberInventory_DisplayItems();
    end;

-- Populate classes dropdown box
    function UberInventory_Classes_Init( self )
        -- Initialize
        local subclasses, UBI_Item;
        local UBI_CLASSES = UBI_CLASSES;

        -- Build structure for classes
        if ( UIDROPDOWNMENU_MENU_LEVEL == 1 ) then
            for key, value in pairs( UBI_CLASSES ) do
                -- Determine subclasses
                subclasses = { GetAuctionItemSubClasses( key-1 ) };

                -- Set new item
                UBI_Item = { text = value,
                             value = { key, 0 },
                             owner = UberInventoryFrameClassDropDown,
                             notCheckable = 1,
                             hasArrow = #subclasses > 0,
                             func = UberInventory_Classes_OnClick };

                -- Add item to dropdown
                UIDropDownMenu_AddButton( UBI_Item, UIDROPDOWNMENU_MENU_LEVEL );
            end;
        end;

        -- Build structure for subclasses
        if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
            -- Determine subclasses
            subclasses = { GetAuctionItemSubClasses( UIDROPDOWNMENU_MENU_VALUE[1]-1 ) };

            for key, value in pairs( subclasses ) do
                -- Set new tem
                UBI_Item = { text = value,
                             value = { UIDROPDOWNMENU_MENU_VALUE[1], key },
                             owner = UberInventoryFrameClassDropDown,
                             notCheckable = 1,
                             func = UberInventory_Classes_OnClick
                             };

                -- Add item to dropdown
                UIDropDownMenu_AddButton( UBI_Item, UIDROPDOWNMENU_MENU_LEVEL );
            end;
        end;
    end;

-- Update classes dropdown box
    function UberInventory_Classes_OnClick( self )
        -- Get selection
        UBI_FILTER_CLASSES = self.value[1];
        UBI_FILTER_SUBCLASSES = self.value[2];

        -- Determine dropdown text
        local infoText = UBI_CLASSES[UBI_FILTER_CLASSES];
        if ( UBI_FILTER_SUBCLASSES > 0 ) then
            local subclasses = { GetAuctionItemSubClasses( UBI_FILTER_CLASSES-1 ) };
            infoText = infoText.." > "..subclasses[UBI_FILTER_SUBCLASSES];
            HideDropDownMenu( 1 ); -- Collapse also the top level menu
        end;

        UIDropDownMenu_SetText( self.owner, infoText );
        UberInventory_ScrollToTop();
        UberInventory_DisplayItems();
    end;

-- Returns an itemLink
    function UberInventory_GetLink( itemid, record )
        if ( record and ( record.type == UBI_BATTLEPET_CLASS and record.item ~= 82800 ) ) then
            return UberInventory_GetBattlePetLink( record );
        end;

        -- Get name of item
        local itemName, _, itemQuality = GetItemInfo( itemid );

        -- If the item has never been seen before, itemName will be nil
        if ( itemName == nil ) then
            itemName = UBI_ITEM_UNCACHED;
            itemQuality = 0;
        end;

        -- Determine item color
        local color = ITEM_QUALITY_COLORS[itemQuality].hex;

        -- Return itemLink
        return color.."|Hitem:"..itemid..":0:0:0:0:0:0:0|h["..itemName.."]|h|r";
    end;

-- Returns an Battlepet Link
    function UberInventory_GetBattlePetLink( record )
        -- Initialize
        local health, power, speed = 0, 0, 0;

        -- Get name of item
        local name, icon, petType, companionID, tooltipSource, tooltipDescription, isWild, canBattle, isTradeable, isUnique, obtainable = C_PetJournal.GetPetInfoBySpeciesID( record.itemid );

        -- If the item has never been seen before, name will be nil
        if ( name == nil ) then
            name = UBI_ITEM_UNCACHED;
        end;

        -- Get additional battlepet info
        if ( record.extra ) then
            health = record.extra[1] or 0;
            power = record.extra[2] or 0;
            speed = record.extra[3] or 0;
        end;

        -- Determine item color
        local color = ITEM_QUALITY_COLORS[record.quality].hex;

        -- Return itemLink
        return color.."|Hbattlepet:"..record.itemid..":"..record.level..":"..record.quality..":"..health..":"..power..":"..speed..":0x0000000000000000|h["..name.."]|h|r";
    end;

-- Handle OnEnter event of the Minimap icon
    function UberInventory_Minimap_OnEnter( object, anchor )
        -- Set location of tooltip and clear old content
        GameTooltip:SetOwner( object, anchor );
        GameTooltip:SetPoint( "TOPLEFT", object, "BOTTOMLEFT" );

        -- Add title (AddOn name and version)
        GameTooltip:AddDoubleLine( UBI_NAME, UBI_VERSION,
                                   HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b,
                                   NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b );

        -- Add slot information
        GameTooltip:AddDoubleLine( UBI_BAG, UBI_FREE:format( UBI_Options["bag_free"] , UBI_Options["bag_max"] ) );
        GameTooltip:AddDoubleLine( UBI_BANK, UBI_FREE:format( UBI_Options["bank_free"] , UBI_Options["bank_max"] ) );

        -- Add cash inforamtion
        GameTooltip:AddDoubleLine( UBI_CASH_TOTAL, GetCoinTextureString( GetMoney() + UBI_Money["mail"] ) );

        -- (Re)display the tooltip
        GameTooltip:Show();
    end;

-- Sorting table content
    function UberInventory_SortFilter( str, cmdline )
        -- From global to local
        local UBI_Track = UBI_Track;
        local UBI_Sorted = UBI_Sorted;
        local UBI_Items_Work = UBI_Items_Work;

        -- determine if sorting/collecting is needed
        if ( UBI_Filter.text == UBI_FILTER_TEXT and
             UBI_Filter.location == UBI_FILTER_LOCATIONS and
             UBI_Filter.quality == UBI_FILTER_QUALITY and
             UBI_Filter.class == UBI_FILTER_CLASSES and
             UBI_Filter.subclass == UBI_FILTER_SUBCLASSES and
             UBI_Filter.usable == UBI_FILTER_USABLE and
             UBI_Filter.date == UBI_SCAN_DATE ) and not UberInventoryFrame:IsVisible() then
            return;
        else
            -- Store new filter settings
            UBI_Filter = { text = UBI_FILTER_TEXT,
                           location = UBI_FILTER_LOCATIONS,
                           quality = UBI_FILTER_QUALITY,
                           class = UBI_FILTER_CLASSES,
                           subclass = UBI_FILTER_SUBCLASSES,
                           usable = UBI_FILTER_USABLE,
                           date = UBI_SCAN_DATE };
        end;

        -- Initialize globals
        wipe( UBI_Sorted );
        wipe( UBI_Track );
        wipe( UBI_Items_Work );
        UBI_Inventory_count = 0;

        -- Copy items to separate array for sorting and displaying
        local include_item;
        local subclasses;
        local function UberInventory_CopyItems( str, cmdline )
            -- Copy items to local array (including filter)
            for key, record in pairs( UBI_Items_Work ) do
                -- Initialize
                include_item = true;

                -- Count number of unique items
                if ( not UBI_Track[record.itemid] ) then
                    UBI_Inventory_count = UBI_Inventory_count + 1;
                    UBI_Track[record.itemid] = 0;
                end;

                -- Fix totalCount (only for actual characters)
                if ( record.bag_count ) then
                    record.total = record.bag_count + record.bank_count + record.mailbox_count + record.equip_count + ( record.void_count or 0 );
                end;

                -- Only apply filters when searching from then inventory frame
                if ( not cmdline ) then
                    -- Filter on location (3 = Character, 4 = Bags, 5 = Banks, 6 = Mail, 7 = Equipped, 8 = Void Storage )
                    if ( ( UBI_FILTER_LOCATIONS == 4 and record.bag_count == 0 ) or
                         ( UBI_FILTER_LOCATIONS == 5 and record.bank_count == 0 ) or
                         ( UBI_FILTER_LOCATIONS == 6 and record.mailbox_count == 0 ) or
                         ( UBI_FILTER_LOCATIONS == 7 and record.equip_count == 0 ) or
                         ( UBI_FILTER_LOCATIONS == 8 and ( record.void_count or 0 ) == 0 ) ) then
                        include_item = false;
                    end;

                    -- Filter on quality
                    if ( UBI_FILTER_QUALITY > 1 and record.quality ~= UBI_FILTER_QUALITY-2 ) then
                        include_item = false;
                    end;

                    -- Filter on class
                    if ( UBI_FILTER_CLASSES > 1 and record.type ~= UBI_CLASSES[UBI_FILTER_CLASSES] ) then
                        include_item = false;
                    end;

                    -- Filter on subclass
                    subclasses = { GetAuctionItemSubClasses( UBI_FILTER_CLASSES-1 ) };
                    if ( UBI_FILTER_SUBCLASSES > 0 and record.subtype ~= subclasses[UBI_FILTER_SUBCLASSES] ) then
                        include_item = false;
                    end;

                    -- Filter on usability
                    if ( UBI_FILTER_USABLE ) then
                        if ( not UberInventory_UsableItem( record.itemid ) ) then
                            include_item = false;
                        end;
                    end;
                end;

                -- Filter on name and store into structure suitable for sorting
                if ( ( strfind( strlower( record.name ) , strlower( str ) ) or 0 ) > 0 ) and include_item then
                    -- Insert item into sorting structure
                    if ( UBI_Track[record.itemid] == 0 ) then
                        tinsert( UBI_Sorted, record );
                    end;

                    -- Track correct item totals
                    UBI_Track[record.itemid] = UBI_Track[record.itemid] + record.total;
                end;
            end;
        end;

        -- Set base list of items to use
        if ( cmdline or UBI_LocationList[UBI_FILTER_LOCATIONS].type == "current" ) then
            -- Current character
            UBI_Items_Work = UBI_Items;
            UberInventory_CopyItems( str, cmdline );
        elseif ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "guildbank" ) then
            -- Guildbank
            UBI_Items_Work = UBI_Guildbank[UBI_LocationList[UBI_FILTER_LOCATIONS].value]["Items"];
            UberInventory_CopyItems( str, cmdline );
        elseif ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "character" ) then
            -- Alt characters
            local character = strgsub( UBI_LocationList[UBI_FILTER_LOCATIONS].value, " .*", "" );
            UBI_Items_Work = UBI_Data[UBI_REALM][character]["Items"];
            UberInventory_CopyItems( str, cmdline );
        elseif ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "complete" ) then
            -- Traverse characters
            for key, value in pairs( UBI_Characters ) do
                UBI_Items_Work = UBI_Data[UBI_REALM][value]["Items"];
                UberInventory_CopyItems( str, cmdline );
            end;

            -- Current character
            UBI_Items_Work = UBI_Items;
            UberInventory_CopyItems( str, cmdline );

            -- Traverse guildbanks
            for key, value in pairs( UBI_Guildbanks ) do
                UBI_Items_Work = UBI_Guildbank[value]["Items"];
                UberInventory_CopyItems( str, cmdline );
            end;
        elseif ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "all_guildbank" ) then
            -- Traverse guildbanks
            for key, value in pairs( UBI_Guildbanks ) do
                UBI_Items_Work = UBI_Guildbank[value]["Items"];
                UberInventory_CopyItems( str, cmdline );
            end;
        elseif ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "all_character" ) then
            -- Current character
            UBI_Items_Work = UBI_Items;
            UberInventory_CopyItems( str, cmdline );

            -- Traverse characters
            for key, value in pairs( UBI_Characters ) do
                UBI_Items_Work = UBI_Data[UBI_REALM][value]["Items"];
                UberInventory_CopyItems( str, cmdline );
            end;
        end;

        -- Sort the array alphabetically based on item name
        tsort( UBI_Sorted, function( rec1, rec2 )
                               return rec1.name < rec2.name
                           end  );
    end;

-- Reset filters
    function UberInventory_ResetFilters( button )
        -- Reset dropdown for location
        if ( button == "RightButton" ) then
            UBI_FILTER_LOCATIONS = 1; -- All items
        else
            UBI_FILTER_LOCATIONS = 3; -- Current character
        end;
        UIDropDownMenu_SetText( UberInventoryFrameLocationDropDown, UBI_LocationList[UBI_FILTER_LOCATIONS].value );

        -- Reset dropdown for quality
        UBI_FILTER_QUALITY = 1;
        UIDropDownMenu_SetText( UberInventoryFrameQualityDropDown, UBI_QUALITY[UBI_FILTER_QUALITY] );

        -- Reset dropdown for class
        UBI_FILTER_CLASSES = 1;
        UBI_FILTER_SUBCLASSES = 0;
        UIDropDownMenu_SetText( UberInventoryFrameClassDropDown, UBI_CLASSES[UBI_FILTER_CLASSES] );

        -- Reset usable items
        UBI_FILTER_USABLE = false;
        UberInventoryFrameUsableItems:SetChecked( UBI_FILTER_USABLE );

        -- Reset search text (and refresh items displayed)
        if ( UBI_FILTER_TEXT == "" ) then
            UberInventory_ScrollToTop();
            UberInventory_DisplayItems();

            -- Update token info on screen
            if ( UberInventoryTokens:IsVisible() ) then
                UberInventory_DisplayTokens();
            end;
        else
            UberInventoryFrameItemSearch:SetText( "" );
        end;
    end;

-- Reset item counts
    function UberInventory_ResetCount( location )
        -- From global to local
        local UBI_Items = UBI_Items;

        -- Clear counts
        location = location.."_count";
        for key, record in pairs( UBI_Items ) do
            record[location] = 0;
        end;
    end;

-- Add sell prices to items in your bag (only used if not already at a merchant)
    function UberInventory_AddItemInfo( tooltip )
        -- Skip when user does not want information added to tooltip
        if ( not UBI_Options["show_tooltip"] ) then return; end;

        -- Function for adding counts per location (only non-zero locations are added to the tooltip)
        local function AddLocationInfo( tooltip, bag, bank, mailbox, equipped, void )
            tooltip:AddLine( "|n" );
            if ( bag > 0 ) then tooltip:AddDoubleLine( UBI_LOCATIONS[1], bag ); tooltip:AddTexture( UBI_LOCATION_TEXTURE[1] ); end;
            if ( bank > 0 ) then tooltip:AddDoubleLine( UBI_LOCATIONS[2], bank ); tooltip:AddTexture( UBI_LOCATION_TEXTURE[2] ); end;
            if ( mailbox > 0 ) then tooltip:AddDoubleLine( UBI_LOCATIONS[3], mailbox ); tooltip:AddTexture( UBI_LOCATION_TEXTURE[3] ); end;
            if ( equipped > 0 ) then tooltip:AddDoubleLine( UBI_LOCATIONS[4], equipped ); tooltip:AddTexture( UBI_LOCATION_TEXTURE[4] ); end;
            if ( ( void or 0 ) > 0 ) then tooltip:AddDoubleLine( UBI_LOCATIONS[5], void ); tooltip:AddTexture( UBI_LOCATION_TEXTURE[5] ); end;
        end;

        -- Set smaller font for vendor, quest and drop information
        local function SetSmallerFont()
            local numlines = tooltip:NumLines();
            local txtLeft = _G[ tooltip:GetName().."TextLeft"..numlines ];
            local txtRight = _G[ tooltip:GetName().."TextRight"..numlines ];
            txtLeft:SetFontObject( GameTooltipTextSmall );
            txtLeft:SetTextColor( 0.0, 1.0, 0.0 );
            txtRight:SetFontObject( GameTooltipTextSmall );
            txtRight:SetTextColor( 0.0, 0.7, 1.0 );
        end;

        -- Initialize
        local itemCount = 1;
        local guildCount = 0;
        local spacerAdded = false;

        -- Get the itemLink
        local itemName, itemLink = tooltip:GetItem();

        -- Does the slot contain an item
        if ( itemLink ) then
            -- Get item ID
            local _, itemId = strsplit( ":", itemLink );
            local _, _, _, _, _, itemType, itemSubType = GetItemInfo( itemLink );

            -- Get count (only if count label exists and is visible, otherwise use the value 1)
            if ( tooltip:GetName() == "ItemRefTooltip" ) then
                itemCount = 1;
            else
                -- Special fix needed for Auctioneer Advanced, since this AddOn removes itembutton as soon as
                -- the mouse is over it to display a bigger button on a different location.
                -- (2009/07/28) Additional fix implemented (ticket #4)
                -- (2009/08/01) Additional fix implemented (related to Skillet)
                if ( GetMouseFocus() and GetMouseFocus():GetName() ) then
                  local objCount = _G[ GetMouseFocus():GetName().."Count" ];
                  if ( objCount and objCount:IsVisible() and objCount.GetText ) then
                      itemCount = tonumber( objCount:GetText() or "" ) or 1;
                  end;
                else
                    itemCount = 1;
                end;
            end;

            -- Get stored sell price
            local itemId_num = tonumber( itemId );
            local buyPrice, sellPrice, buyoutPrice = UberInventory_GetItemPrices( itemId_num );
            local name, area, mob, rate, count;
            local UBI_Zones = UBI_Zones;
            local totalCount = 0;

            -- Only perform the following part when it not has already been done (gets called twice for recipe related items)
            if ( not tooltip.UBI_InfoAdded or false ) then

                -- Add additional pricing information when not at a vendor
                if ( not MerchantFrame:IsVisible() or tooltip == ItemRefTooltip ) then
                    -- Add pricing information for selling to vendors
                    if ( UBI_Options["show_sell_prices"] ) then
                        if ( ( sellPrice or 0 ) == 0 ) then  -- Item unsellable
                            tooltip:AddLine( "|n" );
                            tooltip:AddLine( ITEM_UNSELLABLE, 1.0, 1.0, 1.0 );
                        elseif ( itemCount > 0 ) then -- Calculate sell price and add it
                            -- Add money to the tooltip
                            tooltip:AddLine( "|n" );
                            if ( UBI_Options["pricing_data"] == "vendor" ) then
                                UberInventory_SetTooltipMoney( tooltip, sellPrice * itemCount, "STATIC", UBI_ITEM_SELL, "" );
                            else
                                UberInventory_SetTooltipMoney( tooltip, buyoutPrice * itemCount, "STATIC", UBI_ITEM_BUYOUT, "" );
                            end;
                        end;
                    end;

                    -- Add pricing information for buying recipes from vendors (mainly for auction house use)
                    local recipeData = UBI_RecipeVendors[itemId_num];
                    if ( UBI_Options["show_recipe_prices"] and recipeData ) then
                        -- Add section title (incl cash) to the tooltip
                        tooltip:AddLine( "|n" );
                        if ( buyPrice ) then
                            tooltip:AddLine( UBI_ITEM_RECIPE_SOLD_BY:format( GetCoinTextureString( buyPrice ) ), 1.0, 1.0, 1.0 );
                        else
                            tooltip:AddLine( UBI_ITEM_RECIPE_SOLD_BY:format( "??" ), 1.0, 1.0, 1.0 );
                        end;

                        -- Add vendors to the tooltip
                        count = 0;
                        for idx, vendor in pairs( recipeData ) do
                            if ( count >= UBI_MAX_RECIPE_INFO ) then break; end;
                            name, area = strsplit( "|", UBI_Creatures[vendor] );
                            tooltip:AddDoubleLine( "  "..name, UBI_Zones[tonumber( area )] );
                            SetSmallerFont();
                            count = count + 1;
                        end;
                    end;

                    -- Add quest reward information for recipes
                    local recipeQuest = UBI_RecipeQuestRewards[itemId_num];
                    if ( UBI_Options["show_recipe_reward"] and recipeQuest ) then
                        -- Add section title to the tooltip
                        tooltip:AddLine( "|n" );
                        tooltip:AddLine( UBI_ITEM_RECIPE_REWARD_FROM, 1.0, 1.0, 1.0 );

                        -- Add quests to the tooltip
                        count = 0;
                        for idx, quest in pairs( recipeQuest ) do
                            if ( count >= UBI_MAX_RECIPE_INFO ) then break; end;
                            name, area = strsplit( "|", UBI_Quests[quest] )
                            tooltip:AddDoubleLine( "  "..name, UBI_Zones[tonumber( area )] );
                            SetSmallerFont();
                            count = count + 1;
                        end;
                    end;

                    -- Add drop information for recipes
                    local recipeDrop = UBI_RecipeDrops[itemId_num];
                    if ( UBI_Options["show_recipe_drop"] and recipeDrop ) then
                        -- Add section title to the tooltip
                        tooltip:AddLine( "|n" );
                        tooltip:AddLine( UBI_ITEM_RECIPE_DROP_BY, 1.0, 1.0, 1.0 );

                        -- Add quests to the tooltip
                        count = 0;
                        for idx, drop in pairs( recipeDrop ) do
                            if ( count >= UBI_MAX_RECIPE_INFO ) then break; end;
                            mob, rate = strsplit( ":", drop );
                            mob = tonumber( mob );
                            rate = tonumber( rate );
                            name, area = strsplit( "|", UBI_Creatures[mob] );
                            tooltip:AddDoubleLine( "  "..name.." ("..UBI_Droprates[rate]..")", UBI_Zones[tonumber( area )] );
                            SetSmallerFont();
                            count = count + 1;
                        end;
                    end;
                end;

                -- Only display item counts when show_item_count is turned on
                if ( UBI_Options["show_item_count"] ) then

                    -- Add counts (if UBI_TooltipItem is populated then we are showing a tooltip from the main inventory frame)
                    if ( UBI_TooltipItem ) then
                        -- Only add the info when we are not show data from the guildbank
                        if ( UBI_TooltipItem["bag_count"] and ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "current" or
                                                                UBI_LocationList[UBI_FILTER_LOCATIONS].type == "character" ) ) then
                            -- Add full item count information
                            AddLocationInfo( tooltip,
                                             UBI_TooltipItem["bag_count"],
                                             UBI_TooltipItem["bank_count"],
                                             UBI_TooltipItem["mailbox_count"],
                                             UBI_TooltipItem["equip_count"],
                                             UBI_TooltipItem["void_count"] );
                            totalCount = totalCount + UBI_TooltipItem["bag_count"] + UBI_TooltipItem["bank_count"] + UBI_TooltipItem["mailbox_count"] + UBI_TooltipItem["equip_count"] + ( UBI_TooltipItem["void_count"] or 0 );
                            spacerAdded = true;
                        end;
                    elseif ( UBI_Items[itemId] ) then
                        AddLocationInfo( tooltip,
                                         UBI_Items[itemId]["bag_count"],
                                         UBI_Items[itemId]["bank_count"],
                                         UBI_Items[itemId]["mailbox_count"],
                                         UBI_Items[itemId]["equip_count"],
                                         UBI_Items[itemId]["void_count"]
                                         );
                        totalCount = totalCount + UBI_Items[itemId]["bag_count"] + UBI_Items[itemId]["bank_count"] + UBI_Items[itemId]["mailbox_count"] + UBI_Items[itemId]["equip_count"] + ( UBI_Items[itemId]["void_count"] or 0 );
                        spacerAdded = true;
                    end;
    
                    -- Add info from current character if viewing data from an alt
                    if ( UBI_Items[itemId] and UBI_TooltipLocation and UBI_LocationList[UBI_FILTER_LOCATIONS].type ~= "current" ) then
                        -- Insert spacer if not already added
                        if ( not spacerAdded ) then
                            tooltip:AddLine( "|n" );
                            spacerAdded = true;
                        end;
    
                        -- Add the count and icon for the current alt
                        totalCount = totalCount + UBI_Items[itemId].total;
                        tooltip:AddDoubleLine( UBI_PLAYER, UBI_Items[itemId].total );
                        tooltip:AddTexture( UBI_LOCATION_TEXTURE[6] );
                    end;
    
                    -- Add information for alt characters
                    local UBI_Characters = UBI_Characters;
                    local record;
                    for key, value in pairs( UBI_Characters ) do
                        if ( UBI_Data[UBI_REALM][value]["Items"][itemId] ) then
                            if ( value ~= strtrim( UBI_LocationList[UBI_TooltipLocation or 1].name ) ) then
                                -- Insert spacer if not already added
                                if ( not spacerAdded ) then
                                    tooltip:AddLine( "|n" );
                                    spacerAdded = true;
                                end;
    
                                -- Fix total
                                record = UBI_Data[UBI_REALM][value]["Items"][itemId];
                                record.total = record.bag_count + record.bank_count + record.mailbox_count + record.equip_count + (record.void_count or 0);
                                totalCount = totalCount + record.total;
    
                                -- Add the count and icon for the current alt
                                tooltip:AddDoubleLine( value, record.total );
                                tooltip:AddTexture( UBI_LOCATION_TEXTURE[6] );
                            end;
                        end;
                    end;
    
                    -- Add information for guildbanks
                    local UBI_Guildbanks = UBI_Guildbanks;
                    for key, value in pairs( UBI_Guildbanks ) do
                        if ( UBI_Guildbank[value]["Items"][itemId] ) then
                            -- Insert spacer if not already added
                            if ( not spacerAdded ) then
                                tooltip:AddLine( "|n" );
                                spacerAdded = true;
                            end;
    
                            -- Add the count and icon for the current guildbank
                            totalCount = totalCount + UBI_Guildbank[value]["Items"][itemId].total;
                            tooltip:AddDoubleLine( C_GREY..value..C_CLOSE, C_GREY..UBI_Guildbank[value]["Items"][itemId].total..C_CLOSE );
                            tooltip:AddTexture( UBI_LOCATION_TEXTURE[6] );
                        end;
                    end;
    
                    -- Add total itemcount
                    if ( totalCount > 0 ) then
                        tooltip:AddDoubleLine( " ", C_YELLOW..UBI_SIGMA_ICON.." "..totalCount..C_CLOSE );
                    end;
                
                end;
            end;
        end;

        tooltip.maxlines = tooltip:NumLines();
    end;

-- HOOK - Set new OnTooltipSetItem and OnHide script for Tooltip objects
    function UberInventory_HookTooltip( tooltip )
        -- From global to local
        local UBI_Hooks = UBI_Hooks;

        -- Store default script
        local tooltipName = tooltip:GetName();
        UBI_Hooks["OnTooltipSetItem"][tooltipName] = tooltip:GetScript( "OnTooltipSetItem" );
        UBI_Hooks["OnTooltipCleared"][tooltipName] = tooltip:GetScript( "OnTooltipCleared" );

        -- Set new script to handle OntooltipSetItem
        tooltip:SetScript( "OnTooltipSetItem", function( self, ... )
            -- From global to local
            local UBI_Hooks = UBI_Hooks;

            -- Get tooltip name
            local tooltipName = self:GetName();

            -- Call default script
            if ( UBI_Hooks["OnTooltipSetItem"][tooltipName] ) then
                UBI_Hooks["OnTooltipSetItem"][tooltipName]( self, ... );
            end;

            -- Call new script (adds the item information)
            UberInventory_AddItemInfo( self );

            -- Turn on UberInventory indicator
            self.UBI_InfoAdded = true;
        end );

        -- Set new script to handle OnTooltipCleared
        tooltip:SetScript( "OnTooltipCleared", function( self, ... )
            -- From global to local
            local UBI_Hooks = UBI_Hooks;

            -- Get tooltip name
            local tooltipName = self:GetName();

            -- Force reset of fonts (maxlines is a custom attribute added within the UberInventory_AddItemInfo function)
            if ( self.maxlines ) then
                local txtLeft, txtRight;
                for i = 1, self.maxlines do
                    txtLeft = _G[self:GetName().."TextLeft"..i];
                    txtRight = _G[self:GetName().."TextRight"..i];
                    if ( txtLeft ) then txtLeft:SetFontObject( GameTooltipText ); end;
                    if ( txtRight ) then txtRight:SetFontObject( GameTooltipText ); end;
                end;
            end;

            -- Call default script
            if ( UBI_Hooks["OnTooltipCleared"][tooltipName] ) then
                UBI_Hooks["OnTooltipCleared"][tooltipName]( self, ... );
            end;

            -- Turn off UberInventory indicator
            self.UBI_InfoAdded = false;
        end );
     end;

-- Get item information and store it
    function UberInventory_Item( bagID, slotID, location )
        -- From global to local
        local UBI_Items = UBI_Items;

        -- Initialize
        local bankCount, bagCount, mailCount, equipCount, voidCount = 0, 0, 0, 0, 0;
        local itemLink = nil;
        local questItem, questID = nil, nil;
        local extra = {};

        -- Get itemLink
        if ( location == "mailbox" ) then
            itemLink = GetInboxItemLink( bagID, slotID );
            questItem, questID = GetContainerItemQuestInfo( bagID, slotID );
        elseif ( location == "equip" ) then
            itemLink = GetInventoryItemLink( "player", slotID );
        elseif ( location == "void" ) then
            local itemID = GetVoidItemInfo( slotID );
            if ( itemID ) then
                itemLink = UberInventory_GetLink( itemID );
            end;
        else
            itemLink = GetContainerItemLink( bagID, slotID );
            questItem, questID = GetContainerItemQuestInfo( bagID, slotID );
        end;

        -- Retrieve item information
        if ( itemLink ) then
            -- Initialize
            local itemCount, _ = 0;

            -- Fetch item information (itemLink skipped from GetItemInfo, does not always work at this stage (Quest related items))
            local itemName, _, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo( itemLink );
            local _, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit( ":", itemLink );

            if ( location == "mailbox" ) then
                _, _, itemCount = GetInboxItem( bagID, slotID );
            elseif ( location == "equip" ) then
                itemCount = 1;
            else
                _, itemCount = GetContainerItemInfo( bagID, slotID );
            end;

            -- Get existing item counts or activate sorting (new item is added)
            if ( UBI_Items[itemId] ) then
                bankCount = ( UBI_Items[itemId]["bank_count"] or 0 );
                bagCount = ( UBI_Items[itemId]["bag_count"] or 0 );
                mailCount = ( UBI_Items[itemId]["mailbox_count"] or 0 );
                equipCount = ( UBI_Items[itemId]["equip_count"] or 0 );
                voidCount = ( UBI_Items[itemId]["void_count"] or 0 );
            end;

            -- Sort out itemCount
            if ( location == "bank" ) then
                bankCount = bankCount + itemCount;
            elseif ( location == "bag" ) then
                bagCount = bagCount + itemCount;
            elseif ( location == "mailbox" ) then
                mailCount = mailCount + itemCount;
            elseif ( location == "equip" ) then
                equipCount = equipCount + itemCount;
            elseif ( location == "void" ) then
                voidCount = voidCount + ( itemCount or 1 );
            end;
            local totalCount = bagCount + bankCount + mailCount + equipCount + ( voidCount or 0 );

            -- Handle Battle Pets
            if ( strfind( itemLink, "battlepet:" ) and itemId ~= 82800 ) then
                local _, speciesID, level, breedQuality, maxHealth, power, speed, battlePetID = strsplit( ":", itemLink );
                local name, icon, petType, companionID, tooltipSource, tooltipDescription, isWild, canBattle, isTradeable, isUnique, obtainable = C_PetJournal.GetPetInfoBySpeciesID( speciesID );

                itemName = name;
                itemQuality = tonumber( breedQuality );
                itemType = UBI_BATTLEPET_CLASS;
                itemSubType = _G["BATTLE_PET_NAME_"..petType];
                itemLevel = level;
                extra = { maxHealth, power, speed };
            end;

            -- Store the item information
            UBI_Items[itemId] = { ["itemid"] = tonumber( itemId ),
                                  ["name"] = itemName,
                                  ["quality"] = itemQuality,
                                  ["level"] = itemLevel,
                                  ["bag_count"] = bagCount,
                                  ["bank_count"] = bankCount,
                                  ["mailbox_count"] = mailCount,
                                  ["equip_count"] = equipCount,
                                  ["void_count"] = voidCount,
                                  ["type"] = itemType,
                                  ["subtype"] = itemSubType,
                                  ["total"] = totalCount,
                                  ["qitem"] = questItem,
                                  ["qid"] = questID,
                                  ["extra"] = extra
                                  };
        end;
    end;

-- Handle Bag items
    function UberInventory_Save_Bag()
        if ( not UBI_ACTIVE ) then return; end;

        -- Initialize
        local slotCount, freeCount = 0, 0;

        -- Reset bag counts
        UberInventory_ResetCount( "bag" );

        -- Traverse bags
        for bagID = 0, 4 do
            if ( GetContainerNumSlots( bagID ) ) then
                slotCount = slotCount + GetContainerNumSlots( bagID );
                freeCount = freeCount + GetContainerNumFreeSlots( bagID );
                for slotID = 1, GetContainerNumSlots( bagID ) do
                    UberInventory_Item( bagID, slotID, "bag" );
                end;
            end;
        end;

        -- Save slot count
        UBI_Options["bag_max"] = slotCount;
        UBI_Options["bag_free"] = freeCount;
    end;

-- Handle Void Storage
    function UberInventory_Save_VoidStorage( event )
        if ( not UBI_ACTIVE ) then return; end;

        -- Reset void storage counts
        UberInventory_ResetCount( "void" );

        -- Traverse void storage slots
        for voidID = 1, 80 do
            UberInventory_Item( 0, voidID, "void" );
        end;

        -- Update inventory frame if visible
        if ( UberInventoryFrame:IsVisible() ) then
            UberInventory_DisplayItems();
        end;
    end;

-- Handle Bank items
    function UberInventory_Save_Bank()
        if ( not UBI_ACTIVE ) then return; end;

        -- Intialize
        local slotCount, freeCount = 0, 0;

        if ( UBI_BANK_OPEN ) then
            -- Reset bank counts
            UberInventory_ResetCount( "bank" );

            -- Traverse bank slots
            slotCount = GetContainerNumSlots( BANK_CONTAINER );
            for slotID = 1, GetContainerNumSlots( BANK_CONTAINER ) do
                if ( not GetContainerItemLink( BANK_CONTAINER, slotID ) ) then
                    freeCount = freeCount + 1;
                end;
                UberInventory_Item( BANK_CONTAINER, slotID, "bank" );
            end;

            -- Traverse bank bags
            for bagID = 5, 11 do
                if ( GetContainerNumSlots( bagID ) ) then
                    slotCount = slotCount + GetContainerNumSlots( bagID );
                    freeCount = freeCount + GetContainerNumFreeSlots( bagID );
                    for slotID = 1, GetContainerNumSlots( bagID ) do
                        UberInventory_Item( bagID, slotID, "bank" );
                    end;
                end;
            end;

            -- Traverse reagent bag
            if ( GetContainerNumSlots( REAGENTBANK_CONTAINER ) ) then
                 slotCount = slotCount + GetContainerNumSlots( REAGENTBANK_CONTAINER );
                 freeCount = freeCount + GetContainerNumFreeSlots( REAGENTBANK_CONTAINER );
                 for slotID = 1, GetContainerNumSlots( REAGENTBANK_CONTAINER ) do
                      UberInventory_Item( -3, slotID, "bank" );
                 end;
            end;

            -- Save slot count
            UBI_Options["bank_max"] = slotCount;
            UBI_Options["bank_free"] = freeCount;
        end;
    end;

-- Handle Mailbox items
    function UberInventory_Save_Mailbox()
        if ( not UBI_ACTIVE ) then return; end;

        -- Initialize
        local today = time( UberInventory_GetDateTime() );
        local UBI_Options = UBI_Options;
        local UBI_Money = UBI_Money;
        local mailSender, mailSubject, cashAttached, daysLeft, itemAttached, _;
        local mailText, mailTexture, mailTakeable, mailInvoice;
        local invoiceType, bid, buyout, deposit, consignment;

        if ( UBI_MAILBOX_OPEN ) then
            -- Reset mailbox cash
            UBI_Money["mail"] = 0;

            -- Reset expiration date
            if ( UBI_Options["mail_expires"] ) then wipe( UBI_Options["mail_expires"] ) else UBI_Options["mail_expires"] = {}; end;

            -- Reset mailbox counts
            UberInventory_ResetCount( "mailbox" );

            -- Get number of mails in inbox
            local numItems = GetInboxNumItems();

            -- Traverse mailbox (Reverse order)
            for mailID = numItems, 1, -1 do
                -- Mail info
                _, _, mailSender, mailSubject, cashAttached, _, daysLeft, itemAttached = GetInboxHeaderInfo( mailID );
                daysLeft = today + ( floor( daysLeft ) * UBI_SEC_IN_DAY );

                -- Register all mails stored in mailbox stored by expiration date (exclude sales pending mails)
                if ( itemAttached or cashAttached > 0 ) then
                    UBI_Options["mail_expires"][daysLeft] = ( UBI_Options["mail_expires"][daysLeft] or 0 ) + 1;
                end;

                -- Handle attachment
                if ( itemAttached ) then
                    for attachID = 1, ATTACHMENTS_MAX_RECEIVE do
                        UberInventory_Item( mailID, attachID, "mailbox" );
                    end;
                end;

                -- Handle money
                if ( cashAttached > 0 ) then
                    if ( UBI_Options["take_money"] ) then
                        -- Add task to take inbox money (if not items are attached this also deletes the mail)
                        TaskHandlerLib:AddTask( "UberInventory", UBI_Task_CollectCash, mailID );
                    end;

                    -- Record the mailbox cash
                    UBI_Money["mail"] = UBI_Money["mail"] + cashAttached;
                end;

                -- Update wallet/mail info (if mainframe is shown)
                UberInventory_WalletMailCashInfo();
            end;

            -- Reregister MAIL_INBOX_UPDATE event
            UBI:RegisterEvent( "MAIL_INBOX_UPDATE" );
        end;
    end;

-- Handle Equiped items
    function UberInventory_Save_Equipped()
        if ( not UBI_ACTIVE ) then return; end;

        -- Initialize
        local slotID, _;

        -- Reset Equiped counts
        UberInventory_ResetCount( "equip" );

        -- Traverse equip slots
        for key, value in pairs( UBI_EQUIP_SLOTS ) do
            slotID, _ = GetInventorySlotInfo( value );
            UberInventory_Item( nil, slotID, "equip" );
        end;
    end;

-- Handle Guildbank items
    function UberInventory_Save_Guildbank( event )
        if ( not UBI_ACTIVE ) then return; end;

        -- Exit if tracking is turned off
        if ( not UBI_Options["track_gb_data"] ) then return; end;

        -- Exit if already saving gb data
        if ( UBI_PROCESSING_GB ) then return; end;

        -- From global to local
        local UBI_Guildbank = UBI_Guildbank;

        -- Initialize
        local itemCount = 0;
        local name, icon, isViewable, canDeposit, numWithdrawals, remainingWithdrawals, count, itemLink, _;
        local itemName, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture;
        local itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId;

        if ( UBI_GUILDBANK_OPENED ) then
            -- indicate we are already saving gb data
            UBI_PROCESSING_GB = true;

            -- Start out to assume we have view access to all guildbank tabs
            UBI_GUILDBANK_VIEWACCESS = true;

            -- Clear the existing data
            wipe( UBI_Guildbank[UBI_GUILD]["Items"] );

            -- Traverse guild bank tabs/slots to store into UberInventory
            for gbTab = 1, GetNumGuildBankTabs() do
                -- Can we view the content of all guildbank tabs?
                --   isViewable = true;
                local name, icon, isViewable = GetGuildBankTabInfo( gbTab );
                if ( not isViewable ) then
                    UBI_GUILDBANK_VIEWACCESS = false;
                end;

                -- Only collect when tab is viewable (to prevent messages in chat)
                if ( isViewable ) then

                    for gbSlot = 1, (MAX_GUILDBANK_SLOTS_PER_TAB or 98) do
                        -- Reset
                        itemCount = 0;

                        -- Get slot information
                        _, count, _ = GetGuildBankItemInfo( gbTab, gbSlot );
                        itemLink = GetGuildBankItemLink( gbTab, gbSlot );

                        if ( itemLink ) then
                            -- Fetch item information
                            itemName, _, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo( itemLink );
                            _, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit( ":", itemLink );

                            -- Get existing item count
                            if ( UBI_Guildbank[UBI_GUILD]["Items"][itemId] ) then
                                itemCount = UBI_Guildbank[UBI_GUILD]["Items"][itemId]["count"];
                            end;

                            -- Handle Battle Pets
                            if ( strfind( itemLink, "battlepet:" ) ) then
                                local _, speciesID, level, breedQuality, maxHealth, power, speed, battlePetID = strsplit( ":", itemLink );
                                local name, icon, petType, companionID, tooltipSource, tooltipDescription, isWild, canBattle, isTradeable, isUnique, obtainable = C_PetJournal.GetPetInfoBySpeciesID( speciesID );

                                itemName = name;
                                itemQuality = tonumber( breedQuality );
                                itemType = UBI_BATTLEPET_CLASS;
                                itemSubType = _G["BATTLE_PET_NAME_"..petType];
                                itemLevel = level;
                                extra = { maxHealth, power, speed };
                            end;

                            -- Store the item information
                            UBI_Guildbank[UBI_GUILD]["Items"][itemId] = { ["itemid"] = tonumber( itemId ),
                                                                          ["name"] = itemName,
                                                                          ["quality"] = itemQuality,
                                                                          ["level"] = itemLevel,
                                                                          ["count"] = itemCount + count,
                                                                          ["type"] = itemType,
                                                                          ["subtype"] = itemSubType,
                                                                          ["extra"] = extra,
                                                                          ["total"] = itemCount + count };
                        end;
                    end;
                end;

            end;

            -- Done saving gb data
            UBI_PROCESSING_GB = false;
        end;

        -- Store guildbank cash
        UBI_Guildbank[UBI_GUILD]["Cash"] = GetGuildBankMoney();

        -- Rebuild list of guildbanks
        UberInventory_GetGuildbanks();

        -- Update inventory frame if visible
        if ( UberInventoryFrame:IsVisible() ) then
            UberInventory_DisplayItems();
        end;
    end;

-- Handle Guildbank items
    function UberInventory_Receive_Guildbank()
        -- From global to local
        local UBI_Guildbank = UBI_Guildbank;
        local UBI_GBData = UBI_GBData;

        -- Exit if tracking is turned off
        if ( not UBI_Options["track_gb_data"] ) then return; end;

        -- Init guildbank structures (if needed)
        UberInventory_Guildbank_Init()

        -- Show receiving data
        UberInventory_Message( UBI_NEW_GBDATA:format( UBI_GBSender ), true );

        -- Clear the existing data
        wipe( UBI_Guildbank[UBI_GUILD]["Items"] );

        -- Traverse all guildbank tabs and slots
        local itemLink, itemName, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, _;
        for key, value in pairs( UBI_GBData ) do
            -- Fetch item information
            itemLink = UberInventory_GetLink( value.itemid );
            itemName, _, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo( itemLink );

            -- Store the item information
            UBI_Guildbank[UBI_GUILD]["Items"][value.itemid] = { ["itemid"] = tonumber( value.itemid ),
                                                                ["name"] = value.name or itemName or UBI_ITEM_UNCACHED,
                                                                ["quality"] = value.quality or itemQuality,
                                                                ["level"] = value.level or itemLevel or 0,
                                                                ["count"] = value.count,
                                                                ["type"] = value.type or itemType or UBI_ITEM_UNCACHED,
                                                                ["subtype"] = value.subtype or itemSubType or UBI_ITEM_UNCACHED,
                                                                ["total"] = value.count };

            if ( value.extra ) then 
            end;
        end;

        -- Update inventory frame if visible
        if ( UberInventoryFrame:IsVisible() ) then
            -- Update items
            UberInventory_DisplayItems();

            -- Update slot count information
            UberInventory_Update_SlotCount();
        end;

        -- Track Guildbank last visit date/time
        UBI_Options["guildbank_visit"] = UberInventory_GetDateTime();

        -- Clear sender
        UBI_GBSender = nil;
    end;

-- Send Guildbank data to other guild members
    function UberInventory_Send_Guildbank()
        -- From global to local
        local UBI_Guildbank = UBI_Guildbank;
        local sendData;

        -- Get number of online guild members
        local numTotal, numOnline = GetNumGuildMembers();

        -- Exit if tracking is turned off
        if ( not UBI_Options["track_gb_data"] ) then return; end;

        -- Only send data when we have view access to all guildbank tabs
        if ( UBI_GUILDBANK_VIEWACCESS and numOnline > 1 ) then
            -- Show message
            UberInventory_Message( UBI_GB_SENDING, true );

            -- Send start message
            TaskHandlerLib:AddTask( "UberInventory", UBI_Task_SendMessage, "GBSTART", UBI_VERSION );

            -- Send the actual guildbank data
            for key, record in pairs( UBI_Guildbank[UBI_GUILD]["Items"] ) do
                -- Create data string
                sendData = key.." "..
                           record["count"].." "..
                           strgsub( record["name"], " ", "_" ).." "..
                           strgsub( record["type"], " ", "_" ).." "..
                           strgsub( record["subtype"], " ", "_" ).." "..
                           record["level"].." "..
                           record["quality"];

                -- Send data string
                TaskHandlerLib:AddTask( "UberInventory", UBI_Task_SendMessage, "GBITEM", sendData );
            end;

            -- Send cash
            TaskHandlerLib:AddTask( "UberInventory", UBI_Task_SendMessage, "GBCASH", UBI_Guildbank[UBI_GUILD]["Cash"] );

            -- Send done message
            TaskHandlerLib:AddTask( "UberInventory", UBI_Task_SendMessage, "GBEND" );
        end;
    end;

-- Check for expiring mails (only when the option warn_mailexpire is on)
    function UberInventory_MailExpirationCheck()
        -- From global to local
        local UBI_Data = UBI_Data;
        local realm, daysLeft;

        if ( UBI_Options["warn_mailexpire"] ) then
            -- Check mail expiration for all characters from the current realm
            for key, record in pairs( UBI_Data ) do
                realm = key;

                for player, value in pairs( UBI_Data[realm] ) do
                    if ( player ~= "Guildbank" and value["Options"]["mail_expires"] ) then
                        for key, record in pairs( value["Options"]["mail_expires"] ) do
                            -- Get number of days till expiration (negative number are good)
                            daysLeft = UberInventory_DaysSince( key );

                            -- If daysleft less then zero, mail expires into the future, positive numbers means the mail are already expired
                            if ( daysLeft < 0 ) then
                                daysLeft = abs( daysLeft );
                                if ( daysLeft <= UBI_MAIL_EXPIRE_WARNING ) then
                                    UberInventory_Message( UBI_MAIL_EXPIRES:format( player, realm, record, daysLeft ), true );
                                end;
                            else
                                UberInventory_Message( UBI_MAIL_LOST:format( player, realm, record, daysLeft ), true );
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

-- Cleanup inventory
    function UberInventory_Cleanup()
        -- From global to local
        local UBI_Items = UBI_Items;

        -- Remove items for which bag_count, bank_count, mailbox_count and equip_count equals 0
        for key, record in pairs( UBI_Items ) do
            if ( record.name ) then
                if ( record.bag_count + record.bank_count + record.mailbox_count + record.equip_count + ( record.void_count or 0 )== 0 ) then
                    -- Remove the item
                    UBI_Items[key] = nil;
                end;
            else
                -- Remove the item if name is not found
                UBI_Items[key] = nil;
            end;
        end;
    end;

-- Update inventory
    function UberInventory_UpdateInventory( location )
        -- Update the inventory
        if ( location == "bank" or location == "all" ) then
            UberInventory_Save_Bank();
        end;
        if ( location == "bag" or location == "all" ) then
            UberInventory_Save_Bag();
        end;
        if ( location == "mail" or location == "all" ) then
            UberInventory_Save_Mailbox();
        end;
        if ( location == "equip" or location == "all" ) then
            UberInventory_Save_Equipped();
        end;

        -- Store last update info
        UBI_SCAN_DATE = time();

        -- Cleanup the inventory (remove zero-count items)
        UberInventory_Cleanup();

        -- Get cash information
        UberInventory_SaveMoney();

        -- Update wallet/mail info (if mainframe is shown)
        UberInventory_WalletMailCashInfo();

        -- Update inventory frame if visible
        if ( UberInventoryFrame:IsVisible() ) then
            -- Update items
            UberInventory_DisplayItems();

            -- Update token info on screen
            if ( UberInventoryTokens:IsVisible() ) then
                UberInventory_DisplayTokens();
            end;

            -- Update slot count information
            UberInventory_Update_SlotCount();
        end;
    end;

-- Handle UBI initialization
    function UberInventory_Init()
        -- Initiliaze all parts of the saved variable
        if ( UBI_Data == nil ) then
            UBI_Data = {};
        end;

        if ( UBI_Data[UBI_REALM] == nil ) then
            UBI_Data[UBI_REALM] = {};
        end;

        if ( UBI_Data[UBI_REALM][UBI_PLAYER] == nil ) then
            UBI_Data[UBI_REALM][UBI_PLAYER] = {};
        end;

        if ( UBI_Data[UBI_REALM][UBI_PLAYER]["Options"] == nil ) then
            UBI_Data[UBI_REALM][UBI_PLAYER]["Options"] = { ["version"] = UBI_VERSION,
                                                           ["show_money"] = UBI_Defaults["show_money"],
                                                           ["show_balance"] = UBI_Defaults["show_balance"],
                                                           ["show_tooltip"] = UBI_Defaults["show_tooltip"],
                                                           ["show_item_count"] = UBI_Defaults["show_item_count"],
                                                           ["show_sell_prices"] = UBI_Defaults["show_sell_prices"],
                                                           ["show_recipe_prices"] = UBI_Defaults["show_recipe_prices"],
                                                           ["show_recipe_reward"] = UBI_Defaults["show_recipe_reward"],
                                                           ["show_recipe_drop"] = UBI_Defaults["show_recipe_drop"],
                                                           ["show_minimap"] = UBI_Defaults["show_minimap"],
                                                           ["show_highlight"] = UBI_Defaults["show_highlight"],
                                                           ["track_gb_data"] = UBI_Defaults["track_gb_data"],
                                                           ["send_gb_data"] = UBI_Defaults["send_gb_data"],
                                                           ["receive_gb_data"] = UBI_Defaults["receive_gb_data"],
                                                           ["warn_mailexpire"] = UBI_Defaults["warn_mailexpire"],
                                                           ["pricing_data"] = "vendor",
                                                           ["bag_max"] = 0,
                                                           ["bag_free"] = 0,
                                                           ["bank_max"] = 0,
                                                           ["bank_free"] = 0,
                                                           ["minimap"] = UBI_Defaults["minimap"],
                                                           ["alpha"] = UBI_Defaults["alpha"],
                                                           ["take_money"] = UBI_Defaults["take_money"],
                                                           ["faction"] = UBI_FACTION,
                                                           ["mail_expires"] = {},
                                                           ["level"] = UnitLevel( "player" ),
                                                           ["class"] = select( 2, UnitClass( "player" ) ),
                                                         };
        end;

        if ( UBI_Data[UBI_REALM][UBI_PLAYER]["Items"] == nil ) then
            UBI_Data[UBI_REALM][UBI_PLAYER]["Items"] = {};
        end;

        if ( UBI_Data[UBI_REALM][UBI_PLAYER]["Money"] == nil ) then
            UBI_Data[UBI_REALM][UBI_PLAYER]["Money"] = { ["mail"] = 0,
                                                         ["Cash"] = 0,
                                                         ["Currencies"] = {} };
        end;

        if ( UBI_Data[UBI_REALM]["Guildbank"] == nil ) then
            UBI_Data[UBI_REALM]["Guildbank"] = {};
        end;

        -- Create global variables for easy reference
        UBI_Money = UBI_Data[UBI_REALM][UBI_PLAYER]["Money"];
        UBI_Items = UBI_Data[UBI_REALM][UBI_PLAYER]["Items"];
        UBI_Options = UBI_Data[UBI_REALM][UBI_PLAYER]["Options"];
        UBI_Guildbank = UBI_Data[UBI_REALM]["Guildbank"];

        -- Upgrade data structures
        UberInventory_Upgrade();

        -- Set faction again, to allow for faction change
        UBI_Options["faction"] = UBI_FACTION;
        
        -- Build list of alts and guildbanks
        UberInventory_GetAlts();
        UberInventory_GetGuildbanks();

        -- Build the inventory
        UberInventory_UpdateInventory( "all" );

        -- Build list for locations
        UberInventory_Build_Locations();

        -- Initialize Options dialog
        UberInventory_AddCategory( UberInventoryOptionsFrame );

        -- Force refersh of stored currencies
        UberInventory_Save_Currencies();

        UBI:RegisterEvent( "BAG_UPDATE" );
    end;

-- Initialize guildbank data structure
    function UberInventory_Guildbank_Init()
        if ( IsInGuild() and UBI_Options["track_gb_data"] ) then
            if ( UBI_GUILD and not UBI_Guildbank[UBI_GUILD] ) then
                UBI_Guildbank[UBI_GUILD] = {};
                UBI_Guildbank[UBI_GUILD]["Items"] = {};
                UBI_Guildbank[UBI_GUILD]["Cash"] = 0;
                UBI_Guildbank[UBI_GUILD]["Faction"] = UBI_FACTION;
            end;
        end;
    end;

-- Register events
    function UberInventory_RegisterEvents()
        for key, value in pairs( UBI_TRACKED_EVENTS ) do
            UBI:RegisterEvent( value );
        end;
    end;

-- Register events
    function UberInventory_UnregisterEvents()
        for key, value in pairs( UBI_TRACKED_EVENTS ) do
            UBI:UnregisterEvent( value );
        end;
    end;

-- Handle startup of the addon
    function UberInventory_OnLoad()
        -- Install hooks
        UberInventory_Install_Hooks();

        -- Show startup message
        UberInventory_Message( UBI_STARTUP_MESSAGE, false );

        -- Register slash commands
        SlashCmdList["UBI"] = UberInventory_SlashHandler;
        SLASH_UBI1 = "/ubi";
        SLASH_UBI2 = "/uberinventory";

        -- Register events to be monitored
        UberInventory_RegisterEvents();

        -- Correct quality list
        tinsert( UBI_QUALITY, 1, UBI_ALL_QUALITIES );
    end;

-- Install all of the hooks used by UberInventory
    function UberInventory_Install_Hooks()
        -- Hook the Tooltips (OnTooltipSetItem, OnTooltipCleared)
        UberInventory_HookTooltip( GameTooltip );
        UberInventory_HookTooltip( ItemRefTooltip );
        UberInventory_HookTooltip( ShoppingTooltip1 );
        UberInventory_HookTooltip( ShoppingTooltip2 );

        -- Hook mail stuff
        UBI_Hooks["ReturnInboxItem"] = ReturnInboxItem;
        ReturnInboxItem = UberInventory_ReturnInboxItem;
        UBI_Hooks["SendMail"] = SendMail;
        SendMail = UberInventory_SendMail;
    end;

-- Track mails returned to (current account) characters
    function UberInventory_ReturnInboxItem( mailID )
        local _, _, mailSender, mailSubject, cashAttached, _, daysLeft, itemAttached = GetInboxHeaderInfo( mailID );

        wipe( UBI_Mail_Transfer );
        UBI_Mail_Transfer.to = mailSender;
        UBI_Mail_Transfer.cash = cashAttached;
        UBI_Mail_Transfer.items = {};

        for attachID = 1, ATTACHMENTS_MAX_RECEIVE do
            local itemName, itemTexture, itemCount = GetInboxItem( mailID, attachID );
            if ( itemName ) then
                local _, itemId = strsplit( ":", GetInboxItemLink( mailID, attachID ) );
                UBI_Mail_Transfer.items[itemId] = ( UBI_Mail_Transfer.items[itemId] or 0 ) + itemCount;
            end;
        end;

        if ( UBI_Hooks["ReturnInboxItem"] ) then
            UBI_Hooks["ReturnInboxItem"]( mailID );
        end;
    end;

-- Track mails sent to (current account) characters
    function UberInventory_SendMail( to, subject, body )
        wipe( UBI_Mail_Transfer );
        UBI_Mail_Transfer.to = to;
        UBI_Mail_Transfer.cash = GetSendMailMoney();
        UBI_Mail_Transfer.items = {};
        
        for i = 1, ATTACHMENTS_MAX_SEND do
            local itemName, itemTexture, itemCount = GetSendMailItem( i );
            if ( itemName ) then
                local _, itemId = strsplit( ":", GetSendMailItemLink( i ) );
                UBI_Mail_Transfer.items[itemId] = ( UBI_Mail_Transfer.items[itemId] or 0 ) + itemCount;
            end;
        end;

        if ( UBI_Hooks["SendMail"] ) then
            UBI_Hooks["SendMail"]( to, subject, body );
        end;
    end;

-- Transfer gold/items between characters
    function UberInventory_Transfer()
        if ( UBI_Mail_Transfer.to ) then
            if ( UBI_Data[UBI_REALM][UBI_Mail_Transfer.to] ) then
                -- Determine expiration date/time of transfered cash/items
                local daysLeft = time( UberInventory_GetDateTime() ) + ( 30 * UBI_SEC_IN_DAY );

                -- Transfer cash
                UBI_Data[UBI_REALM][UBI_Mail_Transfer.to]["Money"]["mail"] = ( UBI_Data[UBI_REALM][UBI_Mail_Transfer.to]["Money"]["mail"] or 0 ) + UBI_Mail_Transfer.cash;

                -- Transfer items
                local itemName, itemLink, itemQuality, itemLevel, itemClass, itemSubclass, tempItem, _;
                local itemCount = 0;
                for key, value in pairs( UBI_Mail_Transfer.items ) do
                    itemName, itemLink, itemQuality, itemLevel, _, itemClass, itemSubclass = GetItemInfo( key );
                    tempItem = UBI_Data[UBI_REALM][UBI_Mail_Transfer.to]["Items"][key];
                    if ( tempItem ) then
                        UBI_Data[UBI_REALM][UBI_Mail_Transfer.to]["Items"][key] = { ["itemid"] = tonumber( key ),
                                                                                    ["name"] = itemName,
                                                                                    ["quality"] = itemQuality,
                                                                                    ["level"] = itemLevel,
                                                                                    ["bag_count"] = tempItem["bag_count"],
                                                                                    ["bank_count"] = tempItem["bank_count"],
                                                                                    ["mailbox_count"] = tempItem["mailbox_count"] + value,
                                                                                    ["equip_count"] = tempItem["equip_count"],
                                                                                    ["void_count"] = ( tempItem["void_count"] or 0 ),
                                                                                    ["type"] = itemClass,
                                                                                    ["subtype"] = itemSubclass,
                                                                                    ["total"] = tempItem["total"] + value,
                                                                                    ["qitem"] = tempItem["qitem"],
                                                                                    ["qid"] = tempItem["qitem"],
                                                                                    };
                    else
                        UBI_Data[UBI_REALM][UBI_Mail_Transfer.to]["Items"][key] = { ["itemid"] = tonumber( key ),
                                                                                    ["name"] = itemName,
                                                                                    ["quality"] = itemQuality,
                                                                                    ["level"] = itemLevel,
                                                                                    ["bag_count"] = 0,
                                                                                    ["bank_count"] = 0,
                                                                                    ["mailbox_count"] = value,
                                                                                    ["equip_count"] = 0,
                                                                                    ["void_count"] = 0,
                                                                                    ["type"] = itemClass,
                                                                                    ["subtype"] = itemSubclass,
                                                                                    ["total"] = value,
                                                                                    };
                    end;
                    itemCount = itemCount + 1;
                end;

                -- Register new expiration
                if ( UBI_Mail_Transfer.cash > 0 or itemCount > 0 ) then
                    UBI_Data[UBI_REALM][UBI_Mail_Transfer.to]["Options"]["mail_expires"][daysLeft] = ( UBI_Data[UBI_REALM][UBI_Mail_Transfer.to]["Options"]["mail_expires"][daysLeft] or 0 ) + 1;
                end;
            end;
        end;

        -- Force refresh if main window is open
        if ( UberInventoryFrame:IsVisible() ) then
            UberInventory_DisplayItems();
        end;

        -- Clear temporary data
        wipe( UBI_Mail_Transfer );
    end;

-- Handle events sent to the addon
    function UberInventory_OnEvent( self, event, ... )
        -- Get additional arguments
        local arg1, arg2, arg3, arg4 = ...;


        -- Load data from previous session
        if ( event == "ADDON_LOADED" and arg1 == "UberInventory" ) then
            -- Execute main initialization code
            UberInventory_Init();

            -- Track current player level and class
            UBI_Options["level"] = UnitLevel( "player" );
            UBI_Options["class"] = select( 2, UnitClass( "player" ) );

            -- Check bank visit
            if ( UberInventory_DaysSince( UBI_Options["bank_visit"] ) >= UBI_BANK_VISIT_INTERVAL ) then
                UberInventory_Message( UBI_LAST_BANK_VISIT:format( UberInventory_DaysSince( UBI_Options["bank_visit"] ) ), true );
            else
                if ( not UBI_Options["bank_visit"] ) then UberInventory_Message( UBI_VISIT_BANK, true ); end;
            end;

            -- Check guildbank visit
            if ( IsInGuild() ) then
                if ( UberInventory_DaysSince( UBI_Options["guildbank_visit"] ) >= UBI_GUILDBANK_VISIT_INTERVAL ) then
                    UberInventory_Message( UBI_LAST_GUILDBANK_VISIT:format( UberInventory_DaysSince( UBI_Options["guildbank_visit"] ) ), true );
                else
                    if ( not UBI_Options["guildbank_visit"] ) then UberInventory_Message( UBI_VISIT_GUILDBANK, true ); end;
                end;
            end;

            -- Check mailbox visit
            if ( UberInventory_DaysSince( UBI_Options["mail_visit"] ) >= UBI_MAILBOX_VISIT_INTERVAL ) then
                UberInventory_Message( UBI_LAST_MAILBOX_VISIT:format( UberInventory_DaysSince( UBI_Options["mail_visit"] ) ), true );
            else
                if ( not UBI_Options["mail_visit"] ) then UberInventory_Message( UBI_VISIT_MAILBOX, true ); end;
            end;

            -- Check for mail that are about to expire
            UberInventory_MailExpirationCheck();

            -- Show or hide the minimap icon
            UberInventory_Minimap_Toggle();

            -- Assign proper location for minimap
            UberInventory_Minimap_Update( UBI_Options["minimap"] );

            -- Set transparency
            UberInventory_Change_Alpha( UBI_Options["alpha"] );

            -- Broadcast current version to the guild
            UBI_Task_SendMessage( "VERINFO", UBI_VERSION );

            return;
        end;

        -- Track the new level of the player
        if ( event == "PLAYER_LEVEL_UP" ) then
            -- Track current player level and rebuild the list
            UBI_Options["level"] = arg1;
            UberInventory_Build_Locations();
        end;

        if ( event == "PLAYER_LEAVING_WORLD" ) then
            UBI_ACTIVE = false;
        end;

        -- Update info inventory change (enters the world, enters/leaves an instance, or respawns at a graveyard, reloadui)
        if ( event == "PLAYER_ENTERING_WORLD" ) then
            UBI_ACTIVE = true;

            -- Register AddOn Message prefix (4.1)
            RegisterAddonMessagePrefix( "UBI" );

            -- Update balance frame
            UberInventory_ShowBalanceFrame( UBI_Options["show_balance"] );

            -- Get guild name
            UBI_GUILD = GetGuildInfo( "player" );
            UberInventory_Guildbank_Init();

            UberInventory_UpdateInventory( "all" );
            return;
        end;

        if ( event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" ) then
            UberInventory_UpdateInventory( "equip" );
            return;
        end;

        -- After a money event show the current cash amount
        if ( event == "PLAYER_MONEY" ) then
            -- Save current cash balance
            UberInventory_SaveMoney();

            -- Update wallet/mail info (if mainframe is shown)
            UberInventory_WalletMailCashInfo();

            -- Show message
            if ( UBI_Options["show_money"] ) then
                UberInventory_Message( UBI_MONEY_MESSAGE:format( GetCoinTextureString( GetMoney() ) ), true );
            end;
            return;
        end;

        -- On currency changes update stored data and refresh UI
        if ( event == "CURRENCY_DISPLAY_UPDATE" ) then
            -- Save other currencies
            if ( UBI_Money ) then
                UberInventory_Save_Currencies();
            end;

            -- Update token info on screen
            if ( UberInventoryTokens:IsVisible() ) then
                UberInventory_DisplayTokens();
            end;

            return;
        end;

        -- Bank closed
        if ( event == "BANKFRAME_CLOSED" ) then
            UBI_BANK_OPEN = false;
            return;
        end;

        -- Bank opened
        if ( event == "BANKFRAME_OPENED" ) then
            UBI_BANK_OPEN = true;
            UBI_Options["bank_visit"] = UberInventory_GetDateTime();
            UberInventory_UpdateInventory( "bank" );
            return;
        end;

        -- Items in the bank have changed
        if ( event == "PLAYERBANKSLOTS_CHANGED" or event == "PLAYERBANKBAGSLOTS_CHANGED" ) then
            UberInventory_UpdateInventory( "bank" );
            return;
        end;

        -- Guildbank closed (send guildbank data using the chat system)
        if ( event == "GUILDBANKFRAME_CLOSED" and UBI_GUILDBANK_OPENED and UBI_Options["track_gb_data"] ) then
            -- Store guildbank cash            
            UBI_Guildbank[UBI_GUILD]["Cash"] = GetGuildBankMoney();

            -- Start sending guildbank data
            if ( UBI_Options["send_gb_data"] ) then
                UberInventory_Send_Guildbank();
            end;
            UBI:UnregisterEvent( "GUILDBANKBAGSLOTS_CHANGED" );
            UBI:UnregisterEvent( "GUILDBANK_UPDATE_TABS" );

            UBI_GUILDBANK_OPENED = false;
            return;
        end;

        -- Guild cash changed
        if ( event == "GUILDBANK_UPDATE_MONEY" and IsInGuild() and UBI_Options["track_gb_data"] ) then
            if ( UBI_Guildbank and UBI_Guildbank[UBI_GUILD] and UBI_Guildbank[UBI_GUILD]["Cash"] ) then
                UBI_Guildbank[UBI_GUILD]["Cash"] = GetGuildBankMoney();
            end;

            -- Update cash info on screen
            if ( UberInventoryFrame:IsVisible() ) then
                UberInventory_DisplayItems();
            end;
            return;
        end;

        -- Guildbank opened
        if ( event == "GUILDBANKFRAME_OPENED" and UBI_Options["track_gb_data"] ) then
            -- Track Guildbank open
            UBI_GUILDBANK_OPENED = true;

            UBI:RegisterEvent( "GUILDBANKBAGSLOTS_CHANGED" );
            UBI:RegisterEvent( "GUILDBANK_UPDATE_TABS" );

            -- Traverse guild bank tabs and force loading of data
            for gbTab = 1, GetNumGuildBankTabs() do
                -- Retrieve data from the server (only for visible tabs to prevent warnings)
                local name, icon, isViewable = GetGuildBankTabInfo( gbTab );
                if ( isViewable ) then
                    TaskHandlerLib:AddTask( "UberInventory", QueryGuildBankTab, gbTab );
                end;
            end;

            -- Track Guildbank last visit date/time
            UBI_Options["guildbank_visit"] = UberInventory_GetDateTime();

            return;
        end;

        -- Update Guildbank information
        if ( ( event == "GUILDBANK_UPDATE_TABS" or event == "GUILDBANKBAGSLOTS_CHANGED" or event == "PLAYERREAGENTBANKSLOTS_CHANGED" ) and UBI_GUILDBANK_OPENED and UBI_Options["track_gb_data"] ) then
            -- Send start message
            UberInventory_Save_Guildbank( event );
            return;
        end;

        -- Mailbox opened
        if ( event == "MAIL_SHOW" ) then
            UBI_MAILBOX_OPEN = true;
            UBI:RegisterEvent( "MAIL_CLOSED" );
            UBI:RegisterEvent( "MAIL_INBOX_UPDATE" );
            return;
        end;

        -- Mailbox changes
        if ( event == "MAIL_INBOX_UPDATE" ) then
            UBI:UnregisterEvent( "MAIL_INBOX_UPDATE" ); -- Prevent additional MAIL_INBOX_UPDATE event to be handled
            UberInventory_UpdateInventory( "mail" );
            return;
        end;

        -- Mailbox closed
        if ( event == "MAIL_CLOSED" ) then
            UBI:UnregisterEvent( "MAIL_CLOSED" ); -- Prevent second MAIL_CLOSED event to be handled
            UBI:RegisterEvent( "MAIL_INBOX_UPDATE" );  -- Re-register MAIL_INBOX_UPDATE event
            UBI_Options["mail_visit"] = UberInventory_GetDateTime();
            UberInventory_UpdateInventory( "mail" );
            UBI_MAILBOX_OPEN = false;
            return;
        end;

        -- Record transferred gold/items
        if ( event == "MAIL_SUCCESS" ) then
            UberInventory_Transfer();
            return;
        end;

        -- Items in the bags have changed
        if ( event == "BAG_UPDATE" and arg1 >= -2 ) then
            -- Update inventory
            UberInventory_UpdateInventory( "bag" );

            -- If bank is open rescan item
            -- if ( arg1 == BANK_CONTAINER or ( arg1 >= 5 and arg1 <= 11 ) ) then UberInventory_Save_Bank(); end;
            if ( ( arg1 == BANK_CONTAINER) or ( arg1 == REAGENTBANK_CONTAINER ) or ( arg1 >= 5 and arg1 <= 11 ) ) then UberInventory_Save_Bank(); end;
            
            -- If guildbank is open rescan it
            if ( UBI_GUILDBANK_OPENED ) then UberInventory_Save_Guildbank( 'UBI_RESCAN_GUILDBANK' ); end;
            return;
        end;

        -- Void Storage events
        if ( event == "VOID_STORAGE_OPEN" or event == "VOID_STORAGE_CLOSE" or event == "VOID_STORAGE_UPDATE" or event == "VOID_STORAGE_CONTENTS_UPDATE" ) then
            UberInventory_Save_VoidStorage( event );
        end;

        -- Handle UberInventory related guildchat messages
        if ( event == "CHAT_MSG_ADDON" and arg1 == "UBI" and arg4 ~= UBI_PLAYER and ( UBI_Options["receive_gb_data"] or UBI_GUILDBANK_FORCED ) ) then
            if ( arg2:find( "UBI:VERINFO" ) ) then
                -- Extract version number from the data string
                local _, gbVersion = strsplit( " ", arg2 );

                -- Check if there is a more recent version of UberInventory
                if ( tonumber( gbVersion ) > ( tonumber( UBI_VERSION ) or 0 ) and not UBI_VERSION_WARNING ) then
                    UberInventory_Message( UBI_NEW_VERSION:format( arg4, gbVersion ), true );
                    UBI_VERSION_WARNING = true;
                end;

                -- If this version is more recent send message to other users using this addon
                if ( tonumber( gbVersion ) < ( tonumber( UBI_VERSION ) or 0 ) ) then
                    UBI_Task_SendMessage( "VERINFO", UBI_VERSION );
                end;
            elseif ( arg2:find( "UBI:GBSTART" ) and not UBI_GUILDBANK_OPENED ) then
                -- Start receiving Guildbank data, reset on each new receive from player.
                -- This way only the most recent data should be received.
                -- Only data from equal versions is allowed
                wipe( UBI_GBData );
                UBI_GBSender = arg4;
            elseif ( arg2:find( "UBI:GBITEM" ) and not UBI_GUILDBANK_OPENED ) then
                -- Receiving Guildbank data (item), only receive data from latest sender
                if ( UBI_GBSender == arg4 and UBI_Options["track_gb_data"] ) then
                    local _, itemID, itemCount, itemName, itemType, itemSubtype, itemLevel, itemQuality, extra = strsplit( " ", arg2 );
                    UBI_GBData[itemID] = { ["itemid"] = tonumber( itemID ),
                                           ["count"] = tonumber( itemCount ),
                                           ["name"] = strgsub( itemName, "_", " " ),
                                           ["type"] = strgsub( itemType, "_", " " ),
                                           ["subtype"] = strgsub( itemSubtype, "_", " " ),
                                           ["level"] = tonumber( itemLevel ),
                                           ["quality"] = tonumber( itemQuality ) };
                end;
            elseif ( arg2:find( "UBI:GBCASH" ) and not UBI_GUILDBANK_OPENED ) then
                -- Receiving Guildbank cash, only receive data from latest sender
                if ( UBI_GBSender == arg4 and UBI_Options["track_gb_data"] ) then
                    -- Init guildbank structures (if needed)
                    UberInventory_Guildbank_Init();

                    local _, gbCash = strsplit( " ", arg2 );
                    UBI_Guildbank[UBI_GUILD]["Cash"] = tonumber( gbCash );

                    -- Update cash info on screen
                    if ( UberInventoryFrame:IsVisible() ) then
                        UberInventory_DisplayItems();
                    end;
                end;
            elseif ( arg2:find( "UBI:GBEND" ) and not UBI_GUILDBANK_OPENED ) then
                -- Stop receiving Guildbank data and process the received data, only process data from latest sender
                if ( UBI_GBSender == arg4 and UBI_Options["track_gb_data"] ) then
                    UberInventory_Receive_Guildbank();
                    UBI_GUILDBANK_FORCED = false;
                end;
            end;
        end;

        -- Handle request for sending guildbank data
        if ( event == "CHAT_MSG_ADDON" and arg1 == "UBI" and arg4 ~= UBI_PLAYER ) then
            if ( arg2:find( "UBI:GBREQUEST" ) and UBI_Options["track_gb_data"] ) then
                if ( UBI_GUILDBANK_OPENED and UBI_GUILDBANK_VIEWACCESS ) then
                    UberInventory_Send_Guildbank();
                end;
            end;
        end;

        -- Pandarian toon has selected faction
        if ( event == "NEUTRAL_FACTION_SELECT_RESULT" ) then
            UberInventory_GetAlts();
            UberInventory_GetGuildbanks();
        end;

        -- Build the inventory
        UberInventory_UpdateInventory( "all" );

        -- Build list for locations
        UberInventory_Build_Locations();

        -- Rebuild list of guildbanks
        if ( UBI_GUILD ~= GetGuildInfo( "player" ) ) then
            UBI_GUILD = GetGuildInfo( "player" );
            UberInventory_Guildbank_Init();
            UberInventory_GetGuildbanks();
            UberInventory_Build_Locations();
        end;
    end;

-- Show or hide the balance frame
    function UberInventory_ShowBalanceFrame( showFrame )
        if ( showFrame ) then
            UberInventoryBalanceFrame:Show();
            MoneyFrame_Update( "UberInventoryBalanceFrameMoneyFrame", GetMoney() );
        else
            UberInventoryBalanceFrame:Hide();
        end;
    end;

-- Update minimap button
    function UberInventory_Minimap_Update( angle )
        -- Only redraw the icon if the angle has changed
        if ( UBI_MINIMAP_ANGLE ~= angle ) then
            UberInventoryMinimap:SetPoint( "TOPLEFT",
                                           "Minimap",
                                           "TOPLEFT",
                                           54 - (78 * cos( angle )),
                                           (78 * sin( angle )) - 55 );
        end;

        -- Update current angle
        UBI_MINIMAP_ANGLE = angle;
    end;

-- Update minimap button
    function UberInventory_Minimap_Toggle()
        if ( UBI_Options["show_minimap"]) then
            UberInventoryMinimap:Show();
        else
            UberInventoryMinimap:Hide();
        end;
    end;

-- Update transparency of frames
    function UberInventory_Change_Alpha( alpha )
        UberInventoryFrameTexture:SetAlpha( alpha );
        UberInventoryFrameBorderTexture:SetAlpha( alpha );
        UberInventoryTokensTexture:SetAlpha( alpha );
        UberInventoryTokensBorderTexture:SetAlpha( alpha );
    end;


-- Handle Pricing info radio buttons
    function UberInventory_Change_Pricing( id )
        -- Turn all buttons off
        SettingPriceVendor:SetChecked( nil );
        SettingPriceAH:SetChecked( nil );

        -- Turn only the clicked button on
        if ( id == 16 ) then
            SettingPriceVendor:SetChecked( true );
        elseif ( id == 17 ) then
            SettingPriceAH:SetChecked( true );
        end;
    end;

-- Init frame options
    function UberInventory_SetOptions( frame )
        -- Initiliaze
        local UBI_Options = UBI_Options;

        -- Apply settings to the frame
        _G[ "SettingMoney" ]:SetChecked( UBI_Options["show_money"] );
        _G[ "SettingBalance" ]:SetChecked( UBI_Options["show_balance"] );
        _G[ "SettingShowTooltip" ]:SetChecked( UBI_Options["show_tooltip"] );
        _G[ "SettingSellPrice" ]:SetChecked( UBI_Options["show_sell_prices"] );
        _G[ "SettingRecipePrice" ]:SetChecked( UBI_Options["show_recipe_prices"] );
        _G[ "SettingQuestReward" ]:SetChecked( UBI_Options["show_recipe_reward"] );
        _G[ "SettingRecipeDrop" ]:SetChecked( UBI_Options["show_recipe_drop"] );
        _G[ "SettingHighlight" ]:SetChecked( UBI_Options["show_highlight"] );
        _G[ "SettingInboxMoney" ]:SetChecked( UBI_Options["take_money"] );
        _G[ "SettingShowMinimap" ]:SetChecked( UBI_Options["show_minimap"] );
        _G[ "SettingMinimap" ]:SetValue( UBI_Options["minimap"] );
        _G[ "SettingAlpha" ]:SetValue( UBI_Options["alpha"] );
        _G[ "SettingSendGuildbankData" ]:SetChecked( UBI_Options["send_gb_data"] );
        _G[ "SettingReceiveGuildbankData" ]:SetChecked( UBI_Options["receive_gb_data"] );
        _G[ "SettingTrackGuildbankData" ]:SetChecked( UBI_Options["track_gb_data"] );
        _G[ "SettingWarnMailExpire" ]:SetChecked( UBI_Options["warn_mailexpire"] );
        _G[ "SettingShowItemcount" ]:SetChecked( UBI_Options["show_item_count"] );

        if ( UBI_Options["pricing_data"] == "vendor" ) then
            UberInventory_Change_Pricing( 16 );
        elseif ( UBI_Options["pricing_data"] == "AH" ) then
            UberInventory_Change_Pricing( 17 );
        end;

        UberInventory_Redraw_TooltipOptions();
        UberInventory_Redraw_MinimapOptions();
    end;

-- Redraw state for tooltip options
    function UberInventory_Redraw_TooltipOptions()
        local state = _G[ "SettingShowTooltip" ]:GetChecked();

        UberInventory_SetState( _G[ "SettingSellPrice" ], state );
        UberInventory_SetState( _G[ "SettingRecipePrice" ], state );
        UberInventory_SetState( _G[ "SettingQuestReward" ], state );
        UberInventory_SetState( _G[ "SettingRecipeDrop" ], state );
    end;

-- Redraw state for minimap options
    function UberInventory_Redraw_MinimapOptions()
        local state = _G[ "SettingShowMinimap" ]:GetChecked();

        UberInventory_SetState( _G[ "SettingMinimap" ], state );
    end;

-- Save frame options
    function UberInventory_SaveOptions( frame )
        -- Initiliaze
        local UBI_Options = UBI_Options;

        -- Save settings from the frame
        UBI_Options["show_money"] = _G[ "SettingMoney" ]:GetChecked();
        UBI_Options["show_balance"] = _G[ "SettingBalance" ]:GetChecked();
        UBI_Options["show_tooltip"] = _G[ "SettingShowTooltip" ]:GetChecked();
        UBI_Options["show_sell_prices"] = _G[ "SettingSellPrice" ]:GetChecked();
        UBI_Options["show_recipe_prices"] = _G[ "SettingRecipePrice" ]:GetChecked();
        UBI_Options["show_recipe_reward"] = _G[ "SettingQuestReward" ]:GetChecked();
        UBI_Options["show_recipe_drop"] = _G[ "SettingRecipeDrop" ]:GetChecked();
        UBI_Options["show_highlight"] = _G[ "SettingHighlight" ]:GetChecked();
        UBI_Options["show_item_count"] = _G[ "SettingShowItemcount" ]:GetChecked();
        UBI_Options["take_money"] = _G[ "SettingInboxMoney" ]:GetChecked();
        UBI_Options["show_minimap"] = _G[ "SettingShowMinimap" ]:GetChecked();
        UBI_Options["minimap"] = _G[ "SettingMinimap" ]:GetValue();
        UBI_Options["alpha"] = _G[ "SettingAlpha" ]:GetValue();
        UBI_Options["send_gb_data"] = _G[ "SettingSendGuildbankData" ]:GetChecked();
        UBI_Options["receive_gb_data"] = _G[ "SettingReceiveGuildbankData" ]:GetChecked();
        UBI_Options["track_gb_data"] = _G[ "SettingTrackGuildbankData" ]:GetChecked();
        UBI_Options["warn_mailexpire"] = _G[ "SettingWarnMailExpire" ]:GetChecked();

        if ( _G[ "SettingPriceVendor" ]:GetChecked() ) then
            UBI_Options["pricing_data"] = "vendor";
        else
            UBI_Options["pricing_data"] = "AH";
        end;

    end;

-- Apply setting to the UI
    function UberInventory_UpdateUI()
        -- Initiliaze
        local UBI_Options = UBI_Options;

        -- Hide or show balance frame based on the current settings (look for a more elegant solution)
        UberInventory_ShowBalanceFrame( UBI_Options["show_balance"] );

        -- Show or hide minimap icon
        UberInventory_Minimap_Toggle();

        -- Restore or set minimap location
        UberInventory_Minimap_Update( UBI_Options["minimap"] );

        -- Restore or set transparency
        UberInventory_Change_Alpha( UBI_Options["alpha"] );

        -- Force refresh
        UberInventory_DisplayItems();
    end;

-- Revert all options to default values
    function UberInventory_SetDefaults( frame )
        -- Initiliaze
        local UBI_Options = UBI_Options;

        -- Restore defaults
        for key, value in pairs( UBI_Defaults ) do
            UBI_Options[key] = value;
        end;

        -- Hide or show balance frame based on the current settings (look for a more elegant solution)
        UberInventory_ShowBalanceFrame( UBI_Options["show_balance"] );

        -- Show or hide minimap icon
        UberInventory_Minimap_Toggle();

        -- Restore or set minimap location
        UberInventory_Minimap_Update( UBI_Options["minimap"] );

        -- Restore or set transparency
        UberInventory_Change_Alpha( UBI_Options["alpha"] );

        -- Redraw Options frame
        UberInventory_SetOptions( frame );
    end;

-- Make Settings frame known to the system
    function UberInventory_AddCategory( frame )
        -- Set panel name
        frame.name = UBI_NAME;

        -- Set okay function
        frame.okay = function( self )
            UberInventory_SaveOptions( self );
            UberInventory_UpdateUI();
        end;

        -- Set cancel function
        frame.cancel = function( self )
            UberInventory_SetOptions( self );
            UberInventory_UpdateUI();
        end;

        -- set defaults function
        frame.default = function( self )
            UberInventory_SetDefaults( self );
            UberInventory_UpdateUI();
        end;

        -- Add the panel
        InterfaceOptions_AddCategory( frame );
    end;

-- Update button mask to indicate item usability (clear = usable, red = usuable, blue = uncached item)
    function UberInventory_MarkButton( button, itemid )
        -- Clear state
        button:SetAttribute( "usable", nil );

        -- Reapply color coding
        if UberInventory_UsableItem( itemid ) then
            SetItemButtonTextureVertexColor( button, 1, 1, 1 );
        else
            SetItemButtonTextureVertexColor( button, 1, 0.1, 0.1 );
        end;

        -- Item still not locally cached, mark it again
        if ( not GetItemInfo( itemid ) ) then
            button:SetAttribute( "usable", "uncached" );
            SetItemButtonTextureVertexColor( button, 0.2, 0.2, 0.8 );
        end;
    end;

-- Handle uncached items
    function UberInventory_ItemButton_OnUpdate( self, elapsed )
        -- Initialize
        local state = self:GetAttribute( "usable" );
        local total_elapsed = self:GetAttribute( "elapsed" ) + elapsed;

        -- To minimize load perform the rest only if item is uncached and concerns a visible button
        if ( state and state == "uncached" and self:IsVisible() ) then
            -- Update total elapsed time since last real call
            self:SetAttribute( "elapsed", total_elapsed );

            -- Re-mark the button and reset elapsed
            if ( total_elapsed > 0.5 ) then
                UberInventory_MarkButton( self, self:GetID() );
                self:SetAttribute( "elapsed", 0 );
            end;
        end;
    end;

-- Update cash field
    function UberInventory_UpdateCashField( frame, cash, prefix )
        -- Update cash info and resize frame
        if ( cash > 0 ) then
            frame:SetText( (prefix or "")..GetCoinTextureString( cash ).."  " );
        else
            frame:SetText( (prefix or "").."-  " );
        end;
    end;

-- Update inventory button
    function UberInventory_UpdateButton( slot, record )
        local objSlot = _G[ "UberInventoryFrameItem"..slot ];
        local button = objSlot:GetName().."ItemButton";
        local buttonObj = _G[ button ];

        -- Record is nil, item does not exist and button should be hidden
        if ( not record ) then
            objSlot:Hide();
            return;
        else
            objSlot:Show();
        end;

        -- Get itemID
        local itemid = record["itemid"];

        -- Get item prices
        local buyPrice, sellPrice, buyoutPrice = UberInventory_GetItemPrices( itemid );

        -- Get item counts
        local bagCount = record["bag_count"] or 0;
        local bankCount = record["bank_count"] or 0;
        local mailCount = record["mailbox_count"] or 0;
        local equipCount = record["equip_count"] or 0;
        local voidCount = record["void_count"] or 0;
        local guildCount = record["count"] or 0;
        local totalCount = record["total"] or 0;

        -- Quest information
        local questID = ( record["qid"] or 0 );
        local questItem = ( record["qitem"] or flase );

        -- Get correct totalCount for combined inventory searches
        if ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "complete" or UBI_LocationList[UBI_FILTER_LOCATIONS].type == "all_character" or UBI_LocationList[UBI_FILTER_LOCATIONS].type == "all_guildbank" ) then
            totalCount = UBI_Track[record.itemid] or 0;
        end;

        -- Set item image
        if ( record["type"] == UBI_BATTLEPET_CLASS and itemid ~= 82800 ) then
            local _, icon = C_PetJournal.GetPetInfoBySpeciesID( itemid );
            SetItemButtonTexture( buttonObj, icon );
        else
            SetItemButtonTexture( buttonObj, GetItemIcon( itemid ) );
        end;

        -- Set item name
        local itemcolor = ITEM_QUALITY_COLORS[record.quality];
        _G[ button.."ItemName" ]:SetText( record["name"] );
        _G[ button.."ItemName" ]:SetTextColor( itemcolor.r, itemcolor.g, itemcolor.b );

        -- Set item count
        if ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "current" or UBI_LocationList[UBI_FILTER_LOCATIONS].type == "character" ) then
            _G[ button.."ItemCount" ]:SetFormattedText( UBI_ITEM_COUNT, totalCount, bagCount, bankCount, mailCount, equipCount, voidCount );
        else
            _G[ button.."ItemCount" ]:SetFormattedText( UBI_ITEM_COUNT_SINGLE, totalCount );
        end;
        SetItemButtonCount( buttonObj, totalCount );

        -- Set item id (for tooltip)
        buttonObj:SetID( itemid );
        buttonObj:SetAttribute( "inventoryitem", record );
        buttonObj:SetAttribute( "location", UBI_FILTER_LOCATIONS );
        buttonObj:SetAttribute( "usable", nil );
        buttonObj:SetAttribute( "elapsed", 0 );

        -- Update buy, buyout and sell prices
        if ( UBI_Options["pricing_data"] == "vendor" ) then
            -- Show sell price
            _G[ button.."ItemSell" ]:Show();

            -- Update price fields
            UberInventory_UpdateCashField( _G[ button.."ItemBuy" ], buyPrice or 0, UBI_ITEM_BUY );
            UberInventory_UpdateCashField( _G[ button.."ItemSell" ], sellPrice or 0, UBI_ITEM_SELL );
        else
            -- Hide sell price
            _G[ button.."ItemSell" ]:Hide();

            -- Update price field
            UberInventory_UpdateCashField( _G[ button.."ItemBuy" ], buyoutPrice or 0, UBI_ITEM_BUYOUT );
        end;

        -- Mark usability onto the itembutton
        if ( record["type"] ~= UBI_BATTLEPET_CLASS ) then
            UberInventory_MarkButton( buttonObj, itemid );
        end;

        -- Mark quest item
        local questTexture = _G[ button.."IconQuestTexture" ];
        if ( questID > 0 ) then
            questTexture:SetTexture( TEXTURE_ITEM_QUEST_BANG );
            questTexture:Show();
        elseif ( questItem ) then
            questTexture:SetTexture( TEXTURE_ITEM_QUEST_BORDER) ;
            questTexture:Show();
        else
            questTexture:Hide();
        end;
    end;

-- Mousewheel support for scrolling through items
    function UberInventory_OnMouseWheel( frame, delta, type )
        local offset = FauxScrollFrame_GetOffset( frame ) or 0;
        local newOffset = math.max( offset - delta, 0 );

        -- Update scroll positions and force redisplay of content
        if ( type == "ITEMS" ) then
            local maxOffset = ceil( ( #UBI_Sorted - UBI_NUM_ITEMBUTTONS ) / 2 );
            frame:SetVerticalScroll( math.min( maxOffset, newOffset ) * 36 );
            UberInventory_DisplayItems();
        else
            local maxOffset = #UBI_Currencies+1 - UBI_NUM_TOKENBUTTONS;
            frame:SetVerticalScroll( math.min( maxOffset, newOffset ) * 17 );
            UberInventory_DisplayTokens();
        end;
    end;

-- Display items (by page, UBI_NUM_ITEMBUTTONS items)
    function UberInventory_DisplayItems()
        -- From global to local
        local UBI_Characters = UBI_Characters;
        local UBI_Guildbanks = UBI_Guildbanks;
        local UBI_Data = UBI_Data;
        local UBI_Guildbank = UBI_Guildbank;
        local UBI_Sorted = UBI_Sorted;

        -- Create GB structure if it does not already exist
        UberInventory_Guildbank_Init();

        -- Sort and filter items
        UberInventory_SortFilter( UBI_FILTER_TEXT or "", false );

        -- Get current offset
        local offset = FauxScrollFrame_GetOffset( UberInventoryFrameScroll ) or 0;
        
        -- Update scrollbars (reset scroll position when needed)
        if ( offset > ceil( (#UBI_Sorted-UBI_NUM_ITEMBUTTONS) / 2 ) ) then
            UberInventory_ScrollToTop();
            offset = 0;
        else
            FauxScrollFrame_Update( UberInventoryFrameScroll, ceil( #UBI_Sorted / 2 ), 8, 36 );
        end;

        -- Execute code to actually add the items to the inventory frame
        local index;
        for slot = 1, UBI_NUM_ITEMBUTTONS do
            -- Calculate the actual index within sorted array
            index = ( offset * 2 ) + slot;

            -- Display item
            UberInventory_UpdateButton( slot, UBI_Sorted[ index ] );
        end;

        -- Update inventory count
        UberInventoryFrameInventoryCount:SetFormattedText( UBI_INVENTORY_COUNT, #UBI_Sorted, UBI_Inventory_count );

        -- Disable the token button
        UberInventory_SetState( UberInventoryFrameTokensButton, false );

        -- Show/Hide the moneyframe for displaying Guildbank or Alt cash
        if ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "current" ) then
            UberInventoryFrameMoneyOthersCash:SetText( UBI_EMPTY_TEXT );
            UberInventory_SetState( UberInventoryFrameTokensButton, true );
        else
            -- Initialize
            local otherCash = 0;

            -- Determine the cash owned
            if ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "guildbank" ) then
                otherCash = UBI_Guildbank[UBI_LocationList[UBI_FILTER_LOCATIONS].value]["Cash"];
            elseif ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "character" ) then
                local character = strgsub( UBI_LocationList[UBI_FILTER_LOCATIONS].value, " .*", "" );
                otherCash = UBI_Data[UBI_REALM][character]["Money"]["Cash"] + UBI_Data[UBI_REALM][character]["Money"]["mail"];
                UberInventory_SetState( UberInventoryFrameTokensButton, true );
            elseif ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "all_character" ) then
                -- Traverse guildbanks
                otherCash = otherCash + UBI_Data[UBI_REALM][UBI_PLAYER]["Money"]["Cash"] + UBI_Data[UBI_REALM][UBI_PLAYER]["Money"]["mail"];

                -- Traverse characters
                for key, value in pairs( UBI_Characters ) do
                    otherCash = otherCash + UBI_Data[UBI_REALM][value]["Money"]["Cash"] + UBI_Data[UBI_REALM][value]["Money"]["mail"];
                end;
            elseif ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "all_guildbank" ) then
                -- Traverse guildbanks
                for key, value in pairs( UBI_Guildbanks ) do
                    otherCash = otherCash + UBI_Guildbank[value]["Cash"];
                end;
            elseif ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "complete" ) then
                -- Traverse guildbanks
                otherCash = otherCash + UBI_Data[UBI_REALM][UBI_PLAYER]["Money"]["Cash"] + UBI_Data[UBI_REALM][UBI_PLAYER]["Money"]["mail"];

                -- Traverse characters
                for key, value in pairs( UBI_Characters ) do
                    otherCash = otherCash + UBI_Data[UBI_REALM][value]["Money"]["Cash"] + UBI_Data[UBI_REALM][value]["Money"]["mail"];
                end;

                -- Traverse guildbanks
                for key, value in pairs( UBI_Guildbanks ) do
                    otherCash = otherCash + UBI_Guildbank[value]["Cash"];
                end;
            end;

            -- Update the cash info for Alt/Guildbank
            UberInventory_UpdateCashField( UberInventoryFrameMoneyOthersCash, otherCash );
        end;
    end;

-- Display tokens
    function UberInventory_DisplayTokens()
        local tokenList = {};
        local line, index, button, currency, tokenData, toon;
        local offset = FauxScrollFrame_GetOffset( UberInventoryTokensScroll );

        -- Determine token set to be displayed
        if ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "current" ) then
            tokenData = UBI_Data[UBI_REALM][UBI_PLAYER]["Money"]["Currencies"];
            toon = UBI_PLAYER;
        elseif ( UBI_LocationList[UBI_FILTER_LOCATIONS].type == "character" ) then
            local character = strgsub( UBI_LocationList[UBI_FILTER_LOCATIONS].value, " .*", "" );
            tokenData = UBI_Data[UBI_REALM][character]["Money"]["Currencies"];
            toon = UBI_LocationList[UBI_FILTER_LOCATIONS].value;
        else
            UberInventoryTokens:Hide();
            return;
        end;

        -- Build new list containing headings, non-zero tokens and forced tokens
        for key, value in pairs( UBI_Currencies ) do
            if ( value.id < 0 or value.force ) then
                tinsert( tokenList, value );
            else
                if ( ( tokenData[value.id] or 0 ) > 0 ) then
                    tinsert( tokenList, value );
                end;
            end;
        end;
        local length = #tokenList;

        -- Update scrollbars
        FauxScrollFrame_Update( UberInventoryTokensScroll, length+1, UBI_NUM_TOKENBUTTONS, 17 );

        -- Set title and show frame
        UberInventoryTokensHeading:SetText( UBI_TOKEN:format( toon ) );
        UberInventoryTokens:Show();

        -- Redraw items
        for line = 1, UBI_NUM_TOKENBUTTONS, 1 do
            index = offset + line;
            button = _G[ "Token"..line ];
            if index <= length then
                if ( tokenList[index].id > 0 ) then
                     _G[ "Token"..line.."Icon" ]:SetTexture( "Interface\\Icons\\"..tokenList[index].icon );
                     _G[ "Token"..line.."Icon" ]:Show();
                     if ( ( tokenData[tokenList[index].id] or 0 ) > 0 ) then
                         _G[ "Token"..line.."Name" ]:SetTextColor( 1.0, 1.0, 1.0 );
                         _G[ "Token"..line.."Count" ]:SetTextColor( 1.0, 1.0, 1.0 );
                     else
                         _G[ "Token"..line.."Name" ]:SetTextColor( 0.7, 0.7, 0.7 );
                         _G[ "Token"..line.."Count" ]:SetTextColor( 0.7, 0.7, 0.7 );
                     end;
                     _G[ "Token"..line.."Name" ]:SetText( "   "..( tokenList[index].name or "??" ) );
                     _G[ "Token"..line.."Count" ]:SetText( tokenData[tokenList[index].id] or 0 );
                     _G[ "Token"..line.."Count" ]:Show();
                else
                     _G[ "Token"..line.."Icon" ]:Hide();
                     _G[ "Token"..line.."Name" ]:SetTextColor( 1.0, 0.82, 0.0 );
                     _G[ "Token"..line.."Name" ]:SetText( tokenList[index].name );
                     _G[ "Token"..line.."Count" ]:Hide();
                end;
                button:Show();
            else
                button:Hide();
            end;
        end;

    end;

-- Update wallet/mail cash info on screen
    function UberInventory_WalletMailCashInfo()
        if(  UberInventoryFrame:IsVisible() ) then
            -- Update cash balance information
            UberInventory_UpdateCashField( UberInventoryFrameMoneyWalletCash, GetMoney() );
            UberInventory_UpdateCashField( UberInventoryFrameMoneyMailCash, UBI_Money["mail"] );
        end;
    end;

-- Show or hide the Main dialog
    function UberInventory_Toggle_Main()
        if(  UberInventoryFrame:IsVisible() ) then
            UberInventoryFrame:Hide();
        else
            -- Show the frame
            UberInventoryFrame:Show();
            UberInventoryFrame:SetBackdropColor( 0, 0, 0, 1 );

            -- Update wallet/mail cash information
            UberInventory_WalletMailCashInfo();

            -- Force refresh
            UberInventory_DisplayItems();

            -- Update slot count information
            UberInventory_Update_SlotCount();
        end;
    end;

-- Show or hide the Main dialog
    function UberInventory_Toggle_Tokens()
        if(  UberInventoryTokens:IsVisible() ) then
            UberInventoryTokens:Hide();
        else
            -- Show the frame
            UberInventoryTokens:Show();
            UberInventoryTokens:SetBackdropColor( 0, 0, 0, 1 );
        end;
    end;

-- Show/Hide tooltip info
    function UberInventory_Toggle_Tooltip()
        UBI_Options["show_tooltip"] = not UBI_Options["show_tooltip"];
    end;

-- Set/Remove hightlight for container/item
    function UberInventory_Highlighter( item, state )
        -- Set hightlight from container/item
        function HighlightOn( frame )
            SetItemButtonTextureVertexColor( frame, .6, .6, .6, 1 );
            frame:GetNormalTexture():SetVertexColor( .6, .6, .6, 1 );
            frame:LockHighlight();
            tinsert( UBI_Highlights, frame );
        end;

        -- Remove hightlight from container/item
        function HighlightOff( frame )
            SetItemButtonTextureVertexColor( frame, 1, 1, 1 );
            frame:GetNormalTexture():SetVertexColor( 1, 1, 1 );
            frame:UnlockHighlight();
        end;

        -- Exit if highlighting has been turned off
        if ( not UBI_Options["show_highlight"] ) then
            return;
        end;

        -- Set or remove highlights
        if ( state == "off" ) then
            -- Remove all previous highlights
            for id, frame in pairs( UBI_Highlights ) do
                HighlightOff( frame );
            end;
            wipe( UBI_Highlights );
        else
            -- Initialize
            local bagid, slotid, itemid, itemlink, index, container, _;

            -- Travese all containers and slots (bag, bank) to locate items
            for bagid = -2, 11, 1 do
                index = IsBagOpen( bagid );
                for slotid = 1, GetContainerNumSlots( bagid ) do
                    itemlink = GetContainerItemLink( bagid, slotid );
                    if ( itemlink ) then
                        _, itemid = strsplit( ":", itemlink );
                        if ( tonumber(itemid) == item and UI_CONTAINER_OBJECTS[bagid]:IsShown() ) then
                            -- Highlight container
                            if ( bagid ~= -1 ) then
                                HighlightOn( UI_CONTAINER_OBJECTS[bagid] );
                            end;

                            -- Highlight item
                            if ( index or bagid == BANK_CONTAINER ) then
                                if ( bagid == -1 ) then
                                    container = "BankFrameItem"..slotid;
                                else
                                    slotid = GetContainerNumSlots( bagid ) - slotid + 1;
                                    container = "ContainerFrame"..index.."Item"..slotid;
                                end;
                                HighlightOn(  _G[ container ] );
                            end;
                        end;
                    end;
                end;
            end;

            -- Travese all gb slots to locate item
            if ( UBI_GUILDBANK_OPENED ) then
                local gbTab, gbSlot;
                for gbTab = 1, GetNumGuildBankTabs() do
                    for gbSlot = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
                        itemlink = GetGuildBankItemLink( gbTab, gbSlot );
                        if ( itemlink ) then
                            _, itemid = strsplit( ":", itemlink );
                            if ( tonumber(itemid) == item ) then
                                -- Highlight tab
                                container = "GuildBankTab"..gbTab.."Button";
                                HighlightOn(  _G[ container ] );

                                -- Highlight item
                                if ( GetCurrentGuildBankTab() == gbTab ) then
                                    index = mod( gbSlot, NUM_SLOTS_PER_GUILDBANK_GROUP );
                                    if ( index == 0 ) then
                                        index = NUM_SLOTS_PER_GUILDBANK_GROUP;
                                    end
                                    column = ceil( ( gbSlot - 0.5 ) / NUM_SLOTS_PER_GUILDBANK_GROUP );
                                    container = "GuildBankColumn"..column.."Button"..index;
                                    HighlightOn(  _G[ container ] );
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

-- Perform item search
    function UberInventory_Search( str )
        -- From global to local
        local itemText, msg, count = "", "", 0;
        local icon;

        -- Display search criteria
        UberInventory_Message( UBI_ITEM_SEARCH:format( str ), true );

        -- Search and display items found
        local itemCounts = { 0, 0, 0, 0, 0 };
        for key, value in pairs( UBI_Items ) do
            if ( ( strfind( strlower( value.name ) , strlower( str ) ) or 0 ) > 0 ) then
                -- Get item count
                itemCounts = { value.total,
                               value.bag_count or 0,
                               value.bank_count or 0,
                               value.mailbox_count or 0,
                               value.equip_count or 0,
                               value.void_count or 0 };

                -- Set item image
                if ( value.type == UBI_BATTLEPET_CLASS and value.itemid ~= 82800 ) then
                    _, icon = C_PetJournal.GetPetInfoBySpeciesID( value.itemid );
                else
                    icon = GetItemIcon( value.itemid );
                end;

                -- Build search result
                itemText = "|T"..icon..":0|t "..UberInventory_GetLink( value.itemid, value );
                msg = "  "..itemText.." "..UBI_ITEM_COUNT_SINGLE:format( itemCounts[1] ).." (";
                for loc = 2, #itemCounts do
                    if ( itemCounts[loc] > 0 ) then
                        msg = msg.."|T"..UBI_LOCATION_TEXTURE[loc-1]..":0|t "..UBI_LOCATIONS[loc-1].." = "..itemCounts[loc].." / ";
                    end;
                end;

                -- Display result
                count = count + 1;
                UberInventory_Message( msg:sub( 1, msg:len()-3 )..")", true );
            end;
        end;

        -- Display end of search
        if ( count == 0 ) then
           UberInventory_Message( UBI_ITEM_SEARCH_NONE, true );
        else
           UberInventory_Message( UBI_ITEM_SEARCH_DONE, true );
        end;
    end;

-- Remove character or guildbank data
    function UberInventory_RemoveData( data )
        -- split of command and name (guildbank names can contain spaces, unlike character names)
        local command, _ = strsplit( " ", data ):lower();
        local name = data:sub( command:len()+2 );

        -- Remove the data
        if ( command == "remchar"  and name ~= "Guildbank" ) then
            -- Do not remove data for the current connected character
            if ( name == UBI_PLAYER ) then
                UberInventory_Message( UBI_REM_NOTALLOWED, true );
                return;
            end;

            -- Check if character has data stored and delete it if so
            if ( UBI_Data[UBI_REALM][name] ) then
                StaticPopupDialogs["UBI_CONFIRM_DELETE"].OnAccept = function()
                    -- Remove data
                    UBI_Data[UBI_REALM][name] = nil;

                    -- Display message
                    UberInventory_Message( UBI_REM_DONE:format( name ), true );

                    -- Rebuild list of alts
                    UberInventory_GetAlts();

                    -- Reset filters
                    UberInventory_ResetFilters();
                end;

                -- Ask for remove confirmation
                StaticPopup_Show( "UBI_CONFIRM_DELETE", UBI_REM_CHARACTER:format( name ) );
            else
                UberInventory_Message( UBI_REM_CHARNOTFOUND:format( name ), true );
            end;
        elseif ( command == "remguild" ) then
            -- Check if guildbank has data stored and delete it if so
            if ( UBI_Guildbank[name] ) then
                StaticPopupDialogs["UBI_CONFIRM_DELETE"].OnAccept = function()
                    -- Remove data
                    UBI_Guildbank[name] = nil;

                    -- Display message
                    UberInventory_Message( UBI_REM_DONE:format( name ), true );

                    -- When current guild is removed reinitialize data structure
                    if ( UBI_GUILD == name ) then
                        UberInventory_Guildbank_Init();
                    end;

                    -- Rebuild list of guildbanks
                    UberInventory_GetGuildbanks();

                    -- Reset filters
                    UberInventory_ResetFilters();
                end;

                -- Ask for remove confirmation
                StaticPopup_Show( "UBI_CONFIRM_DELETE", UBI_REM_GUILDBANK:format( name ) );
            else
                UberInventory_Message( UBI_REM_GUILDNOTFOUND:format( name ), true );
            end;
        end;

        -- Rebuild location list
        UberInventory_Build_Locations();
    end;

-- Show help message
    function UberInventory_ShowHelp()
        for key, value in pairs( UBI_HELP ) do
            UberInventory_Message( value, true );
        end;
    end;

-- Handle slash commands
    function UberInventory_SlashHandler( msg, editbox )
        -- arguments should be handled case-insensitve
        local orgData = msg;
        msg = strlower( msg );

        -- Handle each individual argument
        if ( msg == "" ) then
            -- Show main dialog
            UberInventory_Toggle_Main();
        elseif ( msg:find( "remchar" ) or msg:find( "remguild" ) ) then
            -- Remove character or guild data
            UberInventory_RemoveData( orgData );
        elseif ( msg == "help" ) or ( msg == "?" ) then
            -- Show help info
            UberInventory_ShowHelp();
        elseif ( msg == "resetpos" ) then
            UberInventoryFrame:ClearAllPoints();
            UberInventoryFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
        elseif ( msg == "sendgb" ) then
            if ( UBI_GUILDBANK_OPENED and UBI_GUILDBANK_VIEWACCESS ) then
                UberInventory_Send_Guildbank();
            else
                if ( not UBI_GUILDBANK_OPENED ) then
                    UberInventory_Message( UBI_SENDGB_VISIT, true );
                end;
                if ( not UBI_GUILDBANK_VIEWACCESS ) then
                    UberInventory_Message( UBI_SENDGB_ACCESS, true );
                end;
            end;
        elseif ( msg == "requestgb" ) then
            UBI_GUILDBANK_FORCED = true;
            TaskHandlerLib:AddTask( "UberInventory", UBI_Task_SendMessage, "GBREQUEST" );
            UberInventory_Message( UBI_GB_REQUESTED, true );
        else
            -- Perform item search
            UberInventory_Search( msg or "" );
        end;
    end;