ColbyCX410HandlingTweaksE1 = { 
    description = "Colby CX410 Butte Handling Tweaks"
}

local VehicleBaseFunctions = require("modules/functions/main_functions")

function ColbyCX410HandlingTweaksE1.new(FinalDriveMultToSet, MaxTorqueMult, BrakingTorqueMult, BrakingFrictionFactorMult, MaxWheelTurnMult, TurnMaxAddMult, TurnMaxSubMult)
	
	MinRPM=900
	MaxRPM=5500
	MaxTorque=450*MaxTorqueMult
	ResistanceTorque=100
	WheelsResistanceRatio=15
	
	BrakingFrictionFactor=1.75*BrakingFrictionFactorMult
	MaxBrakingTorqueFront=2000*BrakingTorqueMult
	MaxBrakingTorqueBack=2500*BrakingTorqueMult
	
	airResistanceFactor = 1.6
	TurningRollFactor = 1.0
	TotalMass = 1650
	
	MaxWheelTurnDeg = 50*MaxWheelTurnMult
	TurnMaxAddPerSecond = 85*TurnMaxAddMult
	TurnMaxSubPerSecond = 100*TurnMaxSubMult
	
	FrontFrictionLateralMult=0.94
	FrontFricitionLongitudinal=0.94
	
	RearFrictionLateralMult=0.98
	RearFricitionLongitudinal=0.98
	
	FrontVisualSuspensionDroop = 0.10
	FrontWheelsVerticalOffset = 0.04
	
	RearVisualSuspensionDroop = 0.10
	RearWheelsVerticalOffset = 0.04
	
	SpringStiffnessFront = 23
	SpringStiffnessRear = 21
	
	AmountOfGears = 6
	
	gearsTorqueMult = {}
	gearsMinSpeed = {}
	gearsMaxSpeed = {}
	gearsMinRPM = {}
	gearsMaxRPM = {}
	
	--setting '1' cuz there is gear 0
	gearsTorqueMult[1] = 1
	gearsMinSpeed[1] = 0*FinalDriveMultToSet
	gearsMaxSpeed[1] = 14*FinalDriveMultToSet
	gearsMinRPM[1] = 750
	gearsMaxRPM[1] = 4400
	
	gearsTorqueMult[2] = 0.75
	gearsMinSpeed[2] = 13*FinalDriveMultToSet
	gearsMaxSpeed[2] = 21*FinalDriveMultToSet
	gearsMinRPM[2] = 3300
	gearsMaxRPM[2] = 4400
	
	gearsTorqueMult[3] = 0.48
	gearsMinSpeed[3] = 20*FinalDriveMultToSet
	gearsMaxSpeed[3] = 27*FinalDriveMultToSet
	gearsMinRPM[3] = 3400
	gearsMaxRPM[3] = 4500
	
	gearsTorqueMult[4] = 0.34
	gearsMinSpeed[4] = 26*FinalDriveMultToSet
	gearsMaxSpeed[4] = 30*FinalDriveMultToSet
	gearsMinRPM[4] = 3500
	gearsMaxRPM[4] = 4500
	
	gearsTorqueMult[5] = 0.30
	gearsMinSpeed[5] = 29*FinalDriveMultToSet
	gearsMaxSpeed[5] = 33.3*FinalDriveMultToSet
	gearsMinRPM[5] = 3600
	gearsMaxRPM[5] = 4600
	
	gearsTorqueMult[6] = 0.27
	gearsMinSpeed[6] = 31.5*FinalDriveMultToSet
	gearsMaxSpeed[6] = 36*FinalDriveMultToSet
	gearsMinRPM[6] = 3600
	gearsMaxRPM[6] = 5000
	
	--I highly suggest not adding _player etc under them, so that you can more simply use them and make it faster for cloning :)
	vehicleName = "standard25_thorton_colby_pickup"
	
	--Don't change this unless you want to change the way the start of the name is written, this is for your own ease of use :) 
	fullVehicleName = "Vehicle.v_"..vehicleName
	
	gearsToUse = {
	fullVehicleName.."_inline_gear0",
	fullVehicleName.."_inline_gear1",
	fullVehicleName.."_inline_gear2",
	fullVehicleName.."_inline_gear3",
	fullVehicleName.."_inline_gear4",
	fullVehicleName.."_inline_gear5",
	fullVehicleName.."_inline_gear6",
	}
	
	--Cloning
	VehicleBaseFunctions.cloneVehicleSettings(fullVehicleName, true, false, false, false, false)
		
	--Cloned Variable Load
	VehicleEngineData = fullVehicleName.."_full_enginedata"
	--VehicleDriveModelData = fullVehicleName.."_full_vehDriveModelData"
	--VehicleDataPackage = fullVehicleName.."_full_vehDataPackage"
	--VehicleWheelDimensionsSetup = fullVehicleName.."_full_vehWheelDimensionsSetup"
	--VehicleWheelSetup = fullVehicleName.."_full_vehWheelSetup"
	--FrontWheelSuspension = VehicleWheelSetup.."_full_vehWheelSetupFrontPreset"
	--RearWheelSuspension = VehicleWheelSetup.."_full_vehWheelSetupBackPreset"
		
	--Basic Variable Load
	--VehicleEngineData = TweakDB:GetFlat(fullVehicleName..".vehEngineData")
	VehicleDriveModelData = TweakDB:GetFlat(fullVehicleName..".vehDriveModelData")
	VehicleDataPackage = TweakDB:GetFlat(fullVehicleName..".vehDataPackage")
	VehicleWheelDimensionsSetup = TweakDB:GetFlat(fullVehicleName..".vehWheelDimensionsSetup")
	VehicleWheelSetup = TweakDB:GetFlat(VehicleDriveModelData..".wheelSetup")
	FrontWheelSuspension = TweakDB:GetFlat(VehicleWheelSetup..".frontPreset")
	RearWheelSuspension = TweakDB:GetFlat(VehicleWheelSetup..".backPreset")
	
	--Other Variable Load	
	--curvesPath = TweakDB:GetFlat(fullVehicleName..".curvesPath")
	
	
	--Set base
	VehicleBaseFunctions.setSupensionData(VehicleDriveModelData, VehicleWheelSetup, FrontWheelSuspension, RearWheelSuspension)
	
	--Setting the data to specified vehicles
	VehicleBaseFunctions.setVehicleSettings(fullVehicleName, VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	--VehicleBaseFunctions.setVehicleSettings("Vehicle.q000_nomad_v_standard25_thorton_colby_pickup", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard25_thorton_colby_pickup_player", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard25_thorton_colby_pickup_02_player", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard25_thorton_colby_pickup_quest", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard25_thorton_colby_pickup_poor", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)

	
	--Power Settings
	TweakDB:SetFlat(VehicleEngineData..".minRPM", MinRPM)
	TweakDB:SetFlat(VehicleEngineData..".maxRPM", MaxRPM)
	TweakDB:SetFlat(VehicleEngineData..".engineMaxTorque", MaxTorque)
	TweakDB:SetFlat(VehicleEngineData..".resistanceTorque", ResistanceTorque)
	TweakDB:SetFlat(VehicleEngineData..".wheelsResistanceRatio", WheelsResistanceRatio)
	
	--Handling settings
	TweakDB:SetFlat(VehicleDriveModelData..".airResistanceFactor", airResistanceFactor)
	TweakDB:SetFlat(VehicleDriveModelData..".chassis_mass", TotalMass)
	TweakDB:SetFlat(VehicleDriveModelData..".total_mass", TotalMass)
	TweakDB:SetFlat(VehicleDriveModelData..".turningRollFactor", TurningRollFactor)
	TweakDB:SetFlat(VehicleDriveModelData..".maxWheelTurnDeg", MaxWheelTurnDeg)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxAddPerSecond", TurnMaxAddPerSecond)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxSubPerSecond", TurnMaxSubPerSecond)
	
	--Front Suspension and tires
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLateral", FrontFrictionLateralMult)
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLongitudinal", FrontFricitionLongitudinal)
	TweakDB:SetFlat(FrontWheelSuspension..".springStiffness", SpringStiffnessFront)
	TweakDB:SetFlat(FrontWheelSuspension..".visualSuspensionDroop", FrontVisualSuspensionDroop)
	TweakDB:SetFlat(FrontWheelSuspension..".wheelsVerticalOffset", FrontWheelsVerticalOffset)
	
	--Rear Suspension and tires
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLateral", RearFrictionLateralMult)
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLongitudinal", RearFricitionLongitudinal)
	TweakDB:SetFlat(RearWheelSuspension..".springStiffness", SpringStiffnessRear)
	TweakDB:SetFlat(RearWheelSuspension..".visualSuspensionDroop", RearVisualSuspensionDroop)
	TweakDB:SetFlat(RearWheelSuspension..".wheelsVerticalOffset", RearWheelsVerticalOffset)
	
	--Brakes
	TweakDB:SetFlat(VehicleDriveModelData..".brakingFrictionFactor", BrakingFrictionFactor)
	TweakDB:SetFlat(FrontWheelSuspension..".maxBrakingTorque", MaxBrakingTorqueFront)
	TweakDB:SetFlat(RearWheelSuspension..".maxBrakingTorque", MaxBrakingTorqueBack)
	
	--Gears settings
	
	--Gear Cloning
	GearsData = TweakDB:GetFlat(VehicleEngineData..".gears")
	for index=0,AmountOfGears do 
	TweakDB:CloneRecord(fullVehicleName.."_inline_gear"..index, GearsData[1])
	end
	
	--Gear Settings
	TweakDB:SetFlat(VehicleEngineData..".gears", gearsToUse)
	for index=1,AmountOfGears do 
	VehicleBaseFunctions.setGearData(fullVehicleName.."_inline_gear"..index, gearsTorqueMult[index], gearsMinSpeed[index], gearsMaxSpeed[index], gearsMinRPM[index], gearsMaxRPM[index])
	end

end

return ColbyCX410HandlingTweaksE1
