------------------------------------------------
-- USER CONFIGURABLE VARIABLES
------------------------------------------------
-- Experience
giveXP = true			-- gives XP as if using 'Tune Up' in-game skill
xpFactor = 0.5			-- multiplier of Vanilla XP to give (Vanilla = 1.0) (Vanilla = Unc: 18, Rare: 36, Epic: 54, Legend: 90)

-- Components
doComponents = true		-- upgrade Crafting Components automatically
doUpgradeCmp = true		-- upgrade Upgrade Components automatically
doQuickhacks = true		-- upgrade Quickhack Components automatically

-- Skills
requireTuneUp = false	-- if true, mod will not convert anything unless the character has unlocked the Tune-Up skill
xpTuneUp = 1.0			-- XP factor to use when character has unlocked Tune-Up (independent of requireTuneUp)
useOptimization = true	-- will use Cost Optimization to reduce crafting cost, if the character has the skill
useNihilo = true		-- will use Ex Nihilo to give chance of free convert, if the character has the skill

-- Advanced Skill Cost & Fix
useAltCost = true		-- use alternative system for calcuating cost (calculates Cost Reduction and Ex Nihilo PER component)
useCostFix = false		-- apply Cost Reduction bonus (-1 component cost) at Lvl 8 Crafting, and Lvl 17 Crafting (ONLY if useAltCost = false)

-- Other
showActiveMsg = false	-- Show mod activated message in console
showConvertMsg = true 	-- Show amounts converted in console

useFullWait = true		-- Don't convert until player has stopped picking up things; only used if showConvertMsg = true to show total number converted

------------------------------------------------
-- SEMI-ADVANCED (Ratio, Limits & Maximums) --
------------------------------------------------
-- Upgrade Ratio
upgRatio = 10 			-- add 1 of upgraded item for every (default: 10 = Vanilla) of these

-- Crafting Components
limitCommon = 400		-- at this point, will start upgrading, so for every upgRatio above this, will create 1 of next tier
limitUncommon = 350		-- so, with defaults (350 Unc and 10), will wait until have 350 + 10 = 360 Unc, then upgrade 10 Unc --> 1 Rare
limitRare = 300
limitEpic = 250

maxUncommon = 400		-- will keep converting until these maximums are reached, and all higher tiers haven't reached their maximum
maxRare = 350
maxEpic = 300			
maxLegendary = 250		

-- Upgrade Components
limitUpgRare = 350
limitUpgEpic = 250

maxUpgEpic = 350	
maxUpgLegendary = 250

-- Quickhack Components
limitQHUncommon = 350
limitQHRare = 300
limitQHEpic = 250

maxQHRare = 350
maxQHEpic = 300
maxQHLegendary = 250

------------------------------------------------
-- ADVANCED (highly recommend to leave at defaults)
------------------------------------------------
autoConvertTime = 6		-- How often (in sec) to run the script
afterCombatTime = 7		-- Additional time to pause after combat finishes

timeFullWait = 17		-- secs to check for new items
------------------------------------------------
-- END OF USER CONFIGUARBLE VARIABLES
------------------------------------------------

------------------------------------------------
-- MAIN CODE
------------------------------------------------
firstRun = true
pauseTime = os.time()
scriptInterval = 0
usingAutoControl = false

xpUncommon = 18 		-- note, do not change these values, change xpFactor above
xpRare = 36
xpEpic = 54
xpLegendary = 90

prevCommon = 0
prevUpgRare = 0
prevQHUncommon = 0

local GameUI = require('GameUI')

AutoComponentUpgrade = { description = "Auto Component Upgrade" }
function AutoComponentUpgrade:new()

