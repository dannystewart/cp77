local CetAdapter = {}
local presetDir = "character-presets"

local function SplitFilename(strFilename)
    -- Returns the Path, Filename, and Extension as 3 values
    return string.match(strFilename, "(.-)([^\\]-([^\\%.]+))$")
end

local function CheckFilename(strFilename)
    if str:match("%W") then
        return false
    end
    return true
end

-- I hate lua
local function Split (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end  

function CetAdapter.Init()
    print("Hooking functions")

    Override("CharacterPresetManager", "CETActive", function(self) 
        return true
    end)

    Override("CharacterPresetManager", "ListPresets", function(self)
        local presetNames = {}
        local presets = dir(presetDir)
        for _, file in ipairs(presets) do
            if file.type == "file" then
                path,name,extension = SplitFilename(file.name)
                if extension == "preset" then
                    table.insert(presetNames, Split(name, '.')[1])
                end
            end
        end
        return presetNames
    end)

    Override("CharacterPresetManager", "LoadPreset", function(self, name)
        print("LOADING FROM " .. name .. ".preset")
        local file = io.open(presetDir .. "/" .. name .. ".preset", "r")
        file:seek("set")
        local fileStr = file:read("*a")
        file:close()
        local options = {}
        for line in fileStr:gmatch("[^\r\n]+") do
            table.insert(options, line)
        end
        return options
    end)

    Override("CharacterPresetManager", "SavePreset", function(self, name, options)
        local file = io.open(presetDir .. "/" .. name .. ".preset", "w")
        file:seek("set")
        local fileStr = ""
        for _, option in ipairs(options) do
            fileStr = fileStr .. option .. "\n"
        end
        file:write(fileStr)
        file:flush()
        file:close()
    end)
end

registerForEvent('onInit', function()
    CetAdapter.Init()
end)