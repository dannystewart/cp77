// VARIOUS (LEFT)
// phone notification

@wrapMethod(PhoneMessageNotificationsGameController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  if this.m_player.m_customHotkeyPlayerButtonData.IsNormalDpadLeftProhibited() {
    return false;
  }
  return wrappedMethod(action, consumer);
}

// generic notification

@wrapMethod(GenericNotificationController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  if this.m_player as PlayerPuppet.m_customHotkeyPlayerButtonData.IsNormalDpadLeftProhibited() {
    return false;
  }
  return wrappedMethod(action, consumer);
}

// CAR HOTKEY (RIGHT)

// stops car from being called with tap
@wrapMethod(PlayerPuppet)
private final func ProcessCallVehicleAction(type: gameinputActionType) -> Void {
  if this.m_customHotkeyPlayerButtonData.IsNormalDpadRightProhibited() {
    return;
  }
  wrappedMethod(type);
}

// stop car menu
@wrapMethod(VehicleWheelDecisions)
protected final const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if DefaultTransition.GetPlayerPuppet(scriptInterface).m_customHotkeyPlayerButtonData.IsNormalDpadRightProhibited() {
    return false;
  }
  return wrappedMethod(stateContext, scriptInterface);
}

// stops all animations on the car icon while hold button held
@wrapMethod(QuickSlotsReadyEvents)
protected final func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if DefaultTransition.GetPlayerPuppet(scriptInterface).m_customHotkeyPlayerButtonData.IsNormalDpadRightProhibited() {
    return;
  }
  wrappedMethod(timeDelta, stateContext, scriptInterface);
}

// INHALER HOTKEY (UP)
// the animation on the button is disabled in hotkey_item_controller.reds

// stops animation and actual consumption of the consumable
@wrapMethod(DefaultTransition)
protected final const func SendEquipmentSystemWeaponManipulationRequest(const scriptInterface: ref<StateGameScriptInterface>, requestType: EquipmentManipulationAction, opt equipAnimType: gameEquipAnimationType) -> Void {
  if Equals(requestType, EquipmentManipulationAction.RequestConsumable) && DefaultTransition.GetPlayerPuppet(scriptInterface).m_customHotkeyPlayerButtonData.IsNormalDpadUpProhibited() {
    return;
  }
  wrappedMethod(scriptInterface, requestType, equipAnimType);
}

// PHONE HOTKEY (DOWN)
@wrapMethod(HudPhoneGameController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  if this.m_Owner as PlayerPuppet.m_customHotkeyPlayerButtonData.IsNormalDpadDownProhibited() {
    return false;
  }
  return wrappedMethod(action, consumer);
}


// DISABLING  ORIGINAL HOTKEYS (making them red)

public class HotKeyHoldButtonHeldEvent extends Event {
  public let isNormalDpadLeftProhibited: Bool;
  public let isNormalDpadRightProhibited: Bool;
  public let isNormalDpadUpProhibited: Bool;
  public let isNormalDpadDownProhibited: Bool;
}

@addMethod(PhoneHotkeyController)
protected cb func OnHotkeyModifierButtonHeldEvent(evt: ref<HotKeyHoldButtonHeldEvent>) -> Bool {
  this.m_originalHotkeyOverride = evt.isNormalDpadDownProhibited;
  this.ResolveState();
}

@addMethod(CarHotkeyController)
protected cb func OnHotkeyModifierButtonHeldEvent(evt: ref<HotKeyHoldButtonHeldEvent>) -> Bool {
  this.m_originalHotkeyOverride = evt.isNormalDpadRightProhibited;
  this.ResolveState();
}

@addMethod(HotkeyItemController)
protected cb func OnHotkeyModifierButtonHeldEvent(evt: ref<HotKeyHoldButtonHeldEvent>) -> Bool {
  if !this.IsCustomHotkey() && !Equals(this.m_hotkey, EHotkey.RB) {
    this.m_originalHotkeyOverride = evt.isNormalDpadUpProhibited;
    this.ResolveState();
  }
}

@addField(GenericHotkeyController)
private let m_originalHotkeyOverride: Bool;

@wrapMethod(PhoneHotkeyController)
protected func IsAllowedByGameplay() -> Bool {
  if this.m_originalHotkeyOverride {
    return false;
  }
  return wrappedMethod();
}

@wrapMethod(CarHotkeyController)
protected func IsAllowedByGameplay() -> Bool {
  if this.m_originalHotkeyOverride {
    return false;
  }
  return wrappedMethod();
}

@wrapMethod(HotkeyItemController)
protected func IsAllowedByGameplay() -> Bool {
  if this.m_originalHotkeyOverride {
    return false;
  }
  return wrappedMethod();
}
