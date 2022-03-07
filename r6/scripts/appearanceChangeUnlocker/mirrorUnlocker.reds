import AppearanceUnlocker.Codeware.UI.*

/*
Appearance Change Unlocker v2.0
  _____ _   _  ____ _  __  ____  _   _ _____ ___ _   _ 
 |  ___| | | |/ ___| |/ / |  _ \| | | |_   _|_ _| \ | |
 | |_  | | | | |   | ' /  | |_) | | | | | |  | ||  \| |
 |  _| | |_| | |___| . \  |  __/| |_| | | |  | || |\  |
 |_|    \___/ \____|_|\_\ |_|    \___/  |_| |___|_| \_|
                                                       
edition by PotatoOfDoom
*/

@replaceMethod(MenuScenario_CharacterCustomizationMirror)
  protected cb func OnCCOPuppetReady() -> Bool {
    let morphMenuUserData: ref<MorphMenuUserData> = new MorphMenuUserData();
    morphMenuUserData.m_optionsListInitialized = false;
    morphMenuUserData.m_updatingFinalizedState = true;
    morphMenuUserData.m_editMode = gameuiCharacterCustomizationEditTag.NewGame;
    this.m_currMenuName = n"character_customization";
    let menuState: wref<inkMenusState> = this.GetMenusState();
    menuState.OpenMenu(n"player_puppet");
    menuState.OpenMenu(n"character_customization", morphMenuUserData);
  }

@replaceMethod(characterCreationBodyMorphMenu)
  public final func CreateVoiceOverSwitcher() -> Void {
    if this.m_updatingFinalizedState {
      return;
    }
    let switcherWidget: wref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_optionsList), n"VoiceOverSwitcher");
    let switcherController: wref<characterCreationVoiceOverSwitcher> = switcherWidget.GetController() as characterCreationVoiceOverSwitcher;
    switcherController.RegisterToCallback(n"OnVoiceOverSwitched", this, n"OnVoiceOverSwitched");
    switcherWidget.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOverOption");
    switcherController.SetIsBrainGenderMale(this.m_characterCustomizationState.IsBrainGenderMale());
  }

@addField(inkScrollArea)
  public native let constrainContentPosition: Bool;

public class ChangeAppearanceEvent extends Event {}

public class CharacterPresetManager {
  private let morphMenu: ref<characterCreationBodyMorphMenu>;
  
  private let myVerticalPanel: ref<inkVerticalPanel>;

  private let selectCharacterPresetLabel: ref<inkText>;

  private let randomizeAppearanceBtn: ref<SimpleButton>;

  //ScrollArea shit
  private let presetScrollAreaWrapper: ref<inkHorizontalPanel>;
  private let presetScrollArea: ref<inkScrollArea>;

  private let presetScrollAreaVerticalPanel: ref<inkVerticalPanel>;
  private let presetScrollAreaButtons: array<ref<SimpleButton>>;
  
  //ScrollArea Slider shit
  private let isDragged: Bool;
  private let dragStartPos: Vector2;
  private let dragStartMargin: inkMargin;
  private let presetScrollSliderArea: ref<inkCanvas>;
  private let presetScrollSliderHandle: ref<inkRectangle>;
  private let presetSliderHandleWidth: Float;

  private let savePresetBtn: ref<SimpleButton>;
  private let saveNameLabel: ref<inkText>;
  private let saveNameTextInput: ref<TextInput>;

  //Brutal HAX way to bypass cps retarded way of applying customization options
  private let isAppearanceChangePending: Bool;
  private let customizationSystem: ref<gameuiICharacterCustomizationSystem>;
  private let optionsArray: array<ref<CharacterCustomizationOption>>;
  private let presetChangeIndex: Int32;
  private let presetChangeList: array<String>;

  public func IsAppearanceChangePending() -> Bool {
    return this.isAppearanceChangePending;
  }

  public func CETActive() -> Bool {
    return false;
  }

  private func ListPresets() -> array<String> {}
  private func SavePreset(name: String, content: array<String>) -> Void {}
  private func LoadPreset(name: String) -> array<String> {}

