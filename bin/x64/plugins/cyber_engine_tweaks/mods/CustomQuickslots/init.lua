function Deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
          copy[Deepcopy(orig_key)] = Deepcopy(orig_value)
      end
      setmetatable(copy, Deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
      copy = orig
  end
  return copy
end

local maxSlots = 20

-- defaults
local settings = {
  E3HudCompatibilityMode = false,
  hideEmptyConsumableSlots = false,
  hideEmptyCyberwareAbilitySlots = true,
  defaultSlotOpacity = 1.0,
  slotOpacityWhileSubtitlesOnScreen = 0.0,
  numSlots = 10,
  slots = {
    [1] = {
      type = 'BounceBack',
      key = 'IK_Tilde',
      holdModifier = 'QuickMelee',
      button = 'dpad_up'
    },
    [2] = {
      type = 'OpticalCamo',
      key = 'IK_5',
      holdModifier = 'DropCarriedObject',
      button = 'dpad_left'
    },
    [3] = {
      type = 'BloodPump',
      key = 'IK_6',
      holdModifier = 'DropCarriedObject',
      button = 'dpad_right'
    },
    [4] = {
      type = 'Food',
      key = 'IK_7',
      holdModifier = 'DropCarriedObject',
      button = 'dpad_up'
    },
    [5] = {
      type = 'Drink',
      key = 'IK_8',
      holdModifier = 'DropCarriedObject',
      button = 'dpad_down'
    },
    [6] = {
      type = 'Alcohol',
      key = 'IK_9',
      holdModifier = 'ToggleCrouch',
      button = 'dpad_up'
    },
    [7] = {
      type = 'HealthBooster',
      key = 'IK_0',
      holdModifier = 'ToggleCrouch',
      button = 'dpad_down'
    },
    [8] = {
      type = 'StaminaBooster',
      key = 'IK_Minus',
      holdModifier = 'ToggleCrouch',
      button = 'dpad_left'
    },
    [9] = {
      type = 'MemoryBooster',
      key = 'IK_Equals',
      holdModifier = 'ToggleCrouch',
      button = 'dpad_right'
    },
    [10] = {
      type = 'CarryCapacityBooster',
      key = 'IK_Backspace',
      holdModifier = 'QuickMelee',
      button = 'dpad_right'
    },
    [11] = {
      type = 'FlashGrenade',
      key = 'IK_Backspace',
      holdModifier = 'QuickMelee',
      button = 'dpad_left'
    },
    [12] = {
      type = 'FragGrenade',
      key = 'IK_Backspace',
      holdModifier = 'QuickMelee',
      button = 'dpad_down'
    }
  }
}

for i=1,maxSlots do
  if settings.slots[i] == nil then
    settings.slots[i] = {
      type = 'FragGrenade',
      key = 'IK_Backspace',
      holdModifier = 'QuickMelee',
      button = 'dpad_down'
    }
  end
end

if settings.numSlots > maxSlots then
  settings.numSlots = maxSlots
end

for _, slot in pairs(settings.slots) do
  slot['grenadeCycle'] = true
  slot['grenadeQuality'] = 'Regular' -- index to the list of qualities in the map, can be 1, 2, 3
end

local defaults = Deepcopy(settings)

local grenadeSlotOptions = {}

local settingsModified = false

local slotTypes = {
  'Food',  -- normal consumables - 1
  'Drink',
  'Alcohol',
  'HealthBooster',
  'StaminaBooster',
  'MemoryBooster',
  'CarryCapacityBooster',
  'OxyBooster',
  'MaxDoc', -- healing - 9
  'BounceBack',
  'OpticalCamo', -- cyberware abilities - 11
  'BloodPump',
  'ProjectileLauncher',
  'BiohazardGrenade', -- grenades - 14
  'CuttingGrenade',
  'EMPGrenade',
  'FlashGrenade',
  'FragGrenade',
  'IncendiaryGrenade',
  'OzobsNose',
  'ReconGrenade'
}

local gamepadButtonDisplayNames = {
  'Dpad Up',
  'Dpad Left',
  'Dpad Down',
  'Dpad Right'
}

local grenadeTypeQualitiesMap = {
  ['BiohazardGrenade'] = {'Regular', 'Homing'},
  ['CuttingGrenade'] = {'Regular'},
  ['EMPGrenade'] = {'Regular', 'Sticky', 'Homing'},
  ['FlashGrenade'] = {'Regular', 'Homing'},
  ['FragGrenade'] = {'Regular', 'Sticky', 'Homing'},
  ['IncendiaryGrenade'] = {'Regular', 'Sticky', 'Homing'},
  ['OzobsNose'] = {'Regular'},
  ['ReconGrenade'] = {'Regular', 'Sticky'}
}

local gamepadButtonNames = {'dpad_up', 'dpad_left', 'dpad_down', 'dpad_right'}
local gamepadHoldModifierNames = {'DropCarriedObject', 'ToggleCrouch', 'QuickMelee'}

local hotkeyItemControllers  = {}
local hotkeysWidgetController = nil

local GameUI = require('GameUI')
local GameSettings = require('GameSettings')
local lang = ""
local topOptions = {}

registerForEvent("onInit", function()
  lang = NameToString(GameSettings.Get("/language/OnScreen"))
  
  SetupMenuChangeListener()
  LoadSettings()
  SetupMenu()

  ObserveAfter("HotkeysWidgetController", "OnInitialize", function (this)
    hotkeysWidgetController = this
  end)

  Override("HotkeysWidgetController", "GetCustomQuickslots", function(_)
    return GetCustomQuickslots()
  end)

  Override("HotkeysWidgetController", "DefaultSlotOpacity", function(_)
    return settings.defaultSlotOpacity
  end)

  Override("HotkeysWidgetController", "SlotOpacityWhileSubtitlesOnScreen", function(_)
    return settings.slotOpacityWhileSubtitlesOnScreen
  end)

  Override("HotkeysWidgetController", "IsE3HudCompatibilityMode", function(_)
    return settings.E3HudCompatibilityMode
  end)

  ObserveBefore("HotkeyItemController", "Uninitialize", function (this)
    if this:IsCustomHotkey() then
      hotkeyItemControllers[this.customQuickSlotIndex + 1] = nil
    end
  end)

  Override("HotkeyItemController", "GetCustomQuickslots", function(this, index)
    hotkeyItemControllers[index + 1] = this -- because lua arrays start at 1
    return GetCustomQuickslots()
  end)

  Override("HotkeyItemController", "HideEmptyConsumableSlots", function(_)
    return settings.hideEmptyConsumableSlots
  end)

  Override("HotkeyItemController", "HideEmptyCyberwareAbilitySlots", function(_)
    return settings.hideEmptyCyberwareAbilitySlots
  end)

  Override("HotkeyItemController", "IsE3HudCompatibilityMode", function(_)
    return settings.E3HudCompatibilityMode
  end)
end)

function SetupInputListeners()
  for i=1,maxSlots do
    registerInput('quickslot' .. i, 'Quickslot ' .. i .. ' M/K Input', function(pressed)
      if GameUI.IsLoading() or GameUI.IsMenu() or GameUI.IsBraindance() or GameUI.IsCyberspace() or GameUI.IsPhoto() or GameUI.IsFastTravel() or GameUI.IsFlashback() or GameUI.IsPopup() then
        return
      end
      if not pressed and hotkeyItemControllers[i] ~= nil then
        hotkeyItemControllers[i]:HotkeyReleased()
      end
    end)
  end
end

function SetupMenuChangeListener()
  GameUI.Listen("MenuNav", function(state)
		if state.lastSubmenu ~= nil and state.lastSubmenu == "Settings" then
      local newLang = NameToString(GameSettings.Get("/language/OnScreen"))
      if lang ~= newLang then
        lang = newLang
        SetupMenu()
      end
      if settingsModified then
        if hotkeysWidgetController ~= nil then
          hotkeysWidgetController:CustomQuickslotsRefreshSlots()
        end
        settingsModified = false
      end
      SaveSettings()
    end
	end)
end

function LoadSettings()
  local file = io.open('settings.json', 'r')
  if file ~= nil then
    local contents = file:read("*a")
    local validJson, savedSettings = pcall(function() return json.decode(contents) end)
    file:close()

    if validJson then
      for key, _ in pairs(settings) do
        if key == 'slots' then
          -- special case for slots because number of slots might change in future versions
          for i, _ in pairs(settings.slots) do
            if savedSettings.slots[i] ~= nil then
              settings.slots[i] = savedSettings.slots[i]
            end
          end
        elseif savedSettings[key] ~= nil then
          settings[key] = savedSettings[key]
        end
      end
      if settings.numSlots > maxSlots then
        settings.numSlots = maxSlots
      end
    end
  end
end

function SaveSettings()
  local validJson, contents = pcall(function() return json.encode(settings) end)

  if validJson and contents ~= nil then
    local file = io.open("settings.json", "w+")
    file:write(PrettifyJSON(contents))
    file:close()
  end
end

function PrettifyJSON(json)
  local prettyJSON = ''
  local count = 0
  for c in json:gmatch"." do
    if c == '[' or c == '{' then
      prettyJSON = prettyJSON .. c .. '\n'
      count = count + 1
      for i=1,count do
        prettyJSON = prettyJSON .. '  '
      end
    elseif c == ',' then
      prettyJSON = prettyJSON .. ',\n'
      for i=1,count do
        prettyJSON = prettyJSON .. '  '
      end
    elseif c == ']' or c == '}' then
      count = count - 1
      prettyJSON = prettyJSON .. '\n'
      for i=1,count do
        prettyJSON = prettyJSON .. '  '
      end
      prettyJSON = prettyJSON .. c
    else
      prettyJSON = prettyJSON .. c
    end

  end
  return prettyJSON
end

function IndexOf(array, value)
  for i, v in ipairs(array) do
      if v == value then
          return i
      end
  end
  return nil
end

function SetupMenu()
  local nativeSettings = GetMod("nativeSettings")

  if not nativeSettings.pathExists("/CustomQuickslots") then
    nativeSettings.addTab("/CustomQuickslots", "Quickslots")
  end

  for _, option in pairs(topOptions) do
    nativeSettings.removeOption(option)
  end
  topOptions = {}

  local option = nativeSettings.addSwitch("/CustomQuickslots", "E3 2018 HUD Compatibility Mode", 'Turn this on ONLY if using "E3 2018 HUD - Spicy HUDs" V1.3 mod. Requires reload.', settings.E3HudCompatibilityMode, defaults.E3HudCompatibilityMode, function(state)
    settings.E3HudCompatibilityMode = state
    settingsModified = true
  end)
  table.insert(topOptions, option)

  -- Parameters: path, label, desc, currentValue, defaultValue, callback, optionalIndex
  option = nativeSettings.addSwitch("/CustomQuickslots", "Hide empty consumable and grenade slots", "Consumables slots will dissapear when there are no items to fill the slot", settings.hideEmptyConsumableSlots, defaults.hideEmptyConsumableSlots, function(state)
    settings.hideEmptyConsumableSlots = state
    settingsModified = true
  end)
  table.insert(topOptions, option)

  option = nativeSettings.addSwitch("/CustomQuickslots", "Hide empty cyberware ability slots", "Slots for cyberware abilities that are not equipped will dissapear", settings.hideEmptyCyberwareAbilitySlots, defaults.hideEmptyCyberwareAbilitySlots, function(state)
    settings.hideEmptyCyberwareAbilitySlots = state
    settingsModified = true
  end)
  table.insert(topOptions, option)

  -- Parameters: path, label, desc, min, max, step, format, currentValue, defaultValue, callback, optionalIndex
  option = nativeSettings.addRangeFloat("/CustomQuickslots", "Default slot opacity", "Opacity of quickslots most of time", 0.0, 1.0, 0.01, "%.2f", settings.defaultSlotOpacity, defaults.defaultSlotOpacity, function(value)
    settings.defaultSlotOpacity = value
    settingsModified = true
  end)
  table.insert(topOptions, option)

  option = nativeSettings.addRangeFloat("/CustomQuickslots", "Slot opacity while subtitles on screen", "Opacity of quickslots while in conversation", 0.0, 1.0, 0.01, "%.2f", settings.slotOpacityWhileSubtitlesOnScreen, defaults.slotOpacityWhileSubtitlesOnScreen, function(value)
    settings.slotOpacityWhileSubtitlesOnScreen = value
    settingsModified = true
  end)
  table.insert(topOptions, option)

  -- Parameters: path, label, desc, min, max, step, currentValue, defaultValue, callback, optionalIndex
  option = nativeSettings.addRangeInt("/CustomQuickslots", "Number of Custom Quickslots", "", 0, maxSlots, 1, settings.numSlots, defaults.numSlots, function(value)
    settingsModified = true
    local oldValue = settings.numSlots
    settings.numSlots = value

    if value < oldValue then
      for i=value + 1,oldValue do
        nativeSettings.removeSubcategory("/CustomQuickslots/quickslot" .. i)
      end
    end

    if oldValue < value then
      BuildSubCategories(nativeSettings, oldValue + 1, value)
    end

  end)
  table.insert(topOptions, option)

  BuildSubCategories(nativeSettings, 1, settings.numSlots)
end

function BuildSubCategories(nativeSettings, startSlot, endSlot)
  for i=startSlot,endSlot do
    if nativeSettings.pathExists("/CustomQuickslots/quickslot" .. i) then
      nativeSettings.removeSubcategory("/CustomQuickslots/quickslot" .. i)
    end
    nativeSettings.addSubcategory("/CustomQuickslots/quickslot" .. i, 'Slot ' .. i, i)
    
    local slotTypeIndex = IndexOf(slotTypes, settings.slots[i].type)

    -- Parameters: path, label, desc, elements, currentValue, defaultValue, callback, optionalIndex
    nativeSettings.addSelectorString("/CustomQuickslots/quickslot" .. i, "Type", "Choose what kind of item this slot holds", GetLocalizedSlotTypes(), slotTypeIndex, IndexOf(slotTypes, defaults.slots[i].type), function(value)
      settingsModified = true
      local oldValue = IndexOf(slotTypes, settings.slots[i].type)
      settings.slots[i].type = slotTypes[value]
      --if oldValue >= 14 then
        RemoveGrenadeSpecificOptions(nativeSettings, i)
      --end
      --if value >= 14 then
        AddGrenadeSpecificOptions(nativeSettings, i)
      --end
    end)

    --if slotTypeIndex >= 14 then
      AddGrenadeSpecificOptions(nativeSettings, i)
    --end

    nativeSettings.addKeyBinding("/CustomQuickslots/quickslot" .. i, 'Quickslot ' .. i .. ' M/K Input', "IMPORTANT: Enter the keybind here AND in CET Console", settings.slots[i].key, defaults.slots[i].key, function(key)
      settingsModified = true
      settings.slots[i].key = key
    end)

    -- Parameters: path, label, desc, elements, currentValue, defaultValue, callback, optionalIndex
    nativeSettings.addSelectorString("/CustomQuickslots/quickslot" .. i, "Gamepad Hold Modifier", "Hold this button to enable the quickslot", GetLocalizedHoldModifierNames(), IndexOf(gamepadHoldModifierNames, settings.slots[i].holdModifier), IndexOf(gamepadHoldModifierNames, defaults.slots[i].holdModifier), function(value)
      settingsModified = true
      settings.slots[i].holdModifier = gamepadHoldModifierNames[value]
    end)

    nativeSettings.addSelectorString("/CustomQuickslots/quickslot" .. i, "Gamepad Button", "While the modifier button is held, this button uses the item in the quickslot", gamepadButtonDisplayNames, IndexOf(gamepadButtonNames, settings.slots[i].button), IndexOf(gamepadButtonNames, defaults.slots[i].button), function(value)
      settingsModified = true
      settings.slots[i].button = gamepadButtonNames[value]
    end)
  end
end

function AddGrenadeSpecificOptions(nativeSettings, i)
  local grenadeQualityNames = grenadeTypeQualitiesMap[settings.slots[i].type]
  local currentGrenadeQuality = ''
  grenadeSlotOptions[i] = {}
  if grenadeQualityNames ~= nil then
    -- it's a grenade
    if settings.slots[i].type ~= 'CuttingGrenade' and settings.slots[i].type ~= 'OzobsNose' then
      currentGrenadeQuality = settings.slots[i].grenadeQuality
      local match = false
      for _, type in pairs(grenadeQualityNames) do
        if type == settings.slots[i].grenadeQuality then
          match = true
        end
      end
      if not match then
        currentGrenadeQuality = 'Regular'
      end
    else
      currentGrenadeQuality = 'Regular'
    end
    grenadeSlotOptions[i].type = nativeSettings.addSelectorString("/CustomQuickslots/quickslot" .. i, "Grenade Type", "If cycling is enabled, this type will be selected first", GetLocalizedGrenadeTypeList(grenadeQualityNames), IndexOf(grenadeQualityNames, currentGrenadeQuality), 1, function(value)
      settingsModified = true
      settings.slots[i].grenadeQuality = grenadeQualityNames[value]
    end, 2)
  
    grenadeSlotOptions[i].cycle = nativeSettings.addSwitch("/CustomQuickslots/quickslot" .. i, "Cycle Grenades", "Pressing the hotkey repeatedly will cycle through the different types", settings.slots[i].grenadeCycle, true, function(state)
      settingsModified = true
      settings.slots[i].grenadeCycle = state
    end, 3)
  else
    -- not a grenade
    grenadeSlotOptions[i].type = nativeSettings.addSelectorString("/CustomQuickslots/quickslot" .. i, "Grenade Type", "Not a Grenade", {'Not a Grenade'}, 1, 1, function(value)
      
    end, 2)
  
    grenadeSlotOptions[i].cycle = nativeSettings.addSwitch("/CustomQuickslots/quickslot" .. i, "Cycle Grenades", "Not a Grenade", settings.slots[i].grenadeCycle, true, function(state)
      settingsModified = true
      settings.slots[i].grenadeCycle = state
    end, 3)
  end
  
end

function RemoveGrenadeSpecificOptions(nativeSettings, i)
  if grenadeSlotOptions[i] ~= nil then
    if grenadeSlotOptions[i].cycle ~= nil then
      nativeSettings.removeOption(grenadeSlotOptions[i].cycle)
    end
    if grenadeSlotOptions[i].type ~= nil then
      nativeSettings.removeOption(grenadeSlotOptions[i].type)
    end
    grenadeSlotOptions[i] = nil
  end
end

function GetCustomQuickslots()
  local slots = {}
  for i=1,settings.numSlots do
    local slot = NewObject('CustomQuickslotsConfig.CustomQuickslot')
    slot.keyboardInput = settings.slots[i].key
    slot.gamepadInput = settings.slots[i].button
    slot.gamepadHoldModifier = settings.slots[i].holdModifier
    slot.itemType = Enum.new('CustomQuickslotsConfig.CustomQuickslotItemType', settings.slots[i].type)
    slot.grenadeQuality = Enum.new('CustomQuickslotsConfig.GrenadeQuality', settings.slots[i].grenadeQuality)
    slot.grenadeCycle = settings.slots[i].grenadeCycle
    slots[i] = slot
  end
  return slots
end

function GetLocalizedSlotTypes()
  local localizedSlots = {
    GetLocalizedText("LocKey#47364")
  }

  if     lang == 'pl-pl' then
    table.insert(localizedSlots, 'Napój')
    table.insert(localizedSlots, 'Alkohol')
  elseif lang == 'en-us' then
    table.insert(localizedSlots, 'Drink')
    table.insert(localizedSlots, 'Alcohol')
  elseif lang == 'es-es' or lang == 'es-mx' then
    table.insert(localizedSlots, 'Bebida')
    table.insert(localizedSlots, 'Alcohol')
  elseif lang == 'fr-fr' then
    table.insert(localizedSlots, 'Boisson')
    table.insert(localizedSlots, 'Alcool')
  elseif lang == 'it-it' then
    table.insert(localizedSlots, 'Bevanda')
    table.insert(localizedSlots, 'Alcool')
  elseif lang == 'de-de' then
    table.insert(localizedSlots, 'Getränk')
    table.insert(localizedSlots, 'Alkohol')
  elseif lang == 'kr-kr' then
    table.insert(localizedSlots, '음료')
    table.insert(localizedSlots, '술')
  elseif lang == 'zh-cn' then
    table.insert(localizedSlots, '饮料')
    table.insert(localizedSlots, '酒精')
  elseif lang == 'ru-ru' then
    table.insert(localizedSlots, 'напиток')
    table.insert(localizedSlots, 'Алкоголь')
  elseif lang == 'pt-br' then
    table.insert(localizedSlots, 'Bebida')
    table.insert(localizedSlots, 'Álcool')
  elseif lang == 'jp-jp' then
    table.insert(localizedSlots, '飲料')
    table.insert(localizedSlots, 'アルコール')
  elseif lang == 'zh-tw' then
    table.insert(localizedSlots, '飲料')
    table.insert(localizedSlots, '酒精')
  elseif lang == 'ar-ar' then
    table.insert(localizedSlots, 'مشروب')
    table.insert(localizedSlots, 'كحول')
  elseif lang == 'cz-cz' then
    table.insert(localizedSlots, 'Nápoj')
    table.insert(localizedSlots, 'Alkohol')
  elseif lang == 'hu-hu' then
    table.insert(localizedSlots, 'Ital')
    table.insert(localizedSlots, 'Alkohol')
  elseif lang == 'tr-tr' then
    table.insert(localizedSlots, 'İçecek')
    table.insert(localizedSlots, 'Alkol')
  elseif lang == 'th-th' then
    table.insert(localizedSlots, 'เครื่องดื่ม')
    table.insert(localizedSlots, 'เครื่องดื่มแอลกอฮอล์')
  else
    table.insert(localizedSlots, 'Drink')
    table.insert(localizedSlots, 'Alcohol')
  end
  
  table.insert(localizedSlots, GetLocalizedText("LocKey#43539"))  -- health booster
  table.insert(localizedSlots, GetLocalizedText("LocKey#43542"))  -- Stamina Booster
  table.insert(localizedSlots, GetLocalizedText("LocKey#43545"))  -- Memory Booster
  table.insert(localizedSlots, GetLocalizedText("LocKey#43548"))  -- Carry Capacity Booster
  table.insert(localizedSlots, GetLocalizedText("LocKey#43551"))  -- Oxy Booster
  table.insert(localizedSlots, GetLocalizedText("LocKey#35384"))  -- MaxDoc Mk.1
  table.insert(localizedSlots, GetLocalizedText("LocKey#35418"))  -- Bounce Back
  table.insert(localizedSlots, GetLocalizedText("LocKey#3702"))   -- Optical Camo
  table.insert(localizedSlots, GetLocalizedText("LocKey#3678"))   -- Blood Pump
  table.insert(localizedSlots, GetLocalizedText("LocKey#3722"))  -- Projectile Launcher
  table.insert(localizedSlots, GetLocalizedText("LocKey#5171"))  -- Biohazard Grenade
  table.insert(localizedSlots, GetLocalizedText("LocKey#5177"))  -- Cutting Grenade (Anti-personel)
  table.insert(localizedSlots, GetLocalizedText("LocKey#5170"))  -- EMP Grenade
  table.insert(localizedSlots, GetLocalizedText("LocKey#5166"))  -- Flash Grenade
  table.insert(localizedSlots, GetLocalizedText("LocKey#5164"))  -- Frag Grenade
  table.insert(localizedSlots, GetLocalizedText("LocKey#5174"))  -- Incendiary Grenade
  table.insert(localizedSlots, GetLocalizedText("LocKey#51646"))  -- Ozob's Grenade
  table.insert(localizedSlots, GetLocalizedText("LocKey#5175"))  -- Recon Grenade

  return localizedSlots
end

function GetLocalizedHoldModifierNames()
  local names = {
    GetLocalizedText("LocKey#43673") .. " (Square / X)",
    GetLocalizedText("LocKey#52474") .. " (Circle / B)",
    GetLocalizedText("LocKey#52475") .. " (Right Thumb Stick)",
  }
  return names
end

function GetLocalizedGrenadeTypeList(grenadeTypes)
  local newList = {}
  for _, type in pairs(grenadeTypes) do
    if type == "Regular" then
      table.insert(newList, GetLocalizedText("LocKey#35495"))
    elseif type == "Sticky" then
      table.insert(newList, GetLocalizedText("LocKey#35493"))
    elseif type == "Homing" then
      table.insert(newList, GetLocalizedText("LocKey#35494"))
    end
  end
  return newList
end

SetupInputListeners()

