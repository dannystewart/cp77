registerForEvent("onInit", function()

  fileSys = require("fileSys")
  uiVisible = false
  fileSys.tryCreateConfig("config.json", false)

  originalData = setupTweakDBData()

  relicState = fileSys.loadFile("config.json")

  setRelicState(relicState)
end)

function setRelicState(state)
  relicState = state
  for flat, og in pairs(originalData) do
    TweakDB:SetFlat(flat, state and og or CName.new("0"))
  end
end

function setupTweakDBData()
  local flats = {
    ["BaseStatusEffect.JohnnySicknessMediumQuest_inline2.name"] = CName.new('johnny_sickness_lvl2'),
    ["BaseStatusEffect.JohnnySicknessMedium_inline0.name"] = CName.new('johnny_sickness_lvl2'),
    ["BaseStatusEffect.JohnnySicknessLow_inline0.name"] = CName.new('johnny_sickness_lvl1'),
    ["BaseStatusEffect.JohnnySicknessHeavy_inline0.name"] = CName.new('johnny_sickness_lvl3')
  }

  return flats
end

function drawUI()
  if (ImGui.Begin("RelicBegone", ImGuiWindowFlags.AlwaysAutoResize)) then
    ImGui.Text("Relic Malfunction Effect")
    if ImGui.RadioButton("On", relicState == true) then
      setRelicState(true)
      fileSys.saveFile("config.json", true)
    end
    ImGui.SameLine()
    if ImGui.RadioButton("Off", relicState == false) then
      setRelicState(false)
      fileSys.saveFile("config.json", false)
    end
  end
  ImGui.End()
end

registerForEvent("onDraw", function()
	if uiVisible then
		drawUI()
	end
end)

registerForEvent("onOverlayOpen", function()
  uiVisible = true
end)

registerForEvent("onOverlayClose", function()
  uiVisible = false
end)
