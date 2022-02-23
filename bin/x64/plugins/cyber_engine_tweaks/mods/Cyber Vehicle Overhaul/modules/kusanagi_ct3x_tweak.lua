YaibaKusanagiCT3XHandlingModE1 = { 
    description = "Yaiba Kusanagi Handling Mod E1"
}

local VehicleBaseFunctions = require("modules/functions/main_functions")

function YaibaKusanagiCT3XHandlingModE1.new(FinalDriveMultToSet, MaxTorqueMult, BrakingTorqueMult, BrakingFrictionFactorMult, MaxWheelTurnMult, TurnMaxAddMult, TurnMaxSubMult)
	
	MinRPM=980
	MaxRPM=8800
	MaxTorque=220*MaxTorqueMult
	ResistanceTorque=100
	WheelsResistanceRatio=15
	
	airResistanceFactor = 0.4
	
	BrakingFrictionFactor=1.05*BrakingFrictionFactorMult
	MaxBrakingTorqueFront=3000*BrakingTorqueMult
	MaxBrakingTorqueBack=1950*BrakingTorqueMult
	
	FrontFrictionLateralMult=1.00
	FrontFricitionLongitudinal=0.98
	
	RearFrictionLateralMult=1.18
	RearFricitionLongitudinal=1.18
	
	CenterOfMassOffset = Vector3.new(0.0,0.18,0.04)
		
	BikeMaxTilt=45
	BikeTiltSpeed = 100
	BikeTiltReturnSpeed = 100
	BikeTiltCustomSpeed = 140
	
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
	gearsMinRPM[1] = 800
	gearsMaxRPM[1] = 8300
	
	gearsTorqueMult[2] = 0.425
	gearsMinSpeed[2] = 18*FinalDriveMultToSet
	gearsMaxSpeed[2] = 28*FinalDriveMultToSet
	gearsMinRPM[2] = 4700
	gearsMaxRPM[2] = 7644
	
	gearsTorqueMult[3] = 0.45
	gearsMinSpeed[3] = 25*FinalDriveMultToSet
	gearsMaxSpeed[3] = 34*FinalDriveMultToSet
	gearsMinRPM[3] = 4900
	gearsMaxRPM[3] = 7920
	
	gearsTorqueMult[4] = 0.36
	gearsMinSpeed[4] = 32*FinalDriveMultToSet
	gearsMaxSpeed[4] = 39*FinalDriveMultToSet
	gearsMinRPM[4] = 5000
	gearsMaxRPM[4] = 8106
	
	gearsTorqueMult[5] = 0.32
	gearsMinSpeed[5] = 35*FinalDriveMultToSet
	gearsMaxSpeed[5] = 45*FinalDriveMultToSet
	gearsMinRPM[5] = 5100
	gearsMaxRPM[5] = 8297
	
	gearsTorqueMult[6] = 0.28
	gearsMinSpeed[6] = 42.5*FinalDriveMultToSet
	gearsMaxSpeed[6] = 50*FinalDriveMultToSet
	gearsMinRPM[6] = 5200
	gearsMaxRPM[6] = 8300
	
	gearsTorqueMult[7] = 0.255
	gearsMinSpeed[7] = 47.5*FinalDriveMultToSet
	gearsMaxSpeed[7] = 59*FinalDriveMultToSet
	gearsMinRPM[7] = 5300
	gearsMaxRPM[7] = 8800
	
	--Yaiba Kusanagi CT-3X Rework

	--I highly suggest not adding _player (like I did here, but there is a good reason for this for this vehicle) etc under them, so that you can more simply use them and make it faster for cloning :)
	vehicleName = "sportbike1_yaiba_kusanagi"
	
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
	--VehicleBaseFunctions.cloneVehicleSettings(fullVehicleName, true, true, false, false, false)
		
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
	VehicleBaseFunctions.setVehicleSettings(fullVehicleName, VehicleEngineData, VehicleDriveModelData, VehicleDataPackage, VehicleWheelDimensionsSetup)

	--Power Settings
	TweakDB:SetFlat(VehicleEngineData..".minRPM", MinRPM)
	TweakDB:SetFlat(VehicleEngineData..".maxRPM", MaxRPM)
	TweakDB:SetFlat(VehicleEngineData..".engineMaxTorque", MaxTorque)
	TweakDB:SetFlat(VehicleEngineData..".resistanceTorque", ResistanceTorque)
	TweakDB:SetFlat(VehicleEngineData..".wheelsResistanceRatio", WheelsResistanceRatio)
	
	
	--Handling settings
	TweakDB:SetFlat(VehicleDriveModelData..".airResistanceFactor", airResistanceFactor)
	TweakDB:SetFlat(VehicleDriveModelData..".bikeMaxTilt", BikeMaxTilt)
	TweakDB:SetFlat(VehicleDriveModelData..".bikeTiltSpeed", BikeTiltSpeed)
	TweakDB:SetFlat(VehicleDriveModelData..".bikeTiltReturnSpeed", BikeTiltReturnSpeed)
	TweakDB:SetFlat(VehicleDriveModelData..".bikeTiltCustomSpeed", BikeTiltCustomSpeed)
	TweakDB:SetFlat(VehicleDriveModelData..".center_of_mass_offset", CenterOfMassOffset)
		
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

return YaibaKusanagiCT3XHandlingModE1
