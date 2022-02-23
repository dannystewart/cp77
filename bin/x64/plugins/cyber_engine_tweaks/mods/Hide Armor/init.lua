-- True Hidden Everything
-- maniman303 and hawkidoki

-- Updated to CP77 1.5 with fixes and additions by
-- maniman303

-- GameUI, Cron and GameLocale
-- https://github.com/psiberx/cp2077-cet-kit

local GameUI = require('GameUI')
local Cron = require('Cron')
local Localization = require('Localization')
local nativeSettings
local settingsTables = {}
local isInventorUIEnabled
local languageGroupPath = '/language'

-- Class
Class = {}
Class.__index = Class
Class.inventoryState = {}
Class.preferencesState = {}
Class.types = {'Head', 'Face', 'OuterChest', 'InnerChest', 'Legs', 'Feet'}
Class.tagToArea = {}

function Class:Init()
	local this = {
		Ready = false,
		Player = false,
		Equipment = false,
		Transaction = false,
		emptyItemID = ItemID.FromTDBID(""),
	}

	db:exec[=[
		CREATE TABLE Visibility (ID INTEGER PRIMARY KEY, Name, Hidden);
		INSERT INTO Visibility VALUES(NULL, 'Head', 0);
		INSERT INTO Visibility VALUES(NULL, 'Face', 0);
		INSERT INTO Visibility VALUES(NULL, 'OuterChest', 0);
		INSERT INTO Visibility VALUES(NULL, 'InnerChest', 0);
		INSERT INTO Visibility VALUES(NULL, 'Legs', 0);
		INSERT INTO Visibility VALUES(NULL, 'Feet', 0);
	]=]

	db:exec[=[
		CREATE TABLE UserOptions (ID INTEGER PRIMARY KEY, Name, Value);
		INSERT INTO UserOptions VALUES(NULL, 'Inventory', 1);
	]=]

	self.tagToArea['hide_H1'] = 'Head'
	self.tagToArea['hide_F1'] = 'Face'
	self.tagToArea['hide_T2'] = 'OuterChest'
	self.tagToArea['hide_T1'] = 'InnerChest'
	self.tagToArea['hide_L1'] = 'Legs'
	self.tagToArea['hide_S1'] = 'Feet'

	-- Load
	for row in db:rows("SELECT Name, Hidden FROM Visibility") do
		if row[2] == 0 then
			self.inventoryState[row[1]] = false
		else
			self.inventoryState[row[1]] = true
		end
	end

	for row in db:rows("SELECT Name, Value FROM UserOptions") do
		self.preferencesState[row[1]] = row[2]
	end

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
	self:LoadClothes()

	return true
end

function Class:LoadClothes()
	for iter, elem in pairs(self.types) do
		if self:GetBlockade(elem) then
			self:Switch(elem, true, true)
		else
			self:Switch(elem, self:IsHidden(elem))
		end
	end
end

function Class:Destroy()
	self.Ready = false
	self.Player = false
	self.Equipment = false
	self.Transaction = false
end

function Class:IsHidden(Area)
	if self:IsCloth(Area) and self.inventoryState[Area] then
		return true
	end

	return false
end

function Class:IsCloth(Area)
	for iter, elem in pairs(self.types) do
		if elem == Area then
			return true
		end
	end

	return false
end

function Class:GetBlockade(Area)
	if not self.Ready then
		return false
	else
		local itemID = self.Equipment:GetActiveItem('Outfit')
		if itemID == self.emptyItemID then
			return false
		else
			local visualTagsTweakDB = self.Transaction:GetVisualTagsByItemID(itemID, self.Equipment.owner)
			for iter, elem in pairs(visualTagsTweakDB) do
				if self.tagToArea[elem.value] == Area then
					return true
				end
			end

			return false
		end
	end
end

function Class:Switch(Area, IsHidden, Silent)
	if not Silent then
		self.inventoryState[Area] = IsHidden

		if IsHidden then
			db:exec("UPDATE Visibility SET Hidden = 1  WHERE Name = '".. Area .."'")
		else
			db:exec("UPDATE Visibility SET Hidden = 0  WHERE Name = '".. Area .."'")
		end
	end

	if not self.Ready then return end

	if self:GetBlockade(Area) and not Silent then return end

	if IsHidden then
		if Area == 'Legs' then
			if self.Equipment:ShouldShowGenitals() then
				self.Equipment:ClearItemAppearance(self.Transaction, Area)
			end

			-- clearitemappearance removes underwear from tpp
			self.Equipment:ResetItemAppearance(self.Transaction, 'UnderwearBottom')
			self.Equipment:ResetItemAppearanceEvent('UnderwearBottom')
		end

		self.Equipment:ClearItemAppearanceEvent(Area)
	else
		self.Equipment:ResetItemAppearanceEvent(Area)
	end
