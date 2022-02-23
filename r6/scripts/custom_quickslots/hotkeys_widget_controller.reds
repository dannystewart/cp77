import CustomQuickslotsConfig.*
import CustomQuickslotsResolutionListener.*

@addField(HotkeysWidgetController)
let m_customHotkeyFood: wref<inkWidget>;

@addField(HotkeysWidgetController)
let m_customHotkeyDrink: wref<inkWidget>;

@addField(HotkeysWidgetController)
let m_customHotkeyHealthBooster: wref<inkWidget>;

@addField(HotkeysWidgetController)
let m_customHotkeyStaminaBooster: wref<inkWidget>;

@addField(HotkeysWidgetController)
let m_customHotkeyRAMJolt: wref<inkWidget>;

@addField(HotkeysWidgetController)
let m_customHotkeyCapacityBooster: wref<inkWidget>;

@addField(HotkeysWidgetController)
let m_aspectRatioListener: ref<inkVirtualResolutionListener>;

@addField(HotkeysWidgetController)
let m_numVisibleCustomHotkeys: Int32;

// Lua module overrides these functions
@addMethod(HotkeysWidgetController)
private func GetCustomQuickslots() -> array<ref<CustomQuickslot>> {}

@addMethod(HotkeysWidgetController)
private func DefaultSlotOpacity() -> Float {}

@addMethod(HotkeysWidgetController)
private func SlotOpacityWhileSubtitlesOnScreen() -> Float {}

@addMethod(HotkeysWidgetController)
private func SlotFadeInDelay() -> Float {}

@addMethod(HotkeysWidgetController)
private func SlotFadeInDuration() -> Float {}

@addMethod(HotkeysWidgetController)
private func IsE3HudCompatibilityMode() -> Bool {}

@addMethod(HotkeysWidgetController)
public func CustomQuickslotsRefreshSlots() -> Void {
  inkCompoundRef.RemoveAllChildren(this.m_hotkeysList);

  this.m_consumables = this.SpawnFromLocal(inkWidgetRef.Get(this.m_hotkeysList), n"DPAD_UP");
  this.m_gadgets = this.SpawnFromLocal(inkWidgetRef.Get(this.m_hotkeysList), n"RB");

  this.AddCustomQuickslots();

  if this.IsE3HudCompatibilityMode() {
    this.UpdateLengthAndScale();
  }
}

@addMethod(HotkeysWidgetController)
private func AddCustomQuickslots() -> Void {
  let quickslots: array<ref<CustomQuickslot>> = this.GetCustomQuickslots();
  let modifiersForDpadLeft: array<CName>;
  let modifiersForDpadRight: array<CName>;
  let modifiersForDpadUp: array<CName>;
  let modifiersForDpadDown: array<CName>;

  let i: Int32 = 0;
  while i < ArraySize(quickslots) {
    let quickslot: ref<CustomQuickslot> = quickslots[i];
    let slotName: String = "customHotkey_" + i;
    let customHotkey: wref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_hotkeysList), n"DPAD_UP");
    customHotkey.SetName(StringToName(slotName));

    if Equals(quickslot.gamepadInput, n"dpad_left") {
      if !ArrayContains(modifiersForDpadLeft, quickslot.gamepadHoldModifier) {
        ArrayPush(modifiersForDpadLeft, quickslot.gamepadHoldModifier);
      }
    }
    if Equals(quickslot.gamepadInput, n"dpad_right") {
      if !ArrayContains(modifiersForDpadRight, quickslot.gamepadHoldModifier) {
        ArrayPush(modifiersForDpadRight, quickslot.gamepadHoldModifier);
      }
    }
    if Equals(quickslot.gamepadInput, n"dpad_up") {
      if !ArrayContains(modifiersForDpadUp, quickslot.gamepadHoldModifier) {
        ArrayPush(modifiersForDpadUp, quickslot.gamepadHoldModifier);
      }
    }
    if Equals(quickslot.gamepadInput, n"dpad_down") {
      if !ArrayContains(modifiersForDpadDown, quickslot.gamepadHoldModifier) {
        ArrayPush(modifiersForDpadDown, quickslot.gamepadHoldModifier);
      }
    }

    i += 1;
  }

  this.m_CustomHotkeyHideAnim = new inkAnimDef();
  let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
  alphaInterpolator.SetStartTransparency(this.SlotOpacityWhileSubtitlesOnScreen());
  alphaInterpolator.SetEndTransparency(this.DefaultSlotOpacity());
  alphaInterpolator.SetDuration(this.SlotFadeInDuration());
  alphaInterpolator.SetType(inkanimInterpolationType.Linear);
  alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
  alphaInterpolator.SetStartDelay(this.SlotFadeInDelay());
  this.m_CustomHotkeyHideAnim.AddInterpolator(alphaInterpolator);

  this.m_player.GetCustomHotkeyPlayerButtonData().SetModifiers(modifiersForDpadLeft, modifiersForDpadRight, modifiersForDpadUp, modifiersForDpadDown);
  inkWidgetRef.Get(this.m_hotkeysList).SetOpacity(this.DefaultSlotOpacity());
}

