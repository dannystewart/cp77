DisableLoadingCinematics = { 
    description = "Disable Loading Cinematics"
}

function DisableLoadingCinematics:new()

	
    registerForEvent("onInit", function() 
	
	setScreenToDefault("InitLoadingScreen.LoadingScreenAfter104quest")
	setScreenToDefault("InitLoadingScreen.LoadingScreenAfter110quest")
	setScreenToDefault("InitLoadingScreen.LoadingScreenAfter112quest")
	setScreenToDefault("InitLoadingScreen.LoadingScreenAfter113quest")
	setScreenToDefault("InitLoadingScreen.LoadingScreenAfter114quest")
	setScreenToDefault("InitLoadingScreen.LoadingScreenAfter115quest")
	setScreenToDefault("InitLoadingScreen.LoadingScreenAfter5quest")
	setScreenToDefault("InitLoadingScreen.LoadingScreenBefore5quest")

    end)
	
	function setScreenToDefault(ScreenFlat)
		DefaultScreen = "InitLoadingScreen.DefaultInitialLoadingScreen"

		TweakDB:SetFlat(ScreenFlat..".firstAnimLibraryName", TweakDB:GetFlat(DefaultScreen..".firstAnimLibraryName"))
		TweakDB:SetFlat(ScreenFlat..".firstAnimName", TweakDB:GetFlat(DefaultScreen..".firstAnimName"))
		TweakDB:SetFlat(ScreenFlat..".loadingScreenResource", TweakDB:GetFlat(DefaultScreen..".loadingScreenResource"))
		TweakDB:SetFlat(ScreenFlat..".loopAnimName", TweakDB:GetFlat(DefaultScreen..".loopAnimName"))
		TweakDB:SetFlat(ScreenFlat..".mainMenuAnimName", TweakDB:GetFlat(DefaultScreen..".mainMenuAnimName"))
		TweakDB:SetFlat(ScreenFlat..".mainMenuLibraryName", TweakDB:GetFlat(DefaultScreen..".mainMenuLibraryName"))
		TweakDB:SetFlat(ScreenFlat..".mainMenuLoopAnimName", TweakDB:GetFlat(DefaultScreen..".mainMenuLoopAnimName"))
		TweakDB:SetFlat(ScreenFlat..".mainMenuResource", TweakDB:GetFlat(DefaultScreen..".mainMenuResource"))
		TweakDB:SetFlat(ScreenFlat..".secondAnimLibraryName", TweakDB:GetFlat(DefaultScreen..".secondAnimLibraryName"))
		TweakDB:SetFlat(ScreenFlat..".secondAnimName", TweakDB:GetFlat(DefaultScreen..".secondAnimName"))
		TweakDB:SetFlat(ScreenFlat..".thirdAnimLibraryName", TweakDB:GetFlat(DefaultScreen..".thirdAnimLibraryName"))
		TweakDB:SetFlat(ScreenFlat..".thirdAnimName", TweakDB:GetFlat(DefaultScreen..".thirdAnimName"))
		TweakDB:SetFlat(ScreenFlat..".voTrackAnimName", TweakDB:GetFlat(DefaultScreen..".voTrackAnimName"))
	end

end

return DisableLoadingCinematics:new()