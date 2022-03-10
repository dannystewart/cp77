module GrappleCivs.Mod 

@addMethod(ReactionManagerComponent)
private func StimTypeEnumToString(stimType:gamedataStimType) -> String {
    return NameToString(EnumValueToName(n"gamedataStimType", Cast<Int64>(EnumInt(stimType))));
}

@replaceMethod(ReactionManagerComponent)
protected final func HandleStimEvent(stimData: ref<StimEventTaskData>) -> Void {
  let localPlayer: ref<GameObject>;
  let ownerPuppet: ref<ScriptedPuppet>;
  let resetLookatReaction: ref<ResetLookatReactionEvent>;
  let stimEvent: ref<StimuliEvent>;
  let stimParams: StimParams;
  let stimType: gamedataStimType;
  if !IsDefined(stimData) || !IsDefined(stimData.cachedEvt) {
    return;
  };
  stimEvent = stimData.cachedEvt;
  stimType = stimEvent.GetStimType();
  //////////////////////////
  let stimTypeString = this.StimTypeEnumToString(stimType);    
  //////////////////////////
  this.m_receivedStimType = stimType;
  if !this.IsEnabled() {
    this.m_receivedStimType = gamedataStimType.Invalid;
    return;
  };
  if !this.m_initialized {
    this.Initialiaze();
    this.m_initialized = true;
  };
  ownerPuppet = this.GetOwnerPuppet();
  if Equals(this.m_receivedStimType, gamedataStimType.AudioEnemyPing) {
    if ScriptedPuppet.IsActive(ownerPuppet) && ownerPuppet.IsAggressive() {
      localPlayer = GameInstance.GetPlayerSystem(ownerPuppet.GetGame()).GetLocalPlayerMainGameObject();
      if !this.SourceAttitude(localPlayer, EAIAttitude.AIA_Friendly) {
        GameInstance.GetAudioSystem(ownerPuppet.GetGame()).RegisterEnemyPingStim(ownerPuppet.GetHighLevelStateFromBlackboard(), ownerPuppet.IsPrevention());
      };
    };
    return;
  };
  if this.ShouldEventBeProcessed(stimEvent) {
    if IsDefined(ownerPuppet.GetCrowdMemberComponent()) && (this.m_inCrowd || ownerPuppet.IsCharacterCivilian()) {                
      if this.ShouldStimBeProcessedByCrowd(stimEvent) {          
        Log("ownerPuppet should react to:" + stimTypeString);            
        this.HandleCrowdReaction(stimEvent);
      };
      if stimEvent.IsTagInStimuli(n"Safe") {
        resetLookatReaction = new ResetLookatReactionEvent();
        GameInstance.GetDelaySystem(this.GetOwner().GetGame()).DelayEvent(this.GetOwner(), resetLookatReaction, 1.00);
      };
      this.m_receivedStimType = gamedataStimType.Invalid;
      return;
    };
    if this.ShouldStimBeProcessed(stimEvent) {
      stimParams = this.ProcessStimParams(stimEvent);
      this.ProcessReactionOutput(stimData, stimParams);
    };
  };
  if Equals(stimType, gamedataStimType.StopedAiming) && this.m_reactionPreset.IsAggressive() {
    ownerPuppet.GetSensesComponent().ReevaluateDetectionOverwrite(stimEvent.sourceObject);
  };
  if Equals(stimType, gamedataStimType.EnvironmentalHazard) {
    this.ProcessEnvironmentalHazard(stimEvent);
  };
  this.m_receivedStimType = gamedataStimType.Invalid;
}

