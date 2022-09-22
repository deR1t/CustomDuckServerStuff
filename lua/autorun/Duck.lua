DuckLevels = {}

if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("ducklevels/config/config_levels.lua")
    AddCSLuaFile("ducklevels/client/duckgui.lua")
    AddCSLuaFile("ducklevels/client/vgui/dpagepanel.lua")
else
	DuckLevels.Client = {}
	DuckLevels.Client.Stats = {}
    include("ducklevels/config/config_levels.lua")
    hook.Add("Initialize", "DuckClientInit", function()
		include("ducklevels/client/vgui/dpagepanel.lua")
		include("ducklevels/client/duckgui.lua")
	end)
end