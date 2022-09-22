
-- util functions

function VW(num)
	return (num * ScrW()) / 100
end

function VH(num)
	return (num * ScrH()) / 100
end

function Pct(num, parent)
	local w, h
	if (parent == nil) then
		w = ScrW()
		h = ScrH()
	else
		w, h = parent:GetSize()
	end
	return (num * w) / 100, (num * h) / 100
end

function DuckLevels.DrawRank(x, y, w, rankNum, tourNum)

	local inset = w / 4
	local hoffset

	if(DuckLevels.DefinedLevels[rankNum] == nil) then
		hoffset = 0
	else
		hoffset = DuckLevels.DefinedLevels[rankNum][4]
	end

	surface.SetDrawColor(255, 255, 255, 255)

	if(DuckLevels.DefinedToursMats[tourNum] == nil) then
		surface.SetMaterial(DuckLevels.NilTour)
	else
		surface.SetMaterial(DuckLevels.DefinedToursMats[tourNum])
	end

	surface.DrawTexturedRect(x, y + (hoffset / w), w, w)

	if(DuckLevels.DefinedLevelsMats[rankNum] == nil) then
		if(rankNum == 0) then
			surface.SetMaterial(DuckLevels.InitialRankMat)
		else
			surface.SetMaterial(DuckLevels.NilLevel)
		end
	else
		surface.SetMaterial(DuckLevels.DefinedLevelsMats[rankNum][2])
	end

	surface.DrawTexturedRect(x + inset, y + inset + hoffset, w - inset * 2, w - inset * 2)

end


DuckLevels.DefinedLevelsMats = {}
DuckLevels.DefinedToursMats = {}

for i, lvl in ipairs(DuckLevels.DefinedLevels) do
	DuckLevels.DefinedLevelsMats[i] = {lvl[1], Material( lvl[3], "smooth" )}
end

for i, tour in ipairs(DuckLevels.DefinedTours) do
	DuckLevels.DefinedToursMats[i] = Material(tour)
end

-----------------------
-----------------------
-----------------------
-----------------------

function DrawKilledStats(ply, rank, tour)

	local height = VH(15)

	-- Main BG Panel that shows up when someone kills you.
	local killedPanel = vgui.Create( "DPanel" )
	killedPanel:SetPos(VW(33), ScrH() - height)
	killedPanel:SetSize(VW(33), height)

	killedPanel.Paint = function(self, w, h)
		surface.SetDrawColor(64, 64, 64, 230)
		surface.DrawRect(0, 0, w, h)
	end

	-- Gradient to apply to the main BG
	local gradient = vgui.Create( "DImage" )
	gradient:SetParent(killedPanel)
	gradient:SetImage("duckyranks/gradient.png", "phoenix_storms/pack2/darkgrey")
	gradient:SetImageColor(Color(0, 0, 0, 80))
	gradient:Dock( FILL )

	-- Background for the rank icon, plus the rank itself.
	local rankBg = vgui.Create( "DPanel" )
	rankBg:SetParent(killedPanel)
	rankBg:Dock( LEFT )
	rankBg:SetSize(height, height)
	rankBg.Paint = function(self, w, h)
		surface.SetDrawColor(120, 120, 120, 150)
		surface.DrawRect(0, 0, w, h)
		DuckLevels.DrawRank(Pct(5, rankBg), Pct(5, rankBg), w - Pct(5, rankBg) * 2, rank, tour)
	end

	-- Background for everything that isn't the rank icon. Has the player info on who killed ya.
	local textContainer = vgui.Create( "DPanel" )
	textContainer:SetParent(killedPanel)
	textContainer:Dock( FILL )
	textContainer.Paint = function(self, w, h)
		local centerX, centerY = Pct(50, textContainer)
		local _, labelPosY = Pct(10, textContainer)

		local youvediedlabel = {
			text = "You've been killed by:",
			pos = {centerX, labelPosY},
			font = "Roboto45pt",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_TOP
		}

		_, labelPosY = Pct(54, textContainer)
		local playernamelabel = {
			text = ply,
			pos = {centerX, labelPosY},
			font = "Roboto30pt",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER
		}

		_, labelPosY = Pct(90, textContainer)
		local playerranklabel = {
			text = DuckLevels.NumToRankName(rank),
			pos = {centerX, labelPosY},
			font = "Roboto25pt",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_BOTTOM
		}

		draw.Text(youvediedlabel)
		draw.Text(playernamelabel)
		draw.Text(playerranklabel)

	end
	
	killedPanel:MoveTo(VW(33), ScrH(), 0.5, 4, 1.5)

	timer.Create("DuckyPanelKiller", 5, 0, function()
		killedPanel:Remove()
	end)

end

function DuckyButtonPaint( self, w, h )
	if self:IsDown() then
		self.CurColor = Color(48, 48, 48, 255)
	else
		self.CurColor = Color(64, 64, 64, 255)
	end
	draw.RoundedBox(4, 0, 0, w, h, self.CurColor)