@wrapMethod(HotkeysWidgetController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  if this.IsE3HudCompatibilityMode() {
    let quickslots: array<ref<CustomQuickslot>> = this.GetCustomQuickslots();
    this.m_numVisibleCustomHotkeys = ArraySize(quickslots);
    this.AdjustWidget(ArraySize(quickslots));
  }

  this.m_aspectRatioListener = new inkVirtualResolutionListener();
  this.m_aspectRatioListener.Initialize(this.m_player.GetGame());
  
  if this.IsE3HudCompatibilityMode() {
    this.m_aspectRatioListener.ResizeWidget(this.m_root);
    this.m_aspectRatioListener.ScaleWidget(this.m_root.GetWidget(n"mainCanvas"));
  }
  else {
    this.m_aspectRatioListener.ScaleWidget(this.m_root);
  }  

  let evt: ref<SetupHotkeyHudEvent> = new SetupHotkeyHudEvent();
  evt.widget = this.m_root;
  evt.isE3HudCompatibilityMode = this.IsE3HudCompatibilityMode();
  GameInstance.GetUISystem(this.m_player.GetGame()).QueueEvent(evt);

  this.AddCustomQuickslots();
}

@addField(HotkeysWidgetController)
private let m_CustomHotkeyHideAnim: ref<inkAnimDef>;

@addField(HotkeysWidgetController)
private let m_CustomHotkeyHideAnimProxy: ref<inkAnimProxy>;

@addField(HotkeysWidgetController)
private let m_CustomHotkeyUtilsHideAnimProxy: ref<inkAnimProxy>;

@addMethod(HotkeysWidgetController)
protected cb func OnSubtitleVisibilityEvent(evt: ref<CustomQuickslotsInDialog>) -> Bool {
  if evt.subtitlesVisible {
    if IsDefined(this.m_CustomHotkeyHideAnimProxy) {
      if this.m_CustomHotkeyHideAnimProxy.IsPlaying() {
        this.m_CustomHotkeyHideAnimProxy.Stop();
        this.m_CustomHotkeyHideAnimProxy = null;
      }
    }
    if this.IsE3HudCompatibilityMode() {
      inkWidgetRef.Get(this.m_utilsList).SetOpacity(this.SlotOpacityWhileSubtitlesOnScreen());
    }
    inkWidgetRef.Get(this.m_hotkeysList).SetOpacity(this.SlotOpacityWhileSubtitlesOnScreen());
  }
  else {
    if inkWidgetRef.GetOpacity(this.m_hotkeysList) < this.DefaultSlotOpacity() {
      if !(IsDefined(this.m_CustomHotkeyHideAnimProxy) && this.m_CustomHotkeyHideAnimProxy.IsPlaying()) {
        this.m_CustomHotkeyHideAnimProxy = inkWidgetRef.PlayAnimation(this.m_hotkeysList, this.m_CustomHotkeyHideAnim);
      }
      if this.IsE3HudCompatibilityMode() && !(IsDefined(this.m_CustomHotkeyUtilsHideAnimProxy) && this.m_CustomHotkeyUtilsHideAnimProxy.IsPlaying()) {
        this.m_CustomHotkeyUtilsHideAnimProxy = inkWidgetRef.PlayAnimation(this.m_hotkeysList, this.m_CustomHotkeyHideAnim);
      }
    } 
  }
}

