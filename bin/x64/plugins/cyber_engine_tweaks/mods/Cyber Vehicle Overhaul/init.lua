local VehicleBaseFunctions = require("modules/functions/main_functions")

registerForEvent("onInit", function() 
	
	--Multipliers:
	--Only affect vehicles within CVO tweaks
	
	--Gear Min/Max speed multiplier for all gears
	--(Suggested maximum value: 1.25)
	local GearSpeedMult = 1.0
	
	--Engine Power multiplier 
	--(Suggested maximum value: 1.25)
	local MaxTorqueMult = 1.0
	
	--Brake Power multiplier 
	--(Suggested maximum value: 2.0)
	local BrakingTorqueMult = 1.0
	
	--Brake Friction multiplier 
	--(Suggested maximum value: 1.2)
	local BrakingFrictionFactorMult = 1.0
	
	--Car Health Multiplier
	--(Suggested Maximum value: 10.0/Any)
	local CarHealthMultiplier = 3.0
	
	--Max Wheel Turn Degree Multiplier
	--Multiplies how much the wheels are able to turn, will affect turning radius
	--(Suggested min value: 0.5) (Suggested max value: 1.5)
	local MaxWheelTurnMult = 1.0
	
	--Steering Turning Speed
	--Multiplier for turning speed of the wheels/steering 
	--More = wheels turn faster | Less = wheels turn slower
	--(Suggested min value: 0.5) (Suggested max value: 1.5)
	local TurnMaxAddMult = 1.0
	
	--Steering Re-Centering Speed
	--Multiplier for Steering re-centring speed of the wheels/steering 
	--More = wheels recenter faster | Less = wheels recenter slower
	--(Suggested min value: 0.5) (Suggested max value: 1.5)
	local TurnMaxSubMult = 1.0	

    local folder = "modules"

    local req = {}

    for _, file in pairs(dir(folder)) do
        if file.type == "file" and file.name:match("%.lua$") then
            local name = file.name:match("(.+)%..+")
            req[name] = require(folder .. "/" .. name)
        end
    end

	for _, car in pairs(req) do
        car.new(GearSpeedMult, MaxTorqueMult, BrakingTorqueMult, BrakingFrictionFactorMult, MaxWheelTurnMult, TurnMaxAddMult, TurnMaxSubMult)
    end

	VehicleBaseFunctions.setAllCarsBaseHPMult(CarHealthMultiplier)
	
end)