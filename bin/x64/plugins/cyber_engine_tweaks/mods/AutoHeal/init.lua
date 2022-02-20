------------------------------------------------
-- INITIALISATION
------------------------------------------------
firstRun = true
timer = 0
useCount = 0

local autoheal = {
	useMaxDoc = 1,
	useBounceBack = 2,
	combatTimer = 0,
	oncePerCombat = true,
	endCombatReuse = true,	
	autoUse = true,
	useAtPlayerHealth = 30,
	useFood = false,
	convertFood = false,
	foodCheckTime = 10,
	showActiveMsg = true,
	showHealMsg = true,
	showHealAlert = true
}

local GameUI = require('config/GameUI')

AutoHeal = { description = "Auto Heal" }
function AutoHeal:new()

registerForEvent("onUpdate", function(deltaTime)
------------------------------------------------
-- CHECK GOOD TO GO ...
------------------------------------------------
	if paused then return end
------------------------------------------------
-- READY...
------------------------------------------------
	if firstRun then
		firstRun = false
		
		itemHealth0ID = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.FirstAidWhiffV0"))
		itemHealth1ID = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.FirstAidWhiffV1"))
		itemHealth2ID = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.FirstAidWhiffV2"))
		itemRegen0ID = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.BonesMcCoy70V0"))
		itemRegen1ID = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.BonesMcCoy70V1"))
		itemRegen2ID = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.BonesMcCoy70V2"))
		itemFoodID = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.LowQualityFood11"))
		
		if autoheal.showActiveMsg then print("AutoHeal activated.") end
	end
	
	if timer > 0 then timer = timer - deltaTime end

	if not inCombat then
		if autoheal.endCombatReuse then timer = 0 end

		if useCount > 0 and timer <= 0 then
			if autoheal.oncePerCombat then
				playerHealth = ss:GetStatPoolValue(playerID, 'Health', true)
				if playerHealth > 0 and autoheal.showHealAlert then player:SetWarningMessage("AutoHeal Available !") end
			else
				if autoheal.showHealMsg then print("AutoHeal: Heals used during combat:",useCount) end
			end
			useCount = 0
		end
		if autoheal.useFood and timer <= 0 then eatFood() end
		if autoheal.convertFood then processFood() end
		return
	end
	
	if autoheal.oncePerCombat and useCount > 0 then return end
------------------------------------------------
-- CHECK HEALTH
------------------------------------------------
	playerHealth = ss:GetStatPoolValue(playerID, 'Health', true)
	if playerHealth < 2 or playerHealth > autoheal.useAtPlayerHealth then return end
------------------------------------------------
-- ACTIVATE 
------------------------------------------------
	actionHeal()
	
	if autoheal.oncePerCombat then 
		if autoheal.showHealMsg then print("AutoHeal: AutoHeal used during combat.") end
		if autoheal.showHealAlert then player:SetWarningMessage("AutoHeal Used !") end
	end
end)

function actionHeal()
	if timer > 0 or playerHealth > 90 then return end
	------------------------------------------------
	-- GET CURRENT AMOUNTS 
	------------------------------------------------
	currentHealth0Count = ts:GetItemQuantity(player, itemHealth0ID)
	currentHealth1Count = ts:GetItemQuantity(player, itemHealth1ID)
	currentHealth2Count = ts:GetItemQuantity(player, itemHealth2ID)
	currentRegen0Count = ts:GetItemQuantity(player, itemRegen0ID)
	currentRegen1Count = ts:GetItemQuantity(player, itemRegen1ID)
	currentRegen2Count = ts:GetItemQuantity(player, itemRegen2ID)
	------------------------------------------------
	-- ACTIVATE 
	------------------------------------------------
	if autoheal.useMaxDoc == 3 and currentHealth2Count > 0 then
		Game['ItemActionsHelper::ConsumeItem;GameObjectItemIDBool'](player, itemHealth2ID, true)
	elseif autoheal.useMaxDoc >= 2 and currentHealth1Count > 0 then
		Game['ItemActionsHelper::ConsumeItem;GameObjectItemIDBool'](player, itemHealth1ID, true)
	elseif autoheal.useMaxDoc >= 1 and currentHealth0Count > 0 then
		Game['ItemActionsHelper::ConsumeItem;GameObjectItemIDBool'](player, itemHealth0ID, true)
	end

	if autoheal.useBounceBack == 3 and currentRegen2Count > 0 then
		Game['ItemActionsHelper::ConsumeItem;GameObjectItemIDBool'](player, itemRegen2ID, true)
	elseif autoheal.useBounceBack >= 2 and currentRegen1Count > 0 then
		Game['ItemActionsHelper::ConsumeItem;GameObjectItemIDBool'](player, itemRegen1ID, true)
	elseif autoheal.useBounceBack >= 1 and currentRegen0Count > 0 then
		Game['ItemActionsHelper::ConsumeItem;GameObjectItemIDBool'](player, itemRegen0ID, true)
	end
	timer = timerValues[autoheal.combatTimer]
	useCount = useCount + 1
