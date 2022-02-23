EmperorHandlingTweaksE1 = { 
    description = "Chevillon Emperor Handling Tweaks"
}

local VehicleBaseFunctions = require("modules/functions/main_functions")

function EmperorHandlingTweaksE1.new(FinalDriveMultToSet, MaxTorqueMult, BrakingTorqueMult, BrakingFrictionFactorMult, MaxWheelTurnMult, TurnMaxAddMult, TurnMaxSubMult)

	MinRPM=800
	MaxRPM=5300
	MaxTorque=800*MaxTorqueMult
	ResistanceTorque=100
	WheelsResistanceRatio=25
	
	BrakingFrictionFactor=1.6*BrakingFrictionFactorMult
	MaxBrakingTorqueFront=2400*BrakingTorqueMult
	MaxBrakingTorqueBack=4800*BrakingTorqueMult
	
	TotalMass = 2860
	TurningRollFactor = 1
	airResistanceFactor = 3.75
	
	MaxWheelTurnDeg = 40*MaxWheelTurnMult
	TurnMaxAddPerSecond = 70*TurnMaxAddMult
	TurnMaxSubPerSecond = 85*TurnMaxSubMult
	
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
	gearsMaxRPM[1] = 4400
	
	gearsTorqueMult[2] = 0.70
	gearsMinSpeed[2] = 8*FinalDriveMultToSet
	gearsMaxSpeed[2] = 15*FinalDriveMultToSet
	gearsMinRPM[2] = 2200
	gearsMaxRPM[2] = 4100
	
	gearsTorqueMult[3] = 0.46
	gearsMinSpeed[3] = 13*FinalDriveMultToSet
	gearsMaxSpeed[3] = 20*FinalDriveMultToSet
	gearsMinRPM[3] = 2500
	gearsMaxRPM[3] = 4400
	
	gearsTorqueMult[4] = 0.39
	gearsMinSpeed[4] = 18*FinalDriveMultToSet
	gearsMaxSpeed[4] = 25*FinalDriveMultToSet
	gearsMinRPM[4] = 2800
	gearsMaxRPM[4] = 4700
	
	gearsTorqueMult[5] = 0.33
	gearsMinSpeed[5] = 23.5*FinalDriveMultToSet
	gearsMaxSpeed[5] = 30*FinalDriveMultToSet
	gearsMinRPM[5] = 3000
	gearsMaxRPM[5] = 4900
	
	gearsTorqueMult[6] = 0.28
	gearsMinSpeed[6] = 28*FinalDriveMultToSet
	gearsMaxSpeed[6] = 35*FinalDriveMultToSet
	gearsMinRPM[6] = 3200
	gearsMaxRPM[6] = 5150
	
	gearsTorqueMult[7] = 0.255
	gearsMinSpeed[7] = 32.5*FinalDriveMultToSet
	gearsMaxSpeed[7] = 40*FinalDriveMultToSet
	gearsMinRPM[7] = 3400
	gearsMaxRPM[7] = 5300
	
	--I highly suggest not adding _player etc under them, so that you can more simply use them and make it faster for cloning :)
	vehicleName = "standard3_chevalier_emperor_player"
	
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
	--VehicleBaseFunctions.setVehicleSettings("Vehicle.v_standard25_villefort_columbus_player", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	
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

return EmperorHandlingTweaksE1
