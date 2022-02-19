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
  public final func InitializeList() -> Void {
    let i: Int32;
    let option: ref<CharacterCustomizationOption>;
    let options: array<ref<CharacterCustomizationOption>>;
    let system: ref<gameuiICharacterCustomizationSystem>;
    if this.m_characterCustomizationState.IsBodyGenderMale() {
      inkImageRef.SetTexturePart(this.m_preset1Thumbnail, n"preset_nom_m");
      inkImageRef.SetTexturePart(this.m_preset2Thumbnail, n"preset_str_m");
      inkImageRef.SetTexturePart(this.m_preset3Thumbnail, n"preset_cor_m");
      inkImageRef.SetTexturePart(this.m_randomizThumbnail, n"preset_random_m");
    } else {
      inkImageRef.SetTexturePart(this.m_preset1Thumbnail, n"preset_nom_f");
      inkImageRef.SetTexturePart(this.m_preset2Thumbnail, n"preset_str_f");
      inkImageRef.SetTexturePart(this.m_preset3Thumbnail, n"preset_cor_f");
      inkImageRef.SetTexturePart(this.m_randomizThumbnail, n"preset_random_f");
    };
    this.RequestCameraChange(this.m_defaultPreviewSlot);
    system = this.GetCharacterCustomizationSystem();
    system.ApplyEditTag(this.m_editMode);
    options = system.GetUnitedOptions(true, true, true);
    inkCompoundRef.RemoveAllChildren(this.m_optionsList);
    if system.IsTransgenderAllowed() && Equals(this.m_editMode, gameuiCharacterCustomizationEditTag.NewGame) {
      this.CreateVoiceOverSwitcher();
    };
    i = 0;
    while i < ArraySize(options) {
      option = options[i];
      //if option.isEditable && option.isActive && !option.isCensored {
      if !option.info.hidden && option.isActive && !option.isCensored {
        this.CreateEntry(option);
      };
      i += 1;
    };
  }