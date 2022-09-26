
--[[
	SetIconSize(size)	- sets the width and height of the inventory item.
	SetItem(item)		- uses a duck item table to set everything automagically
]]

local PANEL = {}
PANEL.Size = 64

-- colors intended for fallback if there's no icon or model
-- probably should make these editable easily from the outside but im laaazy!! >~<
PANEL.FallbackColor = color_white
PANEL.EmptyBGColor = Color(255, 255, 255, 170)
PANEL.LabelBGColor = Color(0, 0, 0, 150)
PANEL.RandomColors = {
	Color(252, 171, 105),
	Color(80, 255, 147),
	Color(78, 199, 255),
	Color(255, 162, 250),
	Color(239, 255, 97)
}

function PANEL:Rebuild()
	self:SetSize(self.Size, self.Size)
end

function PANEL:Init()
	self.Item = {}
	self.Item["name"] = nil
	self.Item["icon"] = nil
	self.Item["modelpath"] = nil
	self.Item["fallbackcolor"] = self.RandomColors[math.random(1, #self.RandomColors)] -- this doesn't need to exist on the server or get sent to clients...
	self:Rebuild()
end

function PANEL:SetIconSize(size)
	self.Size = size
	self:Rebuild()
end

function PANEL:Paint(w, h)
	if (self.Item["name"] == nil) then
		-- we have no item in this slot so we draw the empty slot
		draw.RoundedBox(4, 0, 0, w, h, self.EmptyBGColor)
	else
		draw.RoundedBox(4, 0, 0, w, h, self.Item["fallbackcolor"])
		draw.RoundedBoxEx(4, 0, (h / 5) * 4, w, h / 5, self.LabelBGColor, false, false, true, true)
		draw.SimpleText(self.Item["name"], "DuckLabel", w / 2, ((h / 5) * 4) + (h / 10), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end


function PANEL:SetItemName(name)
	self.Item["name"] = name
end

function PANEL:SetItemIcon(icon)
	self.Item["icon"] = icon
end

function PANEL:SetItemModel(modelpath)
	self.Item["modelpath"] = modelpath
end

function PANEL:SetItem(newitem)
	self.Item = newitem
end

function PANEL:GetItem()
	return self.Item
end

-- by default you can use this element as a way to display an item
-- this magic function basically makes it so it's an inventory item instead of a pretty display
function PANEL:MakeThisAnInventoryItem()
	self:Receiver("DuckyInventoryItem", function(reciever, droppeditems, droppedbool, menuind, x, y)
		if (droppedbool) then
			local old_reciever_item = reciever:GetItem()
			reciever:SetItem(droppeditems[1]:GetItem())
			droppeditems[1]:SetItem(old_reciever_item)
		end
	end, {})
	self:Droppable("DuckyInventoryItem")
end

vgui.Register("DuckyInventorySlot", PANEL, "DPanel")