public class SetupHotkeyHudEvent extends Event {
  public let widget: wref<inkWidget>;
  public let isE3HudCompatibilityMode:Bool;
}

@addMethod(inkGameController)
protected cb func OnSetupHotkeyHud(evt: ref<SetupHotkeyHudEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    if evt.isE3HudCompatibilityMode {
      let bottomRightHorizontal: ref<inkCompoundWidget> = this.GetRootCompoundWidget().GetWidget(n"BottomRightMain/BottomRight/BottomRightHorizontal") as inkCompoundWidget;

      // Destroy the hotkeys projector that linked to the hotkeys widget
      let hotkeysProjector: ref<inkImage> = bottomRightHorizontal.GetWidget(n"dpad_hint") as inkImage;
      bottomRightHorizontal.RemoveChild(hotkeysProjector);

      // Move hotkeys widget from projector to the container directly
      let hotkeysWidget: ref<inkCanvas> = evt.widget as inkCanvas;
      hotkeysWidget.SetName(n"dpad_hint");
      hotkeysWidget.Reparent(bottomRightHorizontal);

      let listBottom: ref<inkHorizontalPanel> = hotkeysWidget.GetWidget(n"mainCanvas/list_bottom") as inkHorizontalPanel;
      listBottom.SetMargin(new inkMargin(0.0, 0.0, 72.0, 24.0));
    }
    else {
      let bottomLeft: ref<inkCompoundWidget> = this.GetRootCompoundWidget().GetWidget(n"BottomLeft") as inkCompoundWidget;

      // Destroy the hotkeys projector that linked to the hotkeys widget
      let hotkeysProjector: ref<inkImage> = bottomLeft.GetWidget(n"dpad_hint") as inkImage;
      bottomLeft.RemoveChild(hotkeysProjector);

      // Move hotkeys widget from projector to the container directly
      let hotkeysWidget: ref<inkWidget> = evt.widget;
      hotkeysWidget.SetName(n"dpad_hint");
      hotkeysWidget.SetAnchor(inkEAnchor.BottomLeft);
      hotkeysWidget.SetAnchorPoint(new Vector2(0.0, 1.0));
      hotkeysWidget.SetSize(new Vector2(1400.0, 300.0));
      hotkeysWidget.SetMargin(new inkMargin(0.0, 0.0, 0.0, 25.0));
      hotkeysWidget.SetRenderTransformPivot(new Vector2(0.0, 1.0));
      hotkeysWidget.Reparent(bottomLeft);
    }
  };
}

public class DestroyHotkeyHudEvent extends Event {
  public let widget: wref<inkWidget>;
  public let isE3HudCompatibilityMode:Bool;
}

@addMethod(inkGameController)
protected cb func OnDestroyHotkeyHud(evt: ref<DestroyHotkeyHudEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    let container: ref<inkCompoundWidget>;
    if evt.isE3HudCompatibilityMode {
      container = this.GetRootCompoundWidget().GetWidget(n"BottomRightMain/BottomRight/BottomRightHorizontal") as inkCompoundWidget;
    } 
    else {
      container = this.GetRootCompoundWidget().GetWidget(n"BottomLeft") as inkCompoundWidget;
    }

    // Destroy the hotkeys widget
    let hotkeys: ref<inkWidget> = container.GetWidget(n"dpad_hint");
    container.RemoveChild(hotkeys);
  };
}

// alternatively can probably use hudCameraController.
@wrapMethod(TakeOverControlSystem)
private func HideAdvanceInteractionInputHints() -> Void {  
  if(this.GetControlledObject().IsSensor()) {
    let evt: ref<DestroyHotkeyHudEvent> = new DestroyHotkeyHudEvent();
    GameInstance.GetUISystem(this.GetControlledObject().GetGame()).QueueEvent(evt);
  }

  wrappedMethod();
}

public class HotkeyVisibilityUpdateEvent extends Event {}

@addMethod(HotkeysWidgetController)
protected cb func OnHotkeyVisibilityUpdate(evt: ref<HotkeyVisibilityUpdateEvent>) -> Bool {
  this.UpdateLengthAndScale();
}

