module GrappleCivs.Mod 

@wrapMethod(TakedownBeginEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let targetNPCPuppet = this.stateMachineInitData.target as NPCPuppet;
  let isPlayerInCombat: Bool;
  let playerPuppet = GameInstance.GetPlayerSystem(scriptInterface.executionOwner.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
  let broadcaster = playerPuppet.GetStimBroadcasterComponent();

  Log("Player is in combat: " + playerPuppet.IsInCombat());
  if(targetNPCPuppet.IsCrowd()) {
    targetNPCPuppet.SetWasJustGrappledByPlayer(false);
    targetNPCPuppet.DebugHelper();
  }

  if(IsDefined(broadcaster)) {
    Log("Player broadcasting SpreadFear stim");
    let investigateData: stimInvestigateData;
    investigateData.attackInstigator = playerPuppet;
    investigateData.attackInstigatorPosition = playerPuppet.GetWorldPosition();
    investigateData.fearPhase = 3;
    investigateData.illegalAction = true;
    investigateData.skipReactionDelay = false;    
    broadcaster.TriggerSingleBroadcast(playerPuppet, gamedataStimType.SpreadFear, 30.0, investigateData, true);
  };
}

@wrapMethod(TakedownReleasePreyEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  Log("TakedownReleasePreyEvents.OnEnter");
  if (this.stateMachineInitData.target as NPCPuppet).IsCrowd() {    
      let broadcaster: ref<StimBroadcasterComponent>;      
      let targetNPCPuppet = this.stateMachineInitData.target as NPCPuppet;
      let game: GameInstance = targetNPCPuppet.GetGame();      
      let playerPuppet = GameInstance.GetPlayerSystem(targetNPCPuppet.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet;      
      let reactionSystem: ref<ReactionSystem> = GameInstance.GetReactionSystem(targetNPCPuppet.GetStimReactionComponent().GetOwner().GetGame());

      targetNPCPuppet.SetWasJustGrappledByPlayer(true);
      targetNPCPuppet.DebugHelper();

      if GameInstance.GetGameFeatureManager(game).AggressiveCrowdsEnabled() && !VehicleComponent.IsMountedToVehicle(game, targetNPCPuppet) && reactionSystem.TryRegisteringAggressiveNPC(targetNPCPuppet) && AIActionHelper.TryChangingAttitudeToHostile(targetNPCPuppet as ScriptedPuppet, playerPuppet as GameObject) {        
        TargetTrackingExtension.InjectThreat(targetNPCPuppet as ScriptedPuppet, playerPuppet);        
      } else {
        let triggerDelayReactionEvent = new TriggerDelayedReactionEvent();
        triggerDelayReactionEvent.initAnim = false;
        triggerDelayReactionEvent.behavior = gamedataOutput.Flee;
        GameInstance.GetDelaySystem(game).DelayEvent(GameInstance.FindEntityByID(game, targetNPCPuppet.GetEntityID()), triggerDelayReactionEvent, 0.1);
      }          
  };
}

@wrapMethod(GrappleBreakFreeEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {    
  wrappedMethod(stateContext, scriptInterface);  
  let targetNPCPuppet = this.stateMachineInitData.target as NPCPuppet;
  let playerPuppet = GameInstance.GetPlayerSystem(targetNPCPuppet.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
  let game: GameInstance = targetNPCPuppet.GetGame();
  if (IsDefined(targetNPCPuppet) && targetNPCPuppet.IsCrowd()) {      
    targetNPCPuppet.DebugHelper();

    if(GameInstance.GetGameFeatureManager(game).AggressiveCrowdsEnabled() && targetNPCPuppet.IsCrowd() && !targetNPCPuppet.IsVendor() && !VehicleComponent.IsMountedToVehicle(game, targetNPCPuppet)) {      
      targetNPCPuppet.GetSensesComponent().Toggle(true);        
      targetNPCPuppet.GetSensesComponent().IgnoreLODChange(true);
      targetNPCPuppet.GetTargetTrackerComponent().Toggle(true);
      targetNPCPuppet.SetWasAggressiveCrowd(true);
      targetNPCPuppet.GetStimReactionComponent().ResetAllFearAnimWrappers();
    }
  }
}

@wrapMethod(GrappleStruggleEvents)
public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let targetNPCPuppet = this.stateMachineInitData.target as NPCPuppet;
  let playerPuppet = GameInstance.GetPlayerSystem(targetNPCPuppet.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
  if IsDefined(targetNPCPuppet) {
    if targetNPCPuppet.IsCrowd() {
      GameObject.PlayVoiceOver(targetNPCPuppet, n"fear_beg", n"Scripts:GrappleStruggleEvents");    
        let broadcaster = playerPuppet.GetStimBroadcasterComponent();
        if(IsDefined(broadcaster)) {
          Log("Player broadcasting SpreadFear stim");
          let investigateData: stimInvestigateData;
          investigateData.attackInstigator = playerPuppet;
          investigateData.victimEntity = targetNPCPuppet;
          investigateData.attackInstigatorPosition = playerPuppet.GetWorldPosition();
          investigateData.fearPhase = 3;
          investigateData.illegalAction = true;
          investigateData.skipReactionDelay = true;    
          broadcaster.TriggerSingleBroadcast(playerPuppet, gamedataStimType.SpreadFear, 30.0, investigateData, false);
        };  
    }
  }
}