-- i hate derma so much
-- and yet here i am, just to suffer

-- also this code is jank.

local PANEL = {}
PANEL.SelectorSize = 100
PANEL.SelectorLRMargins = 0
PANEL.ContentPanelList = {}

PANEL.CurrentPage = 1

function PANEL:RefreshOpenPage()
	for i, v in pairs(self.ContentPanelList) do
		v:Hide()
	end
	if (#self.ContentPanelList == 0) then return end
	self.ContentPanelList[self.CurrentPage]:Show()
end

function PANEL:InternalConstructPage(page)
	page:SetSize(self.ContentPanel:GetWide(), self.ContentPanel:GetTall())
	page:Dock(FILL)
	page:Hide()
end

function PANEL:AddPageQuick()
	local newpage = vgui.Create("DPanel", self.ContentPanel)
	newpage:SetBackgroundColor(Color(0, 0, 0, 0))
	table.insert(self.ContentPanelList, newpage)
	self:InternalConstructPage(newpage)
	self:RefreshOpenPage()
	return newpage
end

function PANEL:AddPage(page_to_add)
	page_to_add:SetParent(self.ContentPanel)
	table.insert(self.ContentPanelList, page_to_add)
	self:InternalConstructPage(page_to_add)
	self:RefreshOpenPage()
	return page_to_add
end

function PANEL:Build()

	if (self.SelectorPanel ~= nil) then
		self.SelectorPanel:Remove()
	end

	self.SelectorPanel = vgui.Create("DPanel")

	self.SelectorPanel:SetParent(self)
	self.ContentPanel:SetParent(self)
	self.SelectorPanel.Paint = nopaint
	self.ContentPanel.Paint = nopaint

	self.SelectorPanel:SetSize(1, self.SelectorSize)
	self.SelectorPanel:Dock(BOTTOM)

	-- Button time START

	local function ButtonPaint( self, w, h )
		if self:IsDown() then
			self.CurColor = DG_Colors["ButtonDownColor"]
		else
			self.CurColor = DG_Colors["ButtonColor"]
		end
		draw.RoundedBox(4, 0, 0, w, h, self.CurColor)
		draw.SimpleText(self:GetText(), self:GetFont(), w / 2, h / 2, DG_Colors["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	margin = vgui.Create("DPanel", self.SelectorPanel)
	margin:SetPaintBackground(false)
	margin:SetWide(self.SelectorLRMargins)
	margin:Dock(LEFT)

	self.SelectorPanel.LeftSuperArrow = vgui.Create("DButton", self.SelectorPanel)
	self.SelectorPanel.LeftSuperArrow.Paint = ButtonPaint
	self.SelectorPanel.LeftSuperArrow:SetText("<<")
	self.SelectorPanel.LeftSuperArrow:Dock(LEFT)
	self.SelectorPanel.LeftSuperArrow:DockMargin(self.SelectorSize / 2, self.SelectorSize / 8, 0, self.SelectorSize / 8)
	function self.SelectorPanel.LeftSuperArrow:DoClick()
		local dpagepanel = self:GetParent():GetParent()
		dpagepanel:ChangePage(1)
	end

	self.SelectorPanel.LeftArrow = vgui.Create("DButton", self.SelectorPanel)
	self.SelectorPanel.LeftArrow.Paint = ButtonPaint
	self.SelectorPanel.LeftArrow:SetText("<")
	self.SelectorPanel.LeftArrow:Dock(LEFT)
	self.SelectorPanel.LeftArrow:DockMargin(self.SelectorSize / 2, self.SelectorSize / 8, 0, self.SelectorSize / 8)
	function self.SelectorPanel.LeftArrow:DoClick()
		local dpagepanel = self:GetParent():GetParent()
		dpagepanel:ChangePage(dpagepanel.CurrentPage - 1)
	end

	margin = vgui.Create("DPanel", self.SelectorPanel)
	margin:SetPaintBackground(false)
	margin:SetWide(self.SelectorLRMargins)
	margin:Dock(RIGHT)

	self.SelectorPanel.RightSuperArrow = vgui.Create("DButton", self.SelectorPanel)
	self.SelectorPanel.RightSuperArrow.Paint = ButtonPaint
	self.SelectorPanel.RightSuperArrow:SetText(">>")
	self.SelectorPanel.RightSuperArrow:Dock(RIGHT)
	self.SelectorPanel.RightSuperArrow:DockMargin(0, self.SelectorSize / 8, self.SelectorSize / 2, self.SelectorSize / 8)
	function self.SelectorPanel.RightSuperArrow:DoClick()
		local dpagepanel = self:GetParent():GetParent()
		dpagepanel:ChangePage(#dpagepanel.ContentPanelList)
	end

	self.SelectorPanel.RightArrow = vgui.Create("DButton", self.SelectorPanel)
	self.SelectorPanel.RightArrow.Paint = ButtonPaint
	self.SelectorPanel.RightArrow:SetText(">")
	self.SelectorPanel.RightArrow:Dock(RIGHT)
	self.SelectorPanel.RightArrow:DockMargin(0, self.SelectorSize / 8, self.SelectorSize / 2, self.SelectorSize / 8)
	function self.SelectorPanel.RightArrow:DoClick()
		local dpagepanel = self:GetParent():GetParent()
		dpagepanel:ChangePage(dpagepanel.CurrentPage + 1)
	end

	self.SelectorPanel.PageDisplay = vgui.Create("DPanel", self.SelectorPanel)
	self.SelectorPanel.PageDisplay:Dock(FILL)
	function self.SelectorPanel.PageDisplay:Paint(w, h)
		draw.SimpleText(self:GetParent():GetParent().CurrentPage, "Duck20pt", w / 2, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	-- Button time END

	self.ContentPanel:SetSize(self:GetWide(), self:GetTall())
	self.ContentPanel:Dock(FILL)
	self.ContentPanel:DockMargin(0, 0, 0, 2)
	for i, v in pairs(self.ContentPanelList) do
		self:InternalConstructPage(v)
	end
	self:RefreshOpenPage()
end

function PANEL:Paint(w, h)
	if (#self.ContentPanelList >= 1) then return end
	draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 255))
	draw.DrawText("No pages!", "DermaDefault", w / 2, h / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:SetSelectorSize(size)
	self.SelectorSize = math.max(size, 0)
	self:Build()
end

function PANEL:SetSelectorLRMargins(size)
	self.SelectorLRMargins = math.max(size, 0)
	self:Build()
end

function PANEL:IsValidPage(pagenum)
	return pagenum == math.Clamp(pagenum, 1, #self.ContentPanelList)
end

function PANEL:ChangePage(pagenum)
	if (#self.ContentPanelList == 0) then return end
	pagenum = math.Clamp(pagenum, 1, #self.ContentPanelList)
	self.ContentPanelList[self.CurrentPage]:Hide()
	self.ContentPanelList[pagenum]:Show()
	self.CurrentPage = pagenum
end

function PANEL:Init()
	if (#self.ContentPanelList ~= 0) then 
		for i, v in ipairs(self.ContentPanelList) do
			v:Remove()
		end
		self.ContentPanelList = {}
	end
	if (self.ContentPanel ~= nil) then
		self.ContentPanel:Remove()
	end
	self.ContentPanel = vgui.Create("DPanel")
	self:Build()
end

function PANEL:Remove()
	if (self.SelectorPanel ~= nil) then
		self.SelectorPanel:Remove()
	end
	if (self.ContentPanel ~= nil) then
		self.ContentPanel:Remove()
	end
	if (#self.ContentPanelList ~= 0) then 
		for i, v in ipairs(self.ContentPanelList) do
			v:Remove()
		end
		self.ContentPanelList = {}
	end
end

vgui.Register("DPagePanel", PANEL, "DPanel")