@addMethod(HotkeysWidgetController)
private func UpdateLengthAndScale() -> Void {
  let numVisibleQuickslots: Int32 = 0;

  let quickslots: array<ref<CustomQuickslot>> = this.GetCustomQuickslots();
  let i: Int32 = 0;
  while i < ArraySize(quickslots) {
    let slotName: String = "customHotkey_" + i;
    let slot: ref<inkWidget> = inkCompoundRef.GetWidget(this.m_hotkeysList, StringToName(slotName));
    if slot.IsVisible() {
      numVisibleQuickslots += 1;
    }
    i += 1;
  }
  
  let mainCanvas: ref<inkCanvas> = this.m_root.GetWidget(n"mainCanvas") as inkCanvas;
  let tempNumHotkeysFloat: Float = Cast(this.m_numVisibleCustomHotkeys);
  let previousUnscaledLength: Float = 590.0 + 126.0 * tempNumHotkeysFloat;
  let currentSize: Vector2 = mainCanvas.GetSize();
  let scale: Float = currentSize.X / previousUnscaledLength;
  tempNumHotkeysFloat = Cast(numVisibleQuickslots);
  let newLength: Float = (590.0 + 126.0 * tempNumHotkeysFloat) * scale;

  mainCanvas.SetSize(new Vector2(newLength, currentSize.Y));

  this.m_numVisibleCustomHotkeys = numVisibleQuickslots;
}

@addMethod(HotkeysWidgetController)
protected cb func AdjustWidget(numSlots: Int32) -> Bool {
  let slotsFloat: Float = Cast(numSlots);
  let length: Float = 590.0 + 126.0 * slotsFloat;

  this.m_root.SetSize(new Vector2(length, 300.0));
  this.m_root.SetAnchor(inkEAnchor.TopRight);
  this.m_root.SetAnchorPoint(new Vector2(1.0, 0.0));
  this.m_root.SetMargin(new inkMargin(0.0, -25.0, 0.0, 0.0));

  let mainCanvas: ref<inkCanvas> = this.m_root.GetWidget(n"mainCanvas") as inkCanvas;
  mainCanvas.SetSize(new Vector2(length, 300.0));
  mainCanvas.SetAnchor(inkEAnchor.TopRight);
  mainCanvas.SetAnchorPoint(new Vector2(1.0, 0.0));
  mainCanvas.SetHAlign(inkEHorizontalAlign.Right);
  mainCanvas.SetVAlign(inkEVerticalAlign.Top);
  mainCanvas.SetMargin(new inkMargin(0.0, -25.0, 0.0, 0.0));
  mainCanvas.SetRenderTransformPivot(new Vector2(1.0, 0.0));

  let listLeft: ref<inkHorizontalPanel> = mainCanvas.GetWidget(n"list_left") as inkHorizontalPanel;
  listLeft.SetAnchor(inkEAnchor.LeftFillVerticaly);
  listLeft.SetAnchorPoint(new Vector2(0.0, 1.0));
  listLeft.SetVAlign(inkEVerticalAlign.Bottom);
  listLeft.SetPadding(new inkMargin(0.0, 24.0, 0.0, 0.0));
  listLeft.SetMargin(new inkMargin(0.0, 0.0, 0.0, 24.0));

  let listBottom: ref<inkHorizontalPanel> = mainCanvas.GetWidget(n"list_bottom") as inkHorizontalPanel;
  listBottom.SetAnchor(inkEAnchor.RightFillVerticaly);
  listBottom.SetAnchorPoint(new Vector2(1.0, 1.0));
  listBottom.SetVAlign(inkEVerticalAlign.Bottom);
  listBottom.SetPadding(new inkMargin(0.0, 0.0, 0.0, 0.0));
  listBottom.SetMargin(new inkMargin(0.0, 0.0, 72.0, 24.0));

  let dots1: ref<inkImage> = mainCanvas.GetWidget(n"dots") as inkImage;
  dots1.SetAnchor(inkEAnchor.TopRight);
  dots1.SetAnchorPoint(new Vector2(1.0, 0.0));
  dots1.SetMargin(new inkMargin(0.0, 53.333405, 0.0, 0.0));

  let dots2: ref<inkImage> = mainCanvas.GetWidget(n"dot2") as inkImage;
  dots2.SetAnchor(inkEAnchor.TopRight);
  dots2.SetAnchorPoint(new Vector2(1.0, 0.0));
  dots2.SetMargin(new inkMargin(0.0, 92.444550, 0.0, 0.0));
}