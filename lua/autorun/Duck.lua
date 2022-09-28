DuckLevels = {}

function DuckFindEntHead(ent)

	ent:SetupBones()

	local valvehead = ent:LookupBone("ValveBiped.Bip01_Head1")
	if (valvehead) then
		return valvehead
	end

	for i = 0, ent:GetBoneCount() do
		local bone = ent:GetBoneName(i)
		if (string.find(bone, "head")) then
			return ent:LookupBone(bone)
		end
	end

end

if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("ducklevels/config/sh_config.lua")
	AddCSLuaFile("ducklevels/client/vgui/cl_dpagepanel.lua")
	AddCSLuaFile("ducklevels/client/vgui/cl_duckyiconeditor.lua")
	AddCSLuaFile("ducklevels/client/vgui/cl_duckyinventory.lua")
	AddCSLuaFile("ducklevels/client/cl_duckgui.lua")
else
	DuckLevels.Client = {}
	DuckLevels.Client.Stats = {}
	include("ducklevels/config/sh_config.lua")
	hook.Add("Initialize", "DuckClientInit", function()
		include("ducklevels/client/vgui/cl_dpagepanel.lua")
		include("ducklevels/client/vgui/cl_duckyiconeditor.lua")
		include("ducklevels/client/vgui/cl_duckyinventory.lua")
		include("ducklevels/client/cl_duckgui.lua")
	end)
end