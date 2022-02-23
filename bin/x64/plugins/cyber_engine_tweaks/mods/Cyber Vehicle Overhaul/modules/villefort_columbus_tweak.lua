VillefortColumbusHandlingTweaksE1 = { 
    description = "Villefort Columbus Handling Tweaks"
}

local VehicleBaseFunctions = require("modules/functions/main_functions")

function VillefortColumbusHandlingTweaksE1.new(FinalDriveMultToSet, MaxTorqueMult, BrakingTorqueMult, BrakingFrictionFactorMult, MaxWheelTurnMult, TurnMaxAddMult, TurnMaxSubMult)

	MinRPM=800
	MaxRPM=5500
	MaxTorque=500*MaxTorqueMult
	ResistanceTorque=200
	WheelsResistanceRatio=15
	
	BrakingFrictionFactor=1.75*BrakingFrictionFactorMult
	MaxBrakingTorqueFront=1250*BrakingTorqueMult
	MaxBrakingTorqueBack=1050*BrakingTorqueMult
	
	airResistanceFactor = 1.45
	TurningRollFactor = 1
	TotalMass = 2000
	
	MaxWheelTurnDeg = 50*MaxWheelTurnMult
	TurnMaxAddPerSecond = 80*TurnMaxAddMult
	TurnMaxSubPerSecond = 100*TurnMaxSubMult
	
	AmountOfGears = 7
	
	gearsTorqueMult = {}
	gearsMinSpeed = {}
	gearsMaxSpeed = {}
	gearsMinRPM = {}
	gearsMaxRPM = {}
	
	--setting '1' cuz there is gear 0
	gearsTorqueMult[1] = 1
	gearsMinSpeed[1] = 0*FinalDriveMultToSet
	gearsMaxSpeed[1] = 8*FinalDriveMultToSet
	gearsMinRPM[1] = 700
	gearsMaxRPM[1] = 4400
	
	gearsTorqueMult[2] = 0.65
	gearsMinSpeed[2] = 6*FinalDriveMultToSet
	gearsMaxSpeed[2] = 14*FinalDriveMultToSet
	gearsMinRPM[2] = 3300
	gearsMaxRPM[2] = 4900
	
	gearsTorqueMult[3] = 0.57
	gearsMinSpeed[3] = 12*FinalDriveMultToSet
	gearsMaxSpeed[3] = 19*FinalDriveMultToSet
	gearsMinRPM[3] = 3400
	gearsMaxRPM[3] = 4900
	
	gearsTorqueMult[4] = 0.44
	gearsMinSpeed[4] = 17*FinalDriveMultToSet
	gearsMaxSpeed[4] = 24*FinalDriveMultToSet
	gearsMinRPM[4] = 3500
	gearsMaxRPM[4] = 5000
	
	gearsTorqueMult[5] = 0.35
	gearsMinSpeed[5] = 21.5*FinalDriveMultToSet
	gearsMaxSpeed[5] = 26*FinalDriveMultToSet
	gearsMinRPM[5] = 3600
	gearsMaxRPM[5] = 5100
	
	gearsTorqueMult[6] = 0.28
	gearsMinSpeed[6] = 24*FinalDriveMultToSet
	gearsMaxSpeed[6] = 31*FinalDriveMultToSet
	gearsMinRPM[6] = 4000
	gearsMaxRPM[6] = 5400
	
	gearsTorqueMult[7] = 0.24
	gearsMinSpeed[7] = 29*FinalDriveMultToSet
	gearsMaxSpeed[7] = 35*FinalDriveMultToSet
	gearsMinRPM[7] = 4300
	gearsMaxRPM[7] = 5450
	
	--I highly suggest not adding _player etc under them, so that you can more simply use them and make it faster for cloning :)
	vehicleName = "standard25_villefort_columbus"
	
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
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard25_villefort_columbus_player", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard25_villefort_columbus_arasaka", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard25_villefort_columbus_corpo", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard25_villefort_columbus_judy_van", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard25_villefort_columbus_kangtao", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard25_villefort_columbus_poor", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard25_villefort_columbus_quest", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard25_villefort_columbus_sixth_street", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard25_villefort_columbus_tyger", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	
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

return VillefortColumbusHandlingTweaksE1
