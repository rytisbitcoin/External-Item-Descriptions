
-- MOD CONFIG MENU Compatibility
local MCMLoaded, MCM = pcall(require, "scripts.modconfig")
EID.MCMCompat_isDisplayingEIDTab = false
local MCMCompat_isDisplayingDummyMCMObj = false
local MCMCompat_oldPermanentObj = false
EID.MCMLoaded = MCMLoaded
local colorNameArray = {}

function EID:renderMCMDummyDescription()
	if MCMLoaded then
		local mcmHudOffset = ModConfigMenu.Config["General"].HudOffset
		if mcmHudOffset == nil and ScreenHelper then
			mcmHudOffset = ScreenHelper.GetOffset()
		end
		EID:addTextPosModifier("MCM_HudOffset", Vector(mcmHudOffset * 2, mcmHudOffset))
		if MCM.IsVisible and EID.permanentDisplayTextObj == nil and EID.MCMCompat_isDisplayingEIDTab then
			MCMCompat_oldPermanentObj = EID.permanentDisplayTextObj
			local demoDescObj = EID:getDescriptionObj(5, 100, 33)
			demoDescObj.Name = "Demo Object Name"
			demoDescObj.Transformation = "Demo Transformation"
			demoDescObj.Description = "A very cool description as a demonstration of the power of EID!#\1 This is also a cool line#This line loves you {{Heart}}"
			EID:displayPermanentText(demoDescObj)
			MCMCompat_isDisplayingDummyMCMObj = true
			EID:buildColorArray()
		elseif not MCM.IsVisible and MCMCompat_isDisplayingDummyMCMObj then
			if MCMCompat_oldPermanentObj == nil then
				EID:hidePermanentText()
			else
				EID.permanentDisplayTextObj = MCMCompat_oldPermanentObj
			end
			EID.MCMCompat_isDisplayingEIDTab = false
			MCMCompat_oldPermanentObj = nil
			MCMCompat_isDisplayingDummyMCMObj = false
			colorNameArray = {}
		end
	end
end

function EID:buildColorArray()
	colorNameArray = {}
	for k,v in pairs(EID.InlineColors) do
		if k~="ColorText" and k~="ColorTransform" and k~="ColorError" and k~="ColorObjName" and k~="ColorReset" then
			table.insert(colorNameArray,k)
		end
	end
	table.sort(colorNameArray)
end

