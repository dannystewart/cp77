BrennanApolloVehicleTweaksE1 = { 
    description = "Brennan Apollo Handling Mod E1"
}

local VehicleBaseFunctions = require("modules/functions/main_functions")

function BrennanApolloVehicleTweaksE1.new(FinalDriveMultToSet, MaxTorqueMult, BrakingTorqueMult, BrakingFrictionFactorMult, MaxWheelTurnMult, TurnMaxAddMult, TurnMaxSubMult)

	MinRPM=1040
	MaxRPM=10500
	MaxTorque=160*MaxTorqueMult
	ResistanceTorque=20
	WheelsResistanceRatio=13
	
	BrakingFrictionFactor=1.1*BrakingFrictionFactorMult
	MaxBrakingTorqueFront=2050*BrakingTorqueMult
	MaxBrakingTorqueBack=1500*BrakingTorqueMult
	
	FrontFrictionLateralMult=0.98
	FrontFricitionLongitudinal=0.98
	
	RearFrictionLateralMult=1.10
	RearFricitionLongitudinal=1.08
	
	TotalMass = 300
	TurningRollFactor = 1.0
	airResistanceFactor = 0.65
	
	BikeMaxTilt = 41
	
	WheelTurnMaxAddPerSecond = 170
	WheelTurnMaxSubPerSecond = 170
	
	SpringStiffnessFront = 8
	SpringStiffnessRear = 7
	
	FrontVisualSuspensionDroop = 0.05
	RearVisualSuspensionDroop = 0.05
	
	AmountOfGears = 7
	
	gearsTorqueMult = {}
	gearsMinSpeed = {}
	gearsMaxSpeed = {}
	gearsMinRPM = {}
	gearsMaxRPM = {}
	
	--setting '1' cuz there is gear 0
	gearsTorqueMult[1] = 1.2
	gearsMinSpeed[1] = 0*FinalDriveMultToSet
	gearsMaxSpeed[1] = 8*FinalDriveMultToSet
	gearsMinRPM[1] = 840
	gearsMaxRPM[1] = 9400
	
	gearsTorqueMult[2] = 0.80
	gearsMinSpeed[2] = 5*FinalDriveMultToSet
	gearsMaxSpeed[2] = 14*FinalDriveMultToSet
	gearsMinRPM[2] = 5500
	gearsMaxRPM[2] = 9600
	
	gearsTorqueMult[3] = 0.66
	gearsMinSpeed[3] = 10*FinalDriveMultToSet
	gearsMaxSpeed[3] = 23.5*FinalDriveMultToSet
	gearsMinRPM[3] = 6000
	gearsMaxRPM[3] = 9800
	
	gearsTorqueMult[4] = 0.54
	gearsMinSpeed[4] = 16*FinalDriveMultToSet
	gearsMaxSpeed[4] = 26*FinalDriveMultToSet
	gearsMinRPM[4] = 7000
	gearsMaxRPM[4] = 10000
	
	gearsTorqueMult[5] = 0.40
	gearsMinSpeed[5] = 24*FinalDriveMultToSet
	gearsMaxSpeed[5] = 30*FinalDriveMultToSet
	gearsMinRPM[5] = 7000
	gearsMaxRPM[5] = 10200
	
	gearsTorqueMult[6] = 0.34
	gearsMinSpeed[6] = 28*FinalDriveMultToSet
	gearsMaxSpeed[6] = 33*FinalDriveMultToSet
	gearsMinRPM[6] = 7500
	gearsMaxRPM[6] = 10300
	
	gearsTorqueMult[7] = 0.30
	gearsMinSpeed[7] = 30*FinalDriveMultToSet
	gearsMaxSpeed[7] = 40*FinalDriveMultToSet
	gearsMinRPM[7] = 8000
	gearsMaxRPM[7] = 10500
	
	--Brennan Apollo Handling Rework
	
	--Cloning of vehicle handling data
	
	--I highly suggest not adding _player (like I did here, but there is a good reason for this for this vehicle) etc under them, so that you can more simply use them and make it faster for cloning :)
	vehicleName = "sportbike3_brennan_apollo_player"
	
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
	VehicleBaseFunctions.cloneVehicleSettings(fullVehicleName, true, true, false, false, false)
		
	--Cloned Variable Load
	VehicleEngineData = fullVehicleName.."_full_enginedata"
	VehicleDriveModelData = fullVehicleName.."_full_vehDriveModelData"
	--VehicleDataPackage = fullVehicleName.."_full_vehDataPackage"
	--VehicleWheelDimensionsSetup = fullVehicleName.."_full_vehWheelDimensionsSetup"
	--VehicleWheelSetup = fullVehicleName.."_full_vehWheelSetup"
	--FrontWheelSuspension = VehicleWheelSetup.."_full_vehWheelSetupFrontPreset"
	--RearWheelSuspension = VehicleWheelSetup.."_full_vehWheelSetupBackPreset"
		
	--Basic Variable Load
	--VehicleEngineData = TweakDB:GetFlat(fullVehicleName..".vehEngineData")
	--VehicleDriveModelData = TweakDB:GetFlat(fullVehicleName..".vehDriveModelData")
	VehicleDataPackage = TweakDB:GetFlat(fullVehicleName..".vehDataPackage")
	VehicleWheelDimensionsSetup = TweakDB:GetFlat(fullVehicleName..".vehWheelDimensionsSetup")
	VehicleWheelSetup = TweakDB:GetFlat(VehicleDriveModelData..".wheelSetup")
	FrontWheelSuspension = TweakDB:GetFlat(VehicleWheelSetup..".frontPreset")
	RearWheelSuspension = TweakDB:GetFlat(VehicleWheelSetup..".backPreset")
	
	--Other Variable Load	
	--curvesPath = TweakDB:GetFlat(fullVehicleName..".curvesPath")
	
	--Set base
	--VehicleBaseFunctions.setSupensionData(VehicleDriveModelData, VehicleWheelSetup, FrontWheelSuspension, RearWheelSuspension)
	
	--Setting the data to specified vehicles
	VehicleBaseFunctions.setVehicleSettings(fullVehicleName, VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sportbike3_brennan_apollo", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sportbike3_brennan_apollo_nomad", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sportbike3_brennan_apollo_nomad_player", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sportbike3_brennan_apollo_quest", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sportbike3_brennan_apollo_scorpion", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sportbike3_brennan_apollo_sport", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sportbike3_brennan_apollo_tyger", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.cs_savable_brennan_apollo", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	--VehicleBaseFunctions.setVehicleSettings("Vehicle.q114_brennan_apollo_nomad", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)

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
	TweakDB:SetFlat(VehicleDriveModelData..".bikeMaxTilt", BikeMaxTilt)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxAddPerSecond", WheelTurnMaxAddPerSecond)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxSubPerSecond", WheelTurnMaxSubPerSecond)
		
	--Front Suspension and tires
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLateral", FrontFrictionLateralMult)
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLongitudinal", FrontFricitionLongitudinal)
	TweakDB:SetFlat(FrontWheelSuspension..".springStiffness", SpringStiffnessFront)
	TweakDB:SetFlat(FrontWheelSuspension..".visualSuspensionDroop", FrontVisualSuspensionDroop)
	
	--Rear Suspension and tires
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLateral", RearFrictionLateralMult)
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLongitudinal", RearFricitionLongitudinal)
	TweakDB:SetFlat(RearWheelSuspension..".springStiffness", SpringStiffnessRear)
	TweakDB:SetFlat(RearWheelSuspension..".visualSuspensionDroop", RearVisualSuspensionDroop)
	
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

return BrennanApolloVehicleTweaksE1
