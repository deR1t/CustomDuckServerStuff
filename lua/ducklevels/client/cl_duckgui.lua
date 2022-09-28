--[[
	FUNCTIONS:
	OpenStats() - Opens stats gui.
	ConstructStatsPanel() - Creates the derma stats gui, and returns the parent dpanel.
]]

DuckLevels.Client.Stats["Performance Points"] = 0
DuckLevels.Client.Stats["Pointshop Points"] = 0
DuckLevels.Client.Stats["Rank"] = -1

DuckLevels.Client.Stats["Rounds Played"] = 85
DuckLevels.Client.Stats["Rounds Won"] = 13
DuckLevels.Client.Stats["Kills"] = 0
DuckLevels.Client.Stats["Deaths"] = 73
DuckLevels.Client.Stats["Suicides"] = 12
DuckLevels.Client.Stats["Headshots"] = 0
DuckLevels.Client.Stats["Total Damage Dealt"] = 63
DuckLevels.Client.Stats["Total Damage Recieved"] = 7338

DuckLevels.Client.Stats["Jumps"] = 1234

DuckLevels.Client.Stats["Distance Walked"] = 1234 -- hammer units -> kilometers magic number (0.00001905)
DuckLevels.Client.Stats["Bodies Identified"] = 35
DuckLevels.Client.Stats["Average Survival Time"] = "0:03"
DuckLevels.Client.Stats["Most Kills In One Game"] = 3

DuckLevels.Client.Stats["Evil Rounds"] = 104
DuckLevels.Client.Stats["Innocent Rounds"] = 27
DuckLevels.Client.Stats["Detective Rounds"] = 3
DuckLevels.Client.Stats["Credits Used"] = 13
DuckLevels.Client.Stats["RDMs"] = 536
DuckLevels.Client.Stats["Karma Lost"] = 4160

DuckLevels.Client.Stats["Favorite Weapons"] = {} -- some weird table idfk

------------
-- fontz

function DuckyCreateFonts()
	surface.CreateFont("DuckLabel", { font = "Roboto", size = 15 * (ScrH() / 1080) })
	surface.CreateFont("Duck20pt", { font = "Roboto", size = 20 * (ScrH() / 1080) })
	surface.CreateFont("Duck25pt", { font = "Roboto", size = 25 * (ScrH() / 1080) })
	surface.CreateFont("DuckBold25pt", { font = "Roboto", size = 25 * (ScrH() / 1080), weight = 600 })
	surface.CreateFont("Duck30pt", { font = "Roboto", size = 30 * (ScrH() / 1080) })
	surface.CreateFont("Duck35pt", { font = "Roboto", size = 35 * (ScrH() / 1080) })
	surface.CreateFont("Duck45pt", { font = "Roboto", size = 45 * (ScrH() / 1080) })
end

hook.Add( "OnScreenSizeChanged", "DuckyFontHook", DuckyCreateFonts)
DuckyCreateFonts()

-----------
-- GUI STUFF DOWN HERE!!!

DG_BoxRoundedness = 5
DG_WhiteColors = {
	MenuBackground = Color(255, 255, 255),
	Background = Color(245, 245, 245),
	TextColor = Color(16, 16, 16),
	ButtonColor = Color(0, 0, 0, 50),
	ButtonDownColor = Color(0, 0, 0, 80),
	InventoryHighlight = Color(140, 140, 255),
	ShopHighlight = Color(187, 130, 236),
	StatsHighlight = Color(255, 160, 100),
	LeaderboardHighlight = Color(130, 190, 130),
	SettingsHighlight = Color(0, 0, 0),
	Highlight = Color(140, 140, 255), -- pls no chang, it (should) be the same as the inventory highlight.
	TabColor = Color(150, 150, 150),
	TabHighlight = Color(110, 110, 250),
	TabClickColor = Color(0, 0, 0),
	PanelColor = Color(0, 0, 0, 30),
	PanelHigh = Color(255, 255, 255, 120),
	PanelSuperHigh = Color(255, 255, 255, 180)
}

