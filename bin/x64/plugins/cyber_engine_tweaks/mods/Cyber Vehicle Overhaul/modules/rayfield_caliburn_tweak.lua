RayfieldCaliburnHandlingModE1 = { 
    description = "Rayfield Caliburn Handling Mod E1"
}

local VehicleBaseFunctions = require("modules/functions/main_functions")

function RayfieldCaliburnHandlingModE1.new(FinalDriveMultToSet, MaxTorqueMult, BrakingTorqueMult, BrakingFrictionFactorMult, MaxWheelTurnMult, TurnMaxAddMult, TurnMaxSubMult)

	MinRPM=800
	MaxRPM=9000
	MaxTorque=1220*MaxTorqueMult
	ResistanceTorque=500
	WheelsResistanceRatio=15
	
	BrakingFrictionFactor=1.75*BrakingFrictionFactorMult
	MaxBrakingTorqueFront=3800*BrakingTorqueMult
	MaxBrakingTorqueBack=4000*BrakingTorqueMult
	
	WheelsFrictionMapToSet = [[CarDrivingFrictionMap.Sport_Friction_Map]]
	
	FrontFrictionLateralMult=1.12
	FrontFricitionLongitudinal=1.11
	
	RearFrictionLateralMult=1.12
	RearFricitionLongitudinal=1.11
	
	TotalMass = 2050
	TurningRollFactor = 0.80
	airResistanceFactor = 1.4
	
	MaxTurnDegrees = 38*MaxWheelTurnMult
	TurnMaxAddPerSecond = 65*TurnMaxAddMult
	TurnMaxSubPerSecond = 110*TurnMaxSubMult
	
	FrontVisualSuspensionCompressionLength = 0.02
	RearVisualSuspensionCompressionLength = 0.02
	
	FrontVisualSuspensionDroop = 0.11
	RearVisualSuspensionDroop = 0.11
	
	FrontWheelsVerticalOffset = -0.02
	RearWheelsVerticalOffset = -0.02
	
	SpringStiffnessFront = 28
	SpringStiffnessRear = 20
	
	SwaybarStiffnessFront = 24
	SwaybarStiffnessRear = 12
	
	FrontSuspensionMass = 30
	RearSuspensionMass = 30
	
	AmountOfGears = 7
	
	gearsTorqueMult = {}
	gearsMinSpeed = {}
	gearsMaxSpeed = {}
	gearsMinRPM = {}
	gearsMaxRPM = {}
	
	--setting '1' cuz there is gear 0
	gearsTorqueMult[1] = 1
	gearsMinSpeed[1] = 0*FinalDriveMultToSet
	gearsMaxSpeed[1] = 20*FinalDriveMultToSet
	gearsMinRPM[1] = 700
	gearsMaxRPM[1] = 8300
	
	gearsTorqueMult[2] = 0.55
	gearsMinSpeed[2] = 18*FinalDriveMultToSet
	gearsMaxSpeed[2] = 27*FinalDriveMultToSet
	gearsMinRPM[2] = 3300
	gearsMaxRPM[2] = 8150
	
	gearsTorqueMult[3] = 0.39
	gearsMinSpeed[3] = 25*FinalDriveMultToSet
	gearsMaxSpeed[3] = 34*FinalDriveMultToSet
	gearsMinRPM[3] = 3400
	gearsMaxRPM[3] = 8200
	
	gearsTorqueMult[4] = 0.34
	gearsMinSpeed[4] = 34*FinalDriveMultToSet
	gearsMaxSpeed[4] = 42*FinalDriveMultToSet
	gearsMinRPM[4] = 3700
	gearsMaxRPM[4] = 8250
	
	gearsTorqueMult[5] = 0.31
	gearsMinSpeed[5] = 40*FinalDriveMultToSet
	gearsMaxSpeed[5] = 48*FinalDriveMultToSet
	gearsMinRPM[5] = 3900
	gearsMaxRPM[5] = 8300
	
	gearsTorqueMult[6] = 0.295
	gearsMinSpeed[6] = 46*FinalDriveMultToSet
	gearsMaxSpeed[6] = 55*FinalDriveMultToSet
	gearsMinRPM[6] = 4100
	gearsMaxRPM[6] = 8400
	
	gearsTorqueMult[7] = 0.275
	gearsMinSpeed[7] = 52*FinalDriveMultToSet
	gearsMaxSpeed[7] = 69.85*FinalDriveMultToSet
	gearsMinRPM[7] = 4100
	gearsMaxRPM[7] = 9000

	--I highly suggest not adding _player etc under them, so that you can more simply use them and make it faster for cloning :)
	vehicleName = "sport1_rayfield_caliburn"
	
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
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sport1_rayfield_caliburn_player", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sport1_rayfield_caliburn_murdered", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sport1_rayfield_caliburn_02_player", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sport1_rayfield_caliburn_quest", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	
	--Power Settings
	TweakDB:SetFlat(VehicleEngineData..".minRPM", MinRPM)
	TweakDB:SetFlat(VehicleEngineData..".maxRPM", MaxRPM)
	TweakDB:SetFlat(VehicleEngineData..".engineMaxTorque", MaxTorque)
	TweakDB:SetFlat(VehicleEngineData..".resistanceTorque", ResistanceTorque)
	TweakDB:SetFlat(VehicleEngineData..".wheelsResistanceRatio", WheelsResistanceRatio)
	
	--Handling settings
	TweakDB:SetFlat(VehicleDriveModelData..".airResistanceFactor", airResistanceFactor)
	--TweakDB:SetFlat(VehicleDriveModelData..".chassis_mass", TotalMass)
	--TweakDB:SetFlat(VehicleDriveModelData..".total_mass", TotalMass)
	TweakDB:SetFlat(VehicleDriveModelData..".turningRollFactor", TurningRollFactor)
	TweakDB:SetFlat(VehicleDriveModelData..".maxWheelTurnDeg", MaxTurnDegrees)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxAddPerSecond", TurnMaxAddPerSecond)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxSubPerSecond", TurnMaxSubPerSecond)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelsFrictionMap", WheelsFrictionMapToSet)

	
	--Front Suspension and tires
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLateral", FrontFrictionLateralMult)
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLongitudinal", FrontFricitionLongitudinal)
	TweakDB:SetFlat(FrontWheelSuspension..".springStiffness", SpringStiffnessFront)
	TweakDB:SetFlat(FrontWheelSuspension..".swaybarStiffness", SwaybarStiffnessFront)
	TweakDB:SetFlat(FrontWheelSuspension..".visualSuspensionCompressionLength", FrontVisualSuspensionCompressionLength)
	TweakDB:SetFlat(FrontWheelSuspension..".visualSuspensionDroop", FrontVisualSuspensionDroop)
	TweakDB:SetFlat(FrontWheelSuspension..".wheelsVerticalOffset", FrontWheelsVerticalOffset)
	TweakDB:SetFlat(FrontWheelSuspension..".mass", FrontSuspensionMass)
	
	--Rear Suspension and tires
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLateral", RearFrictionLateralMult)
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLongitudinal", RearFricitionLongitudinal)
	TweakDB:SetFlat(RearWheelSuspension..".springStiffness", SpringStiffnessRear)
	TweakDB:SetFlat(RearWheelSuspension..".swaybarStiffness", SwaybarStiffnessRear)
	TweakDB:SetFlat(RearWheelSuspension..".visualSuspensionCompressionLength", RearVisualSuspensionCompressionLength)
	TweakDB:SetFlat(RearWheelSuspension..".visualSuspensionDroop", RearVisualSuspensionDroop)
	TweakDB:SetFlat(RearWheelSuspension..".wheelsVerticalOffset", RearWheelsVerticalOffset)
	TweakDB:SetFlat(RearWheelSuspension..".mass", RearSuspensionMass)
	
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

return RayfieldCaliburnHandlingModE1
