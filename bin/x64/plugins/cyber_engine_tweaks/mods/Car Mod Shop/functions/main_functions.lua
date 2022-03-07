MainFunctions = { 
    description = "Main Functions"
}

--function MainFunctions()

	function MainFunctions.cloneVehicleSettings(SimpleVehicleName, fullTweakDBIDToUse, ShouldCloneVehicleEngineData, ShouldCloneVehicleDriveModelData, ShouldCloneVehicleDataPackage, ShouldCloneVehicleWheelDimensionsSetup, ShouldCloneVehicleWheelSetup)
		VehicleName = "Vehicle.v_" .. SimpleVehicleName
		
		VehicleClonedRecords = {}
		if TweakDB:GetRecord(VehicleName.."_cms_original") == nil then
			TweakDB:CloneRecord(VehicleName.."_cms_original", fullTweakDBIDToUse)
			VehicleClonedRecords.OriginalVehicle = VehicleName.."_cms_original"
		else
			fullTweakDBIDToUse = TweakDB:GetRecord(VehicleName.."_cms_original")
			VehicleClonedRecords.OriginalVehicle = VehicleName.."_cms_original"

			if TweakDB:GetFlat(VehicleName.."_cms_enginedata") ~= nil then
				local engineTweakDB = TweakDB:GetFlat(VehicleName.."_cms_enginedata")
				local gearsToDel = TweakDB:GetFlat(VehicleName.."_cms_enginedata.gears")
				
				for indexG2, gearFound2 in pairs(TweakDB:GetFlat(VehicleClonedRecords.VehicleEngineData .. ".gears")) do
					TweakDB:DeleteRecord(gearFound2)
				end
			
				TweakDB:DeleteRecord(VehicleName.."_cms_enginedata")
				TweakDB:DeleteRecord(VehicleName.."_cms_vehDriveModelData")
				TweakDB:DeleteRecord(VehicleName.."_cms_vehDataPackage")
				TweakDB:DeleteRecord(VehicleName.."_cms_vehWheelDimensionsSetup")
				TweakDB:DeleteRecord(VehicleName.."_cms_vehWheelSetup")
				TweakDB:DeleteRecord(VehicleName.."_cms_vehWheelSetupFrontPreset")
				TweakDB:DeleteRecord(VehicleName.."_cms_vehWheelSetupRearPreset")
				
				--for index = 0, 7 do
				--	TweakDB:DeleteRecord((VehicleName.."_cms_inline_gear" .. index))
				--end
			end
		end
		
		if ShouldCloneVehicleEngineData == true then
			TweakDB:CloneRecord((VehicleName.."_cms_enginedata"), TweakDB:GetFlat(VehicleName.."_cms_original.vehEngineData"))
			VehicleClonedRecords.OriginalVehicleEngineData = TweakDB:GetFlat(VehicleName.."_cms_original.vehEngineData")
			VehicleClonedRecords.VehicleEngineData = VehicleName.."_cms_enginedata"
			
			VehicleClonedRecords.GearBox = {}
			
			local gearCount = 0
			
			GearSet = {}
			OriginalGearSet = {}
			for indexG, gearFound in pairs(TweakDB:GetFlat(VehicleClonedRecords.OriginalVehicleEngineData .. ".gears")) do
				if TweakDB:GetRecord(VehicleName.."_cms_inline_gear" .. gearCount) ~= nil then
					TweakDB:DeleteRecord((VehicleName.."_cms_inline_gear" .. gearCount))
				end
				
				TweakDB:CloneRecord((VehicleName.."_cms_inline_gear" .. gearCount), gearFound)
				GearSet[gearCount+1] = VehicleName.."_cms_inline_gear" .. gearCount
				
				TweakDB:CloneRecord((VehicleName.."_cms_original_inline_gear" .. gearCount), gearFound)
				OriginalGearSet[gearCount+1] = VehicleName.."_cms_original_inline_gear" .. gearCount
				gearCount = gearCount + 1
			end
			
			TweakDB:SetFlat(VehicleName.."_cms_enginedata.gears", GearSet)
			VehicleClonedRecords.OriginalGearBox = OriginalGearSet
			VehicleClonedRecords.GearBox = GearSet
		end
		if ShouldCloneVehicleDriveModelData == true then
			TweakDB:CloneRecord(VehicleName.."_cms_vehDriveModelData", TweakDB:GetFlat(VehicleName.."_cms_original.vehDriveModelData"))
			VehicleClonedRecords.OriginalVehicleDriveModelData = TweakDB:GetFlat(VehicleName.."_cms_original.vehDriveModelData")
			VehicleClonedRecords.VehicleDriveModelData = VehicleName.."_cms_vehDriveModelData"
		end
		if ShouldCloneVehicleDataPackage == true then
			TweakDB:CloneRecord(VehicleName.."_cms_vehDataPackage", TweakDB:GetFlat(VehicleName.."_cms_original.vehDataPackage"))
			VehicleClonedRecords.OriginalVehicleDataPackage = TweakDB:GetFlat(VehicleName.."_cms_original.vehDataPackage")
			VehicleClonedRecords.VehicleDataPackage = VehicleName.."_cms_vehDataPackage"
		end
		if ShouldCloneVehicleWheelDimensionsSetup == true then
			TweakDB:CloneRecord(VehicleName.."_cms_vehWheelDimensionsSetup", TweakDB:GetFlat(VehicleName.."_cms_original.vehWheelDimensionsSetup"))
			VehicleClonedRecords.OriginalVehicleWheelDimensionsSetup = TweakDB:GetFlat(VehicleName.."_cms_original.vehWheelDimensionsSetup")
			VehicleClonedRecords.VehicleWheelDimensionsSetup = VehicleName.."_cms_vehWheelDimensionsSetup"
		end
		if ShouldCloneVehicleWheelSetup == true then
			DriveModelHelper = TweakDB:GetFlat(VehicleName.."_cms_original.vehDriveModelData")
			TweakDB:CloneRecord(VehicleName.."_cms_vehWheelSetup", TweakDB:GetFlat(DriveModelHelper..".wheelSetup"))
			VehicleClonedRecords.OriginalVehicleWheelSetup = TweakDB:GetFlat(DriveModelHelper..".wheelSetup")
			VehicleClonedRecords.VehicleWheelSetup = VehicleName.."_cms_vehWheelSetup"

			TweakDB:CloneRecord(VehicleName.."_cms_vehWheelSetupFrontPreset", TweakDB:GetFlat(VehicleName.."_cms_vehWheelSetup.frontPreset"))
			TweakDB:CloneRecord(VehicleName.."_cms_vehWheelSetupRearPreset", TweakDB:GetFlat(VehicleName.."_cms_vehWheelSetup.backPreset"))
			VehicleClonedRecords.OriginalFrontWheelSuspension = TweakDB:GetFlat(VehicleName.."_cms_vehWheelSetup.frontPreset")
			VehicleClonedRecords.OriginalRearWheelSuspension = TweakDB:GetFlat(VehicleName.."_cms_vehWheelSetup.backPreset")
			VehicleClonedRecords.FrontWheelSuspension = VehicleName.."_cms_vehWheelSetupFrontPreset"
			VehicleClonedRecords.RearWheelSuspension = VehicleName.."_cms_vehWheelSetupRearPreset"
		end
		
		return VehicleClonedRecords
	end
	
	function MainFunctions.removePreviousClones(VehicleClonedRecords)
		--local GearBoxStuff = nil
		--if VehicleClonedRecords.VehicleEngineData ~= nil then
			--local GearBoxStuff = TweakDB:GetFlat(VehicleClonedRecords.VehicleEngineData .. ".gears")
		--end
		
		TweakDB:DeleteRecord(VehicleClonedRecords.VehicleEngineData)
		TweakDB:DeleteRecord(VehicleClonedRecords.VehicleDriveModelData)
		TweakDB:DeleteRecord(VehicleClonedRecords.VehicleDataPackage)
		TweakDB:DeleteRecord(VehicleClonedRecords.VehicleWheelDimensionsSetup)
		TweakDB:DeleteRecord(VehicleClonedRecords.VehicleWheelSetup)
		TweakDB:DeleteRecord(VehicleClonedRecords.FrontWheelSuspension)
		TweakDB:DeleteRecord(VehicleClonedRecords.RearWheelSuspension)
		
		--if GearBoxStuff ~= nil then
			for _, gearToDelete in pairs(VehicleClonedRecords.OriginalGearBox) do
				TweakDB:DeleteRecord(gearToDelete)
			end
		--end
		
		--return VehicleClonedRecords
	end

	function MainFunctions.setVehicleSettings(vehicleToSetTo, VehicleEngineDataToSet, VehicleDriveModelDataToSet, VehicleDataPackageToSet, VehicleWheelDimensionsSetupToSet)
	TweakDB:SetFlat(vehicleToSetTo..".vehEngineData", VehicleEngineDataToSet)
	TweakDB:SetFlat(vehicleToSetTo..".vehDriveModelData", VehicleDriveModelDataToSet)
	TweakDB:SetFlat(vehicleToSetTo..".vehDataPackage", VehicleDataPackageToSet)
	TweakDB:SetFlat(vehicleToSetTo..".vehWheelDimensionsSetup", VehicleWheelDimensionsSetupToSet)
	end

	function MainFunctions.setGearData(gearToSetDataTo, torqueMultiplierToSet, minSpeedToSet, maxSpeedToSet, minEngineRPMToSet, maxEngineRPMToSet)
	TweakDB:SetFlat(gearToSetDataTo..".torqueMultiplier", torqueMultiplierToSet)
	TweakDB:SetFlat(gearToSetDataTo..".minSpeed", minSpeedToSet)
	TweakDB:SetFlat(gearToSetDataTo..".maxSpeed", maxSpeedToSet)
	TweakDB:SetFlat(gearToSetDataTo..".minEngineRPM", minEngineRPMToSet)
	TweakDB:SetFlat(gearToSetDataTo..".maxEngineRPM", maxEngineRPMToSet)
	end

	function MainFunctions.setSupensionData(VehicleDriveModelDataToSetTo, VehicleWheelSetupToSet, FrontWheelSuspensionToSet, RearWheelSuspensionToSet)
	TweakDB:SetFlat(VehicleDriveModelDataToSetTo..".wheelSetup", VehicleWheelSetupToSet)
	TweakDB:SetFlat(VehicleWheelSetupToSet..".frontPreset", FrontWheelSuspensionToSet)
	TweakDB:SetFlat(VehicleWheelSetupToSet..".backPreset", RearWheelSuspensionToSet)
	end
	
	function MainFunctions.setAllCarsBaseHPMult(CarHealthMultiplier)
	TweakDB:SetFlat("VehicleStatPreset.BaseCar_inline0.value", 70*CarHealthMultiplier)
	end
	
	function MainFunctions.split(s, delimiter)
		result = {};
		for match in (s..delimiter):gmatch("(.-)"..delimiter) do
			table.insert(result, match);
		end
		return result;
	end
	
--end

return MainFunctions