end

------------------------------------------------
-- ADDITIONAL FUNCTIONS
------------------------------------------------
function eatFood()
	currentFoodCount = ts:GetItemQuantity(player, itemFoodID)
	if currentFoodCount > 0 then
		playerHealth = ss:GetStatPoolValue(playerID, 'Health', true)
		if playerHealth > 0 and playerHealth < 100 then
			if not checked then
				checked = true
				prevHealth = playerHealth
				checkHealth = os.time() + autoheal.foodCheckTime
			else
				if os.time() > checkHealth then
					checked = false
					if playerHealth == prevHealth then
						Game['ItemActionsHelper::EatItem;GameObjectItemIDBool'](player, itemFoodID, true)
						if autoheal.showHealMsg then print("AutoHeal: Food eaten. (Player Health at "..string.format("%.1f",playerHealth).."%)") end
					end
				end
			end
		end
	end
end

function gameReload()
	timer = 0
	useCount = 0
end

------------------------------------------------
-- UTILITY FUNCTIONS
------------------------------------------------
inCombat = false
paused = true

registerForEvent("onInit", function()
	Observe("PlayerPuppet", "OnCombatStateChanged", function(self,state)
		inCombat = state == 1
	end)
	
	GameUI.Observe(function(state)
		paused = not state.isDefault or state.isJohnny
		menu = GameUI.GetMenu()
		if state.isLoading then gameReload() end
	end)

	player = Game.GetPlayerSystem():GetLocalPlayerMainGameObject()
	ts = Game.GetTransactionSystem()
	playerID = player:GetEntityID()
	ss = Game.GetStatPoolsSystem()
	
	loadConfig()
end)

registerHotkey("healKey","Heal",function()
	actionHeal()
end)

function saveConfig()
    local file = io.open("config/settings.json", "w")
    local jconfig = json.encode(autoheal)
    file:write(jconfig)
    file:close()
end

function loadConfig()    
    local file = io.open("config/settings.json", "r")
	if file == nil then
		saveConfig()
	else
		autoheal = json.decode(file:read("*a"))
		file:close()
	end
end

------------------------------------------------
-- OPTIONAL - CONVERT FOOD ITEMS
-- note, this is practically lifted from Simplified Inventory, all credit to that mod
------------------------------------------------
do
	local foodItems = {}
	local nextFoodCheck = os.time()

	local foodItems = {
			"Items.GoodQualityFood1",
			"Items.GoodQualityFood10",
			"Items.GoodQualityFood11",
			"Items.GoodQualityFood12",
			"Items.GoodQualityFood13",
			"Items.GoodQualityFood2",
			"Items.GoodQualityFood3",
			"Items.GoodQualityFood4",
			"Items.GoodQualityFood5",
			"Items.GoodQualityFood6",
			"Items.GoodQualityFood7",
			"Items.GoodQualityFood8",
			"Items.GoodQualityFood9",
			"Items.LowQualityFood1",
			"Items.LowQualityFood10",
			--"Items.LowQualityFood11",
			"Items.LowQualityFood12",
			"Items.LowQualityFood13",
			"Items.LowQualityFood14",
			"Items.LowQualityFood15",
			"Items.LowQualityFood16",
			"Items.LowQualityFood17",
			"Items.LowQualityFood18",
			"Items.LowQualityFood19",
			"Items.LowQualityFood20",
			"Items.LowQualityFood21",
			"Items.LowQualityFood22",
			"Items.LowQualityFood23",
			"Items.LowQualityFood24",
			"Items.LowQualityFood25",
			"Items.LowQualityFood26",
			"Items.LowQualityFood27",
			"Items.LowQualityFood28",
			"Items.LowQualityFood3",
			"Items.LowQualityFood5",
			"Items.LowQualityFood6",
			"Items.LowQualityFood7",
			"Items.LowQualityFood8",
			"Items.LowQualityFood9",
			"Items.MediumQualityFood1",
			"Items.MediumQualityFood10",
			"Items.MediumQualityFood11",
			"Items.MediumQualityFood12",
			"Items.MediumQualityFood13",
			"Items.MediumQualityFood14",
			"Items.MediumQualityFood15",
			"Items.MediumQualityFood16",
			"Items.MediumQualityFood17",
			"Items.MediumQualityFood18",
			"Items.MediumQualityFood19",
			"Items.MediumQualityFood2",
			"Items.MediumQualityFood20",
			"Items.MediumQualityFood3",
			"Items.MediumQualityFood4",
			"Items.MediumQualityFood5",
			"Items.MediumQualityFood6",
			"Items.MediumQualityFood7",
			"Items.MediumQualityFood8",
			"Items.MediumQualityFood9",
			"Items.NomadsFood1",
			"Items.NomadsFood2"
			}
			
	function processFood()
		if os.time() > nextFoodCheck then
			local totalFood = 0
			for i,v in ipairs(foodItems) do
				tid = TweakDBID.new(v)
				itemid = GetSingleton("gameItemID"):FromTDBID(tid)
				local currentFoodCount = ts:GetItemQuantity(player, itemid)
				
				if currentFoodCount > 0 then
					ts:RemoveItem(player, itemid, currentFoodCount)
					totalFood = totalFood + currentFoodCount
				end
			end
			
			if totalFood > 0 then Game.AddToInventory("Items.LowQualityFood11", totalFood) end
			nextFoodCheck = os.time() + 2		-- run no more than once every other second
		end
	end