  public func OnInitialize(parent: ref<characterCreationBodyMorphMenu>) -> Bool {
    this.isAppearanceChangePending = false;
    this.presetChangeIndex = 0;

    //GUI CODE
    this.presetSliderHandleWidth = 16.0;
    
    //[INSERT VOMIT EMOJI HERE]

    this.morphMenu = parent;

    this.myVerticalPanel = this.morphMenu.GetChildWidgetByPath(n"presets") as inkVerticalPanel;
    this.myVerticalPanel.RemoveAllChildren();

    this.randomizeAppearanceBtn = SimpleButton.Create();
    this.randomizeAppearanceBtn.SetText("Randomize Appearance");
    this.randomizeAppearanceBtn.SetWidth(600);
		this.randomizeAppearanceBtn.SetFlipped(true);
		this.randomizeAppearanceBtn.ToggleAnimations(true);
		this.randomizeAppearanceBtn.ToggleSounds(true);
    this.randomizeAppearanceBtn.Reparent(this.myVerticalPanel);

    this.selectCharacterPresetLabel = new inkText();
    this.selectCharacterPresetLabel.SetText("Select Preset:");
    this.selectCharacterPresetLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\orbitron\\orbitron.inkfontfamily");
		this.selectCharacterPresetLabel.SetFontStyle(n"Regular");
		this.selectCharacterPresetLabel.SetFontSize(25);
		this.selectCharacterPresetLabel.SetLetterCase(textLetterCase.UpperCase);
		this.selectCharacterPresetLabel.SetTintColor(ThemeColors.Bittersweet());
		this.selectCharacterPresetLabel.SetMargin(new inkMargin(0.0, 0.0, 0.0, 4.0));
    this.selectCharacterPresetLabel.Reparent(this.myVerticalPanel);

    this.presetScrollAreaWrapper = new inkHorizontalPanel();
    this.presetScrollAreaWrapper.SetAnchor(inkEAnchor.TopRight);
    this.presetScrollAreaWrapper.SetAnchorPoint(new Vector2(0.0, 0.0));
    this.presetScrollAreaWrapper.Reparent(this.myVerticalPanel);

    //ScrollContent
    this.presetScrollArea = new inkScrollArea();
    this.presetScrollArea.SetSize(620.0, 1000.0);
    this.presetScrollArea.SetName(n"scroller");
    this.presetScrollArea.SetAnchor(inkEAnchor.Fill);
    this.presetScrollArea.SetMargin(new inkMargin(0.0, 0.0, this.presetSliderHandleWidth + 4.0, 0.0));
    this.presetScrollArea.fitToContentDirection = inkFitToContentDirection.Horizontal;
    this.presetScrollArea.SetUseInternalMask(true);
    this.presetScrollArea.constrainContentPosition = true;
    this.presetScrollArea.Reparent(this.presetScrollAreaWrapper, -1);

    this.presetScrollSliderArea = new inkCanvas();
    this.presetScrollSliderArea.SetName(n"sliderArea");
    this.presetScrollSliderArea.SetAnchor(inkEAnchor.RightFillVerticaly);
    this.presetScrollSliderArea.SetSize(this.presetSliderHandleWidth, 1000.0);
    this.presetScrollSliderArea.Reparent(this.presetScrollAreaWrapper);

    this.presetScrollSliderHandle = new inkRectangle();
    this.presetScrollSliderHandle.SetName(n"sliderHandle");
    this.presetScrollSliderHandle.SetAnchor(inkEAnchor.TopFillHorizontaly);
    this.presetScrollSliderHandle.SetSize(this.presetSliderHandleWidth, 40.0);
    this.presetScrollSliderHandle.SetInteractive(true);
    this.presetScrollSliderHandle.SetTintColor(new HDRColor(0.368627, 0.964706, 1.0, 1.0));
    this.presetScrollSliderHandle.Reparent(this.presetScrollSliderArea);

    this.presetScrollAreaVerticalPanel = new inkVerticalPanel();
    this.presetScrollAreaVerticalPanel.SetAnchor(inkEAnchor.TopFillHorizontaly);
    this.presetScrollAreaVerticalPanel.SetAnchorPoint(new Vector2(0.5, 0.5));
    this.presetScrollAreaVerticalPanel.SetChildMargin(new inkMargin(0.0, 4.0, 0.0, 4.0));
    this.presetScrollAreaVerticalPanel.Reparent(this.presetScrollArea, -1);
    this.PopulatePresetList();
    this.presetScrollAreaVerticalPanel.SetFitToContent(true);
    this.presetScrollAreaWrapper.SetFitToContent(true);

    this.saveNameLabel = new inkText();
    this.saveNameLabel.SetText("Preset Name:");
    this.saveNameLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\orbitron\\orbitron.inkfontfamily");
		this.saveNameLabel.SetFontStyle(n"Regular");
		this.saveNameLabel.SetFontSize(25);
		this.saveNameLabel.SetLetterCase(textLetterCase.UpperCase);
		this.saveNameLabel.SetTintColor(ThemeColors.Bittersweet());
		this.saveNameLabel.SetMargin(new inkMargin(0.0, 0.0, 0.0, 4.0));
    this.saveNameLabel.Reparent(this.myVerticalPanel);

    this.saveNameTextInput = HubTextInput.Create();
    this.saveNameTextInput.Reparent(this.myVerticalPanel);

    this.savePresetBtn = SimpleButton.Create();
    this.savePresetBtn.SetName(n"SavePreset");
		this.savePresetBtn.SetText("Save character preset");
    this.savePresetBtn.SetWidth(600);
		this.savePresetBtn.SetFlipped(true);
		this.savePresetBtn.ToggleAnimations(true);
		this.savePresetBtn.ToggleSounds(true);
    this.savePresetBtn.Reparent(this.myVerticalPanel);

    this.RegisterCallbacks();

    if !IsDefined(this.customizationSystem) {
      this.customizationSystem = GameInstance.GetCharacterCustomizationSystem(this.morphMenu.GetPlayerControlledObject().GetGame());
    }

    if ArraySize(this.optionsArray) == 0 {
      this.optionsArray = this.customizationSystem.GetUnitedOptions(true, true, true);
    }

    return true;
  }

