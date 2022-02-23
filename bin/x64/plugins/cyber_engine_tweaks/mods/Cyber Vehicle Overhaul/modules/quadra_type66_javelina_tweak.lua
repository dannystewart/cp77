QuadraJavelinaHandlingModE1 = { 
    description = "Quadra Javelina Handling Mod E1"
}

local VehicleBaseFunctions = require("modules/functions/main_functions")

function QuadraJavelinaHandlingModE1.new(FinalDriveMultToSet, MaxTorqueMult, BrakingTorqueMult, BrakingFrictionFactorMult, MaxWheelTurnMult, TurnMaxAddMult, TurnMaxSubMult)
	
	MinRPM=800
	MaxRPM=7100
	MaxTorque=1055*MaxTorqueMult
	ResistanceTorque=70
	WheelsResistanceRatio=15
	
	BrakingFrictionFactor=1.2*BrakingFrictionFactorMult
	MaxBrakingTorqueFront=5500*BrakingTorqueMult
	MaxBrakingTorqueBack=5500*BrakingTorqueMult
	
	FrontFrictionLateralMult=0.95
	FrontFricitionLongitudinal=0.99
	
	RearFrictionLateralMult=1.05
	RearFricitionLongitudinal=0.99
	
	MaxTurnDegrees = 45*MaxWheelTurnMult
	TurnMaxAddPerSecond = 100*TurnMaxAddMult
	TurnMaxSubPerSecond = 140*TurnMaxSubMult
	
	TotalMass = 1700
	TurningRollFactor = 0.45
	airResistanceFactor = 0.8
	
	MaxHandbrakeTorque = 1980
	
	SpringStiffnessFront = 16.5
	SpringStiffnessRear = 16.5
	
	SwaybarStiffnessFront = 0
	SwaybarStiffnessRear = 0
	
	FrontSpringReboundDamping = 5000.001
	RearSpringReboundDamping = 5000.001
	
	FrontVisualSuspensionCompressionLength = 0.5
	--FrontVisualSuspensionDroop = -0.015
	FrontVisualSuspensionDroop = -0.105
	FrontWheelsVerticalOffset = 0.035
	
	RearVisualSuspensionCompressionLength = 0.5
	--RearVisualSuspensionDroop = -0.015
	RearVisualSuspensionDroop = -0.105
	RearWheelsVerticalOffset = 0.035
	
	FrontExtremeCompressionEventScalor = 0
	RearExtremeCompressionEventScalor = 0
	
	FinalDriveMult = 1.2*FinalDriveMultToSet
	
	AmountOfGears = 7
	
	gearsTorqueMult = {}
	gearsMinSpeed = {}
	gearsMaxSpeed = {}
	gearsMinRPM = {}
	gearsMaxRPM = {}
	
	--setting '1' cuz there is gear 0
	gearsTorqueMult[1] = 1
	gearsMinSpeed[1] = 0*FinalDriveMult
	gearsMaxSpeed[1] = 14*FinalDriveMult
	gearsMinRPM[1] = 700
	gearsMaxRPM[1] = 6400
	
	gearsTorqueMult[2] = 0.75
	gearsMinSpeed[2] = 13*FinalDriveMult
	gearsMaxSpeed[2] = 21*FinalDriveMult
	gearsMinRPM[2] = 3300
	gearsMaxRPM[2] = 6400
	
	gearsTorqueMult[3] = 0.48
	gearsMinSpeed[3] = 20*FinalDriveMult
	gearsMaxSpeed[3] = 27*FinalDriveMult
	gearsMinRPM[3] = 3400
	gearsMaxRPM[3] = 6400
	
	gearsTorqueMult[4] = 0.37
	gearsMinSpeed[4] = 26*FinalDriveMult
	gearsMaxSpeed[4] = 32*FinalDriveMult
	gearsMinRPM[4] = 3500
	gearsMaxRPM[4] = 6400
	
	gearsTorqueMult[5] = 0.32
	gearsMinSpeed[5] = 31*FinalDriveMult
	gearsMaxSpeed[5] = 37*FinalDriveMult
	gearsMinRPM[5] = 3700
	gearsMaxRPM[5] = 6200
	
	gearsTorqueMult[6] = 0.30
	gearsMinSpeed[6] = 35*FinalDriveMult
	gearsMaxSpeed[6] = 44*FinalDriveMult
	gearsMinRPM[6] = 3900
	gearsMaxRPM[6] = 6000
	
	gearsTorqueMult[7] = 0.28
	gearsMinSpeed[7] = 42*FinalDriveMult
	gearsMaxSpeed[7] = 54.75*FinalDriveMult
	gearsMinRPM[7] = 4200
	gearsMaxRPM[7] = 7100
	
	--I highly suggest not adding _player etc under them, so that you can more simply use them and make it faster for cloning :)
	vehicleName = "sport2_quadra_type66_nomad"
	
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
	fullVehicleName.."_inline_gear7"
	}
	
	--Cloning
	VehicleBaseFunctions.cloneVehicleSettings(fullVehicleName, true, true, true, true, true)
	
	--Cloned Variable Load
	VehicleEngineData = fullVehicleName.."_full_enginedata"
	VehicleDriveModelData = fullVehicleName.."_full_vehDriveModelData"
	VehicleDataPackage = fullVehicleName.."_full_vehDataPackage"
	VehicleWheelDimensionsSetup = fullVehicleName.."_full_vehWheelDimensionsSetup"
	--VehicleWheelSetup = fullVehicleName.."_full_vehWheelSetup"
	--FrontWheelSuspension = VehicleWheelSetup.."_full_vehWheelSetupFrontPreset"
	--RearWheelSuspension = VehicleWheelSetup.."_full_vehWheelSetupBackPreset"
	
	--Basic Variable Load
	--VehicleEngineData = TweakDB:GetFlat(fullVehicleName..".vehEngineData")
	--VehicleDriveModelData = TweakDB:GetFlat(fullVehicleName..".vehDriveModelData")
	--VehicleDataPackage = TweakDB:GetFlat(fullVehicleName..".vehDataPackage")
	--VehicleWheelDimensionsSetup = TweakDB:GetFlat(fullVehicleName..".vehWheelDimensionsSetup")
	VehicleWheelSetup = TweakDB:GetFlat(VehicleDriveModelData..".wheelSetup")
	FrontWheelSuspension = TweakDB:GetFlat(VehicleWheelSetup..".frontPreset")
	RearWheelSuspension = TweakDB:GetFlat(VehicleWheelSetup..".backPreset")
	
	--Other Variable Load	
	--curvesPath = TweakDB:GetFlat(fullVehicleName..".curvesPath")
	
	--Set base
	VehicleBaseFunctions.setSupensionData(VehicleDriveModelData, VehicleWheelSetup, FrontWheelSuspension, RearWheelSuspension)
	
	--Setting the data to specified vehicles
	VehicleBaseFunctions.setVehicleSettings(fullVehicleName, VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	--VehicleBaseFunctions.setVehicleSettings("Vehicle.q114_quadra_type66_nomad", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	--VehicleBaseFunctions.setVehicleSettings("Vehicle.q000_nomad_v_sport2_quadra_type66_nomad_quest", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.cs_savable_quadra_type66_nomad", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sport2_quadra_type66_nomad_player", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sport2_quadra_type66_nomad_quest", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sport2_quadra_type66_nomad_wraith", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)

	
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
	TweakDB:SetFlat(VehicleDriveModelData..".maxWheelTurnDeg", MaxTurnDegrees)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxAddPerSecond", TurnMaxAddPerSecond)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxSubPerSecond", TurnMaxSubPerSecond)
	
	--Front Suspension and tires
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLateral", FrontFrictionLateralMult)
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLongitudinal", FrontFricitionLongitudinal)
	TweakDB:SetFlat(FrontWheelSuspension..".springStiffness", SpringStiffnessFront)
	TweakDB:SetFlat(FrontWheelSuspension..".swaybarStiffness", SwaybarStiffnessFront)
	TweakDB:SetFlat(FrontWheelSuspension..".springReboundDamping", FrontSpringReboundDamping)
	TweakDB:SetFlat(FrontWheelSuspension..".visualSuspensionCompressionLength", FrontVisualSuspensionCompressionLength)
	TweakDB:SetFlat(FrontWheelSuspension..".visualSuspensionDroop", FrontVisualSuspensionDroop)
	TweakDB:SetFlat(FrontWheelSuspension..".wheelsVerticalOffset", FrontWheelsVerticalOffset)
	TweakDB:SetFlat(FrontWheelSuspension..".extremeCompressionEventScalor", FrontExtremeCompressionEventScalor)
	
	--Rear Suspension and tires
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLateral", RearFrictionLateralMult)
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLongitudinal", RearFricitionLongitudinal)
	TweakDB:SetFlat(RearWheelSuspension..".springStiffness", SpringStiffnessRear)
	TweakDB:SetFlat(RearWheelSuspension..".swaybarStiffness", SwaybarStiffnessRear)
	TweakDB:SetFlat(RearWheelSuspension..".springReboundDamping", RearSpringReboundDamping)
	TweakDB:SetFlat(RearWheelSuspension..".visualSuspensionCompressionLength", RearVisualSuspensionCompressionLength)
	TweakDB:SetFlat(RearWheelSuspension..".visualSuspensionDroop", RearVisualSuspensionDroop)
	TweakDB:SetFlat(RearWheelSuspension..".wheelsVerticalOffset", RearWheelsVerticalOffset)
	TweakDB:SetFlat(RearWheelSuspension..".extremeCompressionEventScalor", RearExtremeCompressionEventScalor)
	
	--Brakes
	TweakDB:SetFlat(VehicleDriveModelData..".brakingFrictionFactor", BrakingFrictionFactor)
	TweakDB:SetFlat(FrontWheelSuspension..".maxBrakingTorque", MaxBrakingTorqueFront)
	TweakDB:SetFlat(RearWheelSuspension..".maxBrakingTorque", MaxBrakingTorqueBack)
	TweakDB:SetFlat(VehicleDriveModelData..".handbrakeBrakingTorque", MaxHandbrakeTorque)
	
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

return QuadraJavelinaHandlingModE1
