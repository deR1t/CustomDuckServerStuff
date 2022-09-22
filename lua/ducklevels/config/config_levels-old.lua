-- Level name, total xp to get to level, level icon path, Height offset when drawn on tour backplate
DuckLevels.InitialRank = {"Recruit", 0, "default_rank_icons/recruit.png", 0}
DuckLevels.DefinedLevels = {
    {"Private", 7500, "default_rank_icons/private.png", 0},
    {"Corporal", 10000, "default_rank_icons/corporal.png", 0},
    {"Corporal Grade 1", 15000, "default_rank_icons/corporal_gr1.png", 0},
    {"Sergeant", 20000, "default_rank_icons/sergeant.png", 0},
    {"Sergeant Grade 1", 26250, "default_rank_icons/sergeant_gr1.png", 0},
    {"Sergeant Grade 2", 32500, "default_rank_icons/sergeant_gr2.png", 4},
    {"Warrant Officer", 45000, "default_rank_icons/warrantofficer.png", 0},
    {"Warrant Officer Grade 1", 78000, "default_rank_icons/warrantofficer_gr1.png", 0},
    {"Warrant Officer Grade 2", 111000, "default_rank_icons/warrantofficer_gr2.png", 0},
    {"Warrant Officer Grade 3", 144000, "default_rank_icons/warrantofficer_gr3.png", 0},
    {"Captain", 210000, "default_rank_icons/captain.png", 0},
    {"Captain Grade 1", 233000, "default_rank_icons/captain_gr1.png", 0},
    {"Captain Grade 2", 256000, "default_rank_icons/captain_gr2.png", 0},
    {"Captain Grade 3", 279000, "default_rank_icons/captain_gr3.png", 0},
    {"Major", 325000, "default_rank_icons/major.png", -8},
    {"Major Grade 1", 350000, "default_rank_icons/major_gr1.png", -8},
    {"Major Grade 2", 375000, "default_rank_icons/major_gr2.png", -8},
    {"Major Grade 3", 400000, "default_rank_icons/major_gr3.png", -4},
    {"Lt. Colonel", 450000, "default_rank_icons/ltcolonel.png", -6},
    {"Lt. Colonel Grade 1", 480000, "default_rank_icons/ltcolonel_gr1.png", -6},
    {"Lt. Colonel Grade 2", 510000, "default_rank_icons/ltcolonel_gr2.png", -6},
    {"Lt. Colonel Grade 3", 540000, "default_rank_icons/ltcolonel_gr3.png", -6},
    {"Commander", 600000, "default_rank_icons/commander.png", -6},
    {"Commander Grade 1", 650000, "default_rank_icons/commander_gr1.png", -6},
    {"Commander Grade 2", 700000, "default_rank_icons/commander_gr2.png", -6},
    {"Commander Grade 3", 750000, "default_rank_icons/commander_gr3.png", -6},
    {"Colonel", 850000, "default_rank_icons/colonel.png", 0},
    {"Colonel Grade 1", 960000, "default_rank_icons/colonel_gr1.png", -5},
    {"Colonel Grade 2", 1070000, "default_rank_icons/colonel_gr2.png", -5},
    {"Colonel Grade 3", 1180000, "default_rank_icons/colonel_gr3.png", -5},
    {"Brigadier", 1400000, "default_rank_icons/brigadier.png", 0},
    {"Brigadier Grade 1", 1520000, "default_rank_icons/brigadier_gr1.png", 0},
    {"Brigadier Grade 2", 1640000, "default_rank_icons/brigadier_gr2.png", 0},
    {"Brigadier Grade 3", 1760000, "default_rank_icons/brigadier_gr3.png", 0},
    {"General", 2000000, "default_rank_icons/general.png", 0},
    {"General Grade 1", 2200000, "default_rank_icons/general_gr1.png", 0},
    {"General Grade 2", 2350000, "default_rank_icons/general_gr2.png", 0},
    {"General Grade 3", 2500000, "default_rank_icons/general_gr3.png", 0},
    {"General Grade 4", 2650000, "default_rank_icons/general_gr4.png", 0},
    {"Field Marshall", 3000000, "default_rank_icons/fieldmarshall.png", 0},
    {"Hero", 3700000, "default_rank_icons/hero.png", 0},
    {"Legend", 4600000, "default_rank_icons/legend.png", 0},
    {"Mythic", 5650000, "default_rank_icons/mythic.png", 0},
    {"Noble", 7000000, "default_rank_icons/noble.png", 0},
    {"Eclipse", 8500000, "default_rank_icons/eclipse.png", 0},
    {"Nova", 11000000, "default_rank_icons/nova.png", 0},
    {"Forerunner", 13000000, "default_rank_icons/forerunner.png", 0},
    {"Reclaimer", 16500000, "default_rank_icons/reclaimer.png", 0},
    {"Inheritor", 20000000, "default_rank_icons/inheritor.png", 0},
}

DuckLevels.DefinedTours = {
	"default_tour_icons/Tour1.png",
	"default_tour_icons/Tour2.png",
	"default_tour_icons/Tour3.png",
	"default_tour_icons/Tour4.png",
	"default_tour_icons/Tour5.png",
	"default_tour_icons/Tour6.png",
	"default_tour_icons/Tour7.png",
	"default_tour_icons/Tour8.png",
	"default_tour_icons/Tour9.png",
	"default_tour_icons/Tour10.png"
}

function DuckLevels.NumToRankName(num)
	if (num == 0) then return DuckLevels.InitialRank[1] end
	local lvl = DuckLevels.DefinedLevels[num]
	if (lvl == nil) then
		return "Unknown"
	end
	return lvl[1]
end

if (CLIENT) then

	function DuckyCreateFonts()
		surface.CreateFont("Roboto20pt", { font = "Roboto", size = 20 * (ScrW() / 1920) })
		surface.CreateFont("Roboto25pt", { font = "Roboto", size = 25 * (ScrW() / 1920) })
		surface.CreateFont("Roboto30pt", { font = "Roboto", size = 30 * (ScrW() / 1920) })
		surface.CreateFont("Roboto45pt", { font = "Roboto", size = 45 * (ScrW() / 1920) })
	end

	hook.Add( "OnScreenSizeChanged", "DuckyFontHook", DuckyCreateFonts)
	DuckyCreateFonts()

	DuckLevels.InitialRankMat = Material(DuckLevels.InitialRank[3], "smooth")
	DuckLevels.NilLevel = Material("default_rank_icons/missingrank.png", "smooth")
	DuckLevels.NilTour = Material("default_tour_icons/TourNil.png", "smooth")

end

--[[
function DuckLevels.NumToTourIcon(num)
	local tour = DuckLevels.DefinedTours[num]
	if (tour == nil) then
		return "Unknown"
	end
	return tour
end
]]