  public func OnPressSliderHandle(evt: ref<inkPointerEvent>) {
    if evt.IsAction(n"mouse_left") {
      this.isDragged = true;
      this.dragStartPos = evt.GetScreenSpacePosition();
      this.dragStartMargin = this.presetScrollSliderHandle.GetMargin();

      this.morphMenu.RegisterToGlobalInputCallback(n"OnPostOnRelative", this, n"OnGlobalMove");
      this.morphMenu.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease");
    }
  }

  public func UpdateScrollBarSize() -> Void {
    let area: Vector2 = this.presetScrollArea.GetViewportSize();
    let content: Vector2 = this.presetScrollAreaVerticalPanel.GetSize();

    if content.Y > area.Y {
      this.presetScrollSliderHandle.SetVisible(true);
      let viewRatio: Float = area.Y / content.Y;
      this.presetScrollSliderHandle.SetSize(this.presetSliderHandleWidth, viewRatio * area.Y);
    } else {
      this.presetScrollSliderHandle.SetVisible(false);
      this.presetScrollSliderHandle.SetSize(this.presetSliderHandleWidth, 40.0);
    }
    this.presetScrollArea.ScrollVertical(0.0);
    let margin: inkMargin = this.presetScrollSliderHandle.GetMargin();
    margin.top = 0.0;
    this.presetScrollSliderHandle.SetMargin(margin);
  }

  public func OnGlobalMove(evt: ref<inkPointerEvent>) -> Void {

    //Update Scrollposition
    let cursor: Vector2 = evt.GetScreenSpacePosition();
    let margin: inkMargin = this.dragStartMargin;
    let size: Vector2 = this.presetScrollSliderHandle.GetSize();
    let area: Vector2 = this.presetScrollSliderArea.GetSize();

    let contentSize: Vector2 = this.presetScrollAreaVerticalPanel.GetSize();

    let dragOffset: Float = (cursor.Y - this.dragStartPos.Y) * 2.0;

    margin.top += dragOffset;
    margin.top = MaxF(margin.top, 0);
    margin.top = MinF(margin.top, area.Y - size.Y);

    let scrollPosPercent = (1.0 / (area.Y - size.Y)) * margin.top;
    scrollPosPercent = MaxF(scrollPosPercent, 0);
    scrollPosPercent = MinF(scrollPosPercent, 1);

    this.presetScrollSliderHandle.SetMargin(margin);
    this.presetScrollArea.ScrollVertical(scrollPosPercent);
  }

