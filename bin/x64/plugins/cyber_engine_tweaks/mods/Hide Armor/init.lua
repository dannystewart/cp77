-- True Hidden Everything
-- maniman303 and hawkidoki

-- Updated to CP77 1.5 with fixes and additions by
-- maniman303

-- GameUI, GameLocale and Cron
-- https://github.com/psiberx/cp2077-cet-kit

local GameUI = require('GameUI')
local Cron = require('Cron')
local Localization = require('Localization')
local settingsTables = {}
local nativeSettings
local types = {'Head', 'Face', 'OuterChest', 'InnerChest', 'Legs', 'Feet', 'Outfit'}
local outfitState = {}
local languageGroupPath = '/language'
local isUIVisible = true
local blockApperanceReset

-- Class
Class = {}
Class.__index = Class

function Class:Init()

	local this = {
		Ready       = false,
		Player      = false,
		Equipment   = false,
		Transaction = false,
	}

	db:exec[=[
		CREATE TABLE Preferences (ID INTEGER PRIMARY KEY, Name, Hidden);
		INSERT INTO Preferences VALUES(NULL, 'Head', 0);
		INSERT INTO Preferences VALUES(NULL, 'Face', 0);
		INSERT INTO Preferences VALUES(NULL, 'OuterChest', 0);
		INSERT INTO Preferences VALUES(NULL, 'InnerChest', 0);
		INSERT INTO Preferences VALUES(NULL, 'Legs', 0);
		INSERT INTO Preferences VALUES(NULL, 'Feet', 0);
		INSERT INTO Preferences VALUES(NULL, 'Outfit', 0);
		INSERT INTO Preferences VALUES(NULL, 'Language', 1);
	]=]

	setmetatable(this, self)
	return this

end

function Class:Setup()

	-- Bail Early
	if self.Ready then
		return true
	end

	-- PlayerSystem
	local GetPlayerSystem = Game.GetPlayerSystem()
	if not GetPlayerSystem then return false end

	-- player
	local GetPlayer = GetPlayerSystem:GetLocalPlayerMainGameObject()
	if not GetPlayer then return false end

	-- Transaction
	local GetTransactionSystem = Game.GetTransactionSystem()
	if not GetTransactionSystem then return false end

	-- Equipment
	local GetEquipmentSystem = Game.GetScriptableSystemsContainer():Get(CName.new('EquipmentSystem'))
	if not GetEquipmentSystem then return false end

	-- PlayerEquipmentData
	local GetPlayerEquipmentData = GetEquipmentSystem:GetPlayerData(GetPlayer)
	if not GetPlayerEquipmentData then return false end

	-- Vars
	self.Ready = true
	self.Player = GetPlayer
	self.Equipment = GetPlayerEquipmentData
	self.Transaction = GetTransactionSystem

	-- Load
	for row in db:rows("SELECT Name, Hidden FROM Preferences") do

		local Name = row[1]
		local Hidden = row[2]

		Cron.After(0.5, function()
			Mod:Toggle(Name, false, true)
		end)
	
		if Hidden == 1 then
			Cron.After(2.0, function()
				Mod:Toggle(Name, true, true)
			end)
		end

	end

	return true

end

function Class:Destroy()

	self.Ready	  = false
	self.Player	 = false
	self.Equipment      = false
	self.Transaction    = false

end

function Class:InVehicle()
	if self.Ready then
		return Game.GetWorkspotSystem():IsActorInWorkspot(self.Player) --or self.Mirror
	end

	return false
end

function Class:RemoveHelmetRestriction()
	local ItemID = self.Equipment:GetActiveItem('Head')
	Game.GetTransactionSystem():GetItemData(Game.GetPlayer(), ItemID):RemoveDynamicTag("UnequipBlocked")
end

function Class:IsHidden(Name)
	if not outfitState[Name] then
		for row in db:rows("SELECT Name, Hidden FROM Preferences WHERE Name = '".. Name .."'") do
			outfitState[Name] = row[2] == 1
		end
	end

	return outfitState[Name]
end

function Class:Toggle(Name, Hidden, Force)
	if self:InVehicle() and not Force then
		print("Hidding proccess blocked")
		return
	end

	outfitState[Name] = Hidden

	if Hidden then
		db:exec("UPDATE Preferences SET Hidden = 1  WHERE Name = '".. Name .."'")
	else
		db:exec("UPDATE Preferences SET Hidden = 0  WHERE Name = '".. Name .."'")
	end

	if not self.Ready then return end

	local ItemID = self.Equipment:GetActiveItem(Name)
	local AreaType = Game['EquipmentSystem::GetEquipAreaType;ItemID'](ItemID)

	if Hidden then
		-- Hide
		if not ItemID then
			return
		end
	
		self.Equipment:ResetItemAppearance(self.Transaction, AreaType)
		Cron.After(0.3, function()
			self.Equipment:ClearItemAppearance(self.Transaction, AreaType)
			self.Equipment:OnClearItemAppearance(ItemID)
			if Name ~= 'Head' or self:InVehicle() then
				self.Equipment:OnClearItemAppearance(ItemID)
			end
		end)
	else
		-- Show
		self.Equipment:ResetItemAppearance(self.Transaction, AreaType)
		self.Equipment:OnResetItemAppearance(ItemID)
		self.Equipment:EquipItem(ItemID)
	end
