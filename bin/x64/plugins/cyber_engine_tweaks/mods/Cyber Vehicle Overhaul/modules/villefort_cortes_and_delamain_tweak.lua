VillefortCortesHandlingModE1 = { 
    description = "Delamain and Cortes Handling Mod E1"
}

local VehicleBaseFunctions = require("modules/functions/main_functions")

function VillefortCortesHandlingModE1.new(FinalDriveMultToSet, MaxTorqueMult, BrakingTorqueMult, BrakingFrictionFactorMult, MaxWheelTurnMult, TurnMaxAddMult, TurnMaxSubMult)

	MinRPM=1400
	MaxRPM=6800
	MaxTorque=520*MaxTorqueMult
	ResistanceTorque=100
	WheelsResistanceRatio=15
	
	BrakingFrictionFactor=1.5*BrakingFrictionFactorMult
	MaxBrakingTorqueFront=600*BrakingTorqueMult
	MaxBrakingTorqueBack=1700*BrakingTorqueMult
	
	FrontFrictionLateralMult=0.88
	FrontFricitionLongitudinal=0.88
	
	RearFrictionLateralMult=0.87
	RearFricitionLongitudinal=0.88
	
	TotalMass = 1930
	TurningRollFactor = 1.0
	airResistanceFactor = 1.2
	
	MaxHandbrakeTorque = 2000
	
	MaxTurnDegrees = 50*MaxWheelTurnMult
	WheelTurnMaxAddPerSecond = 100*TurnMaxAddMult
	WheelTurnMaxSubPerSecond = 140*TurnMaxSubMult
	
	SpringStiffnessFront = 17
	SpringStiffnessRear = 18
	
	AmountOfGears = 7
	
	gearsTorqueMult = {}
	gearsMinSpeed = {}
	gearsMaxSpeed = {}
	gearsMinRPM = {}
	gearsMaxRPM = {}
	
	--setting '1' cuz there is gear 0
	gearsTorqueMult[1] = 1
	gearsMinSpeed[1] = 0*FinalDriveMultToSet
	gearsMaxSpeed[1] = 9*FinalDriveMultToSet
	gearsMinRPM[1] = 700
	gearsMaxRPM[1] = 6100
	
	gearsTorqueMult[2] = 0.70
	gearsMinSpeed[2] = 7*FinalDriveMultToSet
	gearsMaxSpeed[2] = 14*FinalDriveMultToSet
	gearsMinRPM[2] = 3500
	gearsMaxRPM[2] = 6200
	
	gearsTorqueMult[3] = 0.60
	gearsMinSpeed[3] = 12*FinalDriveMultToSet
	gearsMaxSpeed[3] = 20*FinalDriveMultToSet
	gearsMinRPM[3] = 3600
	gearsMaxRPM[3] = 6300
	
	gearsTorqueMult[4] = 0.45
	gearsMinSpeed[4] = 18*FinalDriveMultToSet
	gearsMaxSpeed[4] = 27*FinalDriveMultToSet
	gearsMinRPM[4] = 3700
	gearsMaxRPM[4] = 6400
	
	gearsTorqueMult[5] = 0.36
	gearsMinSpeed[5] = 25*FinalDriveMultToSet
	gearsMaxSpeed[5] = 31*FinalDriveMultToSet
	gearsMinRPM[5] = 3700
	gearsMaxRPM[5] = 6400
	
	gearsTorqueMult[6] = 0.30
	gearsMinSpeed[6] = 29*FinalDriveMultToSet
	gearsMaxSpeed[6] = 35*FinalDriveMultToSet
	gearsMinRPM[6] = 3900
	gearsMaxRPM[6] = 6500
	
	gearsTorqueMult[7] = 0.24
	gearsMinSpeed[7] = 32.5*FinalDriveMultToSet
	gearsMaxSpeed[7] = 40*FinalDriveMultToSet
	gearsMinRPM[7] = 4200
	gearsMaxRPM[7] = 6800
	
	--Delamain and Cortes Handling Tweaks
	
	vehicleName = "standard2_villefort_cortes"
	
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
	TweakDB:SetFlat(VehicleDriveModelData..".total_mass", TotalMass)
	TweakDB:SetFlat(VehicleDriveModelData..".maxWheelTurnDeg", MaxTurnDegrees)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxAddPerSecond", WheelTurnMaxAddPerSecond)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxSubPerSecond", WheelTurnMaxSubPerSecond)
	
	
	--Front Suspension and tires
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLateral", FrontFrictionLateralMult)
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLongitudinal", FrontFricitionLongitudinal)
	TweakDB:SetFlat(FrontWheelSuspension..".springStiffness", SpringStiffnessFront)
	
	--Rear Suspension and tires
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLateral", RearFrictionLateralMult)
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLongitudinal", RearFricitionLongitudinal)
	TweakDB:SetFlat(RearWheelSuspension..".springStiffness", SpringStiffnessRear)
	
	--Brakes
	TweakDB:SetFlat(VehicleDriveModelData..".brakingFrictionFactor", BrakingFrictionFactor)
	TweakDB:SetFlat(VehicleDriveModelData..".handbrakeBrakingTorque", MaxHandbrakeTorque)
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

return VillefortCortesHandlingModE1