@replaceMethod(ReactionManagerComponent)
private final func HandleCrowdReaction(stimEvent: ref<StimuliEvent>) -> Void {  
  let delayedCrowdReaction: ref<DelayedCrowdReactionEvent>;
  let mountInfo: MountingInfo;
  let stimAttackData: stimInvestigateData;
  let vehicleReactionEvent: ref<HandleReactionEvent>;
  let owner: ref<GameObject> = this.GetOwner();
  let game: GameInstance = owner.GetGame();
  let reactionSystem: ref<ReactionSystem> = GameInstance.GetReactionSystem(this.GetOwner().GetGame());
  if this.m_inCrowd && GameInstance.GetGameFeatureManager(game).AggressiveCrowdsEnabled() && !VehicleComponent.IsMountedToVehicle(game, owner) && this.ShouldTriggerAggressiveCrowdNPCCombat(stimEvent) && reactionSystem.TryRegisteringAggressiveNPC(owner) && AIActionHelper.TryChangingAttitudeToHostile(owner as ScriptedPuppet, stimEvent.sourceObject) {    
    owner.GetSensesComponent().IgnoreLODChange(true);
    owner.GetSensesComponent().Toggle(true);
    owner.GetTargetTrackerComponent().Toggle(true);
    TargetTrackingExtension.InjectThreat(owner as ScriptedPuppet, stimEvent.sourceObject);
    (owner as NPCPuppet).SetWasAggressiveCrowd(true);
    this.ResetAllFearAnimWrappers();
  } else {
    if Equals(this.m_reactionPreset.Type(), gamedataReactionPresetType.Child) && stimEvent.IsTagInStimuli(n"ChildDanger") {
      this.m_desiredFearPhase = 3;
      this.DeactiveLookAt();
      stimAttackData = stimEvent.stimInvestigateData;
      if IsDefined(stimAttackData.attackInstigator) {
        stimEvent.sourceObject = stimAttackData.attackInstigator as GameObject;
        stimEvent.sourcePosition = stimEvent.sourceObject.GetWorldPosition();
      };
      this.ActivateReactionLookAt(stimEvent.sourceObject, false);
      delayedCrowdReaction = new DelayedCrowdReactionEvent();
      delayedCrowdReaction.stimEvent = stimEvent;
      owner.QueueEvent(delayedCrowdReaction);
    } else {
      if VehicleComponent.IsMountedToVehicle(game, owner) && NotEquals(stimEvent.GetStimType(), gamedataStimType.HijackVehicle) && NotEquals(stimEvent.GetStimType(), gamedataStimType.Dying) {
        NPCPuppet.ChangeHighLevelState(owner, gamedataNPCHighLevelState.Fear);
        mountInfo = GameInstance.GetMountingFacility(game).GetMountingInfoSingleWithObjects(owner);
        this.m_previousFearPhase = this.ConvertFearStageToFearPhase(this.m_crowdFearStage);
        vehicleReactionEvent = new HandleReactionEvent();
        vehicleReactionEvent.fearPhase = this.GetFearReactionPhase(stimEvent);
        vehicleReactionEvent.stimEvent = stimEvent;
        GameInstance.FindEntityByID(game, mountInfo.parentId).QueueEvent(vehicleReactionEvent);
      } else {
        this.m_previousFearPhase = this.ConvertFearStageToFearPhase(this.m_crowdFearStage);
        this.m_desiredFearPhase = this.GetFearReactionPhase(stimEvent);
        if VehicleComponent.IsMountedToVehicle(game, owner) && Equals(stimEvent.GetStimType(), gamedataStimType.HijackVehicle) {
          GameObject.PlayVoiceOver(owner, n"fear_beg", n"Scripts:HandleCrowdReaction");
        };
        this.DeactiveLookAt();
        stimAttackData = stimEvent.stimInvestigateData;
        if IsDefined(stimAttackData.attackInstigator) {
          stimEvent.sourceObject = stimAttackData.attackInstigator as GameObject;
          stimEvent.sourcePosition = stimEvent.sourceObject.GetWorldPosition();
        };
        this.ActivateReactionLookAt(stimEvent.sourceObject, false);
        delayedCrowdReaction = new DelayedCrowdReactionEvent();
        delayedCrowdReaction.stimEvent = stimEvent;
        if this.m_desiredFearPhase == -1 {
          return;
        };
        this.CreateFearArea(stimEvent, this.m_desiredFearPhase);
        if !stimAttackData.skipReactionDelay {
          this.m_delayReactionEventID = GameInstance.GetDelaySystem(game).DelayEvent(owner, delayedCrowdReaction, RandRangeF(this.m_delay.X, this.m_delay.Y));
        } else {
          owner.QueueEvent(delayedCrowdReaction);
        };
      };
    };
  };
}