end

Mod = Class

function InitNativeUI ()
	nativeSettings = GetMod("nativeSettings")
	if nativeSettings then
		nativeSettings.addTab("/TrueHiddenEverything", "True Hidden Everything")
	end
end

function AddPreferencesUI (LanguageID)
	local fakeLanguageID = Localization.GetLanguage()

	nativeSettings.addSubcategory("/TrueHiddenEverything/preferences" .. LanguageID,
		Localization.GetCategory(fakeLanguageID, 'Preferences'), LanguageID)

	return nativeSettings.addSelectorString(
		"/TrueHiddenEverything/preferences" .. LanguageID,
		Localization.GetName(fakeLanguageID, 'Language'),
		Localization.GetDescription(fakeLanguageID, 'Language'),
		Localization.GetLanguagesList(),
		LanguageID,
		1,
		function(value)
			Localization.SetLanguage(value)
			local languageIDFun = Localization.GetLanguage()

			if isUIVisible then
				AddVisibilityUI(languageIDFun)
			else
				AddDisabledUI(languageIDFun)
			end

			local newOption = AddPreferencesUI(value)
			nativeSettings.removeSubcategory("/TrueHiddenEverything/preferences" .. LanguageID)
	end)
end

function AddVisibilityUI (LanguageID)
	nativeSettings.removeSubcategory("/TrueHiddenEverything/visibility")
	nativeSettings.removeSubcategory("/TrueHiddenEverything/disabled")
	nativeSettings.addSubcategory("/TrueHiddenEverything/visibility",
		Localization.GetCategory(LanguageID, 'Visibility'), 0)

	for iter, type in pairs(types) do
		settingsTables[type] = nativeSettings.addSwitch(
			"/TrueHiddenEverything/visibility",
			Localization.GetName(LanguageID, type),
			Localization.GetDescription(LanguageID, type),
			not Mod:IsHidden(type),
			true,
			function(state)
				Mod:Toggle(type, not state)
		end)
	end
end

function AddDisabledUI (LanguageID)
	for type, option in pairs(settingsTables) do
		nativeSettings.removeOption(option)
	end

	for iter, type in pairs(types) do
		settingsTables[type] = nil
	end

	nativeSettings.removeSubcategory("/TrueHiddenEverything/disabled")
	nativeSettings.removeSubcategory("/TrueHiddenEverything/visibility")
	nativeSettings.addSubcategory("/TrueHiddenEverything/disabled",
		Localization.GetCategory(LanguageID, 'Disabled'), 0)
end

function RegisterNativeUI (visible)
	isUIVisible = visible
	languageID = Localization.GetLanguage()

	if nativeSettings then
		for i=0, Localization.supported, 1 do
			nativeSettings.removeSubcategory("/TrueHiddenEverything/preferences" .. i)
		end

		if visible then
			AddVisibilityUI(languageID)
		else
			AddDisabledUI(languageID)
		end

		AddPreferencesUI(Localization.GetLanguage(true))
	end
end

function SafeToggle (Type)
	if nativeSettings then
		nativeSettings.setOption(settingsTables[Type], Mod:IsHidden(Type))
	else
		Mod:Toggle(Type, not Mod:IsHidden(Type))
	end
end

function StopApperanceReset ()
	blockApperanceReset = true
	Cron.After(2.0, function()
		blockApperanceReset = false
	end)
end