DG_DarkColors = {
	MenuBackground = Color(75, 75, 75),
	Background = Color(64, 64, 64),
	TextColor = Color(245, 245, 245),
	ButtonColor = Color(255, 255, 255, 50),
	ButtonDownColor = Color(255, 255, 255, 80),
	InventoryHighlight = Color(100, 100, 255),
	ShopHighlight = Color(170, 70, 255),
	StatsHighlight = Color(255, 160, 100),
	LeaderboardHighlight = Color(130, 250, 130),
	SettingsHighlight = Color(255, 255, 255),
	Highlight = Color(80, 80, 255), -- pls no chang, it (should) be the same as the inventory highlight.
	TabColor = Color(170, 170, 170),
	TabHighlight = Color(110, 110, 250),
	TabClickColor = Color(0, 0, 0),
	PanelColor = Color(255, 255, 255, 10),
	PanelHigh = Color(255, 255, 255, 40),
	PanelSuperHigh = Color(255, 255, 255, 50)
}

DG_Colors = DG_WhiteColors

function HideAllPanels(list)
	for i, panel in pairs(list) do
		panel:Hide()
	end
end

function NoPaint() end
function FloatingPanel(s, w, h) draw.RoundedBox(DG_BoxRoundedness, 0, 0, w, h, DG_Colors["PanelColor"]) end
function ButtonPaint( self, w, h )
	if self:IsDown() then
		self.CurColor = DG_Colors["ButtonDownColor"]
	else
		self.CurColor = DG_Colors["ButtonColor"]
	end
	draw.RoundedBox(4, 0, 0, w, h, self.CurColor)
	draw.SimpleText(self.DText, self.DFont, w / 2, h / 2, DG_Colors["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
function TabPaint( self, w, h )
	self.CurColor = DG_Colors["TabColor"]
	if self:IsHovered() then
		self.CurColor = DG_Colors["Highlight"]
	end
	if self:IsDown() then
		self.CurColor = DG_Colors["TabClickColor"]
	end
	draw.SimpleText(self:GetText(), "Duck25pt", w / 2, h / 2, self.CurColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function DuckyCreatePrettyDFrame(window_title)

	local DG_Frame = vgui.Create("DPanel")
	DG_Frame.DG_ContentPanels = {}

	local bar_height = (30 / 1080) * ScrH()

	function DG_Frame:Paint(w, h)
		draw.RoundedBox(DG_BoxRoundedness, 0, 0, w, h, DG_Colors["MenuBackground"])
		draw.RoundedBoxEx(DG_BoxRoundedness, 0, bar_height, w, h - bar_height, DG_Colors["Background"], false, false, true, true)
	end

		DG_Frame.DG_MenuBar = vgui.Create("DPanel", DG_Frame)
		DG_Frame.DG_MenuBar:SetSize(DG_Frame:GetWide(), bar_height)
		DG_Frame.DG_MenuBar:Dock(TOP)
		DG_Frame.DG_MenuBar.Paint = NoPaint

			local DG_TitleLabel = vgui.Create("DLabel", DG_Frame.DG_MenuBar)
			DG_TitleLabel:Dock(LEFT)
			DG_TitleLabel:DockMargin(8, 0, 8, 0)
			DG_TitleLabel:SetFont("DuckBold25pt")
			DG_TitleLabel:SetTextColor(DG_Colors["TextColor"])
			DG_TitleLabel:SetText(window_title)
			DG_TitleLabel:SizeToContents()

			local DG_CloseButton = vgui.Create("DButton", DG_Frame.DG_MenuBar)
			DG_CloseButton:SetSize(bar_height, bar_height)
			DG_CloseButton:Dock(RIGHT)
			DG_CloseButton:SetText("")
			function DG_CloseButton:Paint(w, h)
				draw.SimpleText("X", "Duck25pt", w / 2, h / 2, DG_Colors["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			function DG_CloseButton:DoClick()
				DG_Frame:Hide()
			end

		DG_Frame.DG_Contents = vgui.Create("DPanel", DG_Frame)
		DG_Frame.DG_Contents:SetSize(12, 12)
		DG_Frame.DG_Contents:Dock(FILL)
		DG_Frame.DG_Contents.Paint = NoPaint

	return DG_Frame

end

------------------------------
-- STATS PANEL CONSTRUCTION --
------------------------------
function ConstructStatsPanel()

	local DG_Frame = DuckyCreatePrettyDFrame("Duck Menu")
	DG_Frame:SetMinimumSize(1000, 700)
	DG_Frame:SetSize(ScrW() / 1.5, ScrH() / 1.5)
	DG_Frame:Center()
	DG_Frame:MakePopup()
	DG_Frame:Hide()
	DG_Frame.DG_Contents:InvalidateParent(true)
	print(DG_Frame:GetWide() .. "  " .. DG_Frame.DG_Contents:GetWide())

	local DG_FrameHighlight = vgui.Create("DPanel", DG_Frame)
	DG_FrameHighlight:Dock(TOP)
	DG_FrameHighlight:SetTall(2)
	function DG_FrameHighlight:Paint(w, h) draw.RoundedBox(0, 0, 0, w, h, DG_Colors["Highlight"]) end

		local function QuickDivider(parent, l, r) -- specifically to separate the tab buttons here.
			local DG_Div = vgui.Create("DPanel", parent)
			DG_Div:Dock(LEFT)
			DG_Div:DockMargin(l, 0, r, 0)
			DG_Div:SetWide(1)
			function DG_Div:Paint(w, h)
				surface.SetDrawColor(DG_Colors["TabColor"])
				surface.DrawLine(0, 3, 0, h - 3)
			end
		end

		QuickDivider(DG_Frame.DG_MenuBar, 0, 10)


		local DG_InventoryButton = vgui.Create("DButton", DG_Frame.DG_MenuBar)
		DG_InventoryButton:SetSize(8, 8)
		DG_InventoryButton:Dock(LEFT)
		DG_InventoryButton:DockMargin(0, 2, 8, 2)
		DG_InventoryButton:SetText("Inventory")
		DG_InventoryButton:SetFont("Duck25pt")
		DG_InventoryButton:SetTextColor(Color(0, 0, 0, 0))
		DG_InventoryButton:SizeToContents()
		DG_InventoryButton.Paint = TabPaint
		function DG_InventoryButton:DoClick()
			HideAllPanels(DG_Frame.DG_ContentPanels)
			DG_Frame.DG_ContentPanels["Inventory"]:Show()
			DG_Colors["Highlight"] = DG_Colors["InventoryHighlight"]
		end

		local DG_PointshopButton = vgui.Create("DButton", DG_Frame.DG_MenuBar)
		DG_PointshopButton:SetSize(8, 8)
		DG_PointshopButton:Dock(LEFT)
		DG_PointshopButton:DockMargin(0, 2, 8, 2)
		DG_PointshopButton:SetText("Pointshop")
		DG_PointshopButton:SetFont("Duck25pt")
		DG_PointshopButton:SetTextColor(Color(0, 0, 0, 0))
		DG_PointshopButton:SizeToContents()
		DG_PointshopButton.Paint = TabPaint
		function DG_PointshopButton:DoClick()
			HideAllPanels(DG_Frame.DG_ContentPanels)
			DG_Frame.DG_ContentPanels["Pointshop"]:Show()
			DG_Colors["Highlight"] = DG_Colors["ShopHighlight"]
		end

		local DG_StatsButton = vgui.Create("DButton", DG_Frame.DG_MenuBar)
		DG_StatsButton:SetSize(8, 8)
		DG_StatsButton:Dock(LEFT)
		DG_StatsButton:DockMargin(0, 2, 8, 2)
		DG_StatsButton:SetText("My Stats")
		DG_StatsButton:SetFont("Duck25pt")
		DG_StatsButton:SetTextColor(Color(0, 0, 0, 0))
		DG_StatsButton:SizeToContents()
		DG_StatsButton.Paint = TabPaint
		function DG_StatsButton:DoClick()
			HideAllPanels(DG_Frame.DG_ContentPanels)
			DG_Frame.DG_ContentPanels["Stats"]:Show()
			DG_Colors["Highlight"] = DG_Colors["StatsHighlight"]
		end

		local DG_LeaderboardButton = vgui.Create("DButton", DG_Frame.DG_MenuBar)
		DG_LeaderboardButton:SetSize(8, 8)
		DG_LeaderboardButton:Dock(LEFT)
		DG_LeaderboardButton:DockMargin(0, 2, 8, 2)
		DG_LeaderboardButton:SetText("Leaderboards")
		DG_LeaderboardButton:SetFont("Duck25pt")
		DG_LeaderboardButton:SetTextColor(Color(0, 0, 0, 0))
		DG_LeaderboardButton:SizeToContents()
		DG_LeaderboardButton.Paint = TabPaint
		function DG_LeaderboardButton:DoClick()
			HideAllPanels(DG_Frame.DG_ContentPanels)
			DG_Frame.DG_ContentPanels["Leaderboard"]:Show()
			DG_Colors["Highlight"] = DG_Colors["LeaderboardHighlight"]
		end

		local DG_SettingsButton = vgui.Create("DButton", DG_Frame.DG_MenuBar)
		DG_SettingsButton:SetSize(8, 8)
		DG_SettingsButton:Dock(LEFT)
		DG_SettingsButton:DockMargin(0, 2, 8, 2)
		DG_SettingsButton:SetText("Settings")
		DG_SettingsButton:SetFont("Duck25pt")
		DG_SettingsButton:SetTextColor(Color(0, 0, 0, 0))
		DG_SettingsButton:SizeToContents()
		DG_SettingsButton.Paint = TabPaint
		function DG_SettingsButton:DoClick()
			HideAllPanels(DG_Frame.DG_ContentPanels)
			DG_Frame.DG_ContentPanels["Settings"]:Show()
			DG_Colors["Highlight"] = DG_Colors["SettingsHighlight"]
		end

		local DG_LeftPanel = vgui.Create("DPanel", DG_Frame.DG_Contents)
		DG_LeftPanel:SetSize(DG_Frame:GetWide() / 4.5, 30)
		DG_LeftPanel:Dock(LEFT)
		DG_LeftPanel:DockMargin(8, 8, 0, 8)
		DG_LeftPanel.Paint = FloatingPanel

			local DG_PlayerPanel = vgui.Create("DPanel", DG_LeftPanel)
			DG_PlayerPanel:SetSize(DG_Frame:GetWide() / 4.5, 100)
			DG_PlayerPanel:Dock( TOP )
			DG_PlayerPanel:SetPaintBackground(false)

				local function DrawPictureStat(pic, stat, label)
					local IconSize = (32 / 1080) * ScrH()
					local LabelHeight = IconSize * 1.3
					local Margins = LabelHeight - IconSize
					local TextStat = vgui.Create("DPanel", DG_PlayerPanel)
					local SmallFix = (4 / 1080) * ScrH()

					local TextString = stat .. " " .. label
					local TextX = Margins * 2 + IconSize
					local TextY = (LabelHeight / 2) + SmallFix
					TextStat:Dock(TOP)
					TextStat:SetTall(IconSize * 1.5)
					function TextStat:Paint(w, h)
						surface.SetMaterial(pic)
						surface.SetDrawColor(DG_Colors["TextColor"])
						surface.DrawTexturedRect(Margins, Margins, IconSize, IconSize)
						draw.SimpleText(TextString, "Duck20pt", TextX, TextY, DG_Colors["TextColor"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
				end

				DrawPictureStat(Material("vgui/duck/smallmoney.png"), DuckLevels.Client.Stats["Pointshop Points"], "Points")
				DrawPictureStat(Material("vgui/duck/smallperformance.png"), DuckLevels.Client.Stats["Performance Points"], "Performance")

			local DG_PlayerView = vgui.Create("DModelPanel", DG_LeftPanel)
			DG_PlayerView:Dock( FILL )
			DG_PlayerView:SetModel("models/breen.mdl")
			DG_PlayerView:SetFOV(40)
			DG_PlayerView:SetCursor("arrow")
			DG_PlayerView:GetEntity():SetAngles(Angle(0, 75, 0))
			DG_PlayerView.LayoutEntity = function(ent) return end
			DG_PlayerView.Entity.GetPlayerColor = function() return LocalPlayer():GetPlayerColor() end

		local DG_InventoryContents = vgui.Create("DPanel", DG_Frame.DG_Contents)
		DG_InventoryContents:SetSize(64, 64)
		DG_InventoryContents:Dock(FILL)
		DG_InventoryContents:DockMargin(8, 8, 8, 8)
		DG_InventoryContents.Paint = FloatingPanel
		DG_InventoryContents:InvalidateParent(true)

		local sw = {"Big", "Small", "Silly", "Cool", "Ugly", "Serious", "Extreme", "Calm"}
		local ew = {"Top Hat", "Hat", "Weapon", "Shirt", "Pants", "Accessory"}
		--local coolmdl = {"models/player/ctm_idf_variantb.mdl", "models/player/scout.mdl", "models/props/cs_assault/forklift.mdl", "models/props_c17/oildrum001.mdl", "models/weapons/w_pist_deagle.mdl", "models/weapons/w_c4.mdl"}
		local coolmdl = {}
		local i = 0
		for _, v in pairs(player_manager.AllValidModels()) do
			i = i + 1
			print(i, v)
			coolmdl[i] = v
		end

		for x = 0, 5 do
			for y = 0, 5 do
				local testthing = vgui.Create("DuckyInventorySlot", DG_InventoryContents)
				testthing:SetIconSize((96 / 1080) * ScrH())
				--if (math.random(1, 4) == 1) then
					testthing:SetItemName(sw[math.random(1, #sw)] .. " " .. ew[math.random(1, #ew)])
					testthing:SetItemModel(coolmdl[math.random(1, #coolmdl)])
				--end
				testthing:SetPos((testthing.Size + 4) * x + 4, (testthing.Size + 4) * y + 4)
				testthing:MakeThisAnInventoryItem()
			end
		end

		local DG_PointshopContents = vgui.Create("DPanel", DG_Frame.DG_Contents)
		DG_PointshopContents:SetSize(64, 64)
		DG_PointshopContents:Dock(FILL)
		DG_PointshopContents:DockMargin(8, 8, 8, 8)
		DG_PointshopContents.Paint = FloatingPanel
		DG_PointshopContents:InvalidateParent(true)
		DG_PointshopContents:Hide()


		local DG_StatsContents = vgui.Create("DPagePanel", DG_Frame.DG_Contents)
		DG_StatsContents:SetSize(DG_Frame.DG_Contents:GetWide(), DG_Frame.DG_Contents:GetTall())
		DG_StatsContents:Dock(FILL)
		DG_StatsContents:DockMargin(8, 8, 8, 8)
		DG_StatsContents:Hide()
		DG_StatsContents:SetSelectorSize(40)
		DG_StatsContents:SetSelectorLRMargins((240 * ScrW()) / 1920)
		DG_StatsContents.SelectorPanel.Paint = function (s, w, h) draw.RoundedBoxEx(DG_BoxRoundedness, 0, 0, w, h, DG_Colors["PanelColor"], false, false, true, true) end
		DG_StatsContents.ContentPanel.Paint = function (s, w, h) draw.RoundedBoxEx(DG_BoxRoundedness, 0, 0, w, h, DG_Colors["PanelColor"], true, true, false, false) end
		DG_Frame.DG_Contents:InvalidateParent(true)
		DG_StatsContents:InvalidateParent(true)

			function AddStat(name, parent, statoverride)
				local statpanel = vgui.Create("DPanel", parent)
				statpanel:Dock(TOP)
				statpanel:DockMargin(8, 8, 8, 0)
				statpanel:SetTall(DG_PointshopContents:GetTall() / 6)

				local StatName = DuckLevels.Client.Stats[name]
				function statpanel.Paint(s, w, h)
					draw.RoundedBoxEx(DG_BoxRoundedness, 0, 0, w, h / 2, DG_Colors["PanelSuperHigh"], true, true, false, false)
					draw.RoundedBoxEx(DG_BoxRoundedness, 0, h / 2, w, h / 2, DG_Colors["PanelHigh"], false, false, true, true)
					draw.SimpleText(name, "Duck35pt", w / 2, h / 4, DG_Colors["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					if (statoverride == nil) then
						draw.SimpleText(StatName, "Duck30pt", w / 2, (h / 4) * 3, DG_Colors["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					else
						draw.SimpleText(statoverride(), "Duck30pt", w / 2, (h / 4) * 3, DG_Colors["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				end
			end

			local DG_StatsPage1 = DG_StatsContents:AddPageQuick()
				local DG_Left1 = vgui.Create("DPanel", DG_StatsPage1)
				DG_Left1:Dock(LEFT)
				DG_Left1:SetPaintBackground(false)
				DG_Left1:SetWide(DG_PointshopContents:GetWide() / 2)
				local DG_Right1 = vgui.Create("DPanel", DG_StatsPage1)
				DG_Right1:Dock(FILL)
				DG_Right1:SetPaintBackground(false)
				DG_Right1:SetWide(DG_PointshopContents:GetWide() / 2)

				AddStat("Rounds Played", DG_Left1)
				AddStat("Rounds Won", DG_Left1)
				AddStat("Rounds Lost", DG_Left1, function() return DuckLevels.Client.Stats["Total Damage Dealt"] - DuckLevels.Client.Stats["Rounds Won"] end)
				AddStat("Headshots", DG_Left1)
				AddStat("Suicides", DG_Left1)

				AddStat("Kills", DG_Right1)
				AddStat("Deaths", DG_Right1)
				AddStat("Jumps", DG_Right1)
				AddStat("Bodies Identified", DG_Right1)
				AddStat("Distance Walked", DG_Right1, function() return DuckLevels.Client.Stats["Distance Walked"] * 0.00001905 .. " km" end)


		local DG_LeaderboardContents = vgui.Create("DPanel", DG_Frame.DG_Contents)
		DG_LeaderboardContents:SetSize(64, 64)
		DG_LeaderboardContents:Dock(FILL)
		DG_LeaderboardContents:DockMargin(8, 8, 8, 8)
		DG_LeaderboardContents:Hide()
		DG_LeaderboardContents.Paint = FloatingPanel

		local DG_SettingsContents = vgui.Create("DPanel", DG_Frame.DG_Contents)
		DG_SettingsContents:SetSize(64, 64)
		DG_SettingsContents:Dock(FILL)
		DG_SettingsContents:DockMargin(8, 8, 8, 8)
		DG_SettingsContents:Hide()
		DG_SettingsContents.Paint = FloatingPanel

	DG_Frame.DG_ContentPanels["Inventory"] = DG_InventoryContents
	DG_Frame.DG_ContentPanels["Pointshop"] = DG_PointshopContents
	DG_Frame.DG_ContentPanels["Stats"] = DG_StatsContents
	DG_Frame.DG_ContentPanels["Leaderboard"] = DG_LeaderboardContents
	DG_Frame.DG_ContentPanels["Settings"] = DG_SettingsContents

	return DG_Frame

end

-- Intended for extremely small resolutions!
function LegacyPanelConstruct()

	local DG_Frame = vgui.Create("DFrame")
	DG_Frame:SetSize(ScrW() - 16, ScrH() - 16)
	DG_Frame:SetTitle("Ducky - What a small screen you've got there! - You might be missing some features! :D")
	DG_Frame:Center()
	DG_Frame:SetDraggable(false)
	DG_Frame:SetSizable(true)
	DG_Frame:MakePopup()
	DG_Frame:SetDeleteOnClose(false)
	DG_Frame:Hide()

	local DG_Sheet = vgui.Create("DPropertySheet", DG_Frame)
	DG_Sheet:Dock(FILL)

	local DG_InventoryContents = vgui.Create("DPanel", DG_Sheet)
	DG_InventoryContents:SetPaintBackground(false)
	DG_Sheet:AddSheet("Inventory", DG_InventoryContents)

	local DG_PointshopContents = vgui.Create("DPanel", DG_Sheet)
	DG_PointshopContents:SetPaintBackground(false)
	DG_Sheet:AddSheet("Pointshop", DG_PointshopContents)

	local DG_StatContents = vgui.Create("DPanel", DG_Sheet)
	DG_StatContents:SetPaintBackground(false)
	DG_Sheet:AddSheet("Stats", DG_StatContents)


	return DG_Frame

end

-- initial stats window creation
function MakePanel()
	if (ScrW() >= 1024) then
		DuckLevels.Client.MenuDPanel = ConstructStatsPanel()
	else
		DuckLevels.Client.MenuDPanel = LegacyPanelConstruct()
	end
end

MakePanel()

-- if the gmod window resizes, we make the stats panel again.
hook.Add( "OnScreenSizeChanged", "DuckyRebuildGUIOnResizeHook", MakePanel)

function TogglePanel(panel)
	if (panel:IsVisible()) then
		panel:Hide()
	else
		panel:Show()
	end
end

function OpenStats()
	TogglePanel(DuckLevels.Client.MenuDPanel)
end

-- console command to open the menu
concommand.Add("duck_openstats", OpenStats)

-- pretty background darkening...

hook.Add("HUDPaintBackground", "DuckMenuPaintPrettyDarkBlackScreen", function()
	if (DuckLevels.Client.MenuDPanel:IsVisible()) then
		surface.SetDrawColor(0, 0, 0, 190)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end
end)


-- delete this code if you dont want F3 / F4 to open the menus
hook.Add("PlayerBindPress", "DuckStatsOpenMenuOnF4Press", function(ply, bind, pressed, code)
	if ( string.find( bind, "gm_showspare1" ) ) then
		RunConsoleCommand("duck_openstats")
	end
end)