
$.Msg("working");
ReloadPvZPanorama()
function ReloadPvZPanorama(){
	$.Schedule(3, ReloadPvZPanorama)

	let ScanImage = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("RadarIcon")
	let RightMapContainers = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("GlyphScanContainer")
	let TopBarDire = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("TopBarDireTeamContainer")
	let TopBarRadiant = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("TopBarRadiantTeamContainer")
	let Inventory = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("InventoryContainer")
	let Inventory22 = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("inventory")
	let Inventory2 = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("right_flare")
	let Inventory23 = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("left_flare")
	let Inventory3 = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("inventory_composition_layer_container")
	let Inventory4 = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("AghsStatusContainer")
	let Inventory5 = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("StatBranchDrawer")
	let Inventory6 = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("StatBranch")
	let XP = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("xp")
	let LevelStatsFrame = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("level_stats_frame")

	let InvRight = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block");
	let InvRights = InvRight.FindChildrenWithClassTraverse("AbilityInsetShadowRight")[0]

	let MainPanel = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("AbilitiesAndStatBranch")
	let MainPanelBg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("center_bg")

	let Shop = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("shop_launcher_bg")
	let Stash = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("stash")
	let QB = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("QuickBuyRows")
	let Cour = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("courier")
	let ShopButton = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("ShopButton")
	let Quickbuy = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("quickbuy")
	let BuyBackHeader = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("DOTAHUDGoldTooltip")
	let ShopMain = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("Main")

	let ManaContainer = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("ManaProgress")
	let ManaLabel = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("ManaLabel")
	let ManaRegen = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("ManaRegenLabel")

	let BuffsPanel = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("buffs")
	BuffsPanel.style.marginLeft = "39%";

	let HeroStats = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("stats_container")
	HeroStats.style.visibility = "visible"
	let StrAgiInt = HeroStats.FindChildrenWithClassTraverse("ShowStrAgiInt")[0]
	if (StrAgiInt) {
		StrAgiInt.style.visibility = "collapse"	
	}	

	InvRights.style.visibility = "collapse"
	ScanImage.style.visibility = "collapse"
	RightMapContainers.style.visibility = "collapse"
	TopBarDire.style.visibility = "collapse"
	TopBarRadiant.style.visibility = "collapse"
	Inventory.style.visibility = "collapse"
	Inventory2.style.visibility = "visible"
	Inventory2.style.marginRight = "185px"
	Inventory2.style.backgroundImage = "url('file://{images}/custom_game/right_flare.png')"
	Inventory23.style.backgroundImage = "url('file://{images}/custom_game/side_flare.png')"
	Inventory22.style.visibility = "collapse"
	Inventory3.style.visibility = "collapse"
	Inventory4.style.visibility = "collapse"
	Inventory5.style.visibility = "collapse"
	Inventory6.style.visibility = "collapse"
	MainPanelBg.style.marginRight = "235px"
	MainPanelBg.style.backgroundImage = "url('file://{images}/custom_game/ability_bg.png')"
	XP.style.visibility = "collapse"
	LevelStatsFrame.style.visibility = "collapse"
	Stash.style.visibility = "collapse"
	Shop.style.visibility = "collapse"
	QB.style.visibility = "collapse"
	Cour.style.visibility = "collapse"
	ShopButton.style.backgroundImage = "url('file://{images}/custom_game/game_info/none.png')"
	ShopButton.style.boxShadow = "1px 1px 1px transparent"
	Quickbuy.style.marginRight = "56%"
	Quickbuy.style.marginTop = "20px"
	Quickbuy.style.marginBottom = "-11px"
	//BuyBackHeader.style.visibility = "collapse"
	ShopMain.style.visibility = "collapse"
	ManaContainer.style.visibility = "collapse"
	ManaLabel.style.visibility = "collapse"
	ManaRegen.style.visibility = "collapse"

	//StrAgiInt.style.visibility = "collapse"


	//$.Msg("passed code");
}