registerForEvent('onInit', function()
	-- Mod Init
	Mod = Class:Init()

	-- Native UI Init
	Localization.Initialize()
	InitNativeUI()
	RegisterNativeUI(true)

	languageGroupPath = CName.new(languageGroupPath)

	-- Update Native UI language
	Observe('SettingsMainGameController', 'OnVarModified', function(_, groupPath, varName, _, reason)
		if groupPath == languageGroupPath and reason == InGameConfigChangeReason.Accepted then
			Cron.After(1.0, function ()
				RegisterNativeUI(isUIVisible)
			end)
		end
	end)
	
	GameUI.Observe('LoadingFinish', function()
		Game.GetPlayer()
		Mod:Setup()
	end)
	
	GameUI.Observe('SessionEnd', function()
		Mod:Destroy()
	end)
	
	Observe("QuestTrackerGameController", "OnUninitialize", function()
		if Game.GetPlayer() == nil then
			Mod.Player = nil -- var containing a reference to the player 
		end
	end)

	Observe('EquipmentSystemPlayerData', 'OnEquipProcessVisualTags', function(class, ItemID)
		local self = Mod
		if not self.Ready then return end

		local AreaType = Game['EquipmentSystem::GetEquipAreaType;ItemID'](ItemID)
		local Name = AreaType.value

		if self:IsHidden(Name) then
			Cron.After(0.5, function()
				if not blockApperanceReset then
					self.Equipment:ResetItemAppearance(self.Transaction, AreaType)
				end
			end)
			Cron.After(1.4, function()
				if self:IsHidden(Name) then
					self.Equipment:ClearItemAppearance(self.Transaction, AreaType)
				end
			end)
			Cron.After(1.9, function()
				if not Name == 'Head' then
					self.Equipment:OnClearItemAppearance(ItemID)
				elseif Mod:InVehicle() then
					self.Transaction:RemoveItemFromSlot(self.Player, TweakDBID.new("AttachmentSlots.Head"), false, false, false)
				end
			end)
		end
	end)

	-- Photomode
	Observe('PhotoModePlayerEntityComponent', 'OnGameAttach', function(class)

		local self = Mod
		if not self.Ready then return end

		RegisterNativeUI(false)

		if self:IsHidden('Head') then
			self.Transaction:RemoveItemFromSlot(self.Player, TweakDBID.new("AttachmentSlots.Head"), false, false, false)
		end

		local Hidden = self:IsHidden('InnerChest')

		Cron.After(1.0, function()
			Mod:Toggle('InnerChest', not Hidden)

			Cron.After(0.5, function()
				Mod:Toggle('InnerChest', Hidden)
			end)
		end)
	end)

	Observe('PhotoModePlayerEntityComponent', 'OnGameDetach', function()

		local self = Mod
		if not self.Ready then return end

		RegisterNativeUI(true)

		local ItemID = self.Equipment:GetActiveItem('Head')
		Cron.After(1.5, function()
			self.Transaction:AddItemToSlot(self.Player, TweakDBID.new("AttachmentSlots.Head"), ItemID)
		end)
	end)
	
	--Vehicle
	GameUI.Observe('VehicleEnter', function()
		local self = Mod
		if not self.Ready then return end

		RegisterNativeUI(false)
		
		if self:IsHidden('Head') then
			Cron.After(0.5, function()
				self.Transaction:RemoveItemFromSlot(self.Player, TweakDBID.new("AttachmentSlots.Head"), false, false, false)
			end)
		end
	end)
	
	Observe('inkMotorcycleHUDGameController', 'OnVehicleUnmounted', function()
		local self = Mod
		if not self.Ready then return end

		RegisterNativeUI(true)
		StopApperanceReset()

		local ItemID = self.Equipment:GetActiveItem('Head')
		Cron.After(1.1, function()
			self.Transaction:AddItemToSlot(self.Player, TweakDBID.new("AttachmentSlots.Head"), ItemID)
		end)
	end)
	
	--Mirrors etc
	GameUI.Observe('SceneEnter', function()
		local self = Mod
		if not self.Ready then return end

		RegisterNativeUI(false)
		
		if self:IsHidden('Head') then
			Cron.After(4.0, function()
				self.Transaction:RemoveItemFromSlot(self.Player, TweakDBID.new("AttachmentSlots.Head"), false, false, false)
			end)
		end
	end)
	
	GameUI.Observe('SceneExit', function()
		local self = Mod
		if not self.Ready then return end

		RegisterNativeUI(true)
		StopApperanceReset()
		
		local ItemID = self.Equipment:GetActiveItem('Head')
		Cron.After(0.9, function()
			self.Transaction:AddItemToSlot(self.Player, TweakDBID.new("AttachmentSlots.Head"), ItemID)
		end)
	end)
end)

registerForEvent('onUpdate', function(delta)
	-- This is required for Cron to function
	Cron.Update(delta)
end)

-- Hotkeys
registerHotkey('hide_armor_head', 'Toggle Head', function()
	SafeToggle('Head')
end)

registerHotkey('hide_armor_face', 'Toggle Face', function()
	SafeToggle('Face')
end)

registerHotkey('hide_armor_outer_chest', 'Toggle Outer Chest', function()
	SafeToggle('OuterChest')
end)

registerHotkey('hide_armor_inner_chest', 'Toggle Inner Chest', function()
	SafeToggle('InnerChest')
end)

registerHotkey('hide_armor_pants', 'Toggle Pants', function()
	SafeToggle('Legs')
end)

registerHotkey('hide_armor_boots', 'Toggle Boots', function()
	SafeToggle('Feet')
end)

registerHotkey('hide_armor_outfit', 'Toggle Outfit', function()
	SafeToggle('Outfit')
end)
