--[[ =================================================================
    Description:
        Data broker plugin.

    Revision:
        $Id: Broker_UberInventory.lua 763 2013-02-04 20:42:24Z fmeus_lgs $
    ================================================================= --]]

-- Local variables


-- Library stuff
local LibStub   = LibStub;
local LDB       = LibStub:GetLibrary("LibDataBroker-1.1");


-- Create frame for responding to game events
local f = CreateFrame( "Frame", "Broker_UberInventory", UIParent );


-- Setup broker
local ldbUberInventory = LDB:NewDataObject( "Broker - UberInventory", {
    type    = "data source",
    icon    = "Interface\\AddOns\\UberInventory\\artwork\\UberInventory",
    text    = "",
    OnEnter = function( self )
        ldbUberInventory_OnEnter( self )
    end,
    OnLeave = function()
        ldbUberInventory_OnLeave()
    end
});


-- Initialize when player logs in
function f:PLAYER_LOGIN()
    f:UnregisterEvent( "PLAYER_LOGIN" );

    if ( IsAddOnLoaded( "UberInventory" ) ) then
        ldbUberInventory.icon = "Interface\\AddOns\\UberInventory\\artwork\\UberInventory";
    end;
end;


-- Open UberInventory when clicked
function ldbUberInventory:OnClick( button )
    UberInventory_Toggle_Main();
end;


-- Show tooltip
function ldbUberInventory_OnEnter( self )
    UberInventory_Minimap_OnEnter( self, "ANCHOR_NONE" );
end;


-- Hide tooltip
function ldbUberInventory_OnLeave()
    GameTooltip:Hide();
end;


-- Generic event handler
local function OnEvent( self, event, ... )
    self[event]( self, event, ... );
end;


-- Setup event handler
f:SetScript( "OnEvent", OnEvent );


-- Register events to listen to
f:RegisterEvent( "PLAYER_LOGIN" );