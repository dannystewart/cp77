RayfieldAerondightTweaks = { 
    description = "Rayfield Aerondight Handling Mod E1"
}

local VehicleBaseFunctions = require("modules/functions/main_functions")

function RayfieldAerondightTweaks.new(FinalDriveMultToSet, MaxTorqueMult, BrakingTorqueMult, BrakingFrictionFactorMult, MaxWheelTurnMult, TurnMaxAddMult, TurnMaxSubMult)
	
	MinRPM=800
	MaxRPM=8100
	MaxTorque=1200*MaxTorqueMult
	ResistanceTorque=150
	WheelsResistanceRatio=15
	
	BrakingFrictionFactor=1.25*BrakingFrictionFactorMult
	MaxBrakingTorqueFront=2900*BrakingTorqueMult
	MaxBrakingTorqueBack=2800*BrakingTorqueMult
	
	FrontFrictionLateralMult=1.00
	FrontFricitionLongitudinal=1.00
	
	RearFrictionLateralMult=1.01
	RearFricitionLongitudinal=1.01
	
	TotalMass = 1800
	TurningRollFactor = 1.0
	airResistanceFactor = 1.4
	
	MaxWheelTurnDeg = 52.5*MaxWheelTurnMult
	TurnMaxAddPerSecond = 82*TurnMaxAddMult
	TurnMaxSubPerSecond = 110*TurnMaxSubMult
	
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
	gearsMaxSpeed[1] = 18*FinalDriveMultToSet
	gearsMinRPM[1] = 700
	gearsMaxRPM[1] = 7400
	
	gearsTorqueMult[2] = 0.65
	gearsMinSpeed[2] = 16*FinalDriveMultToSet
	gearsMaxSpeed[2] = 25*FinalDriveMultToSet
	gearsMinRPM[2] = 2900
	gearsMaxRPM[2] = 6400
	
	gearsTorqueMult[3] = 0.44
	gearsMinSpeed[3] = 22*FinalDriveMultToSet
	gearsMaxSpeed[3] = 32*FinalDriveMultToSet
	gearsMinRPM[3] = 3200
	gearsMaxRPM[3] = 6700
	
	gearsTorqueMult[4] = 0.30
	gearsMinSpeed[4] = 28*FinalDriveMultToSet
	gearsMaxSpeed[4] = 38*FinalDriveMultToSet
	gearsMinRPM[4] = 3300
	gearsMaxRPM[4] = 6800
	
	gearsTorqueMult[5] = 0.26
	gearsMinSpeed[5] = 36*FinalDriveMultToSet
	gearsMaxSpeed[5] = 46*FinalDriveMultToSet
	gearsMinRPM[5] = 3400
	gearsMaxRPM[5] = 6900
	
	gearsTorqueMult[6] = 0.24
	gearsMinSpeed[6] = 43.5*FinalDriveMultToSet
	gearsMaxSpeed[6] = 55*FinalDriveMultToSet
	gearsMinRPM[6] = 3500
	gearsMaxRPM[6] = 7000
	
	gearsTorqueMult[7] = 0.225
	gearsMinSpeed[7] = 52*FinalDriveMultToSet
	gearsMaxSpeed[7] = 65.5*FinalDriveMultToSet
	gearsMinRPM[7] = 3600
	gearsMaxRPM[7] = 8100
	
	--I highly suggest not adding _player etc under them, so that you can more simply use them and make it faster for cloning :)
	vehicleName = "sport1_rayfield_aerondight"
	
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
	TweakDB:SetFlat(VehicleDriveModelData..".total_mass", TotalMass)
	TweakDB:SetFlat(VehicleDriveModelData..".turningRollFactor", TurningRollFactor)
	TweakDB:SetFlat(VehicleDriveModelData..".maxWheelTurnDeg", MaxWheelTurnDeg)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxAddPerSecond", TurnMaxAddPerSecond)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxSubPerSecond", TurnMaxSubPerSecond)
	
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

return RayfieldAerondightTweaks
