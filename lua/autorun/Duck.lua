DuckLevels = {}

if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("ducklevels/config/sh_config_levels.lua")
	AddCSLuaFile("ducklevels/client/cl_duckgui.lua")
	AddCSLuaFile("ducklevels/client/vgui/cl_dpagepanel.lua")
else
	DuckLevels.Client = {}
	DuckLevels.Client.Stats = {}
	include("ducklevels/config/sh_config_levels.lua")
	hook.Add("Initialize", "DuckClientInit", function()
		include("ducklevels/client/vgui/cl_dpagepanel.lua")
		include("ducklevels/client/cl_duckgui.lua")
	end)
end