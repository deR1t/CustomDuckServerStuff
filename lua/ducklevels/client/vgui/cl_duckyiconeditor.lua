local PANEL = {}

function PANEL:Init()

	local icon = self:GetParent()
	print(icon)
	self:SetParent(nil)

	self:SetSize(640, 480)
	self:Center()

end

vgui.Register("DuckIconEditor", PANEL, "DFrame")