  public func OnGlobalRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"mouse_left") {
      this.isDragged = false;
      this.morphMenu.UnregisterFromGlobalInputCallback(n"OnPostOnRelative", this, n"OnGlobalMove");
      this.morphMenu.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease");
    }
  }

  private func AddPresetListEntry(presetName: String) -> Void {
    let presetBtn: ref<SimpleButton> = SimpleButton.Create();
    presetBtn.SetName(n"PresetButton");
    presetBtn.SetText(presetName);
    presetBtn.SetWidth(584);
		presetBtn.SetFlipped(true);
    presetBtn.SetDisabled(false);
		presetBtn.ToggleAnimations(true);
		presetBtn.ToggleSounds(true);
    presetBtn.Reparent(this.presetScrollAreaVerticalPanel);

    presetBtn.RegisterToCallback(n"OnRelease", this, n"OnClickPresetListText");

    ArrayPush(this.presetScrollAreaButtons, presetBtn);
  }

  private func ClearPresetList() -> Void {
    this.presetScrollAreaVerticalPanel.RemoveAllChildren();

    for presetScrollButton in this.presetScrollAreaButtons {
      presetScrollButton.UnregisterFromCallback(n"OnRelease", this, n"OnClickPresetListText");
    }
    ArrayClear(this.presetScrollAreaButtons);
  }

  private func PopulatePresetList() -> Void {
    let presets: array<String> = this.ListPresets();

    this.ClearPresetList();

    for preset in presets {
      this.AddPresetListEntry(preset);
    }

    this.presetScrollArea.RemoveAllChildren();

    //Workaround
    //SetFitToContent doesn't really work how it is supposed to work
    let vPanelHeight: Float = (this.presetScrollAreaButtons[0].GetRootWidget().GetHeight() 
      + this.presetScrollAreaVerticalPanel.GetMargin().top
      + this.presetScrollAreaVerticalPanel.GetMargin().bottom)
      * Cast<Float>(ArraySize(this.presetScrollAreaButtons));
    this.presetScrollAreaVerticalPanel.SetSize(this.presetScrollAreaButtons[0].GetRootWidget().GetWidth(), vPanelHeight);

    //Need to do this so scrollarea can update contents (no idea why)
    this.presetScrollAreaVerticalPanel.Reparent(this.presetScrollArea);
    this.UpdateScrollBarSize();
  }

  protected cb func OnGlobalInputUnfocus(evt: ref<inkPointerEvent>) -> Void {
    if evt.IsAction(n"mouse_left") {
		  if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
			  this.morphMenu.RequestSetFocus(null);
		  }
	  }
  }

  private func RegisterCallbacks() -> Void {
    this.randomizeAppearanceBtn.RegisterToCallback(n"OnRelease", this.morphMenu, n"OnRandomize");
    this.savePresetBtn.RegisterToCallback(n"OnRelease", this, n"OnClickSavePreset");
    this.presetScrollSliderHandle.RegisterToCallback(n"OnPress", this, n"OnPressSliderHandle");
    this.morphMenu.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalInputUnfocus");
  }

  private func UnregisterCallbacks() -> Void {
    this.randomizeAppearanceBtn.UnregisterFromCallback(n"OnRelease", this.morphMenu, n"OnRandomize");
    this.savePresetBtn.UnregisterFromCallback(n"OnRelease", this, n"OnClickSavePreset");
    this.presetScrollSliderHandle.UnregisterFromCallback(n"OnPress", this, n"OnPressSliderHandle");
    this.morphMenu.UnregisterFromGlobalInputCallback(n"OnPostOnRelative", this, n"OnGlobalMove");
    this.morphMenu.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease");
    this.morphMenu.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalInputUnfocus");
  }

  public func OnUninitialize() -> Bool {
    this.UnregisterCallbacks();
    this.ClearPresetList();
    return true;
  }

  private func UpdatePresetList() -> Void {
    this.PopulatePresetList();
  }

  protected cb func OnClickPresetListText(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"click") && !this.IsAppearanceChangePending(){
      let widget: ref<inkWidget> = e.GetTarget();
      let name: String = (widget.GetController() as SimpleButton).GetText();

      if NotEquals(widget.GetName(), n"PresetButton") || Equals(name, "") {
        return false;
      }

      LogChannel(n"DEBUG", "Starting appearance change!");

      this.presetChangeList = this.LoadPreset(name);
      if ArraySize(this.presetChangeList) == 0 {
        return false;
      }

      //Can't set all options at once cuz otherwise cyberpunk gets a stroke and displays wrong character options (they still apply correctly tho)
      this.isAppearanceChangePending = true;
      this.presetChangeIndex = 0;

      this.ApplyNextAppearanceChangeOption();

      return true;
    }
    return false;
  }

  protected cb func OnClickSavePreset(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"click") {
      if !IsDefined(this.customizationSystem) {
        this.customizationSystem = GameInstance.GetCharacterCustomizationSystem(this.morphMenu.GetPlayerControlledObject().GetGame());
      }

      if ArraySize(this.optionsArray) == 0 {
        this.optionsArray = this.customizationSystem.GetUnitedOptions(true, true, true);
      }

      let saveOptions: array<String>;

      for option in this.optionsArray {
        if option.isEditable && option.isActive {
          ArrayPush(saveOptions, LocKeyToString(option.info.name) + ":" + ToString(option.currIndex));
        }
      }

      this.SavePreset(this.saveNameTextInput.GetText(), saveOptions);

      this.UpdatePresetList();
    }
    return true;
  }

  private func GetMatchingCustomizationOption(locKey: String) -> ref<CharacterCustomizationOption> {
    for option in this.optionsArray {
      if StrCmp(locKey, LocKeyToString(option.info.name)) == 0{
        return option;
      }
    }
  }

  private func ChangeAppearanceOption(locKey: String, optionIdx: Uint32) -> Bool {
    let option: ref<CharacterCustomizationOption> = this.GetMatchingCustomizationOption(locKey);
    if option.currIndex != optionIdx {
      this.customizationSystem.ApplyChangeToOption(option, optionIdx);
      return true;
    }
    return false;
  }

  public func ApplyNextAppearanceChangeOption() {
    if this.presetChangeIndex >= ArraySize(this.presetChangeList) {
      LogChannel(n"DEBUG", "Appearance change complete");
      this.isAppearanceChangePending = false;
      this.morphMenu.m_optionList.SetVisible(true);
      this.morphMenu.ReInitializeOptionsList();
      return;
    }

    let splitPreset: array<String> = StrSplit(this.presetChangeList[this.presetChangeIndex], ":");
    let locKey: String = splitPreset[0];
    let optionIdx: Uint32 = Cast<Uint32>(StringToInt(splitPreset[1]));

    this.ChangeAppearanceOption(locKey, optionIdx);
    this.presetChangeIndex = this.presetChangeIndex + 1;
    //GameInstance.GetUISystem(this.morphMenu.GetPlayerControlledObject().GetGame()).QueueEvent(new ChangeAppearanceEvent());
    //GameInstance.GetDelaySystem(this.morphMenu.GetPlayerControlledObject().GetGame()).DelayEventNextFrame(this.morphMenu.GetPlayerControlledObject(), new ChangeAppearanceEvent());
    //Change appearance options with a fixed update rate of 30 updates per second
    GameInstance.GetDelaySystem(this.morphMenu.GetPlayerControlledObject().GetGame()).DelayEvent(this.morphMenu.GetPlayerControlledObject(), new ChangeAppearanceEvent(), 0.03);
  }
}