registerForEvent("onUpdate", function(deltaTime)
------------------------------------------------
-- CHECK GOOD TO GO ...
------------------------------------------------
	if paused or inCombat then return end
------------------------------------------------
-- INITIALISE...
------------------------------------------------
	if firstRun then
		firstRun = false
		idCommon = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.CommonMaterial1"))
		idUncommon = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.UncommonMaterial1"))
		idRare = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.RareMaterial1"))
		idEpic = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.EpicMaterial1"))
		idLegendary = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.LegendaryMaterial1"))
		
		idUpgRare = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.RareMaterial2"))
		idUpgEpic = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.EpicMaterial2"))
		idUpgLegendary = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.LegendaryMaterial2"))
		
		idQHUncommon = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.QuickHackUncommonMaterial1"))
		idQHRare = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.QuickHackRareMaterial1"))
		idQHEpic = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.QuickHackEpicMaterial1"))
		idQHLegendary = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.QuickHackLegendaryMaterial1"))
		
		if useFullWait then idToken = GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Keycards.test_keycard")) end
		
		if showActiveMsg then print("Auto Component Upgrade activated.") end
	end
	
	setDevData()
	if checkSkills() then
		skillTuneUp()
		if useAltCost then calcFreeChance(); upgCost = upgRatio
		else upgCost = useOptimization and skillCost(upgRatio) or upgRatio end
	end
	if requireTuneUp and not tuneUp then return end
	
	if useFullWait then
		if checkFreeze() or checkJunk() then fullWait() return end
		if not usingAutoControl and fullWait(deltaTime) then return end
	end
------------------------------------------------
-- READY...
------------------------------------------------
	if not usingAutoControl then
		scriptInterval = scriptInterval + deltaTime
		if scriptInterval < autoConvertTime then return	else scriptInterval = 0	end
	end
------------------------------------------------
-- GET CURRENT AMOUNTS 
------------------------------------------------
	countCommon = ts:GetItemQuantity(player, idCommon)
	countUncommon = ts:GetItemQuantity(player, idUncommon)
	countRare = ts:GetItemQuantity(player, idRare)
	countEpic = ts:GetItemQuantity(player, idEpic)
	countLegendary = ts:GetItemQuantity(player, idLegendary)
	
	countUpgRare = ts:GetItemQuantity(player, idUpgRare)
	countUpgEpic = ts:GetItemQuantity(player, idUpgEpic)
	countUpgLegendary = ts:GetItemQuantity(player, idUpgLegendary)

	countQHUncommon = ts:GetItemQuantity(player, idQHUncommon)
	countQHRare = ts:GetItemQuantity(player, idQHRare)
	countQHEpic = ts:GetItemQuantity(player, idQHEpic)
	countQHLegendary = ts:GetItemQuantity(player, idQHLegendary)

	--if useOptimization and not useAltCost then upgCost = skillCost(upgRatio) else upgCost = upgRatio end
	-- if useAltCost then calcFreeChance() end
------------------------------------------------
-- CRAFTING COMPONENTS
------------------------------------------------
	if doComponents then
		msg = "AutoComponentUpgrade: "
		msgFlag = false
		gainedXP = 0
------------------------------------------------
-- COMMON
------------------------------------------------
		if countUncommon < maxUncommon or countRare < maxRare or countEpic < maxEpic or countLegendary < maxLegendary then
			upgResult, upgOriginal = getUpgraded(countCommon, limitCommon)
			if upgResult > 0 then
				ts:RemoveItem(player, idCommon, upgOriginal)
				Game.AddToInventory("Items.UncommonMaterial1", upgResult)
				countUncommon = countUncommon + upgResult
				gainedXP = xpUncommon * upgResult
				
				msg = msg..upgOriginal.." Common > "..upgResult.." Uncommon"
				msgFlag = true
			end
------------------------------------------------
-- UNCOMMON
------------------------------------------------
			if countRare < maxRare or countEpic < maxEpic or countLegendary < maxLegendary then
				upgResult, upgOriginal = getUpgraded(countUncommon, limitUncommon)
				if upgResult > 0 then
					ts:RemoveItem(player, idUncommon, upgOriginal)
					Game.AddToInventory("Items.RareMaterial1", upgResult)
					countRare = countRare + upgResult
					gainedXP = gainedXP + xpRare * upgResult
					
					if msgFlag then
						msg = msg.."; "
					end
					msg = msg..upgOriginal.." Uncommon > "..upgResult.." Rare"
					msgFlag = true
				end
------------------------------------------------
-- RARE
------------------------------------------------
				if countEpic < maxEpic or countLegendary < maxLegendary then
					upgResult, upgOriginal = getUpgraded(countRare, limitRare)
					if upgResult > 0 then
						ts:RemoveItem(player, idRare, upgOriginal)
						Game.AddToInventory("Items.EpicMaterial1", upgResult)
						countEpic = countEpic + upgResult
						gainedXP = gainedXP + xpEpic * upgResult
						
						if msgFlag then
							msg = msg.."; "
						end
						msg = msg..upgOriginal.." Rare > "..upgResult.." Epic"
						msgFlag = true
					end
------------------------------------------------
-- EPIC
------------------------------------------------
					if countLegendary < maxLegendary then
						upgResult, upgOriginal = getUpgraded(countEpic, limitEpic)
						if upgResult > 0 then
							ts:RemoveItem(player, idEpic, upgOriginal)
							Game.AddToInventory("Items.LegendaryMaterial1", upgResult)
							gainedXP = gainedXP + xpLegendary * upgResult
							
							if msgFlag then
								msg = msg.."; "
							end
							msg = msg..upgOriginal.." Epic > "..upgResult.." Legendary"
							msgFlag = true
						end
					else
						msg = msg.."; Legendary Limit Reached"
					end
				else
					msg = msg.."; Epic & Legendary Limits Reached"
				end
			else
				msg = msg.."; Rare, Epic & Legendary Limits Reached"
			end
		else
			if countCommon ~= prevCommon then
				msg = msg.."Uncommon, Rare, Epic & Legendary Limits Reached"
				prevCommon = countCommon
				msgFlag = true
			end
		end
------------------------------------------------
		if giveXP and gainedXP > 0 then
			gainedXP = math.floor( xpFactor * gainedXP )
			Game.AddExp("Crafting", gainedXP)
		end

		if msgFlag and showConvertMsg then
			print(msg)
		end
	end

------------------------------------------------
-- UPGRADE COMPONENTS
------------------------------------------------
	if doUpgradeCmp	then
		msg = "AutoComponentUpgrade: (Upgrade) "
		msgFlag = false
		gainedXP = 0
------------------------------------------------
-- RARE UPGRADE MATERIAL
------------------------------------------------
		if countUpgEpic < maxUpgEpic or countUpgLegendary < maxUpgLegendary then
			upgResult, upgOriginal = getUpgraded(countUpgRare, limitUpgRare)
			if upgResult > 0 then
				ts:RemoveItem(player, idUpgRare, upgOriginal)
				Game.AddToInventory("Items.EpicMaterial2", upgResult)
				countUpgEpic = countUpgEpic + upgResult
				gainedXP = xpEpic * upgResult
				
				if msgFlag then
					msg = msg.."; "
				end
				msg = msg..upgOriginal.." Rare > "..upgResult.." Epic"
				msgFlag = true
			end
------------------------------------------------
-- EPIC UPGRADE MATERIAL
------------------------------------------------
			if countUpgLegendary < maxUpgLegendary then
				upgResult, upgOriginal = getUpgraded(countUpgEpic, limitUpgEpic)
				if upgResult > 0 then
					ts:RemoveItem(player, idUpgEpic, upgOriginal)
					Game.AddToInventory("Items.LegendaryMaterial2", upgResult)
					gainedXP = gainedXP + xpLegendary * upgResult
					
					if msgFlag then
						msg = msg.."; "
					end
					msg = msg..upgOriginal.." Epic > "..upgResult.." Legendary"
					msgFlag = true
				end
			else
				msg = msg.."; Legendary Limit Reached"
			end
		else
			if countUpgRare ~= prevUpgRare then
				msg = msg.."Epic & Legendary Limits Reached"
				prevUpgRare = countUpgRare
				msgFlag = true
			end
		end
------------------------------------------------
		if giveXP and gainedXP > 0 then
			gainedXP = math.floor( xpFactor * gainedXP )
			Game.AddExp("Crafting", gainedXP)
		end
		
		if msgFlag and showConvertMsg then
			print(msg)
		end
	end
	
------------------------------------------------
-- QUICKHACK COMPONENTS
------------------------------------------------
	if doQuickhacks then
		msg = "AutoComponentUpgrade: (Quickhack) "
		msgFlag = false
		gainedXP = 0
------------------------------------------------
-- UNCOMMON QUICKHACK
------------------------------------------------
		if countQHRare < maxQHRare or countQHEpic < maxQHEpic or countQHLegendary < maxQHLegendary then
			upgResult, upgOriginal = getUpgraded(countQHUncommon, limitQHUncommon)
			if upgResult > 0 then
				ts:RemoveItem(player, idQHUncommon, upgOriginal)
				Game.AddToInventory("Items.QuickHackRareMaterial1", upgResult)
				countQHRare = countQHRare + upgResult
				gainedXP = gainedXP + xpRare * upgResult
				
				msg = msg..upgOriginal.." Uncommon > "..upgResult.." Rare"
				msgFlag = true
			end
------------------------------------------------
-- RARE QUICKHACK
------------------------------------------------
			if countQHEpic < maxQHEpic or countQHLegendary < maxQHLegendary then
				upgResult, upgOriginal = getUpgraded(countQHRare, limitQHRare)
				if upgResult > 0 then
					ts:RemoveItem(player, idQHRare, upgOriginal)
					Game.AddToInventory("Items.QuickHackEpicMaterial1", upgResult)
					countQHEpic = countQHEpic + upgResult
					gainedXP = gainedXP + xpEpic * upgResult
					
					if msgFlag then
						msg = msg.."; "
					end
					msg = msg..upgOriginal.." Rare > "..upgResult.." Epic"
					msgFlag = true
				end
------------------------------------------------
-- EPIC QUICKHACK
------------------------------------------------
				if countQHLegendary < maxQHLegendary then
					upgResult, upgOriginal = getUpgraded(countQHEpic, limitQHEpic)
					if upgResult > 0 then
						ts:RemoveItem(player, idQHEpic, upgOriginal)
						Game.AddToInventory("Items.QuickHackLegendaryMaterial1", upgResult)
						gainedXP = gainedXP + xpLegendary * upgResult
						
						if msgFlag then
							msg = msg.."; "
						end
						msg = msg..upgOriginal.." Epic > "..upgResult.." Legendary"
						msgFlag = true
					end
				else
					msg = msg.."; Legendary Limit Reached"
				end
			else
				msg = msg.."; Epic & Legendary Limits Reached"
			end
		else
			if countQHUncommon ~= prevQHUncommon then
				msg = msg.."Rare, Epic & Legendary Limits Reached"
				prevQHUncommon = countQHUncommon
				msgFlag = true
			end
		end
------------------------------------------------
		if giveXP and gainedXP > 0 then
			gainedXP = math.floor( xpFactor * gainedXP )
			Game.AddExp("Crafting", gainedXP)
		end

		if msgFlag and showConvertMsg then
			print(msg)
		end
	end
end)

