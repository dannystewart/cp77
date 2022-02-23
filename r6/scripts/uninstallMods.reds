@replaceMethod(InventoryDataManagerV2)
  public final func CanUninstallMod(itemType: gamedataItemType, slot: TweakDBID) -> Bool {
    if !this.IsNonModifableSlot(slot) {
      return true;
    };
    return false;
  }
  
@replaceMethod(RPGManager)
  public final static func CanPartBeUnequipped(itemID: ItemID) -> Bool {
    return true;
  }

@replaceMethod(ItemModificationSystem)
  private final func InstallItemPart(obj: ref<GameObject>, itemID: ItemID, partItemID: ItemID, opt slotID: TweakDBID) -> Bool {
    let defaultSlotID: TweakDBID;
    let partData: InnerItemData;
    let partInstallRequest: ref<PartInstallRequest>;
    let previousPartID: ItemID;
    let result: Bool;
    let ts: ref<TransactionSystem> = GameInstance.GetTransactionSystem(obj.GetGame());
    let itemType: gamedataItemType = RPGManager.GetItemRecord(partItemID).ItemType().Type();
    let itemData: wref<gameItemData> = ts.GetItemData(obj, itemID);
    if IsDefined(TweakDBInterface.GetAttachmentSlotRecord(slotID)) {
      itemData.GetItemPart(partData, slotID);
      previousPartID = InnerItemData.GetItemID(partData);
      if ItemID.IsValid(previousPartID) {
        this.RemovePartEquipGLPs(obj, previousPartID);
      };
      result = ts.ForcePartInSlot(obj, itemID, partItemID, slotID);
      if Equals(itemType, gamedataItemType.Prt_Program) {
        this.RemoveLowerShards(obj, itemID, partItemID);
      };
    } else {
      defaultSlotID = EquipmentSystem.GetPlacementSlot(partItemID);
      result = ts.ForcePartInSlot(obj, itemID, partItemID, defaultSlotID);
      if Equals(itemType, gamedataItemType.Prt_Mod) || RPGManager.IsClothingMod(itemType) {
        ts.RemoveItem(obj, partItemID, 1);
      };
    };
    if result {
      partInstallRequest = new PartInstallRequest();
      partInstallRequest.owner = obj;
      partInstallRequest.itemID = itemID;
      partInstallRequest.partID = partItemID;
      GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"EquipmentSystem").QueueRequest(partInstallRequest);
    };
    PlayerPuppet.ChacheQuickHackListCleanup(obj as PlayerPuppet);
    return result;
  }
  
@replaceMethod(InventoryItemModeLogicController)
  private final func EquipPart(itemData: InventoryItemData, slotID: TweakDBID) -> Void {
    let isPartEquipped: Bool;
    let isReplaceableType: Bool;
    let modItemType: gamedataItemType;
    let equippedItemData: InventoryItemData = this.itemChooser.GetModifiedItemData();
    let localEquippedData: wref<gameItemData> = InventoryItemData.GetGameItemData(equippedItemData);
    if this.m_InventoryManager.CanInstallPart(itemData) {
      modItemType = InventoryItemData.GetItemType(itemData);
      isPartEquipped = localEquippedData.HasPartInSlot(slotID);
      this.m_InventoryManager.InstallPart(InventoryItemData.GetID(equippedItemData), InventoryItemData.GetID(itemData), slotID);
      this.TelemetryLogPartInstalled(equippedItemData, itemData, slotID);
      this.SetPingTutorialFact(InventoryItemData.GetID(itemData), false);
    };
  }