end

function Class:Toggle(Area)
	if nativeSettings and settingsTables[Area] then
		nativeSettings.setOption(settingsTables[Area], self:IsHidden(Area))
	else
		self:Switch(Area, not self:IsHidden(Area))
	end
end

function Class:GetPreference(Name)
	if not self.preferencesState[Name] then
		return 0
	end

	return self.preferencesState[Name]
end

function Class:SetPreference(Name, Value)
	self.preferencesState[Name] = Value
	db:exec("INSERT INTO UserOptions VALUES(NULL, '" .. Name .. "', " .. Value .. ")")
	db:exec("UPDATE UserOptions SET Value = " .. Value .. "  WHERE Name = '" .. Name .. "'")
end

Mod = Class

function InitNativeUI()
	nativeSettings = GetMod("nativeSettings")
	if nativeSettings then
		nativeSettings.addTab("/TrueHiddenEverything", "True Hidden Everything")
	end
end

function AddPreferencesUI(LanguageID)
	nativeSettings.addSubcategory("/TrueHiddenEverything/preferences",
		Localization.GetCategory(LanguageID, 'Preferences'), LanguageID)

	settingsTables['Inventory'] = nativeSettings.addSwitch(
		"/TrueHiddenEverything/preferences",
		Localization.GetName(LanguageID, 'Inventory'),
		Localization.GetDescription(LanguageID, 'Inventory'),
		Mod:GetPreference('Inventory') == 1,
		true,
		function(state)
			if state then
				Mod:SetPreference('Inventory', 1)
			else
				Mod:SetPreference('Inventory', 0)
			end
	end)
end

function AddVisibilityUI(LanguageID)
	nativeSettings.removeSubcategory("/TrueHiddenEverything/visibility")
	nativeSettings.removeSubcategory("/TrueHiddenEverything/disabled")
	nativeSettings.addSubcategory("/TrueHiddenEverything/visibility",
		Localization.GetCategory(LanguageID, 'Visibility'), 0)

	for iter, type in pairs(Mod.types) do
		settingsTables[type] = nativeSettings.addSwitch(
			"/TrueHiddenEverything/visibility",
			Localization.GetName(LanguageID, type),
			Localization.GetDescription(LanguageID, type),
			not Mod:IsHidden(type),
			true,
			function(state)
				Mod:Switch(type, not state)
		end)
	end
end

function RegisterNativeUI()
	languageID = Localization.GetLanguage()

	if nativeSettings then
		nativeSettings.removeSubcategory("/TrueHiddenEverything/preferences")

		AddVisibilityUI(languageID)
		AddPreferencesUI(languageID)
	end
end

