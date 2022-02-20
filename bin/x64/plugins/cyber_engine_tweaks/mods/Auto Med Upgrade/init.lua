------------------------------------------------
-- USER CONFIGURABLE VARIABLES
------------------------------------------------
upgRatio = 7 		-- add 1 of upgraded item for every (default: 7) of these

limitMk1 = 75		-- at this point will start upgrading, so for every upgRatio above this, will create 1 of next tier
limitMk2 = 75		-- so, with defaults (75 and 7), will wait until have 75 + 7 = 82 Mk1, then upgrade 7 Mk1 --> 1 Mk2

showActiveMsg = true	-- Show mod activated message in console
showConvertMsg = true 	-- Show amounts converted in console

useFullWait = true		-- Don't convert until player has stopped picking up things; only used if showConvertMsg = true to show total number converted


-- ADVANCED (recommend to leave at defaults)
autoConvertTime = 4 	-- How often (in sec) to check for items to upgrade  (default: 4)
afterCombatTime = 7		-- Additional time to pause after combat finishes  (default: 7) - (only used if useFullWait = true)
timeFullWait = 17		-- How long to wait after picking up any item  (default: 17)
------------------------------------------------
-- END OF USER CONFIGUARBLE VARIABLES
------------------------------------------------

------------------------------------------------
-- MAIN CODE
------------------------------------------------
firstRun = true
pauseTime = os.time()
scriptInterval = 0

upgMk1 = limitMk1 + upgRatio
upgMk2 = limitMk2 + upgRatio
upgMk1Mult = upgMk1 + upgRatio
upgMk2Mult = upgMk2 + upgRatio

registerForEvent("onUpdate", function(deltaTime)
------------------------------------------------
-- CHECK GOOD TO GO ...
------------------------------------------------
	if inCombat then
		scriptInterval = (useFullWait and -afterCombatTime) or 0
		return
	end
	if pauseTime > os.time() then
		return
	end
	if notReady() then
		pauseTime = os.time() + 3
		return
	end
	if playerInMenu() then
		pauseTime = os.time() + 3
		return
	end
------------------------------------------------
-- INITIALISE...
------------------------------------------------
	if firstRun then
		firstRun = false
		idBounce1 = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.BonesMcCoy70V0"))
		idBounce2 = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.BonesMcCoy70V1"))
		idDoc1 = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.FirstAidWhiffV0"))
		idDoc2 = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.FirstAidWhiffV1"))
		
		if useFullWait then idToken = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Keycards.test_keycard")) end
		
		if showActiveMsg then print("Auto Med Upgrade activated.") end
	end
	
	if not player then player = Game.GetPlayerSystem():GetLocalPlayerMainGameObject() end
	if not ts then ts = Game.GetTransactionSystem() end
	
	if useFullWait then
		if checkFreeze() then fullWait() return end
		if fullWait(deltaTime) then return end
	end
------------------------------------------------
-- READY...
------------------------------------------------
	scriptInterval = scriptInterval + deltaTime
	if scriptInterval < autoConvertTime then
		return
	else
		scriptInterval = 0
	end
------------------------------------------------
-- GET CURRENT AMOUNTS 
------------------------------------------------
	countBounce1 = ts:GetItemQuantity(player, idBounce1)
	countBounce2 = ts:GetItemQuantity(player, idBounce2)
	countDoc1 = ts:GetItemQuantity(player, idDoc1)
	countDoc2 = ts:GetItemQuantity(player, idDoc2)
	
	msg = "AutoMedUpgrade: "
	msgFlag = false
	msgFlagMD = false
------------------------------------------------
-- Mk1 BOUNCE BACK UPGRADE
------------------------------------------------
	if countBounce1 >= upgMk1 then
		upgResult = 1
		upgOriginal = upgRatio
		
		if countBounce1 >= upgMk1Mult then
			upgResult = math.floor (( countBounce1 - limitMk1 ) / upgRatio )
			upgOriginal =  upgResult * upgRatio
		end
		
		ts:RemoveItem( player, idBounce1, upgOriginal )
		Game.AddToInventory("Items.BonesMcCoy70V1", upgResult)
		
		msg = msg.."Bounce Back: "..upgOriginal.." Mk1 > "..upgResult.." Mk2"
		msgFlag = true			
	end
------------------------------------------------
-- Mk2 BOUNCE BACK UPGRADE
------------------------------------------------
	if countBounce2 >= upgMk2 then
		upgResult = 1
		upgOriginal = upgRatio
		
		if countBounce2 >= upgMk2Mult then
			upgResult = math.floor (( countBounce2 - limitMk2 ) / upgRatio )
			upgOriginal =  upgResult * upgRatio
		end
		
		ts:RemoveItem( player, idBounce2, upgOriginal )
		Game.AddToInventory("Items.BonesMcCoy70V2", upgResult)

		if msgFlag then
			msg = msg..";  "
		else
			msg = msg.."Bounce Back: "
		end
		msg = msg..upgOriginal.." Mk2 > "..upgResult.." Mk3"
		msgFlag = true		
	end
------------------------------------------------
-- Mk1 MAXDOC UPGRADE
------------------------------------------------
	if countDoc1 >= upgMk1 then
		upgResult = 1
		upgOriginal = upgRatio
		
		if countDoc1 >= upgMk1Mult then
			upgResult = math.floor (( countDoc1 - limitMk1 ) / upgRatio )
			upgOriginal =  upgResult * upgRatio
		end
		
		ts:RemoveItem( player, idDoc1, upgOriginal )
		Game.AddToInventory("Items.FirstAidWhiffV1", upgResult)

		if msgFlag then
			msg = msg.."; "
		end
		msg = msg.."MaxDoc: "..upgOriginal.." Mk1 > "..upgResult.." Mk2"
		msgFlag = true
		msgFlagMD = true
	end
------------------------------------------------
-- Mk2 MAXDOC UPGRADE
------------------------------------------------
	if countDoc2 >= upgMk2 then
		upgResult = 1
		upgOriginal = upgRatio
		
		if countDoc2 >= upgMk2Mult then
			upgResult = math.floor (( countDoc2 - limitMk2 ) / upgRatio )
			upgOriginal =  upgResult * upgRatio
		end
		
		ts:RemoveItem( player, idDoc2, upgOriginal )
		Game.AddToInventory("Items.FirstAidWhiffV2", upgResult)

		if msgFlag then
			msg = msg..";  "
		end
		if not msgFlagMD then
			msg = msg.."MaxDoc: "
		end
		msg = msg..upgOriginal.." Mk2 > "..upgResult.." Mk3"
		msgFlag = true
	end
------------------------------------------------
	if msgFlag and showConvertMsg then
		print(msg)
	end
------------------------------------------------
end)

