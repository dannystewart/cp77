ArcherQuartzHandlingTweaksE1 = { 
    description = "Archer Quartz Handling Tweaks"
}

local VehicleBaseFunctions = require("modules/functions/main_functions")

function ArcherQuartzHandlingTweaksE1.new(FinalDriveMultToSet, MaxTorqueMult, BrakingTorqueMult, BrakingFrictionFactorMult, MaxWheelTurnMult, TurnMaxAddMult, TurnMaxSubMult)

    --registerForEvent("onInit", function() 
	
	MinRPM=900
	MaxRPM=7100
	MaxTorque=320*MaxTorqueMult
	ResistanceTorque=60
	WheelsResistanceRatio=15
	
	BrakingFrictionFactor=1.5*BrakingFrictionFactorMult
	MaxBrakingTorqueFront=1800*BrakingTorqueMult
	MaxBrakingTorqueBack=2400*BrakingTorqueMult
	
	ForwardWeightTransfer = 0.35
	airResistanceFactor = 1.6
	TurningRollFactor = 0.92
	TotalMass = 1150
	
	MaxWheelTurnDeg = 55*MaxWheelTurnMult
	TurnMaxAddPerSecond = 100*TurnMaxAddMult
	TurnMaxSubPerSecond = 130*TurnMaxSubMult
	
	FrontFrictionLateralMult=0.71
	FrontFricitionLongitudinal=0.79
	
	RearFrictionLateralMult=0.79
	RearFricitionLongitudinal=0.78
	
	FrontVisualSuspensionDroop = 0.10
	FrontWheelsVerticalOffset = 0.00
	
	RearVisualSuspensionDroop = 0.10
	RearWheelsVerticalOffset = -0.01
	
	FrontExtremeCompressionEventScale = 0.75
	RearExtremeCompressionEventScale = 0.70
	
	SpringStiffnessFront = 14
	SpringStiffnessRear = 21
	
	SwaybarStiffnessFront = 16
	SwaybarStiffnessRear = 24
	
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
	gearsMinRPM[1] = 700
	gearsMaxRPM[1] = 6400
	
	gearsTorqueMult[2] = 0.75
	gearsMinSpeed[2] = 13*FinalDriveMultToSet
	gearsMaxSpeed[2] = 21*FinalDriveMultToSet
	gearsMinRPM[2] = 3300
	gearsMaxRPM[2] = 6400
	
	gearsTorqueMult[3] = 0.48
	gearsMinSpeed[3] = 20*FinalDriveMultToSet
	gearsMaxSpeed[3] = 31*FinalDriveMultToSet
	gearsMinRPM[3] = 3400
	gearsMaxRPM[3] = 6400
	
	gearsTorqueMult[4] = 0.34
	gearsMinSpeed[4] = 29*FinalDriveMultToSet
	gearsMaxSpeed[4] = 36*FinalDriveMultToSet
	gearsMinRPM[4] = 3500
	gearsMaxRPM[4] = 6400
	
	gearsTorqueMult[5] = 0.30
	gearsMinSpeed[5] = 34*FinalDriveMultToSet
	gearsMaxSpeed[5] = 38.3*FinalDriveMultToSet
	gearsMinRPM[5] = 3700
	gearsMaxRPM[5] = 6200
	
	gearsTorqueMult[6] = 0.27
	gearsMinSpeed[6] = 35.5*FinalDriveMultToSet
	gearsMaxSpeed[6] = 42*FinalDriveMultToSet
	gearsMinRPM[6] = 3900
	gearsMaxRPM[6] = 7100
	
	--I highly suggest not adding _player etc under them, so that you can more simply use them and make it faster for cloning :)
	vehicleName = "standard2_archer_quartz_gt"
	
	--Don't change this unless you want to change the way the start of the name is written, this is for your own ease of use :) 
	fullVehicleName = "Vehicle.v_"..vehicleName
	
	gearsToUse = {
	fullVehicleName.."_inline_gear0",
	fullVehicleName.."_inline_gear1",
	fullVehicleName.."_inline_gear2",
	fullVehicleName.."_inline_gear3",
	fullVehicleName.."_inline_gear4",
	fullVehicleName.."_inline_gear5",
	fullVehicleName.."_inline_gear6"
	}
	
	--Cloning
	--VehicleBaseFunctions.cloneVehicleSettings(fullVehicleName, true, false, false, false, false)
		
	--Cloned Variable Load
	--VehicleEngineData = fullVehicleName.."_full_enginedata"
	--VehicleDriveModelData = fullVehicleName.."_full_vehDriveModelData"
	--VehicleDataPackage = fullVehicleName.."_full_vehDataPackage"
	--VehicleWheelDimensionsSetup = fullVehicleName.."_full_vehWheelDimensionsSetup"
	--VehicleWheelSetup = fullVehicleName.."_full_vehWheelSetup"
	--FrontWheelSuspension = VehicleWheelSetup.."_full_vehWheelSetupFrontPreset"
	--RearWheelSuspension = VehicleWheelSetup.."_full_vehWheelSetupBackPreset"
		
	--Basic Variable Load
	VehicleEngineData = TweakDB:GetFlat(fullVehicleName..".vehEngineData")
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
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard2_archer_quartz_player", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	
	--Power Settings
	TweakDB:SetFlat(VehicleEngineData..".minRPM", MinRPM)
	TweakDB:SetFlat(VehicleEngineData..".maxRPM", MaxRPM)
	TweakDB:SetFlat(VehicleEngineData..".engineMaxTorque", MaxTorque)
	TweakDB:SetFlat(VehicleEngineData..".resistanceTorque", ResistanceTorque)
	TweakDB:SetFlat(VehicleEngineData..".wheelsResistanceRatio", WheelsResistanceRatio)
	
	--Handling settings
	TweakDB:SetFlat(VehicleDriveModelData..".airResistanceFactor", airResistanceFactor)
	TweakDB:SetFlat(VehicleDriveModelData..".chassis_mass", TotalMass)
	TweakDB:SetFlat(VehicleDriveModelData..".turningRollFactor", TurningRollFactor)
	TweakDB:SetFlat(VehicleDriveModelData..".maxWheelTurnDeg", MaxWheelTurnDeg)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxAddPerSecond", TurnMaxAddPerSecond)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxSubPerSecond", TurnMaxSubPerSecond)
	TweakDB:SetFlat(VehicleDriveModelData..".forwardWeightTransferFactor", ForwardWeightTransfer)
		
	--Front Suspension and tires
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLateral", FrontFrictionLateralMult)
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLongitudinal", FrontFricitionLongitudinal)
	TweakDB:SetFlat(FrontWheelSuspension..".springStiffness", SpringStiffnessFront)
	TweakDB:SetFlat(FrontWheelSuspension..".swaybarStiffness", SwaybarStiffnessFront)
	TweakDB:SetFlat(FrontWheelSuspension..".extremeCompressionEventScalor", FrontExtremeCompressionEventScale)
	TweakDB:SetFlat(FrontWheelSuspension..".visualSuspensionDroop", FrontVisualSuspensionDroop)
	TweakDB:SetFlat(FrontWheelSuspension..".wheelsVerticalOffset", FrontWheelsVerticalOffset)
		
	--Rear Suspension and tires
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLateral", RearFrictionLateralMult)
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLongitudinal", RearFricitionLongitudinal)
	TweakDB:SetFlat(RearWheelSuspension..".springStiffness", SpringStiffnessRear)
	TweakDB:SetFlat(RearWheelSuspension..".swaybarStiffness", SwaybarStiffnessRear)
	TweakDB:SetFlat(RearWheelSuspension..".extremeCompressionEventScalor", RearExtremeCompressionEventScale)
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

return ArcherQuartzHandlingTweaksE1
