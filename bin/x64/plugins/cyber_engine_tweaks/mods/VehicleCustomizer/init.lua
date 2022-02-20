registerForEvent("onInit",function ()
    ActiveVehicle=nil
    VehicleOptions=LoadFile("options.json")
    VehicleReplacement=LoadFile("replacements.json")
    
    Observe("VehicleComponent", "OnGameAttach", function(self, event)
        local veh=self:GetVehicle()
        --print("Found vehicle "..GetVehicleName(veh))
        if(veh:IsPlayerVehicle())then
            VehicleReplacement=LoadFile("replacements.json")
            local id,app=GetAppearanceFromArray(veh)
            if(app~=nil)then
                SetAppearance(veh,app)
            end
        end
        
    end)
    Observe("VehicleComponent", "OnSummonStartedEvent", function(self,event)
        ActiveVehicle=self:GetVehicle()
        
    end)
end)
registerForEvent("onOverlayOpen", function()
	CetOpen = true
end)

registerForEvent("onOverlayClose", function()
	CetOpen = false
end)
registerForEvent("onDraw", function()
    if(CetOpen)then
        ImGui.Begin("Vehicle Customizer", ImGuiWindowFlags.AlwaysAutoResize)
        if(ActiveVehicle~=nil)then
            local activeScanID=GetScanID(ActiveVehicle)
            ImGui.Text("Current Vehicle: "..GetVehicleName(ActiveVehicle))
            ImGui.Spacing()
            local currentSkin=GetAppearanceString(ActiveVehicle:GetCurrentAppearanceName())
            ImGui.Text("Current Skin: "..currentSkin)
            ImGui.Spacing()
            if (ImGui.BeginCombo("", "Select a Skin", ImGuiComboFlags.HeightLarge)) then
                if (ImGui.Selectable("DEFAULT"))then
                    VehicleReplacement[activeScanID].ReplaceWith="nil"
                    SaveFile("replacements.json",VehicleReplacement)
                    SetAppearance(ActiveVehicle, VehicleReplacement[activeScanID].Default)
                end
                for key,value in pairs(VehicleOptions[activeScanID]) do
                    local display=value
                    if(value==VehicleReplacement[activeScanID].ReplaceWith)then display=(display.." : SELECTED") end
                    if (ImGui.Selectable(display))then
                        VehicleReplacement[activeScanID].ReplaceWith=value
                        SaveFile("replacements.json",VehicleReplacement)
                        SetAppearance(ActiveVehicle,value)
                    end
                end
                ImGui.EndCombo()
            end
        else ImGui.Text("Current Vehicle: NONE")end
        ImGui.End()
    end
end)
function GetAppearanceFromArray(veh)
    local id = GetScanID(veh)
    
    if(VehicleReplacement[id]==nil)then
        VehicleReplacement[id]={Name=GetVehicleName(veh),ReplaceWith="nil",Default=GetAppearanceString(veh:GetCurrentAppearanceName())}
        SaveFile("replacements.json",VehicleReplacement)
    end
    local app=VehicleReplacement[id].ReplaceWith
    if(app=="nil")then
        app=nil
    end
    return id,app
end
function GetAppearanceString(ent)
    local str=tostring(ent)
    local begin1,end1=string.find (str, "%-%-%[%[ ")
    local begin2,end2=string.find (str, " %-%-%]%]")
    local returnString=string.sub (str, end1+1, begin2-1)
    
    return returnString
end
function SetAppearance(t,newApperance)
    if(GetAppearanceString(t:GetCurrentAppearanceName())~=newApperance)then
        t:PrefetchAppearanceChange(newApperance)
        t:ScheduleAppearanceChange(newApperance)
    end
end


function GetVehicleName(t)
	if(t == nil)then
		return nil
	end
    return t:GetDisplayName()
end
function PrintTable(table)
    local output=""
    for key, value in pairs(table) do
        output=output..(tostring(key).. " -- ".. tostring(value).."\n")
    end
    return output
end
function GetScanID(t)
	return tostring(t:GetRecordID()):match("= (%g+),")
end
function LoadFile(path) 
    local file = io.open(path, "r")
    local cf = json.decode(file:read("*a"))
    file:close()
    return cf
end

function SaveFile(path, data)
    local file = io.open(path, "w")
    local jconfig = json.encode(data)
    file:write(jconfig)
    file:close()
end