------------------------------------------------
-- ADDITIONAL FUNCTIONS
------------------------------------------------
do
	if not showConvertMsg then useFullWait = false end
	local oldInv = 0
	local waitPause = 0
	local itemCashID

	function fullWait(deltaTime)
		if not itemCashID then itemCashID = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.money")) end
		local currentCash = ts:GetItemQuantity(player, itemCashID)
		
		local currentInv = ts:GetTotalItemQuantity(player) - currentCash
		if oldInv == 0 then oldInv = currentInv end
		
		if currentInv > oldInv then waitPause = timeFullWait end
		oldInv = currentInv
		
		if deltaTime == nil then waitPause = 0; scriptInterval = autoConvertTime; end
		if waitPause > 0 then
			waitPause = waitPause - deltaTime
			return true
		else
			return false
		end

	end
end
------------------------------------------------
-- UTILITY FUNCTIONS
------------------------------------------------
function notReady()
	inkMenuScenario = GetSingleton('inkMenuScenario'):GetSystemRequestsHandler()
	if inkMenuScenario:IsGamePaused() or inkMenuScenario:IsPreGame() then
		return true
	end
	
	if Game.GetPlayerSystem() == nil then
		return true
	end
	
	if Game.GetPlayerSystem():GetLocalPlayerMainGameObject() == nil then
		return true
	end
	
	if Game.GetPlayer() == nil then
		return true
	end

	if Game.GetQuestsSystem():GetFactStr("q000_started") == 0 then
		return true
	end
	
	return false
end

function playerInMenu()
	blackboard = Game.GetBlackboardSystem():Get(Game.GetAllBlackboardDefs().UI_System);
	uiSystemBB = (Game.GetAllBlackboardDefs().UI_System);
	return(blackboard:GetBool(uiSystemBB.IsInMenu));
end

inCombat = false
registerForEvent("onInit", function()
	Observe("PlayerPuppet", "OnCombatStateChanged", function(self,state)
		inCombat = state == 1
	end)
end)

function checkFreeze()
	return ts:GetItemQuantity(player, idToken) > 1
end
