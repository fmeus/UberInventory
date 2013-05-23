  --[[ Revision: $Id: UberInventory_debug.lua 745 2013-01-29 09:51:44Z fmeus_lgs $ --]]
-- Define overloading functions
--    EventTracker_TrackProc( "HighlightOff", { "frame" } );
--    EventTracker_TrackProc( "HighlightOn", { "frame" } );
--    EventTracker_TrackProc( "UBI_Task_CollectCash" );
--    EventTracker_TrackProc( "UBI_Task_SendMessage", { "task", "info" } );
--    EventTracker_TrackProc( "UberInventory_AddCategory", { "frame" } );
--    EventTracker_TrackProc( "UberInventory_AddItemInfo", { "tooltip" } );
--    EventTracker_TrackProc( "UberInventory_Change_Alpha", { "alpha" } );
--    EventTracker_TrackProc( "UberInventory_Classes_Init" );
--    EventTracker_TrackProc( "UberInventory_Classes_OnClick" );
--    EventTracker_TrackProc( "UberInventory_Cleanup" );
--    EventTracker_TrackProc( "UberInventory_DaysSince", { "visit" } );
--    EventTracker_TrackProc( "UberInventory_DisplayItems" );
--    EventTracker_TrackProc( "UberInventory_GetAlts" );
--    EventTracker_TrackProc( "UberInventory_GetGuildbanks" );
--    EventTracker_TrackProc( "UberInventory_GetItemPrices", { "itemid" } );
--    EventTracker_TrackProc( "UberInventory_GetLink", { "itemid" } );
--    EventTracker_TrackProc( "UberInventory_GetMoney" );
--    EventTracker_TrackProc( "UberInventory_GetMoneyString", { "amount" } );
--    EventTracker_TrackProc( "UberInventory_Guildbank_Init" );
--    EventTracker_TrackProc( "UberInventory_Highlighter", { "item", "state" } );
--    EventTracker_TrackProc( "UberInventory_HookTooltip", { "tooltip" } );
--    EventTracker_TrackProc( "UberInventory_Init" );
--    EventTracker_TrackProc( "UberInventory_Install_Hooks" );
--    EventTracker_TrackProc( "UberInventory_Item", { "bagid", "slotid", "location" } );
--    EventTracker_TrackProc( "UberInventory_ItemButton_OnUpdate", { "self", "elapsed" } );
--    EventTracker_TrackProc( "UberInventory_Locations_Init" );
--    EventTracker_TrackProc( "UberInventory_Locations_OnClick" );
--    EventTracker_TrackProc( "UberInventory_MailExpirationCheck" );
--    EventTracker_TrackProc( "UberInventory_MarkButton", { "button", "itemid" } );
--    EventTracker_TrackProc( "UberInventory_Message", { "msg", "prefix" } );
--    EventTracker_TrackProc( "UberInventory_Minimap_OnEnter", { "anchor" } );
--    EventTracker_TrackProc( "UberInventory_Minimap_Toggle" );
--    EventTracker_TrackProc( "UberInventory_Minimap_Update", { "angle" } );
--    EventTracker_TrackProc( "UberInventory_OnEvent", { "self", "event" } );
--    EventTracker_TrackProc( "UberInventory_OnLoad" );
--    EventTracker_TrackProc( "UberInventory_Quality_Init" );
--    EventTracker_TrackProc( "UberInventory_Quality_OnClick" );
--    EventTracker_TrackProc( "UberInventory_Receive_Guildbank" );
--    EventTracker_TrackProc( "UberInventory_RegisterEvents" );
--    EventTracker_TrackProc( "UberInventory_RemoveData", { "data" } );
--    EventTracker_TrackProc( "UberInventory_ResetCount", { "location" } );
--    EventTracker_TrackProc( "UberInventory_ResetFilters" );
--    EventTracker_TrackProc( "UberInventory_SaveOptions", { "frame" } );
--    EventTracker_TrackProc( "UberInventory_Save_Bag" );
--    EventTracker_TrackProc( "UberInventory_Save_Bank" );
--    EventTracker_TrackProc( "UberInventory_Save_Equipped" );
--    EventTracker_TrackProc( "UberInventory_Save_Guildbank", { "event" } );
--    EventTracker_TrackProc( "UberInventory_Save_Mailbox" );
--    EventTracker_TrackProc( "UberInventory_Scan_Tooltip", { "itemid", "color", "searchtext" } );
--    EventTracker_TrackProc( "UberInventory_ScrollToTop" );
--    EventTracker_TrackProc( "UberInventory_Search", { "str" } );
--    EventTracker_TrackProc( "UberInventory_Send_Guildbank" );
--    EventTracker_TrackProc( "UberInventory_SetDefaults", { "frame" } );
--    EventTracker_TrackProc( "UberInventory_SetOptions", { "frame" } );
--    EventTracker_TrackProc( "UberInventory_SetTooltipMoney", { "tooltip", "money", "type", "prefix", "suffix" } );
--    EventTracker_TrackProc( "UberInventory_ShowBalanceFrame", { "showFrame" } );
--    EventTracker_TrackProc( "UberInventory_ShowHelp" );
--    EventTracker_TrackProc( "UberInventory_SlashHandler", { "msg", "editbox" } );
--    EventTracker_TrackProc( "UberInventory_SortFilter", { "str", "cmdline" } );
--    EventTracker_TrackProc( "UberInventory_SplitMoney", { "amount" } );
--    EventTracker_TrackProc( "UberInventory_Toggle_Main" );
--    EventTracker_TrackProc( "UberInventory_UpdateButton", { "slot", "record" } );
--    EventTracker_TrackProc( "UberInventory_UpdateCashField", { "frame", "cash", "prefix" } );
--    EventTracker_TrackProc( "UberInventory_UpdateInventory", { "location" } );
--    EventTracker_TrackProc( "UberInventory_UpdateUI" );
--    EventTracker_TrackProc( "UberInventory_Update_SlotCount" );
--    EventTracker_TrackProc( "UberInventory_Upgrade" );
--    EventTracker_TrackProc( "UberInventory_UsableItem", { "itemid" } );
--    EventTracker_TrackProc( "UberInventory_WalletMailCashInfo" );

-- Track specific events
--    EventTracker:RegisterEvent( "CURRENCY_DISPLAY_UPDATE" );
--    EventTracker:RegisterEvent( "KNOWN_CURRENCY_TYPES_UPDATE" );
--    EventTracker:RegisterEvent( "VARIABLES_LOADED" );
--    EventTracker:RegisterEvent( "BAG_UPDATE" );
--    EventTracker:RegisterEvent( "PLAYER_LOGIN" );