------------------------------------------------
-- MAIN UPGRADE FUNCTION
------------------------------------------------
function getUpgraded(count, limit)
	local result, original = 0, 0
	if useAltCost then 
		result, original = getUpgradedAlt(count, limit) 
	else
		local upg = limit + upgCost
		
		while count >= upg do
			result = result + 1
			if not skillNihilo() then original = original + upgCost; count = count - upgCost end
		end
	end

	return result, original
end
------------------------------------------------
-- ALTERNATIVE UPGRADE FUNCTION
------------------------------------------------
do
	function getUpgradedAlt(count, limit)
		local result, original = 0, 0
		local upg = limit + upgCost
		
		while count >= upg do
			local altCost = 0
			for i = 1, upgCost do
				local rng = math.random()
				if rng > 0.9975 then altCost = altCost + 2
				elseif rng > freeChance then altCost = altCost + 1 end
			end
			result = result + 1
			original = original + altCost
			count = count - altCost
		end
		return result, original
	end

	function calcFreeChance()
		freeChance = ss:GetStatValue(plID, "CraftingCostReduction")
		if plDevData:HasPerk("Crafting_Area_06_Perk_1") then freeChance = freeChance + 0.2 end
		
		if prevChance ~= freeChance then
			local msg = "AutoComponentUpgrade: Free Component Chance "
			if prevChance == nil then msg = msg .. "currently " else msg = msg .. "now " end
			msg = msg .. string.format("%.1f",freeChance * 100) .."%."
			print(msg)
			prevChance = freeChance
		end
	end
