module GrappleCivs.Mod 

@replaceMethod(ScriptedPuppetPS)
public final func DetermineInteractionState(interaction: ref<InteractionComponent>, context: GetActionsContext, objectActionsCallbackController: wref<gameObjectActionsCallbackController>) -> Void {
  let actionRecords: array<wref<ObjectAction_Record>>;
  let customActionRecords: array<wref<ObjectAction_Record>>;
  let choices: array<InteractionChoice>;
  if !this.GetHudManager().IsQuickHackPanelOpened() {
    this.SetHasDirectInteractionChoicesActive(false);
    if !IsDefined(this.m_cooldownStorage) {
      this.m_cooldownStorage = new CooldownStorage();
      this.m_cooldownStorage.Initialize(this.GetID(), this.GetClassName(), this.GetGameInstance());
    };
    if !IsNameValid(context.interactionLayerTag) {
      context.interactionLayerTag = this.m_lastInteractionLayerTag;
    };
    if Equals(context.requestType, gamedeviceRequestType.Direct) {
      this.GetOwnerEntity().GetRecord().ObjectActions(actionRecords);
      let targetNPCPuppet = this.GetOwnerEntity() as NPCPuppet;
      if(IsDefined(targetNPCPuppet)) {
        if(targetNPCPuppet.IsCrowd() && !targetNPCPuppet.IsVendor() && NotEquals(targetNPCPuppet.GetBodyType(), n"ManFat")) {
          customActionRecords = NPCPuppet.GetCustomObjectActions();
          let i = 0;
          while i < ArraySize(customActionRecords) {
            ArrayPush(actionRecords, customActionRecords[i]);
            i += 1;
          };
        };
      };
      this.GetValidChoices(actionRecords, context, objectActionsCallbackController, true, choices);
      if ArraySize(choices) > 0 {
        this.SetHasDirectInteractionChoicesActive(true);
      };
    };
  };
  this.PushChoicesToInteractionComponent(interaction, context, choices);
}