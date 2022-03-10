module GrappleCivs.Mod

@addField(NPCPuppet)
private let m_wasJustGrappledByPlayer: Bool;

@addMethod(NPCPuppet)
private func SetWasJustGrappledByPlayer(value: Bool) -> Void {
  this.m_wasJustGrappledByPlayer = value;
}

@addMethod(NPCPuppet)
private func WasCrowdMemberJustGrappledByPlayer() -> Bool {
  if this.IsCrowd() {
    return this.m_wasJustGrappledByPlayer;
  } else {
    return false;
  }
}

@addMethod(NPCPuppet)
private static final func GetCustomObjectActions() -> array<wref<ObjectAction_Record>> {
  let customActionRecords: array<wref<ObjectAction_Record>>; 
  let grappleRecord: wref<ObjectAction_Record> = TweakDBInterface.GetObjectActionRecord(t"Takedown.Grapple");
  let grappleRecordLethal: wref<ObjectAction_Record> = TweakDBInterface.GetObjectActionRecord(t"Takedown.LethalTakedown");
  let grappleRecordNonLethal: wref<ObjectAction_Record> = TweakDBInterface.GetObjectActionRecord(t"Takedown.NonLethalTakedown");
  let pickUpBody: wref<ObjectAction_Record> = TweakDBInterface.GetObjectActionRecord(t"GenericInteraction.PickUpBody"); 

  if (IsDefined(grappleRecord)) {            
    ArrayPush(customActionRecords, grappleRecord);
  };
  if (IsDefined(grappleRecordLethal)) {      
    ArrayPush(customActionRecords, grappleRecordLethal);    
  };
  if (IsDefined(grappleRecordNonLethal)) {      
    ArrayPush(customActionRecords, grappleRecordNonLethal);      
  };
  if (IsDefined(pickUpBody)) {      
    ArrayPush(customActionRecords, pickUpBody);
  };

  return customActionRecords;
}

@replaceMethod(ScriptedPuppet)
private final func ToggleInteractionLayers() -> Void {  
  let canGrappleCivilian: Bool = TweakDBInterface.GetBool(t"player.grapple.canGrappleCivilian", true);  
  if this.IsCrowd() {    
    if this.GetRecord().CanHaveGenericTalk() {        
      this.EnableInteraction(n"GenericTalk", true);
    };      
    this.EnableInteraction(n"Grapple", true);
    this.EnableInteraction(n"TakedownLayer", true);
    this.EnableInteraction(n"AerialTakedown", false);
  } else {
    if this.IsCharacterCivilian() {      
      this.EnableInteraction(n"Grapple", true);
      this.EnableInteraction(n"TakedownLayer", true);
      this.EnableInteraction(n"AerialTakedown", false);
    } else {
      if this.IsBoss() {
        if !this.IsCharacterCyberpsycho() {
          this.EnableInteraction(n"BossTakedownLayer", true);
          this.EnableInteraction(n"Grapple", false);
          this.EnableInteraction(n"TakedownLayer", false);
          this.EnableInteraction(n"AerialTakedown", false);
        };
      } else {
        if this.IsMassive() {
          this.EnableInteraction(n"MassiveTargetTakedownLayer", true);
          this.EnableInteraction(n"Grapple", false);
          this.EnableInteraction(n"TakedownLayer", false);
          this.EnableInteraction(n"AerialTakedown", false);
        } else {
          if this.GetRecord().ForceCanHaveGenericTalk() {
            this.EnableInteraction(n"GenericTalk", true);
          } else {
            if this.IsVendor() {
              this.EnableInteraction(n"Grapple", false);
              this.EnableInteraction(n"TakedownLayer", false);
              this.EnableInteraction(n"AerialTakedown", false);
            };
          };
        };
      };
    };
  };
}

@addMethod(ReactionManagerComponent)
private func StimTypeEnumToString(stimType:gamedataStimType) -> String {
    return NameToString(EnumValueToName(n"gamedataStimType", Cast<Int64>(EnumInt(stimType))));
}

@addMethod(ReactionManagerComponent)
private func AIReactionDataToString(gameDataOutput: gamedataOutput) -> String {
    return NameToString(EnumValueToName(n"gamedataOutput", Cast<Int64>(EnumInt(gameDataOutput))));
}

@addMethod(ReactionManagerComponent)
private func LogAIReactionData(memberName: String, aiReactionData: ref<AIReactionData>) -> Void {
  if(IsDefined(aiReactionData)) {
    let name = this.AIReactionDataToString(aiReactionData.reactionBehaviorName);
    Log(memberName + ":" + name);
  }
}

@addMethod(ReactionManagerComponent)
private func LogOnlyGrappledEntity(data: String) {
  let owner = this.GetOwner();
  if(ScriptedPuppet.IsBeingGrappled(owner)) {
    Log(data);
  };
}

@addMethod(NPCPuppet)
private func DebugHelper() -> Void {
  if(this.IsCrowd() || this.IsCharacterCivilian()) {          
    let highLevelState = this.GetHighLevelStateFromBlackboard();
    let currentState = NameToString(EnumValueToName(n"gamedataNPCHighLevelState", Cast<Int64>(EnumInt(highLevelState))));
    let reactionComponent = this.GetStimReactionComponent();
    Log("EntityID:" + EntityID.ToDebugString(this.GetEntityID()));
    Log("ReactionManagerComponentData:");
    Log("HighLevelState:" + currentState);
    reactionComponent.LogAIReactionData("m_activeReaction", reactionComponent.m_activeReaction);
    reactionComponent.LogAIReactionData("m_desiredReaction", reactionComponent.m_desiredReaction);
    reactionComponent.LogAIReactionData("m_pendingReaction", reactionComponent.m_pendingReaction);
    Log("Desired FearPhase: " + reactionComponent.m_desiredFearPhase);
    Log("IsInPendingBehavior: " + reactionComponent.IsInPendingBehavior());
    Log("m_wasJustGrappledByPlayer: " + this.WasCrowdMemberJustGrappledByPlayer());
    Log("BodyType: " + NameToString(this.GetBodyType()));
  }
}