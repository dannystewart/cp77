registerForEvent("onInit", function()
	local ammoID = {
		[tostring(TweakDBID.new("Ammo.HandgunAmmo"))] = 500,
		[tostring(TweakDBID.new("Ammo.RifleAmmo"))] = 700,
		[tostring(TweakDBID.new("Ammo.ShotgunAmmo"))] = 100,
		[tostring(TweakDBID.new("Ammo.SniperRifleAmmo"))] = 100
	}

	Override("CraftingSystem", "OnCraftItemRequest", function(self, request)
		local newAmount
		if ammoID[tostring(request.itemRecord:GetID())] ~= nil then
			local curAmt = Game.GetTransactionSystem():GetItemQuantity(Game.GetPlayer(), ItemID.new(request.itemRecord:GetID()))
			local maxAmt = ammoID[tostring(request.itemRecord:GetID())]
			if curAmt >= maxAmt then return end
			if (curAmt + (request.bulletAmount * request.amount)) > maxAmt then
				newAmount = ((maxAmt - curAmt) / request.bulletAmount)
			end
		end
		
		newAmount = (newAmount ~= nil) and (tonumber(math.floor(((newAmount + 0.5) - (newAmount + 0.5) % 1))) + 1) or nil
		
		local craftedItem = Game.GetScriptableSystemsContainer():Get(CName.new("CraftingSystem")):CraftItem(request.target, request.itemRecord, ((newAmount ~= nil) and newAmount or request.amount), request.bulletAmount)
		Game.GetScriptableSystemsContainer():Get(CName.new("CraftingSystem")):UpdateBlackboard("CraftingFinished", craftedItem:GetID(), {})
	end)
end)