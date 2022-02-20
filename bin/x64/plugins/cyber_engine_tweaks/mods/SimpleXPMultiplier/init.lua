local settings = {
  StreetCred = 1.0,
  Level = 1.0,
  Demolition = 1.0,
  Assault = 1.0,
  Athletics = 1.0,
  Kenjutsu = 1.0,
  Hacking = 1.0,
  ColdBlood = 1.0,
  Crafting = 1.0,
  Engineering = 1.0,
  Gunslinger = 1.0,
  CombatHacking = 1.0,
  Stealth = 1.0,
  Brawling = 1.0
}

local locKeys = {
  StreetCred = 22294,
  Level = 22291,
  Demolition = 22320,
  Assault = 22315,
  Athletics = 22299,
  Kenjutsu = 22318,
  Hacking = 22330,
  ColdBlood = 22302,
  Crafting = 22328,
  Engineering = 22326,
  Gunslinger = 22311,
  CombatHacking = 22332,
  Stealth = 22324,
  Brawling = 22306
}

local xpOrder = {
  'Level',
  'StreetCred',
  'Athletics',
  'Hacking',
  'ColdBlood',
  'Crafting',
  'Engineering',
  'Stealth',
  'Demolition',
  'Assault',
  'Gunslinger',
  'Kenjutsu',
  'Brawling',
  'CombatHacking'
}

local GameUI = require('GameUI')
local GameSettings = require('GameSettings')
local lang = ""

registerForEvent("onInit", function()
  lang = NameToString(GameSettings.Get("/language/OnScreen"))
  
  SetupLanguageListener()
  LoadSettings()
  SetupMenu()

  Override("PlayerDevelopmentSystem", "OnExperienceAdded", function(this, request, wrapped)
    local newAmount = math.floor(request.amount * GetMultiplier(request.experienceType))
    request.amount = newAmount
    
    wrapped(request)
  end)

  Override("PlayerDevelopmentSystem", "OnExperienceQueued", function(this, request, wrapped)
    local newAmount = math.floor(request.amount * GetMultiplier(request.experienceType))
    request.amount = newAmount

    wrapped(request)
  end)
end)

function GetMultiplier(type)
  local mult = 1.0
  if type == gamedataProficiencyType.Level then mult = settings.Level
  elseif type == gamedataProficiencyType.StreetCred then mult = settings.StreetCred
  elseif type == gamedataProficiencyType.Athletics then mult = settings.Athletics
  elseif type == gamedataProficiencyType.Hacking then mult = settings.Hacking
  elseif type == gamedataProficiencyType.ColdBlood then mult = settings.ColdBlood
  elseif type == gamedataProficiencyType.Crafting then mult = settings.Crafting
  elseif type == gamedataProficiencyType.Engineering then mult = settings.Engineering
  elseif type == gamedataProficiencyType.Stealth then mult = settings.Stealth
  elseif type == gamedataProficiencyType.Demolition then mult = settings.Demolition
  elseif type == gamedataProficiencyType.Assault then mult = settings.Assault
  elseif type == gamedataProficiencyType.Gunslinger then mult = settings.Gunslinger
  elseif type == gamedataProficiencyType.Kenjutsu then mult = settings.Kenjutsu
  elseif type == gamedataProficiencyType.Brawling then mult = settings.Brawling
  elseif type == gamedataProficiencyType.CombatHacking then mult = settings.CombatHacking
  end
  return mult
end

function SetupLanguageListener()
  GameUI.Listen("MenuNav", function(state)
		if state.lastSubmenu ~= nil and state.lastSubmenu == "Settings" then
      local newLang = NameToString(GameSettings.Get("/language/OnScreen"))
      if lang ~= newLang then
        lang = newLang
        SetupMenu()
      end
      SaveSettings()
    end
	end)
end

function LoadSettings()
  local file = io.open('settings.json', 'r')
  if file ~= nil then
    local contents = file:read("*a")
    local validJson, savedSettings = pcall(function() return json.decode(contents) end)
    file:close()

    if validJson then
      for key, _ in pairs(settings) do
        if savedSettings[key] ~= nil then
          settings[key] = savedSettings[key]
        end
      end
    end
  end
end

function SaveSettings()
  local validJson, contents = pcall(function() return json.encode(settings) end)

  if validJson and contents ~= nil then
    local file = io.open("settings.json", "w+")
    file:write(contents)
    file:close()
  end
end

function SetupMenu()
  local nativeSettings = GetMod("nativeSettings")

  if not nativeSettings.pathExists("/RMK") then
    nativeSettings.addTab("/RMK", "RMK Mods")
  end

  if nativeSettings.pathExists("/RMK/simple_xp_multiplier") then
    nativeSettings.removeSubcategory("/RMK/simple_xp_multiplier")
  end
  nativeSettings.addSubcategory("/RMK/simple_xp_multiplier", GetCategoryName())

  for _, xpType in pairs(xpOrder) do
    local xpName = GetLocalizedText("LocKey#" .. locKeys[xpType])
    -- Parameters: path, label, desc, min, max, step, format, currentValue, defaultValue, callback
    nativeSettings.addRangeFloat("/RMK/simple_xp_multiplier", xpName, GetDescriptionText(), 0, 10, 0.1, "%.1f", settings[xpType], 1, function(value)
      settings[xpType] = value
    end)
  end
  nativeSettings.refresh()
