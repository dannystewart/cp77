ArchSportsBikeHandlingModE1 = { 
    description = "Arch Sports Bike Handling Mod E1"
}

local VehicleBaseFunctions = require("modules/functions/main_functions")

function ArchSportsBikeHandlingModE1.new(FinalDriveMultToSet, MaxTorqueMult, BrakingTorqueMult, BrakingFrictionFactorMult, MaxWheelTurnMult, TurnMaxAddMult, TurnMaxSubMult)
	
    --registerForEvent("onInit", function() 
	
	MinRPM=900
	MaxRPM=6450
	MaxTorque=200*MaxTorqueMult
	ResistanceTorque=100
	WheelsResistanceRatio=15
	
	airResistanceFactor = 0.5
	TurningRollFactor = 1
	TotalMass = 350
	
	BrakingFrictionFactor=1.025*BrakingFrictionFactorMult
	MaxBrakingTorqueFront=3400*BrakingTorqueMult
	MaxBrakingTorqueBack=2800*BrakingTorqueMult
	
	FrontFrictionLateralMult=1.06
	FrontFricitionLongitudinal=1.04
	
	RearFrictionLateralMult=1.29
	RearFricitionLongitudinal=1.20
		
	CenterOfMassOffset = Vector3.new(0.0,0.09,0.05)
		
	BikeMaxTilt=46
	BikeTiltSpeed = 80
	BikeTiltReturnSpeed = 80
	BikeTiltCustomSpeed = 130
	
	AmountOfGears = 6
	
	gearsTorqueMult = {}
	gearsMinSpeed = {}
	gearsMaxSpeed = {}
	gearsMinRPM = {}
	gearsMaxRPM = {}
	
	--setting '1' cuz there is gear 0
	gearsTorqueMult[1] = 1.15
	gearsMinSpeed[1] = 0*FinalDriveMultToSet
	gearsMaxSpeed[1] = 12*FinalDriveMultToSet
	gearsMinRPM[1] = 750
	gearsMaxRPM[1] = 5900
	
	gearsTorqueMult[2] = 0.60
	gearsMinSpeed[2] = 11*FinalDriveMultToSet
	gearsMaxSpeed[2] = 19*FinalDriveMultToSet
	gearsMinRPM[2] = 2400
	gearsMaxRPM[2] = 5500
	
	gearsTorqueMult[3] = 0.38
	gearsMinSpeed[3] = 17*FinalDriveMultToSet
	gearsMaxSpeed[3] = 32*FinalDriveMultToSet
	gearsMinRPM[3] = 2500
	gearsMaxRPM[3] = 5600
	
	gearsTorqueMult[4] = 0.36
	gearsMinSpeed[4] = 30*FinalDriveMultToSet
	gearsMaxSpeed[4] = 36*FinalDriveMultToSet
	gearsMinRPM[4] = 2600
	gearsMaxRPM[4] = 5900
	
	gearsTorqueMult[5] = 0.32
	gearsMinSpeed[5] = 31.5*FinalDriveMultToSet
	gearsMaxSpeed[5] = 42*FinalDriveMultToSet
	gearsMinRPM[5] = 2700
	gearsMaxRPM[5] = 6100
	
	gearsTorqueMult[6] = 0.265
	gearsMinSpeed[6] = 38*FinalDriveMultToSet
	gearsMaxSpeed[6] = 50*FinalDriveMultToSet
	gearsMinRPM[6] = 2800
	gearsMaxRPM[6] = 6450
	
	--Arch Sports Bike Rework

	--I highly suggest not adding _player etc under them, so that you can more simply use them and make it faster for cloning :)
	vehicleName = "sportbike2_arch"
	
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
	--VehicleBaseFunctions.setSupensionData(VehicleDriveModelData, VehicleWheelSetup, FrontWheelSuspension, RearWheelSuspension)
	
	--Setting the data to specified vehicles
	--VehicleBaseFunctions.setVehicleSettings(fullVehicleName, VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	--VehicleBaseFunctions.setVehicleSettings("Vehicle.v_sportbike2_arch", VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)
	
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
	TweakDB:SetFlat(VehicleDriveModelData..".center_of_mass_offset", CenterOfMassOffset)
	TweakDB:SetFlat(VehicleDriveModelData..".bikeMaxTilt", BikeMaxTilt)
	TweakDB:SetFlat(VehicleDriveModelData..".bikeTiltSpeed", BikeTiltSpeed)
	TweakDB:SetFlat(VehicleDriveModelData..".bikeTiltReturnSpeed", BikeTiltReturnSpeed)
	TweakDB:SetFlat(VehicleDriveModelData..".bikeTiltCustomSpeed", BikeTiltCustomSpeed)
	
	--Front Suspension and tires
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLateral", FrontFrictionLateralMult)
	TweakDB:SetFlat(FrontWheelSuspension..".frictionMulLongitudinal", FrontFricitionLongitudinal)
	
	--Rear Suspension and tires
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLateral", RearFrictionLateralMult)
	TweakDB:SetFlat(RearWheelSuspension..".frictionMulLongitudinal", RearFricitionLongitudinal)
	
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

return ArchSportsBikeHandlingModE1