if MCMLoaded then
	function AnIndexOf(t, val)
		for k, v in ipairs(t) do
			if v == val then
				return k
			end
		end
		return 1
	end

	---------------------------------------------------------------------------
	-----------------------------------Info------------------------------------
	MCM.AddSpace("EID", "Info")
	MCM.AddText("EID", "Info", function() return "External Item Descriptions" end)
	MCM.AddSpace("EID", "Info")
	MCM.AddText("EID", "Info", function() return "Version "..EID.Config.Version.." ("..EID.GameVersion..")" end)
	MCM.AddSpace("EID", "Info")
	MCM.AddText("EID", "Info", function() return "by Wofsauge" end)

	---------------------------------------------------------------------------
	---------------------------------General-----------------------------------
	-- Language
	local displayLanguage = {"English", "English (detailed)", "French",  "Portuguese", "Portugues (Brasil)", "Russian", "Spanish", "Italian", "Bulgarian (WIP)", "Polish (WIP)", "German (WIP)", "Turkish (WIP)"}
	MCM.AddSetting(
		"EID",
		"General",
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function()
				return AnIndexOf(EID.Languages, EID.Config["Language"])
			end,
			Minimum = 1,
			Maximum = #(EID.Languages),
			Display = function()
				EID.MCMCompat_isDisplayingEIDTab = false;
				return "Language: " .. displayLanguage[AnIndexOf(EID.Languages, EID.Config["Language"])]
			end,
			OnChange = function(currentNum)
				EID.Config["Language"] = EID.Languages[currentNum]
			end,
			Info = {"Changes the language.","Languages marked with (WIP) are incomplete"}
		}
	)
	-- Item Name Language
	local translateStates = {"English", "Current Language", "Current + English"}
	MCM.AddSetting(
		"EID",
		"General",
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function()
				return EID.Config["TranslateItemName"]
			end,
			Minimum = 1,
			Maximum = 3,
			Display = function()
				return "Name Language: " .. translateStates[EID.Config["TranslateItemName"]]
			end,
			OnChange = function(currentNum)
				EID.Config["TranslateItemName"] = currentNum
			end,
			Info = {"If translated names are available,","this changes how item names are displayed."}
		}
	)
	MCM.AddSpace("EID", "General")
	
	-- Disable on Curse
	MCM.AddSetting(
		"EID",
		"General",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["DisableOnCurse"]
			end,
			Display = function()
				local onOff = "True"
				if EID.Config["DisableOnCurse"] then
					onOff = "False"
				end
				return 'Show on "Curse of Blind": ' .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["DisableOnCurse"] = currentBool
			end
		}
	)

	--------ShowUnidentifiedPillDescriptions---------
	MCM.AddSetting(
		"EID",
		"General",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["ShowUnidentifiedPillDescriptions"]
			end,
			Display = function()
				local onOff = "False"
				if EID.Config["ShowUnidentifiedPillDescriptions"] then
					onOff = "True"
				end
				return "Show Unidentified Pill Effects: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["ShowUnidentifiedPillDescriptions"] = currentBool
			end
		}
	)
	MCM.AddSetting(
		"EID",
		"General",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["HideInBattle"]
			end,
			Display = function()
				local onOff = "False"
				if EID.Config["HideInBattle"] then
					onOff = "True"
				end
				return "Hide in Battle: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["HideInBattle"] = currentBool
			end,
			Info = {"Hides the descriptions when in a fight"}
		}
	)

	MCM.AddSpace("EID", "General")

	--indicator
	local indicators = {"arrow", "blink", "border", "highlight", "none"}
	MCM.AddSetting(
		"EID",
		"General",
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function()
				return AnIndexOf(indicators, EID.Config["Indicator"])
			end,
			Minimum = 1,
			Maximum = 5,
			Display = function()
				return "Indicator: " .. EID.Config["Indicator"]
			end,
			OnChange = function(currentNum)
				EID.Config["Indicator"] = indicators[currentNum]
			end,
			Info = {"Highlights the currently described item"}
		}
	)
	
	MCM.AddSpace("EID", "General")

	-- maxDistance
	local distances = {1, 1.5, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	MCM.AddSetting(
		"EID",
		"General",
		{
			Type = ModConfigMenu.OptionType.SCROLL,
			CurrentSetting = function()
				return AnIndexOf(distances, EID.Config["MaxDistance"]) - 1
			end,
			Display = function()
				return "Max Distance: $scroll" ..
					AnIndexOf(distances, EID.Config["MaxDistance"]) - 1 .. " " .. EID.Config["MaxDistance"] .. " Grids"
			end,
			OnChange = function(currentNum)
				EID.Config["MaxDistance"] = distances[currentNum + 1]
			end,
			Info = {"Distance to the object until descriptions are displayed."}
		}
	)

	---------------------------------------------------------------------------
	---------------------------------Display-----------------------------------

	------------Collectibles--------------

	MCM.AddSetting(
		"EID",
		"Display",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["DisplayItemInfo"]
			end,
			Display = function()
				EID.MCMCompat_isDisplayingEIDTab = false;
				local onOff = "False"
				if EID.Config["DisplayItemInfo"] then
					onOff = "True"
				end
				return "Collectible Infos: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["DisplayItemInfo"] = currentBool
			end
		}
	)
	------------Trinkets--------------

	MCM.AddSetting(
		"EID",
		"Display",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["DisplayTrinketInfo"]
			end,
			Display = function()
				local onOff = "False"
				if EID.Config["DisplayTrinketInfo"] then
					onOff = "True"
				end
				return "Trinket Infos: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["DisplayTrinketInfo"] = currentBool
			end
		}
	)
	------------CARDS--------------

	MCM.AddSetting(
		"EID",
		"Display",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["DisplayCardInfo"]
			end,
			Display = function()
				local onOff = "False"
				if EID.Config["DisplayCardInfo"] then
					onOff = "True"
				end
				return "Card Infos: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["DisplayCardInfo"] = currentBool
			end
		}
	)

	------------PILLS--------------
	MCM.AddSetting(
		"EID",
		"Display",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["DisplayPillInfo"]
			end,
			Display = function()
				local onOff = "False"
				if EID.Config["DisplayPillInfo"] then
					onOff = "True"
				end
				return "Pill Infos: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["DisplayPillInfo"] = currentBool
			end
		}
	)
	--------Sacrifice Room---------
	MCM.AddSetting(
		"EID",
		"Display",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["DisplaySacrificeInfo"]
			end,
			Display = function()
				local onOff = "False"
				if EID.Config["DisplaySacrificeInfo"] then
					onOff = "True"
				end
				return "Sacrifice Room Infos: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["DisplaySacrificeInfo"] = currentBool
			end
		}
	)

	--------Dice Room---------
	MCM.AddSetting(
		"EID",
		"Display",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["DisplayDiceInfo"]
			end,
			Display = function()
				local onOff = "False"
				if EID.Config["DisplayDiceInfo"] then
					onOff = "True"
				end
				return "Dice Room Infos: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["DisplayDiceInfo"] = currentBool
			end
		}
	)

	MCM.AddSpace("EID", "Display")
	MCM.AddText("EID", "Display", "Display Infos in Shops")
	------------CARDS--------------

	MCM.AddSetting(
		"EID",
		"Display",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["DisplayCardInfoShop"]
			end,
			Display = function()
				local onOff = "False"
				if EID.Config["DisplayCardInfoShop"] then
					onOff = "True"
				end
				return "Card Infos: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["DisplayCardInfoShop"] = currentBool
			end
		}
	)

	------------PILLS--------------
	MCM.AddSetting(
		"EID",
		"Display",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["DisplayPillInfoShop"]
			end,
			Display = function()
				local onOff = "False"
				if EID.Config["DisplayPillInfoShop"] then
					onOff = "True"
				end
				return "Pill Infos: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["DisplayPillInfoShop"] = currentBool
			end
		}
	)

	---------------------------------------------------------------------------
	---------------------------------Visuals-----------------------------------
	-- Font Type
	local fontTypes = {"default","borderless","inverted"}
	MCM.AddSetting(
		"EID",
		"Visuals",
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function()
				return AnIndexOf(fontTypes, EID.Config["FontType"])
			end,
			Minimum = 1,
			Maximum = #fontTypes,
			Display = function()
				EID.MCMCompat_isDisplayingEIDTab = true;
				return "Font Type: " .. EID.Config["FontType"]
			end,
			OnChange = function(currentNum)
				EID.Config["FontType"] = fontTypes[currentNum]
				local fontFile = EID.Config["FontType"] or "default"
				EID:loadFont(EID.modPath .. "resources/font/eid_"..fontFile..".fnt")
			end
		}
	)
	-- SCALE
	local textScales = {0.5, 0.75, 1, 1.25, 1.5, 2}
	MCM.AddSetting(
		"EID",
		"Visuals",
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function()
				return AnIndexOf(textScales, EID.Config["Scale"])
			end,
			Minimum = 1,
			Maximum = 6,
			Display = function()
				return "Text Size: " .. EID.Config["Scale"]
			end,
			OnChange = function(currentNum)
				EID.Config["Scale"] = textScales[currentNum]
			end
		}
	)

	-- Transparency
	local transparencies = {0.1, 0.175, 0.25, 0.3, 0.4, 0.5, 0.6, 0.75, 0.8, 0.9, 1}
	MCM.AddSetting(
		"EID",
		"Visuals",
		{
			Type = ModConfigMenu.OptionType.SCROLL,
			CurrentSetting = function()
				return AnIndexOf(transparencies, EID.Config["Transparency"]) - 1
			end,
			Display = function()
				return "Transparency: $scroll" ..
					AnIndexOf(transparencies, EID.Config["Transparency"]) - 1 .. " " .. EID.Config["Transparency"]
			end,
			OnChange = function(currentNum)
				EID.Config["Transparency"] = transparencies[currentNum + 1]
			end
		}
	)

	MCM.AddSpace("EID", "Visuals")

	--------ShowItemName---------
	MCM.AddSetting(
		"EID",
		"Visuals",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["ShowItemName"]
			end,
			Display = function()
				local onOff = "False"
				if EID.Config["ShowItemName"] then
					onOff = "True"
				end
				return "Display Item Name: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["ShowItemName"] = currentBool
			end
		}
	)
	--------ShowItemType---------
	MCM.AddSetting(
		"EID",
		"Visuals",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["ShowItemType"]
			end,
			Display = function()
				local onOff = "False"
				if EID.Config["ShowItemType"] then
					onOff = "True"
				end
				return "Display Item Type: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["ShowItemType"] = currentBool
			end
		}
	)
	MCM.AddSetting(
		"EID",
		"Visuals",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["ShowItemIcon"]
			end,
			Display = function()
				local onOff = "False"
				if EID.Config["ShowItemIcon"] then
					onOff = "True"
				end
				return "Display Item Icon: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["ShowItemIcon"] = currentBool
			end
		}
	)

	-------TRANSFORMATIONS---------
	MCM.AddSetting(
		"EID",
		"Visuals",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["TransformationText"]
			end,
			Display = function()
				local onOff = "False"
				if EID.Config["TransformationText"] then
					onOff = "True"
				end
				return "Display Transformation Name: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["TransformationText"] = currentBool
			end
		}
	)
	-------TRANSFORMATION ICON---------
	MCM.AddSetting(
		"EID",
		"Visuals",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EID.Config["TransformationIcons"]
			end,
			Display = function()
				local onOff = "False"
				if EID.Config["TransformationIcons"] then
					onOff = "True"
				end
				return "Display Transformation Icon: " .. onOff
			end,
			OnChange = function(currentBool)
				EID.Config["TransformationIcons"] = currentBool
			end
		}
	)

	---------------------------------------------------------------------------
	---------------------------------Visuals-----------------------------------

	-- Text Color
	MCM.AddSetting(
		"EID",
		"Colors",
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function()
				return AnIndexOf(colorNameArray, EID.Config["TextColor"])
			end,
			Minimum = 0,
			Maximum = 1000,
			Display = function()
				EID.MCMCompat_isDisplayingEIDTab = true;
				return "Descriptions: " .. string.gsub(EID.Config["TextColor"], "Color", "").. " ("..AnIndexOf(colorNameArray, EID.Config["TextColor"]).."/"..#colorNameArray..")"
			end,
			OnChange = function(currentNum)
				if currentNum == 0 then currentNum = #colorNameArray end
				if currentNum > #colorNameArray then currentNum = 1 end
				EID.Config["TextColor"] = colorNameArray[currentNum]
			end,
			Info = {"Changes the color of normal texts."}
		}
	)
	-- Name Color
	MCM.AddSetting(
		"EID",
		"Colors",
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function()
				return AnIndexOf(colorNameArray, EID.Config["ItemNameColor"])
			end,
			Minimum = 0,
			Maximum = 1000,
			Display = function()
				EID.MCMCompat_isDisplayingEIDTab = true;
				return "Names: " .. string.gsub(EID.Config["ItemNameColor"], "Color", "").. " ("..AnIndexOf(colorNameArray, EID.Config["ItemNameColor"]).."/"..#colorNameArray..")"
			end,
			OnChange = function(currentNum)
				if currentNum == 0 then currentNum = #colorNameArray end
				if currentNum > #colorNameArray then currentNum = 1 end
				EID.Config["ItemNameColor"] = colorNameArray[currentNum]
			end,
			Info = {"Changes the color of name texts."}
		}
	)
	-- Transform Color
	MCM.AddSetting(
		"EID",
		"Colors",
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function()
				return AnIndexOf(colorNameArray, EID.Config["TransformationColor"])
			end,
			Minimum = 0,
			Maximum = 1000,
			Display = function()
				EID.MCMCompat_isDisplayingEIDTab = true;
				return "Transformations: " .. string.gsub(EID.Config["TransformationColor"], "Color", "").. " ("..AnIndexOf(colorNameArray, EID.Config["TransformationColor"]).."/"..#colorNameArray..")"
			end,
			OnChange = function(currentNum)
				if currentNum == 0 then currentNum = #colorNameArray end
				if currentNum > #colorNameArray then currentNum = 1 end
				EID.Config["TransformationColor"] = colorNameArray[currentNum]
			end,
			Info = {"Changes the color of transformation texts."}
		}
	)
	-- Error Color
	MCM.AddSetting(
		"EID",
		"Colors",
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function()
				return AnIndexOf(colorNameArray, EID.Config["ErrorColor"])
			end,
			Minimum = 0,
			Maximum = 1000,
			Display = function()
				EID.MCMCompat_isDisplayingEIDTab = true;
				return "Errors: " .. string.gsub(EID.Config["ErrorColor"], "Color", "").. " ("..AnIndexOf(colorNameArray, EID.Config["ErrorColor"]).."/"..#colorNameArray..")"
			end,
			OnChange = function(currentNum)
				if currentNum == 0 then currentNum = #colorNameArray end
				if currentNum > #colorNameArray then currentNum = 1 end
				EID.Config["ErrorColor"] = colorNameArray[currentNum]
			end,
			Info = {"Changes the color of error messages like Unknown pills"}
		}
	)
end
