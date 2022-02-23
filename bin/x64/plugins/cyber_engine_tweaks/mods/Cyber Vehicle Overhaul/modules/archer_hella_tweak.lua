ArcherHellaHandlingTweaksE1 = { 
    description = "Archer Hella Handling Tweaks"
}

local VehicleBaseFunctions = require("modules/functions/main_functions")

function ArcherHellaHandlingTweaksE1.new(FinalDriveMultToSet, MaxTorqueMult, BrakingTorqueMult, BrakingFrictionFactorMult, MaxWheelTurnMult, TurnMaxAddMult, TurnMaxSubMult)

    --registerForEvent("onInit", function() 
	
	MinRPM=900
	MaxRPM=5500
	MaxTorque=475*MaxTorqueMult
	ResistanceTorque=100
	WheelsResistanceRatio=15
	
	WheelsFrictionMapToSet = [[CarDrivingFrictionMap.Sport_Friction_Map]]
	
	BrakingFrictionFactor=1.35*BrakingFrictionFactorMult
	MaxBrakingTorqueFront=3000*BrakingTorqueMult
	MaxBrakingTorqueBack=3500*BrakingTorqueMult
	
	ForwardWeightTransfer = 0.0
	airResistanceFactor = 1.65
	TurningRollFactor = 0.95
	TotalMass = 1600
	
	MaxWheelTurnDeg = 38*MaxWheelTurnMult
	TurnMaxAddPerSecond = 60*TurnMaxAddMult
	TurnMaxSubPerSecond = 100*TurnMaxSubMult
	
	FrontFrictionLateralMult=0.64
	FrontFricitionLongitudinal=0.60
	
	RearFrictionLateralMult=0.88
	RearFricitionLongitudinal=0.86
	
	CenterOfMassOffset = Vector3.new(0.0,0.06,0.38)
		
	FrontVisualSuspensionDroop = 0.10
	FrontWheelsVerticalOffset = -0.01
	
	RearVisualSuspensionDroop = 0.10
	RearWheelsVerticalOffset = -0.03
	
	FrontExtremeCompressionEventScale = 0.6
	RearExtremeCompressionEventScale = 0.6
	
	--23/21
	SpringStiffnessFront = 19
	SpringStiffnessRear = 29
	
	--20/17
	SwaybarStiffnessFront = 16
	SwaybarStiffnessRear = 15
	
	FrontSuspensionMass = 20
	RearSuspensionMass = 50
	
	AmountOfGears = 6
	
	gearsTorqueMult = {}
	gearsMinSpeed = {}
	gearsMaxSpeed = {}
	gearsMinRPM = {}
	gearsMaxRPM = {}
	
	--setting '1' cuz there is gear 0
	gearsTorqueMult[1] = 1.20
	gearsMinSpeed[1] = 0*FinalDriveMultToSet
	gearsMaxSpeed[1] = 9*FinalDriveMultToSet
	gearsMinRPM[1] = 700
	gearsMaxRPM[1] = 4400
	
	gearsTorqueMult[2] = 0.70
	gearsMinSpeed[2] = 7*FinalDriveMultToSet
	gearsMaxSpeed[2] = 18*FinalDriveMultToSet
	gearsMinRPM[2] = 3300
	gearsMaxRPM[2] = 4400
	
	gearsTorqueMult[3] = 0.55
	gearsMinSpeed[3] = 15*FinalDriveMultToSet
	gearsMaxSpeed[3] = 24*FinalDriveMultToSet
	gearsMinRPM[3] = 3400
	gearsMaxRPM[3] = 4500
	
	gearsTorqueMult[4] = 0.42
	gearsMinSpeed[4] = 22*FinalDriveMultToSet
	gearsMaxSpeed[4] = 30*FinalDriveMultToSet
	gearsMinRPM[4] = 3500
	gearsMaxRPM[4] = 4500
	
	gearsTorqueMult[5] = 0.36
	gearsMinSpeed[5] = 27*FinalDriveMultToSet
	gearsMaxSpeed[5] = 35*FinalDriveMultToSet
	gearsMinRPM[5] = 3600
	gearsMaxRPM[5] = 4600
	
	gearsTorqueMult[6] = 0.32
	gearsMinSpeed[6] = 32.5*FinalDriveMultToSet
	gearsMaxSpeed[6] = 40*FinalDriveMultToSet
	gearsMinRPM[6] = 3700
	gearsMaxRPM[6] = 5300
	
	--I highly suggest not adding _player etc under them, so that you can more simply use them and make it faster for cloning :)
	vehicleName = "standard2_archer_hella_player"
	
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
	
	--Swapping the car to Cortes RWD setup
	TweakDB:SetFlat("Vehicle.v_standard2_archer_hella_player_inline5.LB", TweakDB:GetFlat("Vehicle.VehicleDriveModelData_Cortes_Police_inline0.LB"))
	TweakDB:SetFlat("Vehicle.v_standard2_archer_hella_player_inline5.LF", TweakDB:GetFlat("Vehicle.VehicleDriveModelData_Cortes_Police_inline0.LF"))
	TweakDB:SetFlat("Vehicle.v_standard2_archer_hella_player_inline5.RB", TweakDB:GetFlat("Vehicle.VehicleDriveModelData_Cortes_Police_inline0.RB"))
	TweakDB:SetFlat("Vehicle.v_standard2_archer_hella_player_inline5.RF", TweakDB:GetFlat("Vehicle.VehicleDriveModelData_Cortes_Police_inline0.RF"))

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
	TweakDB:SetFlat(VehicleDriveModelData..".maxWheelTurnDeg", MaxWheelTurnDeg)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxAddPerSecond", TurnMaxAddPerSecond)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelTurnMaxSubPerSecond", TurnMaxSubPerSecond)
	TweakDB:SetFlat(VehicleDriveModelData..".forwardWeightTransferFactor", ForwardWeightTransfer)
	TweakDB:SetFlat(VehicleDriveModelData..".wheelsFrictionMap", WheelsFrictionMapToSet)
	TweakDB:SetFlat(VehicleDriveModelData..".center_of_mass_offset", CenterOfMassOffset)
	TweakDB:SetFlat(VehicleDriveModelData..".useAlternativeTurnUpdate", true)
			
	--Front Suspension and tires
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLateral", FrontFrictionLateralMult)
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLongitudinal", FrontFricitionLongitudinal)
	TweakDB:SetFlat(FrontWheelSuspension..".springStiffness", SpringStiffnessFront)
	TweakDB:SetFlat(FrontWheelSuspension..".swaybarStiffness", SwaybarStiffnessFront)
	TweakDB:SetFlat(FrontWheelSuspension..".extremeCompressionEventScalor", FrontExtremeCompressionEventScale)
	TweakDB:SetFlat(FrontWheelSuspension..".visualSuspensionDroop", FrontVisualSuspensionDroop)
	TweakDB:SetFlat(FrontWheelSuspension..".wheelsVerticalOffset", FrontWheelsVerticalOffset)
	TweakDB:SetFlat(FrontWheelSuspension..".mass", FrontSuspensionMass)
		
	--Rear Suspension and tires
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLateral", RearFrictionLateralMult)
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLongitudinal", RearFricitionLongitudinal)
	TweakDB:SetFlat(RearWheelSuspension..".springStiffness", SpringStiffnessRear)
	TweakDB:SetFlat(RearWheelSuspension..".swaybarStiffness", SwaybarStiffnessRear)
	TweakDB:SetFlat(RearWheelSuspension..".extremeCompressionEventScalor", RearExtremeCompressionEventScale)
	TweakDB:SetFlat(RearWheelSuspension..".visualSuspensionDroop", RearVisualSuspensionDroop)
	TweakDB:SetFlat(RearWheelSuspension..".wheelsVerticalOffset", RearWheelsVerticalOffset)
	TweakDB:SetFlat(FrontWheelSuspension..".mass", RearSuspensionMass)
	
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

return ArcherHellaHandlingTweaksE1