end

------------------------------------------------
-- UI
------------------------------------------------
windowOpen = false
timerValues = {5, 15, 30, 60, 120, 0}

registerForEvent("onOverlayOpen", function()
	windowOpen = true
end)

registerForEvent("onOverlayClose", function()
	windowOpen = false
end)

registerForEvent('onDraw', function()	
	if windowOpen then
	
		local windowWidth = 350
		local screenWidth, screenHeight = GetDisplayResolution()
		local screenRatioX, screenRatioY = screenWidth / 1920, screenHeight / 1200

		ImGui.SetNextWindowPos(600 * screenRatioX, 30 * screenRatioY, ImGuiCond.FirstUseEver)
		ImGui.SetNextWindowSize(windowWidth, 297)

		--ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 8)
		ImGui.PushStyleVar(ImGuiStyleVar.WindowPadding, 8, 7)
		ImGui.PushStyleColor(ImGuiCol.WindowBg, 0xaa000000)
		ImGui.PushStyleColor(ImGuiCol.Border, 0x8ffefd01)
		
		local update = false
		
		ImGui.Begin('AutoHeal')
		ImGui.BeginTabBar("Tabs")

		if ImGui.BeginTabItem("AutoHeal") then
			ImGui.Text("Heal Method")
			optionTextforSlider = {}
			optionTextforSlider[0] = "HotKey"
			optionTextforSlider[1] = "AutoHeal"
			local current = autoheal.autoUse and 1 or 0
			tempValue = optionTextforSlider[current]
			current, changed = ImGui.SliderInt(" Method", current, 0, 1, tempValue)
			if changed then update = true end
			autoheal.autoUse = current == 1
			
			if not autoheal.autoUse then 
				ImGui.PushStyleColor(ImGuiCol.Text, 0xaaaaaaaa)
			end
			ImGui.Text("Use at Player Health")
			local current = autoheal.useAtPlayerHealth / 5
			tempValue = 5 * current .. "%%"
			current, changed = ImGui.SliderInt(" Health", current, 2, 10, tempValue)
			if autoheal.autoUse then 
				autoheal.useAtPlayerHealth = current * 5
				if changed then update = true end
			else
				ImGui.PopStyleColor()
			end

			ImGui.Separator()
			
			ImGui.Text("Re-Use Timer")
			local combatEndValue = #timerValues
			if timerValues[combatEndValue] ~= 0 then table.insert(timerValues, 0) end
			for i, v in ipairs(timerValues) do
				if v == 0 then 
					optionTextforSlider[i] = "Combat End Only"
				else
					optionTextforSlider[i] = v.." secs"
				end
			end
			tempValue = optionTextforSlider[autoheal.combatTimer]
			autoheal.combatTimer, changed = ImGui.SliderInt(" Timer", autoheal.combatTimer, 1, combatEndValue, tempValue)
			if changed then update = true end
			autoheal.oncePerCombat = autoheal.combatTimer == combatEndValue
			if autoheal.oncePerCombat then 
				autoheal.endCombatReuse = true
				ImGui.PushStyleColor(ImGuiCol.Text, 0xaaaaaaaa)
			end

			autoheal.endCombatReuse = ImGui.Checkbox("Timer Resets at End of Combat", autoheal.endCombatReuse)
			if autoheal.oncePerCombat then ImGui.PopStyleColor() end

			ImGui.Separator()
			
			ImGui.Text("Default Inhalers To Use")
			optionTextforSlider = {}
			optionTextforSlider[0] = "None"
			optionTextforSlider[1] = "Bounce Back Mk.1"
			optionTextforSlider[2] = "Bounce Back Mk.2"
			optionTextforSlider[3] = "Bounce Back Mk.3"
			tempValue = optionTextforSlider[autoheal.useBounceBack]
			autoheal.useBounceBack, changed = ImGui.SliderInt(" Bounce Back", autoheal.useBounceBack, 0, 3, tempValue)
			if changed then
				if autoheal.useBounceBack == 0 and autoheal.useMaxDoc == 0 then autoheal.useMaxDoc = 1 end
				update = true
			end

			optionTextforSlider[1] = "MaxDoc Mk.1"
			optionTextforSlider[2] = "MaxDoc Mk.2"
			optionTextforSlider[3] = "MaxDoc Mk.3"
			tempValue = optionTextforSlider[autoheal.useMaxDoc]
			autoheal.useMaxDoc, changed = ImGui.SliderInt(" MaxDoc", autoheal.useMaxDoc, 0, 3, tempValue)
			if changed then
				if autoheal.useBounceBack == 0 and autoheal.useMaxDoc == 0 then autoheal.useBounceBack = 1 end
				update = true
			end

			
			ImGui.Separator()
			ImGui.Spacing()
			
			if ImGui.Button("Reset to Defaults") then
				autoheal.useMaxDoc = 1
				autoheal.useBounceBack = 2
				autoheal.combatTimer = combatEndValue
				autoheal.autoUse = true		
				autoheal.endCombatReuse = true
				autoheal.useAtPlayerHealth = 30
				update = true
			end
			
			ImGui.EndTabItem()
		end
			
		if ImGui.BeginTabItem("Food") then
			autoheal.useFood, changed = ImGui.Checkbox("Consume Food to Keep Health at 100%", autoheal.useFood)
			if changed then update = true end
			if not autoheal.useFood then
				ImGui.PushStyleColor(ImGuiCol.Text, 0xaaaaaaaa)
				autoheal.convertFood = false
			end
			
			autoheal.convertFood, changed = ImGui.Checkbox("Convert Food to Single Item", autoheal.convertFood)
			if autoheal.useFood then
				if changed then update = true end
			else
				ImGui.PopStyleColor()
			end
			
			ImGui.PushStyleColor(ImGuiCol.Text, 0xdddddddd)
			ImGui.TextWrapped("Convert is required if not using another mod to do the same job.")
			ImGui.PopStyleColor()
			
			if not autoheal.useFood then 
				ImGui.PushStyleColor(ImGuiCol.Text, 0xaaaaaaaa)
			end
			ImGui.NewLine()
			ImGui.Text("Food Check Time")
			local current = autoheal.foodCheckTime / 5
			tempValue = 5 * current .. " secs"
			current, changed = ImGui.SliderInt(" Food Check", current, 1, 4, tempValue)
			if autoheal.useFood then 
				autoheal.foodCheckTime = current * 5
				if changed then update = true end
			else
				ImGui.PopStyleColor()
			end
			
			ImGui.EndTabItem()
		end
		
		if ImGui.BeginTabItem("Notifications") then
			autoheal.showHealAlert, changed = ImGui.Checkbox("Show 'AutoHeal Used!' Banner", autoheal.showHealAlert)
			if changed then update = true end
			autoheal.showActiveMsg, changed = ImGui.Checkbox("Show Mod Activated Message in console", autoheal.showActiveMsg)
			if changed then update = true end
			autoheal.showHealMsg, changed = ImGui.Checkbox("Log Heal Use in console", autoheal.showHealMsg)
			if changed then update = true end
		
			ImGui.EndTabItem()
		end
		
		ImGui.EndTabBar()
		ImGui.End()
		ImGui.PopStyleColor(2)
		ImGui.PopStyleVar(1)
		
		if update then saveConfig()	end
	end
	
	if timer > 0 and ( not menu or menu == "PauseMenu" ) then
		local windowWidth = 220
		local screenWidth, screenHeight = GetDisplayResolution()
		local screenRatioX, screenRatioY = screenWidth / 1920, screenHeight / 1200

		ImGui.SetNextWindowPos(screenWidth - windowWidth - 320 * screenRatioX, 140 * screenRatioY)
		ImGui.SetNextWindowSize(windowWidth, 0)

		ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 8)
		ImGui.PushStyleVar(ImGuiStyleVar.WindowPadding, 8, 7)
				
		if inCombat then 
			ImGui.PushStyleColor(ImGuiCol.Border, 0xff0000ff)
			ImGui.PushStyleColor(ImGuiCol.Text, 0xff0000ff)
		else
			ImGui.PushStyleColor(ImGuiCol.Border, 0xff00ffff)
			ImGui.PushStyleColor(ImGuiCol.Text, 0xff00ffff)			
		end
		
		ImGui.Begin('AH Timer', ImGuiWindowFlags.NoTitleBar)
		ImGui.Text("AutoHeal Timer : ".. string.format("%.0f", timer).." s.")
		ImGui.End()
		ImGui.PopStyleColor(2)
		ImGui.PopStyleVar(2)
		
	end
end)

end
return AutoHeal:new()