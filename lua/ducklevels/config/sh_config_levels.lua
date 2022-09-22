-- Level name, total xp to get to level, level icon path
DuckLevels.InitialLevel = {"Recruit", 0, "level_icons/recruit.png"}
DuckLevels.DefinedLevels = {
    {"Private", 7500, "level_icons/private.png"},
    {"Corporal", 10000, "level_icons/corporal.png"},
    {"Corporal Grade 1", 15000, "level_icons/corporal_gr1.png"},
    {"Sergeant", 20000, "level_icons/sergeant.png"},
    {"Sergeant Grade 1", 26250, "level_icons/sergeant_gr1.png"},
    {"Sergeant Grade 2", 32500, "level_icons/sergeant_gr2.png", 4},
    {"Warrant Officer", 45000, "level_icons/warrantofficer.png"},
    {"Warrant Officer Grade 1", 78000, "level_icons/warrantofficer_gr1.png"},
    {"Warrant Officer Grade 2", 111000, "level_icons/warrantofficer_gr2.png"},
    {"Warrant Officer Grade 3", 144000, "level_icons/warrantofficer_gr3.png"},
    {"Captain", 210000, "level_icons/captain.png"},
    {"Captain Grade 1", 233000, "level_icons/captain_gr1.png"},
    {"Captain Grade 2", 256000, "level_icons/captain_gr2.png"},
    {"Captain Grade 3", 279000, "level_icons/captain_gr3.png"},
    {"Major", 325000, "level_icons/major.png", -8},
    {"Major Grade 1", 350000, "level_icons/major_gr1.png", -8},
    {"Major Grade 2", 375000, "level_icons/major_gr2.png", -8},
    {"Major Grade 3", 400000, "level_icons/major_gr3.png", -4},
    {"Lt. Colonel", 450000, "level_icons/ltcolonel.png", -6},
    {"Lt. Colonel Grade 1", 480000, "level_icons/ltcolonel_gr1.png", -6},
    {"Lt. Colonel Grade 2", 510000, "level_icons/ltcolonel_gr2.png", -6},
    {"Lt. Colonel Grade 3", 540000, "level_icons/ltcolonel_gr3.png", -6},
    {"Commander", 600000, "level_icons/commander.png", -6},
    {"Commander Grade 1", 650000, "level_icons/commander_gr1.png", -6},
    {"Commander Grade 2", 700000, "level_icons/commander_gr2.png", -6},
    {"Commander Grade 3", 750000, "level_icons/commander_gr3.png", -6},
    {"Colonel", 850000, "level_icons/colonel.png"},
    {"Colonel Grade 1", 960000, "level_icons/colonel_gr1.png", -5},
    {"Colonel Grade 2", 1070000, "level_icons/colonel_gr2.png", -5},
    {"Colonel Grade 3", 1180000, "level_icons/colonel_gr3.png", -5},
    {"Brigadier", 1400000, "level_icons/brigadier.png"},
    {"Brigadier Grade 1", 1520000, "level_icons/brigadier_gr1.png"},
    {"Brigadier Grade 2", 1640000, "level_icons/brigadier_gr2.png"},
    {"Brigadier Grade 3", 1760000, "level_icons/brigadier_gr3.png"},
    {"General", 2000000, "level_icons/general.png"},
    {"General Grade 1", 2200000, "level_icons/general_gr1.png"},
    {"General Grade 2", 2350000, "level_icons/general_gr2.png"},
    {"General Grade 3", 2500000, "level_icons/general_gr3.png"},
    {"General Grade 4", 2650000, "level_icons/general_gr4.png"},
    {"Field Marshall", 3000000, "level_icons/fieldmarshall.png"},
    {"Hero", 3700000, "level_icons/hero.png"},
    {"Legend", 4600000, "level_icons/legend.png"},
    {"Mythic", 5650000, "level_icons/mythic.png"},
    {"Noble", 7000000, "level_icons/noble.png"},
    {"Eclipse", 8500000, "level_icons/eclipse.png"},
    {"Nova", 11000000, "level_icons/nova.png"},
    {"Forerunner", 13000000, "level_icons/forerunner.png"},
    {"Reclaimer", 16500000, "level_icons/reclaimer.png"},
    {"Inheritor", 20000000, "level_icons/inheritor.png"},
}

function DuckLevels.NumToLevelName(num)
	if (num == 0) then return DuckLevels.InitialLevel[1] end
	local lvl = DuckLevels.DefinedLevels[num]
	if (lvl == nil) then
		return "Unknown"
	end
	return lvl[1]
end

if (CLIENT) then

	function DuckyCreateFonts()
		surface.CreateFont("Duck20pt", { font = "Roboto", size = 20 * (ScrH() / 1080) })
		surface.CreateFont("Duck25pt", { font = "Roboto", size = 25 * (ScrH() / 1080) })
		surface.CreateFont("DuckBold25pt", { font = "Roboto", size = 25 * (ScrH() / 1080), weight = 600 })
		surface.CreateFont("Duck30pt", { font = "Roboto", size = 30 * (ScrH() / 1080) })
		surface.CreateFont("Duck35pt", { font = "Roboto", size = 35 * (ScrH() / 1080) })
		surface.CreateFont("Duck45pt", { font = "Roboto", size = 45 * (ScrH() / 1080) })
	end

	hook.Add( "OnScreenSizeChanged", "DuckyFontHook", DuckyCreateFonts)
	DuckyCreateFonts()

	DuckLevels.InitialLevelMat = Material(DuckLevels.InitialLevel[3], "smooth")
	DuckLevels.NilLevel = Material("level_icons/missingLevel.png", "smooth")

end