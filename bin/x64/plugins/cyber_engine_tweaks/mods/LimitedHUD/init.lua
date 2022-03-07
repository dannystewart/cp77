local defaults = {
	ActionButtonsEnabled = true,
	ActionButtonsGlobal = false,
	ActionButtonsCombat = true,
	ActionButtonsOutOfCombat = false,
	ActionButtonsStealth = true,
	ActionButtonsWeapon = true,
	ActionButtonsZoom = false,
	CrouchEnabled = true,
	CrouchGlobal = false,
	CrouchCombat = true,
	CrouchOutOfCombat = false,
	CrouchStealth = true,
	CrouchWeapon = true,
	CrouchZoom = false,
	RosterEnabled = true,
	RosterGlobal = false,
	RosterCombat = true,
	RosterOutOfCombat = false,
	RosterStealth = true,
	RosterWeapon = true,
	RosterZoom = false,
	HintsEnabled = true,
	HintsGlobal = false,
	HintsCombat = false,
	HintsOutOfCombat = false,
	HintsStealth = false,
	HintsVehicle = false,
	HintsWeapon = false,
	HintsZoom = false,
	MinimapEnabled = true,
	MinimapGlobal = true,
	MinimapCombat = false,
	MinimapOutOfCombat = false,
	MinimapStealth = false,
	MinimapVehicle = true,
	MinimapScanner = false,
	MinimapWeapon = false,
	MinimapZoom = true,
	MinimapOpacity = 1.0,
	TrackerEnabled = true,
	TrackerGlobal = true,
	TrackerCombat = false,
	TrackerOutOfCombat = false,
	TrackerStealth = false,
	TrackerVehicle = true,
	TrackerScanner = false,
	TrackerWeapon = false,
	TrackerZoom = true,
	HealthbarEnabled = true,
	HealthbarGlobal = false,
	HealthbarNotFullHealth = true,
	HealthbarNotFullMemory = true,
	HealthbarBuffs = true,
	HealthbarHacks = true,
	HealthbarCombat = true,
	HealthbarOutOfCombat = false,
	HealthbarStealth = false,
	HealthbarWeapon = true,
	HealthbarZoom = false,
	QuestMarkersEnabled = true,
	QuestMarkersGlobal = true,
	QuestMarkersCombat = false,
	QuestMarkersOutOfCombat = false,
	QuestMarkersStealth = false,
	QuestMarkersVehicle = false,
	QuestMarkersScanner = true,
	QuestMarkersWeapon = false,
	QuestMarkersZoom = true,
	LootMarkersEnabled = true,
	LootMarkersGlobal = false,
	LootMarkersCombat = false,
	LootMarkersOutOfCombat = false,
	LootMarkersStealth = false,
	LootMarkersVehicle = false,
	LootMarkersScanner = true,
	LootMarkersWeapon = false,
	LootMarkersZoom = true,
	POIMarkersEnabled = true,
	POIMarkersGlobal = false,
	POIMarkersCombat = false,
	POIMarkersOutOfCombat = false,
	POIMarkersStealth = false,
	POIMarkersVehicle = true,
	POIMarkersScanner = true,
	POIMarkersWeapon = false,
	POIMarkersZoom = true,
	POIAlwaysShowTracked = false,
	CombatMarkersEnabled = true,
	CombatMarkersGlobal = false,
	CombatMarkersCombat = true,
	CombatMarkersOutOfCombat = false,
	CombatMarkersStealth = true,
	CombatMarkersVehicle = false,
	CombatMarkersScanner = false,
	CombatMarkersWeapon = true,
	CombatMarkersZoom = false,
	VehicleMarkersEnabled = true,
	VehicleMarkersGlobal = false,
	VehicleMarkersVehicle = false,
	VehicleMarkersScanner = false,
	VehicleMarkersZoom = true,
	DeviceMarkersEnabled = true,
	DeviceMarkersScanner = true
}

local settings = {
	ActionButtonsEnabled = true,
	ActionButtonsGlobal = false,
	ActionButtonsCombat = true,
	ActionButtonsOutOfCombat = false,
	ActionButtonsStealth = true,
	ActionButtonsWeapon = true,
	ActionButtonsZoom = false,
	CrouchEnabled = true,
	CrouchGlobal = false,
	CrouchCombat = true,
	CrouchOutOfCombat = false,
	CrouchStealth = true,
	CrouchWeapon = true,
	CrouchZoom = false,
	RosterEnabled = true,
	RosterGlobal = false,
	RosterCombat = true,
	RosterOutOfCombat = false,
	RosterStealth = true,
	RosterWeapon = true,
	RosterZoom = false,
	HintsEnabled = true,
	HintsGlobal = false,
	HintsCombat = false,
	HintsOutOfCombat = false,
	HintsStealth = false,
	HintsVehicle = false,
	HintsWeapon = false,
	HintsZoom = false,
	MinimapEnabled = true,
	MinimapGlobal = true,
	MinimapCombat = false,
	MinimapOutOfCombat = false,
	MinimapStealth = false,
	MinimapVehicle = true,
	MinimapScanner = false,
	MinimapWeapon = false,
	MinimapZoom = true,
	MinimapOpacity = 1.0,
	TrackerEnabled = true,
	TrackerGlobal = true,
	TrackerCombat = false,
	TrackerOutOfCombat = false,
	TrackerStealth = false,
	TrackerVehicle = true,
	TrackerScanner = false,
	TrackerWeapon = false,
	TrackerZoom = true,
	HealthbarEnabled = true,
	HealthbarGlobal = false,
	HealthbarNotFullHealth = true,
	HealthbarNotFullMemory = true,
	HealthbarBuffs = true,
	HealthbarHacks = true,
	HealthbarCombat = true,
	HealthbarOutOfCombat = false,
	HealthbarStealth = false,
	HealthbarWeapon = true,
	HealthbarZoom = false,
	QuestMarkersEnabled = true,
	QuestMarkersGlobal = true,
	QuestMarkersCombat = false,
	QuestMarkersOutOfCombat = false,
	QuestMarkersStealth = false,
	QuestMarkersVehicle = false,
	QuestMarkersScanner = true,
	QuestMarkersWeapon = false,
	QuestMarkersZoom = true,
	LootMarkersEnabled = true,
	LootMarkersGlobal = false,
	LootMarkersCombat = false,
	LootMarkersOutOfCombat = false,
	LootMarkersStealth = false,
	LootMarkersVehicle = false,
	LootMarkersScanner = true,
	LootMarkersWeapon = false,
	LootMarkersZoom = true,
	POIMarkersEnabled = true,
	POIMarkersGlobal = false,
	POIMarkersCombat = false,
	POIMarkersOutOfCombat = false,
	POIMarkersStealth = false,
	POIMarkersVehicle = true,
	POIMarkersScanner = true,
	POIMarkersWeapon = false,
	POIMarkersZoom = true,
	POIAlwaysShowTracked = false,
	CombatMarkersEnabled = true,
	CombatMarkersGlobal = false,
	CombatMarkersCombat = true,
	CombatMarkersOutOfCombat = false,
	CombatMarkersStealth = true,
	CombatMarkersVehicle = false,
	CombatMarkersScanner = false,
	CombatMarkersWeapon = true,
	CombatMarkersZoom = false,
	VehicleMarkersEnabled = true,
	VehicleMarkersGlobal = false,
	VehicleMarkersVehicle = false,
	VehicleMarkersScanner = false,
	VehicleMarkersZoom = true,
	DeviceMarkersEnabled = true,
	DeviceMarkersScanner = true
}