end


function OpenStatsMenu()

	-- The main window frame.
	local statsFrame = vgui.Create( "DFrame" )
		statsFrame:SetSize(VW(60), VW(60) / 1.5)
		statsFrame:Center()
		statsFrame:SetTitle("")
		statsFrame:SetVisible(true)
		statsFrame:SetDraggable(false)
		statsFrame:SetSizable(false)
		statsFrame:ShowCloseButton(false)
		statsFrame:SetBackgroundBlur(true)
		statsFrame:MakePopup()
		statsFrame.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, h, Color(32, 32, 32, 253))
		end

	-- The close button in the top right corner.
	local closeButton = vgui.Create( "DImageButton", statsFrame )
		closeButton:SetText("")
		closeButton:SetImage( "duckyranks/xbutton.png", "icon16/bomb.png" )
		closeButton:SetSize(VW(1), VW(1))
		closeButton:AlignRight(VW(0.33))
		closeButton:AlignTop(VW(0.33))
		closeButton.DoClick = function()
			statsFrame:Remove()
		end

	-- This invisible panel holds all of the main contents of the window excluding the title bar at the top.
	local contentsPanel = vgui.Create( "DPanel", statsFrame )
		contentsPanel:Dock( BOTTOM )
		local _, sizeY = Pct(95, statsFrame)
		contentsPanel:SetSize(statsFrame:GetWide(), sizeY)
		contentsPanel.Paint = function( self, w, h ) end

	-- Holds the left column items.
	local leftColumnPanel = vgui.Create( "DPanel", contentsPanel )
		leftColumnPanel:Dock( LEFT )
		leftColumnPanel:SetSize(Pct(15, contentsPanel), contentsPanel:GetTall())
		leftColumnPanel.Paint = function( self, w, h )
		end

	-- This panel is in the left column.
	-- Displays the rank in the top left corner of the window
	local rankIconPanel = vgui.Create( "DPanel", leftColumnPanel )
		rankIconPanel:Dock( TOP )
		rankIconPanel:SetSize(leftColumnPanel:GetWide(), leftColumnPanel:GetWide())
		rankIconPanel.Paint = function( self, w, h )
			draw.RoundedBox(4, 0, 0, w, h, Color(64, 64, 64, 70))
			DuckLevels.DrawRank(VW(0.5), VW(0.5), w - VW(1), 0, 1) -- TODO: server need put value >:(
		end

	-- This panel is in the left column.
	-- Displays your playermodel in the bottom left for pretties.
	local playermodelView = vgui.Create( "DPanel", leftColumnPanel )
		playermodelView:Dock( BOTTOM )
		playermodelView:SetSize(leftColumnPanel:GetTall() / 2.5, leftColumnPanel:GetTall() / 2.5)
		playermodelView.Paint = function( self, w, h )
			draw.RoundedBox(4, 0, 0, w, h, Color(64, 64, 64, 70))
		end

	local playermodelView = vgui.Create( "DModelPanel", playermodelView )
		playermodelView:Dock( FILL )
		playermodelView:SetModel(LocalPlayer():GetModel())
		playermodelView:SetFOV(40)
		playermodelView:SetCursor("arrow")
		local plymdl = playermodelView:GetEntity()
		plymdl:SetAngles(Angle(0, 75, 0))
		playermodelView.LayoutEntity = function(ent) return end
		playermodelView.Entity.GetPlayerColor = function() return LocalPlayer():GetPlayerColor() end

	-- This panel is in the left column.
	-- It's the little middle bit with the buttons that swap between the leaderboard and stuff.
	local switcherPanel = vgui.Create( "DPanel", leftColumnPanel )
		switcherPanel:Dock( FILL )
		switcherPanel:DockMargin(0, VH(0.5), 0, VH(0.5))
		switcherPanel.Paint = function( self, w, h )
			draw.RoundedBox(4, 0, 0, w, h, Color(64, 64, 64, 70))
		end


	local tabsArray = {}
	local function HideAllPanels(table)
		for i, v in ipairs(table) do
			v:SetVisible(false)
		end
	end

	-- Holds the right column items.
	local rightColumnPanel = vgui.Create( "DPanel", contentsPanel )
		rightColumnPanel:Dock( FILL )
		rightColumnPanel:DockMargin(VW(0.25), 0, 0, 0)
		rightColumnPanel.Paint = function( self, w, h ) end

	-- Exists within the right column.
	-- Shows the player stats.
	local statsPanel = vgui.Create("DPanel", rightColumnPanel)
		statsPanel:SetSize(contentsPanel:GetWide() - leftColumnPanel:GetWide(), contentsPanel:GetTall())
		statsPanel:SetPos(rightColumnPanel:GetPos())
		statsPanel.Paint = function( self, w, h ) draw.RoundedBox(4, 0, 0, w, h, Color(80, 80, 80, 50)) end
		tabsArray[1] = statsPanel

		local tPicture = vgui.Create("DImage", statsPanel)
			tPicture:SetImage("duckyranks/badguy.png", "phoenix_storms/pack2/darkgrey")
			tPicture:SetSize(377 * (ScrW() / 1920), 534 * (ScrW() / 1920))
			tPicture:Center(0)

		local bProgressBar = vgui.Create("DPanel", statsPanel)
			bProgressBar:Dock( BOTTOM )
			bProgressBar:SetSize(1, Pct(5, statsPanel))
			bProgressBar:InvalidateParent(true)
			bProgressBar.Paint = function( self, w, h ) draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 50)) end

		local lStatsColumn = vgui.Create("DPanel", statsPanel)
			lStatsColumn:Dock( LEFT )
			lStatsColumn:SetSize(Pct(25, statsPanel), 1)
			lStatsColumn:InvalidateParent(true)
			lStatsColumn.Paint = function( self, w, h ) draw.RoundedBox(4, 0, 0, w, h, Color(80, 80, 80, 50)) end

			local kdDisplay = vgui.Create("DPanel", lStatsColumn)
				


		local rStatsColumn = vgui.Create("DPanel", statsPanel)
			rStatsColumn:Dock( RIGHT )
			rStatsColumn:SetSize(Pct(25, statsPanel), 1)
			rStatsColumn:InvalidateParent(true)
			rStatsColumn.Paint = function( self, w, h ) draw.RoundedBox(4, 0, 0, w, h, Color(80, 80, 80, 50)) end

		local bStatsBar = vgui.Create("DPanel", statsPanel)
			bStatsBar:Dock( BOTTOM )
			bStatsBar:SetSize(1, Pct(10, statsPanel))
			bStatsBar:InvalidateParent(true)
			bStatsBar.Paint = function( self, w, h ) draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 50)) end

		local bVerdictBar = vgui.Create("DPanel", statsPanel)
			bVerdictBar:Dock( TOP )
			bVerdictBar:SetSize(1, Pct(10, statsPanel))
			bVerdictBar:InvalidateParent(true)
			bVerdictBar.Paint = function( self, w, h ) draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 50)) end


	local leaderboardPanel = vgui.Create("DPanel", rightColumnPanel)
		leaderboardPanel:SetSize(contentsPanel:GetWide() - leftColumnPanel:GetWide(), contentsPanel:GetTall())
		leaderboardPanel:SetPos(rightColumnPanel:GetPos())
		leaderboardPanel.Paint = function( self, w, h ) draw.RoundedBox(4, 0, 0, w, h, Color(0, 255, 0, 10)) end
		tabsArray[2] = leaderboardPanel

	local rankListPanel = vgui.Create("DPanel", rightColumnPanel)
		rankListPanel:SetSize(contentsPanel:GetWide() - leftColumnPanel:GetWide(), contentsPanel:GetTall())
		rankListPanel:SetPos(rightColumnPanel:GetPos())
		rankListPanel.Paint = function( self, w, h ) draw.RoundedBox(4, 0, 0, w, h, Color(255, 0, 255, 10)) end
		tabsArray[3] = rankListPanel


	local myStatsButton = vgui.Create( "DButton", switcherPanel)
		myStatsButton:Dock( TOP )
		myStatsButton:SetTall(VH(3))
		myStatsButton:DockMargin(VW(0.5), VW(0.5), VW(0.5), 0)
		myStatsButton:SetText("My Stats")
		myStatsButton:SetTextColor( Color(255, 255, 255) )
		myStatsButton.Paint = DuckyButtonPaint
		function myStatsButton:DoClick()
			HideAllPanels(tabsArray)
			tabsArray[1]:SetVisible(true)
		end

	local leaderboardButton = vgui.Create( "DButton", switcherPanel)
		leaderboardButton:Dock( TOP )
		leaderboardButton:SetTall(VH(3))
		leaderboardButton:DockMargin(VW(0.5), VW(0.25), VW(0.5), 0)
		leaderboardButton:SetText("Leaderboard")
		leaderboardButton:SetTextColor( Color(255, 255, 255) )
		leaderboardButton.Paint = DuckyButtonPaint
		function leaderboardButton:DoClick()
			HideAllPanels(tabsArray)
			tabsArray[2]:SetVisible(true)
		end

	local rankListButton = vgui.Create( "DButton", switcherPanel)
		rankListButton:Dock( TOP )
		rankListButton:SetTall(VH(3))
		rankListButton:DockMargin(VW(0.5), VW(0.25), VW(0.5), 0)
		rankListButton:SetText("Rank List")
		rankListButton:SetTextColor( Color(255, 255, 255) )
		rankListButton.Paint = DuckyButtonPaint
		function rankListButton:DoClick()
			HideAllPanels(tabsArray)
			tabsArray[3]:SetVisible(true)
		end

		HideAllPanels(tabsArray)
		tabsArray[1]:SetVisible(true)

end

concommand.Add("duckystats_open_stats_menu", OpenStatsMenu)