registerForEvent('onInit', function()
	-- Mod Init
	Mod = Class:Init()

	-- Native UI Init
	Localization.Initialize()
	InitNativeUI()
	RegisterNativeUI()

	languageGroupPath = CName.new(languageGroupPath)

	-- Update Native UI language
	Observe('SettingsMainGameController', 'OnVarModified', function(_, groupPath, varName, _, reason)
		if groupPath == languageGroupPath and reason == InGameConfigChangeReason.Accepted then
			RegisterNativeUI()
		end
	end)

	-- Inventory UI
	Override('InventoryDataManagerV2', 'IsTransmogEnabled', function()
		return Mod:GetPreference('Inventory')
	end)

	-- Visiblity getters
	Override('EquipmentSystemPlayerData', 'IsVisualTagActive', function(self, Tag, Wrapped)
		local area = Mod.tagToArea[Tag.value]
		if area and Mod:IsHidden(area) and not Mod:GetBlockade(area) then
			return true
		else
			return Wrapped(Tag)
		end
	end)

	Override('EquipmentSystemPlayerData', 'IsSlotHidden', function(self, Area, Wrapped)
		if Area.value == 'Legs' and not Mod.Ready then
			return false
		elseif Mod:IsCloth(Area) and not Mod:GetBlockade(Area) then
			return Mod:IsHidden(Area)
		else
			return Wrapped(Area)
		end
	end)

	-- Transactions
	Override('TransactionSystem', 'ResetItemAppearance', function(self, obj, itemID, Wrapped)
		local equipmentSystem = Game.GetScriptableSystemsContainer():Get(CName.new('EquipmentSystem'))
		local equipmentSystemPlayer = equipmentSystem:GetPlayerData(Game.GetPlayerSystem():GetLocalPlayerMainGameObject())
		local area = equipmentSystem.GetEquipAreaType(itemID)

		if not (area.value == 'InnerChest' and Mod:IsHidden('InnerChest')) then
			Wrapped(obj, itemID)
		end
	end)

	-- On Visual Tags
	Override('EquipmentSystemPlayerData', 'OnUnequipProcessVisualTags', function(self, itemID, isUnequipping, Wrapped)
		local equipmentSystem = Game.GetScriptableSystemsContainer():Get(CName.new('EquipmentSystem'))
		local transactionSystem = Game.GetTransactionSystem()
		local itemEntity = transactionSystem:GetItemInSlot(self.owner, equipmentSystem.GetPlacementSlot(itemID))
		local areaType = equipmentSystem.GetEquipAreaType(itemID)

		Wrapped(itemID, isUnequipping)

		if itemEntity then
			if areaType.value == 'Outfit' then
				for iter, elem in pairs(Mod.types) do
					Mod:Switch(elem, Mod:IsHidden(elem), true)
				end
			end
		end
	end)

	Override('EquipmentSystemPlayerData', 'OnEquipProcessVisualTags', function(self, itemID, Wrapped)
		local isUnderwearHidden
    	local visualTagsTweakDB = {}
    	local transactionSystem = Game.GetTransactionSystem()
		local equipmentSystem = Game.GetScriptableSystemsContainer():Get(CName.new('EquipmentSystem'))
    	local itemEntity = transactionSystem:GetItemInSlot(self.owner, equipmentSystem.GetPlacementSlot(itemID))
    	local areaType = equipmentSystem.GetEquipAreaType(itemID)
    	local tag = self:GetVisualTagByAreaType(areaType)

		if tag ~= Mod.emptyItemID and self:IsVisualTagActive(tag) then
			if areaType == gamedataEquipmentArea.Legs and self:ShouldShowGenitals() then
				self:ClearItemAppearance(transactionSystem, areaType)
			end

			self:ClearItemAppearanceEvent(areaType)
		elseif itemEntity then
			visualTagsTweakDB = transactionSystem:GetVisualTagsByItemID(itemID, self.owner)
			for iter, elem in pairs(visualTagsTweakDB) do
				local slotInfoIndex = self:GetSlotsInfoIndex(elem)
				if slotInfoIndex > -1 and self.clothingSlotsInfo then
					local clothingSlotInfo = self.clothingSlotsInfo[slotInfoIndex]
					if clothingSlotInfo then
						local isSlotEmpty = transactionSystem:IsSlotEmpty(self.owner, clothingSlotInfo.equipSlot)
						if not isSlotEmpty then
							if Mod:IsHidden(clothingSlotInfo.areaType.value) or not string.find(elem.value, 'hide_') then
								self:ClearItemAppearanceEvent(clothingSlotInfo.areaType)
							end
						end
					end
				end

				local shouldPartial = elem.value == 'hide_T1part' and not Mod:IsHidden('OuterChest')
				if areaType == gamedataEquipmentArea.OuterChest and (self:IsPartialVisualTagActive(itemID, transactionSystem) or shouldPartial) then
					self.isPartialVisualTagActive = true
          			self:UpdateInnerChest(transactionSystem)
				end

				isUnderwearHidden = self:IsUnderwearHidden()
				local areaEqualsUnderwear = areaType == gamedataEquipmentArea.UnderwearBottom
				local isItemValid = ItemID.IsValid(self:GetActiveItem(gamedataEquipmentArea.Legs))
				local isVisualTagActive = self:IsVisualTagActive(CName.new("hide_L1"))
				if (areaEqualsUnderwear or not isUnderwearHidden) and (isItemValid or isVisualTagActive) and not (Mod:IsHidden('Legs') or self:ShouldShowGenitals()) then
					self:ClearItemAppearanceEvent(gamedataEquipmentArea.UnderwearBottom)
				end

				isUnderwearHidden = self:EvaluateUnderwearTopHiddenState()
				areaEqualsUnderwear = areaType == gamedataEquipmentArea.UnderwearTop
				isItemValid = ItemID.IsValid(self:GetActiveItem(gamedataEquipmentArea.InnerChest))
				isVisualTagActive = self:IsVisualTagActive(CName.new("hide_T1"))
				if (areaEqualsUnderwear or not isUnderwearHidden) and self:IsBuildCensored() and (isItemValid or isVisualTagActive) then
					self:ClearItemAppearanceEvent(gamedataEquipmentArea.UnderwearTop)
				end
			end
		end

		if itemEntity then
			visualTagsTweakDB = transactionSystem:GetVisualTagsByItemID(itemID, self.owner)
			if areaType.value == 'OuterChest' then
				self.isPartialVisualTagActive = false

				for iter, elem in pairs(visualTagsTweakDB) do
					if elem.value == 'hide_T1part' then
						self.isPartialVisualTagActive = not Mod:IsHidden('OuterChest')
					end
				end

				self:UpdateInnerChest(transactionSystem)
			elseif areaType.value == 'Outfit' then
				for iter, elem in pairs(visualTagsTweakDB) do
					local tagArea = Mod.tagToArea[elem.value]
					if tagArea then
						Mod:Switch(tagArea, true, true)
					end
				end
			end
		end
	end)

	-- Toggle
	Override('InventoryDataManagerV2', 'ToggleItemVisibility', function(self, Area, Wrapped)
		if not Mod:IsCloth(Area.value) then
			Wrapped(Area)
		elseif not Mod:GetBlockade(Area.value) then
			Mod:Toggle(Area.value)
		end
	end)

	Override('InventoryItemDisplayController', 'UpdateTransmogControls', function(self, IsEmpty, Wrapped)
		if not inkWidgetRef.IsValid(self.transmogContainer) then
			return
		end

		local showHideIcon = Mod:IsCloth(self.equipmentArea.value)

		if not IsEmpty and showHideIcon then
			if not self.btnHideAppearance then
				self.btnHideAppearance = self:SpawnFromLocal(inkWidgetRef.Get(self.transmogContainer), CName.new('hideButton'))
				self.btnHideAppearanceCtrl = self.btnHideAppearance:GetControllerByType(CName.new('TransmogButtonView'))
			end

			local isHidden = Mod:IsHidden(self.equipmentArea.value)
			self.btnHideAppearanceCtrl:SetActive(not isHidden)
		elseif self.btnHideAppearance and showHideIcon then
			inkCompoundRef.RemoveAllChildren(self.transmogContainer)
      		self.btnHideAppearance = nil
      		self.btnHideAppearanceCtrl = nil
		else
			Wrapped(IsEmpty)
		end

		if not IsEmpty and self.inventoryDataManager:IsSlotOverriden(self.equipmentArea) then
			self.transmogItem = self.inventoryDataManager:GetVisualItemInSlot(m_equipmentArea)
		else
			self.transmogItem = Mod.emptyItemID
		end
	end)
	
	-- Mod handling
	GameUI.Observe(GameUI.Event.LoadingFinish, function()
		if not Mod.Ready and Game.GetPlayer() ~= nil then
			Mod:Setup()
		end
	end)

	GameUI.Observe(GameUI.Event.SceneEnter, function()
		Cron.After(0.6, function()
			if not Mod.Ready and Game.GetPlayer() ~= nil then
				Mod:Setup()
			end
		end)
	end)
	
	GameUI.Observe(GameUI.Event.SessionEnd, function()
		Mod:Destroy()
	end)

	-- Mirrors character edit
	Observe('MenuScenario_CharacterCustomizationMirror', 'OnAccept', function()
		local self = Mod
		if not self.Ready then return end

		self:LoadClothes()
	end)
end)

registerForEvent('onUpdate', function(delta)
	-- This is required for Cron to function
	Cron.Update(delta)
end)

-- Hotkeys
registerHotkey('hide_armor_head', 'Toggle Head', function()
	Mod:Toggle('Head')
end)

registerHotkey('hide_armor_face', 'Toggle Face', function()
	Mod:Toggle('Face')
end)

registerHotkey('hide_armor_outer_chest', 'Toggle Outer Chest', function()
	Mod:Toggle('OuterChest')
end)

registerHotkey('hide_armor_inner_chest', 'Toggle Inner Chest', function()
	Mod:Toggle('InnerChest')
end)

registerHotkey('hide_armor_pants', 'Toggle Pants', function()
	Mod:Toggle('Legs')
end)

registerHotkey('hide_armor_boots', 'Toggle Boots', function()
	Mod:Toggle('Feet')
end)

registerHotkey('enable_ui', 'Toggle Inventory UI', function()
	local state = Mod:GetPreference('Inventory') == 1

	if nativeSettings and settingsTables['Inventory'] then
		nativeSettings.setOption(settingsTables['Inventory'], not state)
	elseif state then
		Mod:SetPreference('Inventory', 0)
	else
		Mod:SetPreference('Inventory', 1)
	end
end)
