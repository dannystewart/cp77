local GameSettings = require('GameSettings')
local GameUI = require('GameUI')
local debug = false
local QuestTrackerSetting = '/interface/hud/quest_tracker'

function dbprint(msg)
	if debug then
		print(msg)
	end
end

registerForEvent('onInit', function()
	GameUI.Listen(function(state)
		GameSettings.Set(QuestTrackerSetting, true)
		dbprint('Quest Tracker enabled')
	end)
end)

registerHotkey("Quest_Untrack", "Untrack Current Quest", function()
	print('Quest Untracker Mod activated')
	Game.untrack()
	print('Current quest untracked')
	dbprint('Current Quest Tracker status:', GameSettings.Get(QuestTrackerSetting))
	GameSettings.Set(QuestTrackerSetting, false)
	print('Quest Tracker disabled')
	dbprint('New Quest Tracker status:', GameSettings.Get(QuestTrackerSetting))
end)
