Porsche911GT2RSTweaks = { 
    description = "Porsche 911 GT2 RS Handling Mod E1"
}

local VehicleBaseFunctions = require("modules/functions/main_functions")

function Porsche911GT2RSTweaks.new(FinalDriveMultToSet, MaxTorqueMult, BrakingTorqueMult, BrakingFrictionFactorMult, MaxWheelTurnMult, TurnMaxAddMult, TurnMaxSubMult)

	MinRPM=900
	MaxRPM=7200
	MaxTorque=750*MaxTorqueMult
	ResistanceTorque=60
	WheelsResistanceRatio=15
	
	BrakingFrictionFactor=1.1*BrakingFrictionFactorMult
	MaxBrakingTorqueFront=2000*BrakingTorqueMult
	MaxBrakingTorqueBack=3800*BrakingTorqueMult
	
	FrontFrictionLateralMult=1.06
	FrontFricitionLongitudinal=1.14
	
	RearFrictionLateralMult=1.10
	RearFricitionLongitudinal=1.10
	
	FrontTireWidth = 0.285
	RearTireWidth = 0.335
	
	FrontTireRadius = 0.35
	RearTireRadius = 0.35
	
	TotalMass = 1200
	TurningRollFactor = 0.8
	airResistanceFactor = 1.25
	
	MaxTurnDegrees = 50*MaxWheelTurnMult
	WheelTurnMaxAddPerSecond = 90*TurnMaxAddMult
	WheelTurnMaxSubPerSecond = 128*TurnMaxSubMult
	
	--If you use RWB mod uncomment these and comment the others (remove the --):
	--FrontVisualSuspensionCompressionLength = 0.000
	--FrontVisualSuspensionDroop = -0.02
	--FrontWheelsVerticalOffset = 0.00
	
	--RearVisualSuspensionCompressionLength = 0.000
	--RearVisualSuspensionDroop = 0.05
	--RearWheelsVerticalOffset = -0.02
	
	FrontVisualSuspensionCompressionLength = 0.000
	FrontVisualSuspensionDroop = 0.04
	FrontWheelsVerticalOffset = 0.00
	
	RearVisualSuspensionCompressionLength = 0.000
	RearVisualSuspensionDroop = 0.07
	RearWheelsVerticalOffset = -0.02
	
	SpringStiffnessFront = 19
	SpringStiffnessRear = 29
	
	FrontSuspensionMass = 90
	RearSuspensionMass = 90
	
	FrontExtremeCompressionEventScalor = 0.25
	RearExtremeCompressionEventScalor = 0.20
	
	AmountOfGears = 7
	
	gearsTorqueMult = {}
	gearsMinSpeed = {}
	gearsMaxSpeed = {}
	gearsMinRPM = {}
	gearsMaxRPM = {}
	
	--setting '1' cuz there is gear 0
	gearsTorqueMult[1] = 1
	gearsMinSpeed[1] = 0*FinalDriveMultToSet
	gearsMaxSpeed[1] = 15*FinalDriveMultToSet
	gearsMinRPM[1] = 700
	gearsMaxRPM[1] = 6400
	
	gearsTorqueMult[2] = 0.76
	gearsMinSpeed[2] = 12*FinalDriveMultToSet
	gearsMaxSpeed[2] = 21*FinalDriveMultToSet
	gearsMinRPM[2] = 3600
	gearsMaxRPM[2] = 6400
	
	gearsTorqueMult[3] = 0.51
	gearsMinSpeed[3] = 18*FinalDriveMultToSet
	gearsMaxSpeed[3] = 27*FinalDriveMultToSet
	gearsMinRPM[3] = 3700
	gearsMaxRPM[3] = 6400
	
	gearsTorqueMult[4] = 0.35
	gearsMinSpeed[4] = 24*FinalDriveMultToSet
	gearsMaxSpeed[4] = 32*FinalDriveMultToSet
	gearsMinRPM[4] = 3800
	gearsMaxRPM[4] = 6400
	
	gearsTorqueMult[5] = 0.30
	gearsMinSpeed[5] = 29*FinalDriveMultToSet
	gearsMaxSpeed[5] = 35.3*FinalDriveMultToSet
	gearsMinRPM[5] = 4000
	gearsMaxRPM[5] = 6200
	
	gearsTorqueMult[6] = 0.27
	gearsMinSpeed[6] = 32.5*FinalDriveMultToSet
	gearsMaxSpeed[6] = 42*FinalDriveMultToSet
	gearsMinRPM[6] = 4200
	gearsMaxRPM[6] = 6400
	
	gearsTorqueMult[7] = 0.205
	gearsMinSpeed[7] = 38*FinalDriveMultToSet
	gearsMaxSpeed[7] = 49.5*FinalDriveMultToSet
	gearsMinRPM[7] = 4500
	gearsMaxRPM[7] = 7100

	
	--Porsche 911 GT2 RS Rework
	
	--I highly suggest not adding _player etc under them, so that you can more simply use them and make it faster for cloning :)
	vehicleName = "sport2_porsche_911turbo"
	
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
	--VehicleBaseFunctions.setVehicleSettings("Vehicle.q000_nomad_v_sport2_porsche_911turbo_quest", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sport2_porsche_911turbo_player", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sport2_porsche_911turbo_quest", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	
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
	TweakDB:SetFlat(FrontWheelSuspension..".visualSuspensionCompressionLength", FrontVisualSuspensionCompressionLength)
	TweakDB:SetFlat(FrontWheelSuspension..".visualSuspensionDroop", FrontVisualSuspensionDroop)
	TweakDB:SetFlat(FrontWheelSuspension..".wheelsVerticalOffset", FrontWheelsVerticalOffset)
	TweakDB:SetFlat(FrontWheelSuspension..".extremeCompressionEventScalor", FrontExtremeCompressionEventScalor)
	TweakDB:SetFlat(FrontWheelSuspension..".mass", FrontSuspensionMass)
	
	--Rear Suspension and tires
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLateral", RearFrictionLateralMult)
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLongitudinal", RearFricitionLongitudinal)
	TweakDB:SetFlat(RearWheelSuspension..".springStiffness", SpringStiffnessRear)
	TweakDB:SetFlat(RearWheelSuspension..".visualSuspensionCompressionLength", RearVisualSuspensionCompressionLength)
	TweakDB:SetFlat(RearWheelSuspension..".visualSuspensionDroop", RearVisualSuspensionDroop)
	TweakDB:SetFlat(RearWheelSuspension..".wheelsVerticalOffset", RearWheelsVerticalOffset)
	TweakDB:SetFlat(RearWheelSuspension..".extremeCompressionEventScalor", RearExtremeCompressionEventScalor)
	TweakDB:SetFlat(RearWheelSuspension..".mass", RearSuspensionMass)
	
	--Tire fixes
	TweakDB:SetFlat("Vehicle.v_sport2_porsche_911turbo_inline32.tireWidth", FrontTireWidth)
	TweakDB:SetFlat("Vehicle.v_sport2_porsche_911turbo_inline32.tireRadius", FrontTireRadius)
	
	TweakDB:SetFlat("Vehicle.v_sport2_porsche_911turbo_inline33.tireWidth", RearTireWidth)
	TweakDB:SetFlat("Vehicle.v_sport2_porsche_911turbo_inline33.tireRadius", RearTireRadius)
	
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

return Porsche911GT2RSTweaks
