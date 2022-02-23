MainFunctions = { 
    description = "Main Functions"
}

--function MainFunctions()

	function MainFunctions.cloneVehicleSettings(fullVehicleNameToUse, ShouldCloneVehicleEngineData, ShouldCloneVehicleDriveModelData, ShouldCloneVehicleDataPackage, ShouldCloneVehicleWheelDimensionsSetup, ShouldCloneVehicleWheelSetup)
		if ShouldCloneVehicleEngineData == true then
			TweakDB:CloneRecord((fullVehicleNameToUse.."_full_enginedata"), TweakDB:GetFlat(fullVehicleNameToUse..".vehEngineData"))
		end
		if ShouldCloneVehicleDriveModelData == true then
			TweakDB:CloneRecord(fullVehicleNameToUse.."_full_vehDriveModelData", TweakDB:GetFlat(fullVehicleNameToUse..".vehDriveModelData"))
		end
		if ShouldCloneVehicleDataPackage == true then
			TweakDB:CloneRecord(fullVehicleNameToUse.."_full_vehDataPackage", TweakDB:GetFlat(fullVehicleNameToUse..".vehDataPackage"))
		end
		if ShouldCloneVehicleWheelDimensionsSetup == true then
			TweakDB:CloneRecord(fullVehicleNameToUse.."_full_vehWheelDimensionsSetup", TweakDB:GetFlat(fullVehicleNameToUse..".vehWheelDimensionsSetup"))
		end
		if ShouldCloneVehicleWheelSetup == true then
			DriveModelHelper = TweakDB:GetFlat(fullVehicleNameToUse..".vehDriveModelData")
			TweakDB:CloneRecord(fullVehicleNameToUse.."_full_vehWheelSetup", TweakDB:GetFlat(DriveModelHelper..".wheelSetup"))
			TweakDB:CloneRecord(fullVehicleNameToUse.."_full_vehWheelSetupFrontPreset", TweakDB:GetFlat(fullVehicleNameToUse.."_full_vehWheelSetup.frontPreset"))
			TweakDB:CloneRecord(fullVehicleNameToUse.."_full_vehWheelSetupRearPreset", TweakDB:GetFlat(fullVehicleNameToUse.."_full_vehWheelSetup.backPreset"))
		end
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
	
--end

return MainFunctions