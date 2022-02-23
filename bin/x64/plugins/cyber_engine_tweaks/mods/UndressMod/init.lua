-- Begin of Undress Mod Class
UNMOD = {
	description = "",
}

-- External --
Cron = require("Cron.lua")

-- ALIAS for string.format --
local f = string.format

function intToBool(value)
	return value > 0 and true or false
end

function boolToInt(value)
  return value and 1 or 0
end

function UNMOD:new()

	UNMOD.settings = UNMOD:PrepareSettings()
	UNMOD.state = 0
	UNMOD.makeupToggle = true
	UNMOD.windowHeight = 170
	UNMOD.photoPuppet = nil
	UNMOD.photoPuppetComponent = nil
	UNMOD.braID = nil
	UNMOD.bottomID = nil

	registerForEvent("onInit", function()
		Observe('PhotoModePlayerEntityComponent', 'ListAllCurrentItems', function(self)
			UNMOD.photoPuppet = self.fakePuppet
			UNMOD.photoPuppetComponent = self
		 end)
	
		 Observe('gameuiPhotoModeMenuController', 'OnHide', function()
			UNMOD.photoPuppet = nil
			UNMOD.photoPuppetComponent = nil
		 end)
	end)

	registerForEvent('onUpdate', function(delta)
		Cron.Update(delta)
	 end)

	registerForEvent("onDraw", function()
		ImGui.SetNextWindowPos(500, 500, ImGuiCond.FirstUseEver)

		if(drawWindow) then
			ImGui.SetNextWindowSize(700, UNMOD.windowHeight)

			ImGui.PushStyleColor(ImGuiCol.Text, 0.9, 0.8, 0.2, 1)
			ImGui.PushStyleColor(ImGuiCol.WindowBg, 0.20, 0.08, 0.26, 0.95)
			ImGui.PushStyleColor(ImGuiCol.FrameBg, 0.25, 0.08, 0.36, 0.85)
			ImGui.PushStyleColor(ImGuiCol.FrameBgActive, 0.40, 0.08, 0.46, 0.85)
			ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, 0.30, 0.08, 0.46, 0.85)
			ImGui.PushStyleColor(ImGuiCol.Border, 0.20, 0.08, 0.26, 0.4)
			ImGui.PushStyleColor(ImGuiCol.TitleBg, 0.1, 0.08, 0.10, 0.8)
			ImGui.PushStyleColor(ImGuiCol.TitleBgActive, 0.25, 0.08, 0.30, 0.8)
			ImGui.PushStyleColor(ImGuiCol.TitleBgCollapsed, 0.25, 0.08, 0.30, 0.5)
			ImGui.PushStyleColor(ImGuiCol.ResizeGrip, 0, 0, 0, 0)
			ImGui.PushStyleColor(ImGuiCol.ResizeGripHovered, 0.90, 0.20, 0.96, 0.5)
			ImGui.PushStyleColor(ImGuiCol.ResizeGripActive, 0.90, 0.20, 0.96, 0.85)
			ImGui.PushStyleColor(ImGuiCol.SliderGrab, 0.40, 0.08, 0.46, 0.8)
			ImGui.PushStyleColor(ImGuiCol.SliderGrabActive, 0.70, 0.20, 0.96, 0.85)
			ImGui.PushStyleColor(ImGuiCol.CheckMark, 0.90, 0.20, 0.96, 0.85)
			ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 1)

			if (ImGui.Begin("Undress Mod")) then
				UNMOD.settings.numOfStates, used = ImGui.SliderInt("Number of States", UNMOD.settings.numOfStates, 2, 4)
				UNMOD.settings.shouldUndress, clicked = ImGui.Checkbox("Undress Before Cycle", UNMOD.settings.shouldUndress)

				if UNMOD.settings.numOfStates == 2 then
					ImGui.SameLine()
					UNMOD.settings.withBra, clicked = ImGui.Checkbox("Wear Bra", UNMOD.settings.withBra)
				end

				if clicked or used then UNMOD:UpdateSettings() end
			end

			ImGui.PopStyleColor(15)
			ImGui.PopStyleVar(1)
			ImGui.End()
		end
	end)

  return UNMOD
end

function UNMOD:GetPlayerGender()
  -- True = Female / False = Male
  return string.find(tostring(Game.GetPlayer():GetResolvedGenderName()), "Female")
end