@replaceMethod(ReactionManagerComponent)
private final func ShouldTriggerAggressiveCrowdNPCCombat(stimEvent: ref<StimuliEvent>) -> Bool {
  let distanceToPlayer: Float;
  let maxDistanceToTriggerCombat: Float;
  let preventionSystem: ref<PreventionSystem>;
  let playerPuppet: ref<PlayerPuppet> = stimEvent.sourceObject as PlayerPuppet;
  let targetNPCPuppet: ref<NPCPuppet> = this.GetOwner() as NPCPuppet;

  Log("ShouldTriggerAggressiveCrowdNPCCombat");  
  if IsDefined(targetNPCPuppet) {
    targetNPCPuppet.DebugHelper();
  }

  if !IsDefined(playerPuppet) {
    Log("playerPuppet not defined so not the stimEvent.sourceObject?");
    return false;
  };
  ////////////////////////////////////
  if this.CrowdMemberBrokeFreeFromGrapple() {
    Log("Just broke free from grapple! we should react aggressively");
    return true;
  }
  ////////////////////////////////////
  if playerPuppet.IsInCombat() {
    Log("Player is in combat");
    return false;
  };
  preventionSystem = GameInstance.GetScriptableSystemsContainer(this.GetOwner().GetGame()).Get(n"PreventionSystem") as PreventionSystem;
  if EnumInt(preventionSystem.GetHeatStage()) > 0 {
    Log("Heat Stage > 0");
    return false;
  };
  if stimEvent.IsTagInStimuli(n"NonAggressiveCrowd") {
    Log("NonAggressiveCrowd in stimuli tags");
    return false;
  };
  if !this.IsTargetInFront(playerPuppet, 120.00) {
    Log("player not in front");
    return false;
  };
  if !this.IsTargetInFront(playerPuppet, 15.00, true) {
    Log("Me not in front of player");
    return false;
  };
  if WeaponObject.IsRanged(GameObject.GetActiveWeapon(playerPuppet).GetItemID()) {
    distanceToPlayer = Vector4.DistanceSquared(this.GetOwner().GetWorldPosition(), playerPuppet.GetWorldPosition());
    maxDistanceToTriggerCombat = TweakDBInterface.GetFloat(t"AIGeneralSettings.distanceToTriggerAggressiveCrowdRanged", 15.00);
    if distanceToPlayer >= maxDistanceToTriggerCombat * maxDistanceToTriggerCombat {
      Log("player brandishing weapon but not within specified trigger ranged combat distance");
      return false;
    };
  } else {
    distanceToPlayer = Vector4.DistanceSquared(this.GetOwner().GetWorldPosition(), playerPuppet.GetWorldPosition());
    maxDistanceToTriggerCombat = TweakDBInterface.GetFloat(t"AIGeneralSettings.distanceToTriggerAggressiveCrowdMelee", 5.00);
    if distanceToPlayer >= maxDistanceToTriggerCombat * maxDistanceToTriggerCombat {
      Log("player not brandishing weapon and now within specified trigger melee distance");
      return false;
    };
  };
  Log("Yes we should trigger aggressive npc!");
  return true;
}

@replaceMethod(ReactionManagerComponent)
private final func GetFearReactionPhase(stimEvent: ref<StimuliEvent>) -> Int32 {
  let stimData: stimInvestigateData;
  let tags: array<CName> = stimEvent.stimRecord.Tags();
  
  if Equals(stimEvent.GetStimType(), gamedataStimType.IllegalInteraction) && (stimData.victimEntity  == GameInstance.FindEntityByID(this.GetOwner().GetGame(), this.GetOwner().GetEntityID())) {
    Log("GetFearReationPhase from grappled entity stimdata");
    stimData = stimEvent.stimInvestigateData;
    return stimData.fearPhase;
  };
  if Equals(stimEvent.GetStimType(), gamedataStimType.IllegalAction) {
    stimData = stimEvent.stimInvestigateData;
    if stimData.fearPhase != 0 {
      return 0;
    };
  };
  if ArrayContains(tags, n"Uncomfortable") {
    if this.m_isInCrosswalk {
      return 1;
    };
    return 0;
  };
  if ArrayContains(tags, n"PotentialFear") {
    return 1;
  };
  if ArrayContains(tags, n"DirectThreat") {
    if this.IsTargetClose(stimEvent.sourceObject, 10.00) {
      return 2;
    };
    return 1;
  };
  if ArrayContains(tags, n"PanicFear") {
    return 3;
  };
  if Equals(stimEvent.GetStimType(), gamedataStimType.SpreadFear) {
    stimData = stimEvent.stimInvestigateData;
    if stimData.fearPhase == 0 {
      return 1;
    };
    return stimData.fearPhase;
  };
  if Equals(stimEvent.GetStimType(), gamedataStimType.Driving) {
    return 3;
  };
  return -1;
}

@addMethod(ReactionManagerComponent)
private final func CrowdMemberBrokeFreeFromGrapple() -> Bool {
  let ownerNPCPuppet = this.GetOwner() as NPCPuppet;
  if IsDefined(ownerNPCPuppet) {
    Log("ownerPuppet was just grappled " + ownerNPCPuppet.WasCrowdMemberJustGrappledByPlayer());
    return ownerNPCPuppet.WasCrowdMemberJustGrappledByPlayer();
  };
}