function SaveSettings() 
	local validJson, contents = pcall(function() return json.encode(settings) end)
	
	if validJson and contents ~= nil then
		local updatedFile = io.open("settings.json", "w+");
		updatedFile:write(contents);
		updatedFile:close();
	end
end

function LoadSettings() 
	local file = io.open("settings.json", "r")
	if file ~= nil then
		local contents = file:read("*a")
		local validJson, persistedState = pcall(function() return json.decode(contents) end)
		
		if validJson then
			file:close();
			for key, _ in pairs(settings) do
				if persistedState[key] ~= nil then
					settings[key] = persistedState[key]
				end
			end
		end
	end
end

function SetupSettingsMenu()
	local nativeSettings = GetMod("nativeSettings")
	
	if not nativeSettings then
		print("Error: NativeSettings not found!")
		return
	end

	nativeSettings.addTab("/lhud", "Limited HUD")
	
	nativeSettings.addSubcategory("/lhud/action", "Action buttons")
	nativeSettings.addSwitch("/lhud/action", "Is module enabled", "If enabled then widget controlled by LHUD, disable if you want to restore default widget behavior", settings.ActionButtonsEnabled, defaults.ActionButtonsEnabled, function(state) settings.ActionButtonsEnabled = state end)
	nativeSettings.addSwitch("/lhud/action", "Bind to Global hotkey", "If enabled then you will be able to toggle the module widgets visibility with the global hotkey if you have it configured", settings.ActionButtonsGlobal, defaults.ActionButtonsGlobal, function(state) settings.ActionButtonsGlobal = state end)
	nativeSettings.addSwitch("/lhud/action", "Show in combat", "Show when combat mode is active", settings.ActionButtonsCombat, defaults.ActionButtonsCombat, function(state) settings.ActionButtonsCombat = state end)
	nativeSettings.addSwitch("/lhud/action", "Show out of combat", "Show when when combat mode is not active and stealth mode is not active", settings.ActionButtonsOutOfCombat, defaults.ActionButtonsOutOfCombat, function(state) settings.ActionButtonsOutOfCombat = state end)
	nativeSettings.addSwitch("/lhud/action", "Show in stealth", "Show when stealth mode is active", settings.ActionButtonsStealth, defaults.ActionButtonsStealth, function(state) settings.ActionButtonsStealth = state end)
	nativeSettings.addSwitch("/lhud/action", "Show with weapon", "Show when weapon unsheated", settings.ActionButtonsWeapon, defaults.ActionButtonsWeapon, function(state) settings.ActionButtonsWeapon = state end)
	nativeSettings.addSwitch("/lhud/action", "Show with zoom", "Show when zoom mode is active (press aim hotkey with no weapon in hands)", settings.ActionButtonsZoom, defaults.ActionButtonsZoom, function(state) settings.ActionButtonsZoom = state end)
	
	nativeSettings.addSubcategory("/lhud/crouch", "Crouch indicator")
	nativeSettings.addSwitch("/lhud/crouch", "Is module enabled", "If enabled then widget controlled by LHUD, disable if you want to restore default widget behavior", settings.CrouchEnabled, defaults.CrouchEnabled, function(state) settings.CrouchEnabled = state end)
	nativeSettings.addSwitch("/lhud/crouch", "Bind to Global hotkey", "If enabled then you will be able to toggle the module widgets visibility with the global hotkey if you have it configured", settings.CrouchGlobal, defaults.CrouchGlobal, function(state) settings.CrouchGlobal = state end)
	nativeSettings.addSwitch("/lhud/crouch", "Show in combat", "Show when combat mode is active", settings.CrouchCombat, defaults.CrouchCombat, function(state) settings.CrouchCombat = state end)
	nativeSettings.addSwitch("/lhud/crouch", "Show out of combat", "Show when when combat mode is not active and stealth mode is not active", settings.CrouchOutOfCombat, defaults.CrouchOutOfCombat, function(state) settings.CrouchOutOfCombat = state end)
	nativeSettings.addSwitch("/lhud/crouch", "Show in stealth", "Show when stealth mode is active", settings.CrouchStealth, defaults.CrouchStealth, function(state) settings.CrouchStealth = state end)
	nativeSettings.addSwitch("/lhud/crouch", "Show with weapon", "Show when weapon unsheated", settings.CrouchWeapon, defaults.CrouchWeapon, function(state) settings.CrouchWeapon = state end)
	nativeSettings.addSwitch("/lhud/crouch", "Show with zoom", "Show when zoom mode is active (press aim hotkey with no weapon in hands)", settings.CrouchZoom, defaults.CrouchZoom, function(state) settings.CrouchZoom = state end)
	
	nativeSettings.addSubcategory("/lhud/roster", "Weapon roster")
	nativeSettings.addSwitch("/lhud/roster", "Is module enabled", "If enabled then widget controlled by LHUD, disable if you want to restore default widget behavior", settings.RosterEnabled, defaults.RosterEnabled, function(state) settings.RosterEnabled = state end)
	nativeSettings.addSwitch("/lhud/roster", "Bind to Global hotkey", "If enabled then you will be able to toggle the module widgets visibility with the global hotkey if you have it configured", settings.RosterGlobal, defaults.RosterGlobal, function(state) settings.RosterGlobal = state end)
	nativeSettings.addSwitch("/lhud/roster", "Show in combat", "Show when combat mode is active", settings.RosterCombat, defaults.RosterCombat, function(state) settings.RosterCombat = state end)
	nativeSettings.addSwitch("/lhud/roster", "Show out of combat", "Show when when combat mode is not active and stealth mode is not active", settings.RosterOutOfCombat, defaults.RosterOutOfCombat, function(state) settings.RosterOutOfCombat = state end)
	nativeSettings.addSwitch("/lhud/roster", "Show in stealth", "Show when stealth mode is active", settings.RosterStealth, defaults.RosterStealth, function(state) settings.RosterStealth = state end)
	nativeSettings.addSwitch("/lhud/roster", "Show with weapon", "Show when weapon unsheated", settings.RosterWeapon, defaults.RosterWeapon, function(state) settings.RosterWeapon = state end)
	nativeSettings.addSwitch("/lhud/roster", "Show with zoom", "Show when zoom mode is active (press aim hotkey with no weapon in hands)", settings.RosterZoom, defaults.RosterZoom, function(state) settings.RosterZoom = state end)
	
	nativeSettings.addSubcategory("/lhud/hints", "Hotkey hints")
	nativeSettings.addSwitch("/lhud/hints", "Is module enabled", "If enabled then widget controlled by LHUD, disable if you want to restore default widget behavior", settings.HintsEnabled, defaults.HintsEnabled, function(state) settings.HintsEnabled = state end)
	nativeSettings.addSwitch("/lhud/hints", "Bind to Global hotkey", "If enabled then you will be able to toggle the module widgets visibility with the global hotkey if you have it configured", settings.HintsGlobal, defaults.HintsGlobal, function(state) settings.HintsGlobal = state end)
	nativeSettings.addSwitch("/lhud/hints", "Show in combat", "Show when combat mode is active", settings.HintsCombat, defaults.HintsCombat, function(state) settings.HintsCombat = state end)
	nativeSettings.addSwitch("/lhud/hints", "Show out of combat", "Show when when combat mode is not active and stealth mode is not active", settings.HintsOutOfCombat, defaults.HintsOutOfCombat, function(state) settings.HintsOutOfCombat = state end)
	nativeSettings.addSwitch("/lhud/hints", "Show in stealth", "Show when stealth mode is active", settings.HintsStealth, defaults.HintsStealth, function(state) settings.HintsStealth = state end)
	nativeSettings.addSwitch("/lhud/hints", "Show in vehicle", "Show when player mounted to vehicle", settings.HintsVehicle, defaults.HintsVehicle, function(state) settings.HintsVehicle = state end)
	nativeSettings.addSwitch("/lhud/hints", "Show with weapon", "Show when weapon unsheated", settings.HintsWeapon, defaults.HintsWeapon, function(state) settings.HintsWeapon = state end)
	nativeSettings.addSwitch("/lhud/hints", "Show with zoom", "Show when zoom mode is active (press aim hotkey with no weapon in hands)", settings.HintsZoom, defaults.HintsZoom, function(state) settings.HintsZoom = state end)
	
	nativeSettings.addSubcategory("/lhud/minimap", "Minimap")
	nativeSettings.addSwitch("/lhud/minimap", "Is module enabled", "If enabled then widget controlled by LHUD, disable if you want to restore default widget behavior", settings.MinimapEnabled, defaults.MinimapEnabled, function(state) settings.MinimapEnabled = state end)
	nativeSettings.addSwitch("/lhud/minimap", "Bind to Global hotkey", "If enabled then you will be able to toggle the module widgets visibility with the global hotkey if you have it configured", settings.MinimapGlobal, defaults.MinimapGlobal, function(state) settings.MinimapGlobal = state end)
	nativeSettings.addRangeFloat("/lhud/minimap", "Opacity", "Minimap widget opacity (change it from the main menu only)", 0.0, 1.0, 0.1, "%.1f", settings.MinimapOpacity, defaults.MinimapOpacity, function(value) settings.MinimapOpacity = value end)
	nativeSettings.addSwitch("/lhud/minimap", "Show in combat", "Show when combat mode is active", settings.MinimapCombat, defaults.MinimapCombat, function(state) settings.MinimapCombat = state end)
	nativeSettings.addSwitch("/lhud/minimap", "Show out of combat", "Show when when combat mode is not active and stealth mode is not active", settings.MinimapOutOfCombat, defaults.MinimapOutOfCombat, function(state) settings.MinimapOutOfCombat = state end)
	nativeSettings.addSwitch("/lhud/minimap", "Show in stealth", "Show when stealth mode is active", settings.MinimapStealth, defaults.MinimapStealth, function(state) settings.MinimapStealth = state end)
	nativeSettings.addSwitch("/lhud/minimap", "Show in vehicle", "Show when player mounted to vehicle", settings.MinimapVehicle, defaults.MinimapVehicle, function(state) settings.MinimapVehicle = state end)
	nativeSettings.addSwitch("/lhud/minimap", "Show with scanner", "Show when scanner is active", settings.MinimapScanner, defaults.MinimapScanner, function(state) settings.MinimapScanner = state end)
	nativeSettings.addSwitch("/lhud/minimap", "Show with weapon", "Show when weapon unsheated", settings.MinimapWeapon, defaults.MinimapWeapon, function(state) settings.MinimapWeapon = state end)
	nativeSettings.addSwitch("/lhud/minimap", "Show with zoom", "Show when zoom mode is active (press aim hotkey with no weapon in hands)", settings.MinimapZoom, defaults.MinimapZoom, function(state) settings.MinimapZoom = state end)
	
	nativeSettings.addSubcategory("/lhud/tracker", "Quest tracker")
	nativeSettings.addSwitch("/lhud/tracker", "Is module enabled", "If enabled then widget controlled by LHUD, disable if you want to restore default widget behavior", settings.TrackerEnabled, defaults.TrackerEnabled, function(state) settings.TrackerEnabled = state end)
	nativeSettings.addSwitch("/lhud/tracker", "Bind to Global hotkey", "If enabled then you will be able to toggle the module widgets visibility with the global hotkey if you have it configured", settings.TrackerGlobal, defaults.TrackerGlobal, function(state) settings.TrackerGlobal = state end)
	nativeSettings.addSwitch("/lhud/tracker", "Show in combat", "Show when combat mode is active", settings.TrackerCombat, defaults.TrackerCombat, function(state) settings.TrackerCombat = state end)
	nativeSettings.addSwitch("/lhud/tracker", "Show out of combat", "Show when when combat mode is not active and stealth mode is not active", settings.TrackerOutOfCombat, defaults.TrackerOutOfCombat, function(state) settings.TrackerOutOfCombat = state end)
	nativeSettings.addSwitch("/lhud/tracker", "Show in stealth", "Show when stealth mode is active", settings.TrackerStealth, defaults.TrackerStealth, function(state) settings.TrackerStealth = state end)
	nativeSettings.addSwitch("/lhud/tracker", "Show in vehicle", "Show when player mounted to vehicle", settings.TrackerVehicle, defaults.TrackerVehicle, function(state) settings.TrackerVehicle = state end)
	nativeSettings.addSwitch("/lhud/tracker", "Show with scanner", "Show when scanner is active", settings.TrackerScanner, defaults.TrackerScanner, function(state) settings.TrackerScanner = state end)
	nativeSettings.addSwitch("/lhud/tracker", "Show with weapon", "Show when weapon unsheated", settings.TrackerWeapon, defaults.TrackerWeapon, function(state) settings.TrackerWeapon = state end)
	nativeSettings.addSwitch("/lhud/tracker", "Show with zoom", "Show when zoom mode is active (press aim hotkey with no weapon in hands)", settings.TrackerZoom, defaults.TrackerZoom, function(state) settings.TrackerZoom = state end)
	
	nativeSettings.addSubcategory("/lhud/healthbar", "Player healthbar")
	nativeSettings.addSwitch("/lhud/healthbar", "Is module enabled", "If enabled then widget controlled by LHUD, disable if you want to restore default widget behavior", settings.HealthbarEnabled, defaults.HealthbarEnabled, function(state) settings.HealthbarEnabled = state end)
	nativeSettings.addSwitch("/lhud/healthbar", "Bind to Global hotkey", "If enabled then you will be able to toggle the module widgets visibility with the global hotkey if you have it configured", settings.HealthbarGlobal, defaults.HealthbarGlobal, function(state) settings.HealthbarGlobal = state end)
	nativeSettings.addSwitch("/lhud/healthbar", "Show when health not full", "Show when your character health is not full", settings.HealthbarNotFullHealth, defaults.HealthbarNotFullHealth, function(state) settings.HealthbarNotFullHealth = state end)
	nativeSettings.addSwitch("/lhud/healthbar", "Show when memory not full", "Show when your character memory is not full", settings.HealthbarNotFullMemory, defaults.HealthbarNotFullMemory, function(state) settings.HealthbarNotFullMemory = state end)
	nativeSettings.addSwitch("/lhud/healthbar", "Show with buffs", "Show when character has any active buffs", settings.HealthbarBuffs, defaults.HealthbarBuffs, function(state) settings.HealthbarBuffs = state end)
	nativeSettings.addSwitch("/lhud/healthbar", "Show with quickhacks", "Show when character has any active quickhack effects", settings.HealthbarHacks, defaults.HealthbarHacks, function(state) settings.HealthbarHacks = state end)
	nativeSettings.addSwitch("/lhud/healthbar", "Show in combat", "Show when combat mode is active", settings.HealthbarCombat, defaults.HealthbarCombat, function(state) settings.HealthbarCombat = state end)
	nativeSettings.addSwitch("/lhud/healthbar", "Show out of combat", "Show when when combat mode is not active and stealth mode is not active", settings.HealthbarOutOfCombat, defaults.HealthbarOutOfCombat, function(state) settings.HealthbarOutOfCombat = state end)
	nativeSettings.addSwitch("/lhud/healthbar", "Show in stealth", "Show when stealth mode is active", settings.HealthbarStealth, defaults.HealthbarStealth, function(state) settings.HealthbarStealth = state end)
	nativeSettings.addSwitch("/lhud/healthbar", "Show with weapon", "Show when weapon unsheated", settings.HealthbarWeapon, defaults.HealthbarWeapon, function(state) settings.HealthbarWeapon = state end)
	nativeSettings.addSwitch("/lhud/healthbar", "Show with zoom", "Show when zoom mode is active (press aim hotkey with no weapon in hands)", settings.HealthbarZoom, defaults.HealthbarZoom, function(state) settings.HealthbarZoom = state end)
	
	nativeSettings.addSubcategory("/lhud/questmakers", "World markers - Quest")
	nativeSettings.addSwitch("/lhud/questmakers", "Is module enabled", "If enabled then widget controlled by LHUD, disable if you want to restore default widget behavior", settings.QuestMarkersEnabled, defaults.QuestMarkersEnabled, function(state) settings.QuestMarkersEnabled = state end)
	nativeSettings.addSwitch("/lhud/questmakers", "Bind to Global hotkey", "If enabled then you will be able to toggle the module widgets visibility with the global hotkey if you have it configured", settings.QuestMarkersGlobal, defaults.QuestMarkersGlobal, function(state) settings.QuestMarkersGlobal = state end)
	nativeSettings.addSwitch("/lhud/questmakers", "Show in combat", "Show when combat mode is active", settings.QuestMarkersCombat, defaults.QuestMarkersCombat, function(state) settings.QuestMarkersCombat = state end)
	nativeSettings.addSwitch("/lhud/questmakers", "Show out of combat", "Show when when combat mode is not active and stealth mode is not active", settings.QuestMarkersOutOfCombat, defaults.QuestMarkersOutOfCombat, function(state) settings.QuestMarkersOutOfCombat = state end)
	nativeSettings.addSwitch("/lhud/questmakers", "Show in stealth", "Show when stealth mode is active", settings.QuestMarkersStealth, defaults.QuestMarkersStealth, function(state) settings.QuestMarkersStealth = state end)
	nativeSettings.addSwitch("/lhud/questmakers", "Show in vehicle", "Show when player mounted to vehicle", settings.QuestMarkersVehicle, defaults.QuestMarkersVehicle, function(state) settings.QuestMarkersVehicle = state end)
	nativeSettings.addSwitch("/lhud/questmakers", "Show with scanner", "Show when scanner is active", settings.QuestMarkersScanner, defaults.QuestMarkersScanner, function(state) settings.QuestMarkersScanner = state end)
	nativeSettings.addSwitch("/lhud/questmakers", "Show with weapon", "Show when weapon unsheated", settings.QuestMarkersWeapon, defaults.QuestMarkersWeapon, function(state) settings.QuestMarkersWeapon = state end)
	nativeSettings.addSwitch("/lhud/questmakers", "Show with zoom", "Show when zoom mode is active (press aim hotkey with no weapon in hands)", settings.QuestMarkersZoom, defaults.QuestMarkersZoom, function(state) settings.QuestMarkersZoom = state end)
	
	nativeSettings.addSubcategory("/lhud/lootmarkers", "World markers - Loot")
	nativeSettings.addSwitch("/lhud/lootmarkers", "Is module enabled", "If enabled then widget controlled by LHUD, disable if you want to restore default widget behavior", settings.LootMarkersEnabled, defaults.LootMarkersEnabled, function(state) settings.LootMarkersEnabled = state end)
	nativeSettings.addSwitch("/lhud/lootmarkers", "Bind to Global hotkey", "If enabled then you will be able to toggle the module widgets visibility with the global hotkey if you have it configured", settings.LootMarkersGlobal, defaults.LootMarkersGlobal, function(state) settings.LootMarkersGlobal = state end)
	nativeSettings.addSwitch("/lhud/lootmarkers", "Show in combat", "Show when combat mode is active", settings.LootMarkersCombat, defaults.LootMarkersCombat, function(state) settings.LootMarkersCombat = state end)
	nativeSettings.addSwitch("/lhud/lootmarkers", "Show out of combat", "Show when when combat mode is not active and stealth mode is not active", settings.LootMarkersOutOfCombat, defaults.LootMarkersOutOfCombat, function(state) settings.LootMarkersOutOfCombat = state end)
	nativeSettings.addSwitch("/lhud/lootmarkers", "Show in stealth", "Show when stealth mode is active", settings.LootMarkersStealth, defaults.LootMarkersStealth, function(state) settings.LootMarkersStealth = state end)
	nativeSettings.addSwitch("/lhud/lootmarkers", "Show in vehicle", "Show when player mounted to vehicle", settings.LootMarkersVehicle, defaults.LootMarkersVehicle, function(state) settings.LootMarkersVehicle = state end)
	nativeSettings.addSwitch("/lhud/lootmarkers", "Show with scanner", "Show when scanner is active", settings.LootMarkersScanner, defaults.LootMarkersScanner, function(state) settings.LootMarkersScanner = state end)
	nativeSettings.addSwitch("/lhud/lootmarkers", "Show with weapon", "Show when weapon unsheated", settings.LootMarkersWeapon, defaults.LootMarkersWeapon, function(state) settings.LootMarkersWeapon = state end)
	nativeSettings.addSwitch("/lhud/lootmarkers", "Show with zoom", "Show when zoom mode is active (press aim hotkey with no weapon in hands)", settings.LootMarkersZoom, defaults.LootMarkersZoom, function(state) settings.LootMarkersZoom = state end)
	
	nativeSettings.addSubcategory("/lhud/poimarkers", "World markers - Places Of Interest")
	nativeSettings.addSwitch("/lhud/poimarkers", "Is module enabled", "If enabled then widget controlled by LHUD, disable if you want to restore default widget behavior", settings.POIMarkersEnabled, defaults.POIMarkersEnabled, function(state) settings.POIMarkersEnabled = state end)
	nativeSettings.addSwitch("/lhud/poimarkers", "Bind to Global hotkey", "If enabled then you will be able to toggle the module widgets visibility with the global hotkey if you have it configured", settings.POIMarkersGlobal, defaults.POIMarkersGlobal, function(state) settings.POIMarkersGlobal = state end)
	nativeSettings.addSwitch("/lhud/poimarkers", "Show in combat", "Show when combat mode is active", settings.POIMarkersCombat, defaults.POIMarkersCombat, function(state) settings.POIMarkersCombat = state end)
	nativeSettings.addSwitch("/lhud/poimarkers", "Show out of combat", "Show when when combat mode is not active and stealth mode is not active", settings.POIMarkersOutOfCombat, defaults.POIMarkersOutOfCombat, function(state) settings.POIMarkersOutOfCombat = state end)
	nativeSettings.addSwitch("/lhud/poimarkers", "Show in stealth", "Show when stealth mode is active", settings.POIMarkersStealth, defaults.POIMarkersStealth, function(state) settings.POIMarkersStealth = state end)
	nativeSettings.addSwitch("/lhud/poimarkers", "Show in vehicle", "Show when player mounted to vehicle", settings.POIMarkersVehicle, defaults.POIMarkersVehicle, function(state) settings.POIMarkersVehicle = state end)
	nativeSettings.addSwitch("/lhud/poimarkers", "Show with scanner", "Show when scanner is active", settings.POIMarkersScanner, defaults.POIMarkersScanner, function(state) settings.POIMarkersScanner = state end)
	nativeSettings.addSwitch("/lhud/poimarkers", "Show with weapon", "Show when weapon unsheated", settings.POIMarkersWeapon, defaults.POIMarkersWeapon, function(state) settings.POIMarkersWeapon = state end)
	nativeSettings.addSwitch("/lhud/poimarkers", "Show with zoom", "Show when zoom mode is active (press aim hotkey with no weapon in hands)", settings.POIMarkersZoom, defaults.POIMarkersZoom, function(state) settings.POIMarkersZoom = state end)
	nativeSettings.addSwitch("/lhud/poimarkers", "Always show tracked", "If enabled then makes current tracked POI marker always visible", settings.POIAlwaysShowTracked, defaults.POIAlwaysShowTracked, function(state) settings.POIAlwaysShowTracked = state end)
	
	nativeSettings.addSubcategory("/lhud/combatmarkers", "World markers - Combat")
	nativeSettings.addSwitch("/lhud/combatmarkers", "Is module enabled", "If enabled then widget controlled by LHUD, disable if you want to restore default widget behavior", settings.CombatMarkersEnabled, defaults.CombatMarkersEnabled, function(state) settings.CombatMarkersEnabled = state end)
	nativeSettings.addSwitch("/lhud/combatmarkers", "Bind to Global hotkey", "If enabled then you will be able to toggle the module widgets visibility with the global hotkey if you have it configured", settings.CombatMarkersGlobal, defaults.CombatMarkersGlobal, function(state) settings.CombatMarkersGlobal = state end)
	nativeSettings.addSwitch("/lhud/combatmarkers", "Show in combat", "Show when combat mode is active", settings.CombatMarkersCombat, defaults.CombatMarkersCombat, function(state) settings.CombatMarkersCombat = state end)
	nativeSettings.addSwitch("/lhud/combatmarkers", "Show out of combat", "Show when when combat mode is not active and stealth mode is not active", settings.CombatMarkersOutOfCombat, defaults.CombatMarkersOutOfCombat, function(state) settings.CombatMarkersOutOfCombat = state end)
	nativeSettings.addSwitch("/lhud/combatmarkers", "Show in stealth", "Show when stealth mode is active", settings.CombatMarkersStealth, defaults.CombatMarkersStealth, function(state) settings.CombatMarkersStealth = state end)
	nativeSettings.addSwitch("/lhud/combatmarkers", "Show in vehicle", "Show when player mounted to vehicle", settings.CombatMarkersVehicle, defaults.CombatMarkersVehicle, function(state) settings.CombatMarkersVehicle = state end)
	nativeSettings.addSwitch("/lhud/combatmarkers", "Show with scanner", "Show when scanner is active", settings.CombatMarkersScanner, defaults.CombatMarkersScanner, function(state) settings.CombatMarkersScanner = state end)
	nativeSettings.addSwitch("/lhud/combatmarkers", "Show with weapon", "Show when weapon unsheated", settings.CombatMarkersWeapon, defaults.CombatMarkersWeapon, function(state) settings.CombatMarkersWeapon = state end)
	nativeSettings.addSwitch("/lhud/combatmarkers", "Show with zoom", "Show when zoom mode is active (press aim hotkey with no weapon in hands)", settings.CombatMarkersZoom, defaults.CombatMarkersZoom, function(state) settings.CombatMarkersZoom = state end)
	
	nativeSettings.addSubcategory("/lhud/vehiclemarkers", "World markers - Owned Vehicles")
	nativeSettings.addSwitch("/lhud/vehiclemarkers", "Is module enabled", "If enabled then widget controlled by LHUD, disable if you want to restore default widget behavior", settings.VehicleMarkersEnabled, defaults.VehicleMarkersEnabled, function(state) settings.VehicleMarkersEnabled = state end)
	nativeSettings.addSwitch("/lhud/vehiclemarkers", "Bind to Global hotkey", "If enabled then you will be able to toggle the module widgets visibility with the global hotkey if you have it configured", settings.VehicleMarkersGlobal, defaults.VehicleMarkersGlobal, function(state) settings.VehicleMarkersGlobal = state end)
	nativeSettings.addSwitch("/lhud/vehiclemarkers", "Show in vehicle", "Show when player mounted to vehicle", settings.VehicleMarkersVehicle, defaults.VehicleMarkersVehicle, function(state) settings.VehicleMarkersVehicle = state end)
	nativeSettings.addSwitch("/lhud/vehiclemarkers", "Show with scanner", "Show when scanner is active", settings.VehicleMarkersScanner, defaults.VehicleMarkersScanner, function(state) settings.VehicleMarkersScanner = state end)
	nativeSettings.addSwitch("/lhud/vehiclemarkers", "Show with zoom", "Show when zoom mode is active (press aim hotkey with no weapon in hands)", settings.VehicleMarkersZoom, defaults.VehicleMarkersZoom, function(state) settings.VehicleMarkersZoom = state end)
	
	nativeSettings.addSubcategory("/lhud/interactionmarkers", "World markers - Device Interactions")
	nativeSettings.addSwitch("/lhud/interactionmarkers", "Is module enabled", "If enabled then widgets controlled by LHUD, disable if you want to restore default widget behavior", settings.DeviceMarkersEnabled, defaults.DeviceMarkersEnabled, function(state) settings.DeviceMarkersEnabled = state end)
	nativeSettings.addSwitch("/lhud/interactionmarkers", "Show with scanner", "Show when scanner is active", settings.DeviceMarkersScanner, defaults.DeviceMarkersScanner, function(state) settings.DeviceMarkersScanner = state end)