end

function GetCategoryName()
  if     lang == 'pl-pl' then return "Prosty mnożnik PD"
  elseif lang == 'en-us' then return 'Simple XP Multiplier'
  elseif lang == 'es-es' or lang == 'es-mx' then return "Multiplicador de XP simple"
  elseif lang == 'fr-fr' then return "Multiplicateur d'XP simple"
  elseif lang == 'it-it' then return "Moltiplicatore XP semplice"
  elseif lang == 'de-de' then return "Einfacher XP-Multiplikator"
  elseif lang == 'kr-kr' then return "단순 XP 승수" -- Korean
  elseif lang == 'zh-cn' then return "简单的 XP 乘数" -- Simplified Chinese
  elseif lang == 'ru-ru' then return "Простой множитель опыта" -- Russian
  elseif lang == 'pt-br' then return "Multiplicador XP Simples" -- Brazilian Portuguese
  elseif lang == 'jp-jp' then return "シンプルなXP乗数" -- Japanese
  elseif lang == 'zh-tw' then return "簡單的 XP 乘數" -- Traditional Chinese
  elseif lang == 'ar-ar' then return "مضاعف XP بسيط" -- Arabic
  elseif lang == 'cz-cz' then return "Jednoduchý násobič XP" -- Czech
  elseif lang == 'hu-hu' then return "Egyszerű XP szorzó" -- Hungarian
  elseif lang == 'tr-tr' then return "Basit XP Çarpanı" -- Turkish
  elseif lang == 'th-th' then return "ตัวคูณ XP อย่างง่าย" -- Thai
  else return "Simple XP Multiplier"
  end
end

function GetDescriptionText()
  if     lang == 'pl-pl' then return "Zdobyte doświadczenie zostanie pomnożone przez tę wartość"
  elseif lang == 'en-us' then return "Experience gained will be multiplied by this value"
  elseif lang == 'es-es' or lang == 'es-mx' then return "La experiencia adquirida se multiplicará por este valor."
  elseif lang == 'fr-fr' then return "L'expérience acquise sera multipliée par cette valeur"
  elseif lang == 'it-it' then return "L'esperienza acquisita sarà moltiplicata per questo valore"
  elseif lang == 'de-de' then return "Die gesammelten Erfahrungen werden mit diesem Wert multipliziert"
  elseif lang == 'kr-kr' then return "획득한 경험치는 이 값을 곱합니다." -- Korean
  elseif lang == 'zh-cn' then return "获得的经验将乘以这个值" -- Simplified Chinese
  elseif lang == 'ru-ru' then return "Полученный опыт будет умножен на это значение." -- Russian
  elseif lang == 'pt-br' then return "A experiência adquirida será multiplicada por este valor" -- Brazilian Portuguese
  elseif lang == 'jp-jp' then return "得られた経験はこの値で乗算されます" -- Japanese
  elseif lang == 'zh-tw' then return "獲得的經驗將乘以這個值" -- Traditional Chinese
  elseif lang == 'ar-ar' then return "الخبرة المكتسبة سوف تتضاعف بهذه القيمة" -- Arabic
  elseif lang == 'cz-cz' then return "Získané zkušenosti se touto hodnotou vynásobí" -- Czech
  elseif lang == 'hu-hu' then return "A megszerzett tapasztalatok megszorozódnak ezzel az értékkel" -- Hungarian
  elseif lang == 'tr-tr' then return "Kazanılan deneyim bu değerle çarpılacaktır." -- Turkish
  elseif lang == 'th-th' then return "ค่าประสบการณ์ที่ได้รับจะถูกคูณด้วยค่านี้" -- Thai
  else return "Experience gained will be multiplied by this value"
  end
end


function GetTextTemplate()
  if     lang == 'pl-pl' then return ""
  elseif lang == 'en-us' then return ""
  elseif lang == 'es-es' or lang == 'es-mx' then return ""
  elseif lang == 'fr-fr' then return ""
  elseif lang == 'it-it' then return ""
  elseif lang == 'de-de' then return ""
  elseif lang == 'kr-kr' then return "" -- Korean
  elseif lang == 'zh-cn' then return "" -- Simplified Chinese
  elseif lang == 'ru-ru' then return "" -- Russian
  elseif lang == 'pt-br' then return "" -- Brazilian Portuguese
  elseif lang == 'jp-jp' then return "" -- Japanese
  elseif lang == 'zh-tw' then return "" -- Traditional Chinese
  elseif lang == 'ar-ar' then return "" -- Arabic
  elseif lang == 'cz-cz' then return "" -- Czech
  elseif lang == 'hu-hu' then return "" -- Hungarian
  elseif lang == 'tr-tr' then return "" -- Turkish
  elseif lang == 'th-th' then return "" -- Thai
  else return ""
  end
end