end
------------------------------------------------
-- CHECK SKILLS
------------------------------------------------
do
	local prevPerkPoints = 0
	local prevCraftingLevel = 0
	
	function checkSkills()
		local check = false
		local craftingLevel = plDevData:GetProficiencyLevel("Crafting")
		if craftingLevel ~= prevCraftingLevel then prevCraftingLevel = craftingLevel; check = true end
		
		local perkPoints = plDevData:GetDevPoints('Primary')
		if perkPoints < prevPerkPoints then check = true end
		prevPerkPoints = perkPoints
		return check
	end
end
------------------------------------------------
-- TUNE-UP SKILL CHECK
------------------------------------------------
do
	function skillTuneUp()
		tuneUp = plDevData:HasPerk("Crafting_Area_08_Perk_2")

		if prevTuneUp ~= tuneUp then
			xpFactor = (tuneUp and xpTuneUp) or xpFactor
			local msg
			if requireTuneUp then
				if tuneUp then 
					print("AutoComponentUpgrade: Tune-Up available to the character. Auto Component Upgrading is enabled.")
					msg = "AutoComponentUpgrade:"
				else
					print("AutoComponentUpgrade: Tune-Up required for Auto Component Upgrading. Upgrading disabled.")
				end
			else
				if tuneUp then
					msg = "AutoComponentUpgrade: Tune-Up detected."
				else
					msg = "AutoComponentUpgrade: Tune-Up not detected."
				end
			end
			if msg then 
				msg = msg .. " Auto Crafting XP set to ".. xpFactor * 100 .."%."
				print(msg)
			end
			prevTuneUp = tuneUp
		end
	end
