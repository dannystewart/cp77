@replaceMethod(DamageSystem)
  private final func ProcessFinisher(hitEvent: ref<gameHitEvent>) -> Void {
    let broadcaster: ref<StimBroadcasterComponent>;
    let choiceData: DialogChoiceHubs;
    let gameInstance: GameInstance;
    let interactionData: ref<UIInteractionsDef>;
    let interactonsBlackboard: ref<IBlackboard>;
    let tags: array<CName>;
    let targetPuppet: wref<ScriptedPuppet>;
    let weapon: ref<WeaponObject>;
    let weaponRecord: ref<Item_Record>;
    let attackData: ref<AttackData> = hitEvent.attackData;
    let vecToTarget: Vector4 = hitEvent.target.GetWorldPosition() - attackData.GetInstigator().GetWorldPosition();
    if AbsF(vecToTarget.Z) > 0.30 {
      return;
    };
    weapon = attackData.GetWeapon();
    gameInstance = GetGameInstance();
    if hitEvent.projectionPipeline {
      return;
    };
    if !IsDefined(weapon) {
      return;
    };
    weaponRecord = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(weapon.GetItemID()));
    if attackData.HasFlag(hitFlag.DoNotTriggerFinisher) || attackData.HasFlag(hitFlag.Nonlethal) {
      return;
    };
    if !attackData.GetInstigator().IsPlayer() {
      return;
    };
    if StatusEffectSystem.ObjectHasStatusEffect(attackData.GetInstigator(), t"GameplayRestriction.FistFight") {
      return;
    };
    if Equals(attackData.GetInstigator().GetAttitudeTowards(hitEvent.target), EAIAttitude.AIA_Friendly) {
      return;
    };
    tags = weaponRecord.Tags();
    if !ArrayContains(tags, n"FinisherFront") && !ArrayContains(tags, n"FinisherBack") {
      return;
    };
    targetPuppet = hitEvent.target as ScriptedPuppet;
    if !IsDefined(targetPuppet) {
      return;
    };
	/*
    if targetPuppet.IsCrowd() || targetPuppet.IsCharacterCivilian() {
      return;
    };
	*/
    if !ScriptedPuppet.IsActive(targetPuppet) {
      return;
    };
    if StatusEffectSystem.ObjectHasStatusEffect(targetPuppet, t"GameplayRestriction.FistFight") {
      return;
    };
    if GameInstance.GetGodModeSystem(gameInstance).HasGodMode(targetPuppet.GetEntityID(), gameGodModeType.Immortal) {
      return;
    };
    if GameInstance.GetGodModeSystem(gameInstance).HasGodMode(targetPuppet.GetEntityID(), gameGodModeType.Invulnerable) {
      return;
    };
    if targetPuppet.IsMassive() {
      return;
    };
    if Equals(targetPuppet.GetPuppetRarity().Type(), gamedataNPCRarity.Boss) && !targetPuppet.IsCharacterCyberpsycho() {
      return;
    };
    if NotEquals(targetPuppet.GetNPCType(), gamedataNPCType.Human) {
      return;
    };
    if attackData.WasBlocked() || attackData.WasDeflected() {
      return;
    };
    if !AttackData.IsStrongMelee(attackData.GetAttackType()) {
      return;
    };
    interactonsBlackboard = GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UIInteractions);
    interactionData = GetAllBlackboardDefs().UIInteractions;
    choiceData = FromVariant<DialogChoiceHubs>(interactonsBlackboard.GetVariant(interactionData.DialogChoiceHubs));
    if ArraySize(choiceData.choiceHubs) > 0 {
      return;
    };
    if (StatPoolsManager.SimulateDamageDeal(hitEvent) || this.CanTriggerMeleeLeapFinisher(attackData, hitEvent)) && this.PlayFinisherGameEffect(hitEvent, ArrayContains(tags, n"FinisherFront"), ArrayContains(tags, n"FinisherBack")) {
      attackData.AddFlag(hitFlag.DealNoDamage, n"Finisher");
      attackData.AddFlag(hitFlag.FinisherTriggered, n"Finisher");
      broadcaster = targetPuppet.GetStimBroadcasterComponent();
      if IsDefined(broadcaster) {
        broadcaster.TriggerSingleBroadcast(targetPuppet, gamedataStimType.Scream, 10.00);
      };
    };
  }