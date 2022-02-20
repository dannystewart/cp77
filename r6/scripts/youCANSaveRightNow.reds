@replaceMethod(GameInstance)
  public final static func IsSavingLocked(self: GameInstance, out locks: array<gameSaveLock>) -> Bool {
    // this was native, no original code to show here
    ArrayClear(locks);
    return false;
  }

@replaceMethod(PreventionSystem)
  private func IsSavingLocked() -> Bool {
    // return this.IsChasingPlayer();
    return false;
  }

@replaceMethod(BraindanceSystem)
  private func IsSavingLocked() -> Bool {
    // return this.isInBraindance;
    return false;
  }

@replaceMethod(ScriptableSystem)
  private func IsSavingLocked() -> Bool {
    // return false;
    return false;
  }

@replaceMethod(TakeOverControlSystem)
  private func IsSavingLocked() -> Bool {
    // return this.IsDeviceControlled();
    return false;
  }

@replaceMethod(PauseMenuGameController)
  private final func HandlePressToSaveGame(target: wref<inkWidget>) -> Void {
    // let locks: array<gameSaveLock>;
    // if GameInstance.IsSavingLocked(this.m_gameInstance, locks) {
    //   this.PlaySound(n"Button", n"OnPress");
    //   this.PlayLibraryAnimationOnAutoSelectedTargets(n"pause_button_blocked", target);
    //   this.ShowSavingLockedNotification(AsRef(locks));
    //   return ;
    // };
    this.PlaySound(n"Button", n"OnPress");
    this.m_menuEventDispatcher.SpawnEvent(n"OnSwitchToSaveGame");
  }

@replaceMethod(PauseMenuGameController)
  private final func HandlePressToQuickSaveGame() -> Void {
    // let locks: array<gameSaveLock>;
    if this.m_quickSaveInProgress || this.IsSaveFailedNotificationActive() || this.IsGameSavedNotificationActive() {
      this.PlaySound(n"Button", n"OnPress");
      return ;
    };
    // if GameInstance.IsSavingLocked(this.m_gameInstance, locks) {
    //   this.PlaySound(n"Button", n"OnPress");
    //   this.ShowSavingLockedNotification(AsRef(locks));
    //   return ;
    // };
    this.PlaySound(n"Button", n"OnPress");
    this.GetSystemRequestsHandler().QuickSave();
    this.m_quickSaveInProgress = true;
  }

@replaceMethod(gameuiInGameMenuGameController)
  private final func HandleQuickSave() -> Void {
    // let locks: array<gameSaveLock>;
    if this.m_quickSaveInProgress {
      return ;
    };
    // if GameInstance.IsSavingLocked(this.GetPlayerControlledObject().GetGame(), locks) {
    //   GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame()).QueueEvent(new UIInGameNotificationRemoveEvent());
    //   GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame()).QueueEvent(UIInGameNotificationEvent.CreateSavingLockedEvent(AsRef(locks)));
    //   return ;
    // };
    this.GetSystemRequestsHandler().QuickSave();
    this.m_quickSaveInProgress = true;
  }

@replaceMethod(SaveGameMenuGameController)
  protected cb func OnSavingComplete(success: Bool, locks: array<gameSaveLock>) -> Bool {
    if success {
      this.m_handler.RequestSavesForSave();
      this.RequestGameSavedNotification();
    } else {
      // this.ShowSavingLockedNotification(AsRef(locks));
      this.RequestSaveFailedNotification();
      GameInstance.GetAutoSaveSystem(this.GetPlayerControlledObject().GetGame()).RequestCheckpoint();  // try to make an autosave
    };
    this.m_saveInProgress = false;
  }

@replaceMethod(PauseMenuGameController)
  protected cb func OnSavingComplete(success: Bool, locks: array<gameSaveLock>) -> Bool {
    if success {
      this.RequestGameSavedNotification();
    } else {
      this.RequestSaveFailedNotification();
      // this.ShowSavingLockedNotification(AsRef(locks));
      GameInstance.GetAutoSaveSystem(this.GetPlayerControlledObject().GetGame()).RequestCheckpoint();  // try to make an autosave
    };
    this.m_quickSaveInProgress = false;
  }