end
------------------------------------------------
-- EX NIHILO SKILL CHECK
-- 20% chance to upgrade for free
------------------------------------------------
do
	function skillNihilo()
		local free = false
		if useNihilo then
			if plDevData:HasPerk("Crafting_Area_06_Perk_1") then
				if math.random() <= 0.2 then free = true end
			end
		end
		return free
	end
end
------------------------------------------------
-- COST OPTIMIZATION SKILL CHECK
-- 15% at 1st rank;  30% at 2nd rank
------------------------------------------------
--[[
 Cost Fix 
Game gives ~0.5% cost reduction per Crafting level but states +5% at lvls 3, 4, and 11
so, compromise: give 1 reduction at lvl 8, 2 reduction at lvl 17)
i.e. with the 0.5% per level provided already by the game, net is: +7% at lvl 8, and +12% at lvl 17
ensures Cost Optimization perk is always worth additional 1 discount at step 1, plus another 2 discount with step 2
]]
function skillCost(cost)
	local reduct = ss:GetStatValue(plID, "CraftingCostReduction")

	if useCostFix then
		local currentCraftingLevel = plDevData:GetProficiencyLevel("Crafting")
		if currentCraftingLevel >= 17 then reduct = reduct + 0.12
		elseif currentCraftingLevel >= 8 then reduct = reduct + 0.07 end
	end
	
	cost = cost - math.floor(cost * reduct)
	return cost
end
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
		
		local currentInv = ts:GetTotalItemQuantity(player) - currentCash + getAmmo()
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
	
	function getAmmo()
		return Game.GetQuestsSystem():GetFactStr("SenseiAutoAmmoSell_Tokens")
	end
end
------------------------------------------------
-- UTILITY FUNCTIONS
------------------------------------------------
function setDevData()
	plDevData = Game.GetScriptableSystemsContainer():Get(CName.new("PlayerDevelopmentSystem")):GetDevelopmentData(Game.GetPlayer())
end

inCombat = false
paused = true
if useAltCost then useCostFix = false end

registerForEvent("onInit", function()
	Observe("PlayerPuppet", "OnCombatStateChanged", function(self,state)
		inCombat = state == 1
	end)
	
	GameUI.Observe(function(state)
		paused = not state.isDefault or state.isJohnny
	end)
	
	player = Game.GetPlayerSystem():GetLocalPlayerMainGameObject()
	plID = Game.GetPlayer():GetEntityID()
	ts = Game.GetTransactionSystem()
	ss = Game.GetStatsSystem()

	math.randomseed (os.time())
end)

function checkFreeze()
	usingAutoControl = Game.GetQuestsSystem():GetFactStr("SenseiAutoControl") ~= 0
	return Game.GetQuestsSystem():GetFactStr("SenseiAutoControl") == 2
end

function checkJunk()
	return Game.GetQuestsSystem():GetFactStr("SenseiAutoJunk") == 2
end

end

return AutoComponentUpgrade:new()