@addField(characterCreationBodyMorphMenu)
  let characterPresetManager: ref<CharacterPresetManager>;

@wrapMethod(characterCreationBodyMorphMenu)
  protected cb func OnInitialize() -> Bool {
    let result: Bool =  wrappedMethod();

    this.characterPresetManager = new CharacterPresetManager();
    if this.characterPresetManager.CETActive() {
      this.characterPresetManager.OnInitialize(this);

      inkWidgetRef.SetInteractive(this.m_randomize, false);
      inkWidgetRef.SetVisible(this.m_randomize, false);
      inkWidgetRef.SetVisible(this.m_randomizBg, false);
      inkWidgetRef.SetVisible(this.m_randomizThumbnail, false);
    }

    return result;
  }

@wrapMethod(characterCreationBodyMorphMenu)
  protected cb func OnUninitialize() -> Bool {
    let result: Bool = wrappedMethod();

    if IsDefined(this.characterPresetManager) && this.characterPresetManager.CETActive() {
      this.characterPresetManager.OnUninitialize();
    }
    return result;
  }

@addMethod(characterCreationBodyMorphMenu)
  protected cb func OnChangeAppearance(evt: ref<ChangeAppearanceEvent>) -> Bool {
    if IsDefined(this.characterPresetManager) && this.characterPresetManager.CETActive() 
      && this.characterPresetManager.IsAppearanceChangePending() {
      this.characterPresetManager.ApplyNextAppearanceChangeOption();
    }
  }