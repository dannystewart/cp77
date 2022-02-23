-------------------------------------------------------------------------------------------------------------------------------
-- This mod was created by keanuWheeze from CP2077 Modding Tools Discord.
--
-- You are free to use this mod as long as you follow the following license guidelines:
--    * It may not be uploaded to any other site without my express permission.
--    * Using any code contained herein in another mod requires credits / asking me.
--    * You may not fork this code and make your own competing version of this mod available for download without my permission.
--
-------------------------------------------------------------------------------------------------------------------------------
-- Credits: psiberx for GameUI.lua and Cron.lua
-------------------------------------------------------------------------------------------------------------------------------

local flashlight = {
    runtimeData = {
        inMenu = false,
        inGame = false
    },

    defaultSettings = {
        fadeTime = 0.15,
        offset = 0.3,
        brightness = 20,
        angle = 40,
        falloff = 10,
        range = 100,
        color = 2,
        red = 255,
        green = 255,
        blue = 255
    },
    settings = {},

    config = require("modules/utils/config"),
    settingsUI = require("modules/settingsUI"),
    logic = require("modules/logic"),
    Cron = require("modules/external/Cron"),
    GameUI = require("modules/external/GameUI")
}

function flashlight:new()
    registerForEvent("onInit", function()
        self.archiveInstalled = ModArchiveExists("flashlight.archive")
        if not self.archiveInstalled then
            print("[Flashlight] Error: \"flashlight.archive\" file could not be found inside \"archive/pc/mod\". Mod has been disabled to avoid crashes.")
            return
        end

        self.config.tryCreateConfig("config.json", self.defaultSettings)
        self.config.backwardComp("config.json", self.defaultSettings)
        self.settings = self.config.loadFile("config.json")
        self.logic.initColors()

        self.settingsUI.setupNative(self)
        self.logic.addObserver(flashlight)

        Observe('RadialWheelController', 'OnIsInMenuChanged', function(_, isInMenu) -- Setup observer and GameUI to detect inGame / inMenu
            self.runtimeData.inMenu = isInMenu
        end)

        self.GameUI.OnSessionStart(function()
            self.runtimeData.inGame = true
            self.logic.initColors()
        end)

        self.GameUI.OnSessionEnd(function()
            self.runtimeData.inGame = false
            self.logic.despawn()
            self.logic.active = false
        end)

        self.GameUI.OnPhotoModeOpen(function()
            self.runtimeData.inMenu = true
        end)

        self.GameUI.OnPhotoModeClose(function()
            self.runtimeData.inMenu = false
        end)

        self.runtimeData.inGame = not self.GameUI.IsDetached() -- Required to check if ingame after reloading all mods
    end)

    registerForEvent("onShutdown", function ()
        self.logic.despawn()
    end)

    registerForEvent("onUpdate", function (deltaTime)
        if not self.archiveInstalled then return end

        if self.runtimeData.inGame and not self.runtimeData.inMenu then
            self.Cron.Update(deltaTime)
            self.logic.run(self)
        end
    end)

    registerHotkey('flashLightToggle', 'Toggle Flashlight', function()
        if not self.archiveInstalled then return end
        if self.runtimeData.inGame and not self.runtimeData.inMenu then
            self.logic.toggle(flashlight)
        end
    end)

    return self

end

return flashlight:new()