end

registerForEvent("onInit", function()

	LoadSettings()
	SetupSettingsMenu()
	
	Override("LimitedHudConfig.ActionButtonsModuleConfig", "IsEnabled;", function(_) return settings.ActionButtonsEnabled end)
	Override("LimitedHudConfig.ActionButtonsModuleConfig", "BindToGlobalHotkey;", function(_) return settings.ActionButtonsGlobal end)
	Override("LimitedHudConfig.ActionButtonsModuleConfig", "ShowInCombat;", function(_) return settings.ActionButtonsCombat end)
	Override("LimitedHudConfig.ActionButtonsModuleConfig", "ShowOutOfCombat;", function(_) return settings.ActionButtonsOutOfCombat end)
	Override("LimitedHudConfig.ActionButtonsModuleConfig", "ShowInStealth;", function(_) return settings.ActionButtonsStealth end)
	Override("LimitedHudConfig.ActionButtonsModuleConfig", "ShowWithWeapon;", function(_) return settings.ActionButtonsWeapon end)
	Override("LimitedHudConfig.ActionButtonsModuleConfig", "ShowWithZoom;", function(_) return settings.ActionButtonsZoom end)
	Override("LimitedHudConfig.CrouchIndicatorModuleConfig", "IsEnabled;", function(_) return settings.CrouchEnabled end)
	Override("LimitedHudConfig.CrouchIndicatorModuleConfig", "BindToGlobalHotkey;", function(_) return settings.CrouchGlobal end)
	Override("LimitedHudConfig.CrouchIndicatorModuleConfig", "ShowInCombat;", function(_) return settings.CrouchCombat end)
	Override("LimitedHudConfig.CrouchIndicatorModuleConfig", "ShowOutOfCombat;", function(_) return settings.CrouchOutOfCombat end)
	Override("LimitedHudConfig.CrouchIndicatorModuleConfig", "ShowInStealth;", function(_) return settings.CrouchStealth end)
	Override("LimitedHudConfig.CrouchIndicatorModuleConfig", "ShowWithWeapon;", function(_) return settings.CrouchWeapon end)
	Override("LimitedHudConfig.CrouchIndicatorModuleConfig", "ShowWithZoom;", function(_) return settings.CrouchZoom end)
	Override("LimitedHudConfig.WeaponRosterModuleConfig", "IsEnabled;", function(_) return settings.RosterEnabled end)
	Override("LimitedHudConfig.WeaponRosterModuleConfig", "BindToGlobalHotkey;", function(_) return settings.RosterGlobal end)
	Override("LimitedHudConfig.WeaponRosterModuleConfig", "ShowInCombat;", function(_) return settings.RosterCombat end)
	Override("LimitedHudConfig.WeaponRosterModuleConfig", "ShowOutOfCombat;", function(_) return settings.RosterOutOfCombat end)
	Override("LimitedHudConfig.WeaponRosterModuleConfig", "ShowInStealth;", function(_) return settings.RosterStealth end)
	Override("LimitedHudConfig.WeaponRosterModuleConfig", "ShowWithWeapon;", function(_) return settings.RosterWeapon end)
	Override("LimitedHudConfig.WeaponRosterModuleConfig", "ShowWithZoom;", function(_) return settings.RosterZoom end)
	Override("LimitedHudConfig.HintsModuleConfig", "IsEnabled;", function(_) return settings.HintsEnabled end)
	Override("LimitedHudConfig.HintsModuleConfig", "BindToGlobalHotkey;", function(_) return settings.HintsGlobal end)
	Override("LimitedHudConfig.HintsModuleConfig", "ShowInCombat;", function(_) return settings.HintsCombat end)
	Override("LimitedHudConfig.HintsModuleConfig", "ShowOutOfCombat;", function(_) return settings.HintsOutOfCombat end)
	Override("LimitedHudConfig.HintsModuleConfig", "ShowInStealth;", function(_) return settings.HintsStealth end)
	Override("LimitedHudConfig.HintsModuleConfig", "ShowInVehicle;", function(_) return settings.HintsVehicle end)
	Override("LimitedHudConfig.HintsModuleConfig", "ShowWithWeapon;", function(_) return settings.HintsWeapon end)
	Override("LimitedHudConfig.HintsModuleConfig", "ShowWithZoom;", function(_) return settings.HintsZoom end)
	Override("LimitedHudConfig.MinimapModuleConfig", "IsEnabled;", function(_) return settings.MinimapEnabled end)
	Override("LimitedHudConfig.MinimapModuleConfig", "BindToGlobalHotkey;", function(_) return settings.MinimapGlobal end)
	Override("LimitedHudConfig.MinimapModuleConfig", "ShowInCombat;", function(_) return settings.MinimapCombat end)
	Override("LimitedHudConfig.MinimapModuleConfig", "ShowOutOfCombat;", function(_) return settings.MinimapOutOfCombat end)
	Override("LimitedHudConfig.MinimapModuleConfig", "ShowInStealth;", function(_) return settings.MinimapStealth end)
	Override("LimitedHudConfig.MinimapModuleConfig", "ShowInVehicle;", function(_) return settings.MinimapVehicle end)
	Override("LimitedHudConfig.MinimapModuleConfig", "ShowWithScanner;", function(_) return settings.MinimapScanner end)
	Override("LimitedHudConfig.MinimapModuleConfig", "ShowWithWeapon;", function(_) return settings.MinimapWeapon end)
	Override("LimitedHudConfig.MinimapModuleConfig", "ShowWithZoom;", function(_) return settings.MinimapZoom end)
	Override("LimitedHudConfig.MinimapModuleConfig", "Opacity;", function(_) return settings.MinimapOpacity end)
	Override("LimitedHudConfig.QuestTrackerModuleConfig", "IsEnabled;", function(_) return settings.TrackerEnabled end)
	Override("LimitedHudConfig.QuestTrackerModuleConfig", "BindToGlobalHotkey;", function(_) return settings.TrackerGlobal end)
	Override("LimitedHudConfig.QuestTrackerModuleConfig", "ShowInCombat;", function(_) return settings.TrackerCombat end)
	Override("LimitedHudConfig.QuestTrackerModuleConfig", "ShowOutOfCombat;", function(_) return settings.TrackerOutOfCombat end)
	Override("LimitedHudConfig.QuestTrackerModuleConfig", "ShowInStealth;", function(_) return settings.TrackerStealth end)
	Override("LimitedHudConfig.QuestTrackerModuleConfig", "ShowInVehicle;", function(_) return settings.TrackerVehicle end)
	Override("LimitedHudConfig.QuestTrackerModuleConfig", "ShowWithScanner;", function(_) return settings.TrackerScanner end)
	Override("LimitedHudConfig.QuestTrackerModuleConfig", "ShowWithWeapon;", function(_) return settings.TrackerWeapon end)
	Override("LimitedHudConfig.QuestTrackerModuleConfig", "ShowWithZoom;", function(_) return settings.TrackerZoom end)
	Override("LimitedHudConfig.PlayerHealthbarModuleConfig", "IsEnabled;", function(_) return settings.HealthbarEnabled end)
	Override("LimitedHudConfig.PlayerHealthbarModuleConfig", "BindToGlobalHotkey;", function(_) return settings.HealthbarGlobal end)
	Override("LimitedHudConfig.PlayerHealthbarModuleConfig", "ShowWhenHealthNotFull;", function(_) return settings.HealthbarNotFullHealth end)
	Override("LimitedHudConfig.PlayerHealthbarModuleConfig", "ShowWhenMemoryNotFull;", function(_) return settings.HealthbarNotFullMemory end)
	Override("LimitedHudConfig.PlayerHealthbarModuleConfig", "ShowWhenBuffsActive;", function(_) return settings.HealthbarBuffs end)
	Override("LimitedHudConfig.PlayerHealthbarModuleConfig", "ShowWhenQuickhacksActive;", function(_) return settings.HealthbarHacks end)
	Override("LimitedHudConfig.PlayerHealthbarModuleConfig", "ShowInCombat;", function(_) return settings.HealthbarCombat end)
	Override("LimitedHudConfig.PlayerHealthbarModuleConfig", "ShowOutOfCombat;", function(_) return settings.HealthbarOutOfCombat end)
	Override("LimitedHudConfig.PlayerHealthbarModuleConfig", "ShowInStealth;", function(_) return settings.HealthbarStealth end)
	Override("LimitedHudConfig.PlayerHealthbarModuleConfig", "ShowWithWeapon;", function(_) return settings.HealthbarWeapon end)
	Override("LimitedHudConfig.PlayerHealthbarModuleConfig", "ShowWithZoom;", function(_) return settings.HealthbarZoom end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigQuest", "IsEnabled;", function(_) return settings.QuestMarkersEnabled end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigQuest", "BindToGlobalHotkey;", function(_) return settings.QuestMarkersGlobal end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigQuest", "ShowInCombat;", function(_) return settings.QuestMarkersCombat end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigQuest", "ShowOutOfCombat;", function(_) return settings.QuestMarkersOutOfCombat end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigQuest", "ShowInStealth;", function(_) return settings.QuestMarkersStealth end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigQuest", "ShowInVehicle;", function(_) return settings.QuestMarkersVehicle end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigQuest", "ShowWithScanner;", function(_) return settings.QuestMarkersScanner end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigQuest", "ShowWithWeapon;", function(_) return settings.QuestMarkersWeapon end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigQuest", "ShowWithZoom;", function(_) return settings.QuestMarkersZoom end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigLoot", "IsEnabled;", function(_) return settings.LootMarkersEnabled end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigLoot", "BindToGlobalHotkey;", function(_) return settings.LootMarkersGlobal end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigLoot", "ShowInCombat;", function(_) return settings.LootMarkersCombat end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigLoot", "ShowOutOfCombat;", function(_) return settings.LootMarkersOutOfCombat end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigLoot", "ShowInStealth;", function(_) return settings.LootMarkersStealth end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigLoot", "ShowInVehicle;", function(_) return settings.LootMarkersVehicle end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigLoot", "ShowWithScanner;", function(_) return settings.LootMarkersScanner end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigLoot", "ShowWithWeapon;", function(_) return settings.LootMarkersWeapon end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigLoot", "ShowWithZoom;", function(_) return settings.LootMarkersZoom end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigPOI", "IsEnabled;", function(_) return settings.POIMarkersEnabled end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigPOI", "BindToGlobalHotkey;", function(_) return settings.POIMarkersGlobal end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigPOI", "ShowInCombat;", function(_) return settings.POIMarkersCombat end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigPOI", "ShowOutOfCombat;", function(_) return settings.POIMarkersOutOfCombat end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigPOI", "ShowInStealth;", function(_) return settings.POIMarkersStealth end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigPOI", "ShowInVehicle;", function(_) return settings.POIMarkersVehicle end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigPOI", "ShowWithScanner;", function(_) return settings.POIMarkersScanner end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigPOI", "ShowWithWeapon;", function(_) return settings.POIMarkersWeapon end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigPOI", "ShowWithZoom;", function(_) return settings.POIMarkersZoom end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigPOI", "AlwaysShowTrackedMarker;", function(_) return settings.POIAlwaysShowTracked end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigCombat", "IsEnabled;", function(_) return settings.CombatMarkersEnabled end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigCombat", "BindToGlobalHotkey;", function(_) return settings.CombatMarkersGlobal end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigCombat", "ShowInCombat;", function(_) return settings.CombatMarkersCombat end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigCombat", "ShowOutOfCombat;", function(_) return settings.CombatMarkersOutOfCombat end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigCombat", "ShowInStealth;", function(_) return settings.CombatMarkersStealth end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigCombat", "ShowInVehicle;", function(_) return settings.CombatMarkersVehicle end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigCombat", "ShowWithScanner;", function(_) return settings.CombatMarkersScanner end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigCombat", "ShowWithWeapon;", function(_) return settings.CombatMarkersWeapon end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigCombat", "ShowWithZoom;", function(_) return settings.CombatMarkersZoom end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigVehicles", "IsEnabled;", function(_) return settings.VehicleMarkersEnabled end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigVehicles", "BindToGlobalHotkey;", function(_) return settings.VehicleMarkersGlobal end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigVehicles", "ShowInVehicle;", function(_) return settings.VehicleMarkersVehicle end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigVehicles", "ShowWithScanner;", function(_) return settings.VehicleMarkersScanner end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigVehicles", "ShowWithZoom;", function(_) return settings.VehicleMarkersZoom end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigVehicles", "IsEnabled;", function(_) return settings.DeviceMarkersEnabled end)
	Override("LimitedHudConfig.WorldMarkersModuleConfigVehicles", "ShowWithScanner;", function(_) return settings.DeviceMarkersScanner end)

end)

registerForEvent("onShutdown", function()
    SaveSettings()
end)