function UNMOD:CycleStates()
	if UNMOD.settings.shouldUndress then UNMOD:Undress() end

	local isFemale = UNMOD:GetPlayerGender()
	local ts = Game.GetTransactionSystem()

	if isFemale then
		UNMOD.state = UNMOD.state + 1

		if(UNMOD.state == 1) then
			UNMOD:ToggleUnderwear(false, "UnderwearTop")
			UNMOD:ToggleUnderwear(false, "UnderwearBottom")
		end

		if(UNMOD.state == 2) then
			if UNMOD.settings.numOfStates == 4 then
				UNMOD:ToggleUnderwear(true, "UnderwearTop")

				Cron.After(0.3, function()
					UNMOD:ToggleUnderwear(false, "UnderwearBottom")
				end)
			else
				if UNMOD.settings.withBra then
					UNMOD:ToggleUnderwear(true, "UnderwearTop")
				else
					UNMOD:ToggleUnderwear(true, "UnderwearBottom")
				end
			end
		end

		if(UNMOD.state == 3) then
			if UNMOD.settings.numOfStates == 4 then
				UNMOD:ToggleUnderwear(false, "UnderwearTop")
				UNMOD:ToggleUnderwear(true, "UnderwearBottom")
			else
				UNMOD:ToggleUnderwear(true, "UnderwearTop")
				UNMOD:ToggleUnderwear(true, "UnderwearBottom")
			end
		end

		if(UNMOD.state == 4) then
			UNMOD:ToggleUnderwear(true, "UnderwearTop")
			UNMOD:ToggleUnderwear(true, "UnderwearBottom")
		end

		if UNMOD.settings.numOfStates == UNMOD.state then UNMOD.state = 0 end
	else
		UNMOD.state = UNMOD.state + 1

		if UNMOD.state == 1 then
			UNMOD:ToggleUnderwear(true, "UnderwearBottom")
		else
			UNMOD:ToggleUnderwear(false, "UnderwearBottom")
			UNMOD.state = 0
		end
	end
end

function UNMOD:Undress()
  local player = Game.GetPlayer()

  if player:IsNaked() == false then
    Game.UnequipItem('Face', 0)
    Game.UnequipItem('Feet', 0)
    Game.UnequipItem('Head', 0)
    Game.UnequipItem('Legs', 0)
    Game.UnequipItem('OuterChest', 0)
    Game.UnequipItem('Outfit', 0)
    Game.UnequipItem('InnerChest', 0)
  end
end

function UNMOD:ToggleUnderwear(equip, slot)
	local ts = Game.GetTransactionSystem()

	local itemID = ItemID.FromTDBID('Items.Underwear_Basic_01_Top')
	local attachmentSlot = "AttachmentSlots."..slot
	if slot == "UnderwearBottom" then
		itemID = ItemID.FromTDBID('Items.Underwear_Basic_01_Bottom')
	end
		
	if not ts:HasItem(Game.GetPlayer(), itemID) then
		ts:GiveItem(Game.GetPlayer(), itemID, 1)
  	end

	if equip then
		Game.GetScriptableSystemsContainer():Get(CName.new("EquipmentSystem")):GetPlayerData(Game.GetPlayer()):EquipItem(itemID, false, false)

		if UNMOD.photoPuppetComponent then
			UNMOD.photoPuppetComponent:PutOnFakeItemFromMainPuppet(itemID)
		end
	else
		Game.UnequipItem(slot, 0)

		if UNMOD.photoPuppet then
			local item = ts:GetItemInSlot(UNMOD.photoPuppet, TweakDBID.new(attachmentSlot))
			ts:RemoveItem(UNMOD.photoPuppet, item:GetItemData():GetID(), 1)
		end
	end
end

function UNMOD:PrepareSettings()
	local settings = {}
	for r in db:nrows("SELECT * FROM settings") do
		if r.name == "shouldUndress" or r.name == "withBra" then r.value = intToBool(r.value) end
		settings[r.name] = r.value
	end
	return settings
end

function UNMOD:UpdateSettings()
	for name, value in pairs(UNMOD.settings) do
		db:execute(f("UPDATE settings SET setting_value = %i WHERE setting_name = '%s'", boolToInt(value), name))
	end
end

-- Keybinds Configuration
registerHotkey("undress_mod_undress", "Undress", function()
  	UNMOD:Undress()
end)

registerHotkey("undress_mod_cycle", "Cycle States", function()
  	UNMOD:CycleStates()
end)

registerHotkey("undress_mod_open_menu", "Open Settings", function()
  drawWindow = not drawWindow
end)

return UNMOD:new()
