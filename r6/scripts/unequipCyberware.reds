//Handle visibility of the unequip button
@replaceMethod(RipperDocGameController)
  private final func SetInventoryItemButtonHintsHoverOver(displayingData: InventoryItemData) -> Void {
    let isEmpty: Bool = InventoryItemData.IsEmpty(displayingData);
    let isEquipped: Bool = InventoryItemData.IsEquipped(displayingData);
    switch this.m_screen {
      case CyberwareScreenType.Ripperdoc:
        if Equals(this.m_mode, RipperdocModes.Default) {
          this.m_buttonHintsController.AddButtonHint(n"select", "LocKey#273");
        } else {
          if Equals(this.m_mode, RipperdocModes.Item) {
            if isEmpty || isEquipped {
              this.m_buttonHintsController.AddButtonHint(n"select", "LocKey#34928");
			  //Change starts here
			  if !isEmpty && isEquipped
              {
		        this.m_buttonHintsController.AddButtonHint(n"unequip_item", GetLocalizedText("UI-UserActions-Unequip"));
		      }
			  //Change ends here
            } else {
              if InventoryItemData.IsVendorItem(displayingData) {
                this.m_buttonHintsController.AddButtonHint(n"select", "LocKey#17847");
              } else {
                this.m_buttonHintsController.AddButtonHint(n"disassemble_item", "LocKey#17848");
                this.m_buttonHintsController.AddButtonHint(n"select", "LocKey#246");
              };
            };
          };
        };
        if isEquipped && this.CheckTokenAvailability() {
          this.m_buttonHintsController.AddButtonHint(n"upgrade_perk", this.m_ripperdocTokenManager.IsItemUpgraded(InventoryItemData.GetID(displayingData)) ? "LocKey#79251" : "LocKey#79250");
        };
        this.SetCursorContext(n"Hover");
        break;
      case CyberwareScreenType.Inventory:
        if Equals(this.m_mode, RipperdocModes.Default) {
          this.m_buttonHintsController.AddButtonHint(n"select", "LocKey#273");
        };
        this.SetCursorContext(n"Default");
    };
  }

@replaceMethod(RipperDocGameController)
  private final func SetInventoryItemButtonHintsHoverOut() -> Void {
    this.m_buttonHintsController.RemoveButtonHint(n"select");
    this.m_buttonHintsController.RemoveButtonHint(n"upgrade_perk");
    this.m_buttonHintsController.RemoveButtonHint(n"disassemble_item");
	//Change starts here
    this.m_buttonHintsController.RemoveButtonHint(n"unequip_item");
	//Change ends here
  }

//Handle actual functionality
@replaceMethod(RipperDocGameController)
  protected cb func OnSlotClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
    let additionalInfo: ref<VendorRequirementsNotMetNotificationData>;
    let itemGameData: wref<gameItemData>;
    let type: VendorConfirmationPopupType;
    let vendorNotification: ref<UIMenuNotificationEvent>;
    let itemData: InventoryItemData = evt.itemData;
	//Change starts here
	let unequipItemRequest: ref<UnequipItemsRequest>;
	//Change ends here
    if !this.m_isActivePanel || InventoryItemData.IsEmpty(itemData) {
      return false;
    };
    itemGameData = InventoryItemData.GetGameItemData(itemData);
	//Change starts here
	if evt.actionName.IsAction(n"unequip_item") && this.m_equiped && Equals(this.m_mode, RipperdocModes.Item) {
      this.PlaySound(n"Button", n"OnPress");
      let widget: ref<inkWidget>;
      let controller: wref<InventoryItemDisplayController>;
      widget = evt.evt.GetCurrentTarget();
      this.m_equiped = false;
      unequipItemRequest = new UnequipItemsRequest();
      unequipItemRequest.owner = this.m_player;
      ArrayPush(unequipItemRequest.items, InventoryItemData.GetGameItemData(itemData).GetID());
      this.PlaySound(n"ItemCyberware", n"OnInstall");
      EquipmentSystem.GetInstance(this.m_player).QueueRequest(unequipItemRequest);
    }
	//Change ends here
    if evt.actionName.IsAction(n"click") {
      this.PlaySound(n"Button", n"OnPress");
      if InventoryItemData.IsVendorItem(itemData) {
        if !InventoryItemData.IsRequirementMet(itemData) {
          vendorNotification = new UIMenuNotificationEvent();
          vendorNotification.m_notificationType = UIMenuNotificationType.VendorRequirementsNotMet;
          additionalInfo = new VendorRequirementsNotMetNotificationData();
          additionalInfo.m_data = InventoryItemData.GetRequirement(itemData);
          vendorNotification.m_additionalInfo = ToVariant(additionalInfo);
          GameInstance.GetUISystem(this.m_player.GetGame()).QueueEvent(vendorNotification);
        } else {
          if evt.isBuybackStack {
            this.m_VendorDataManager.BuybackItemFromVendor(itemGameData, 1);
          } else {
            if this.m_VendorDataManager.GetBuyingPrice(itemGameData.GetID()) > this.m_VendorDataManager.GetLocalPlayerCurrencyAmount() {
              vendorNotification = new UIMenuNotificationEvent();
              vendorNotification.m_notificationType = UIMenuNotificationType.VNotEnoughMoney;
              GameInstance.GetUISystem(this.m_player.GetGame()).QueueEvent(vendorNotification);
            } else {
              type = EquipmentSystem.GetInstance(this.m_player).GetPlayerData(this.m_player).IsEquippable(itemGameData) ? VendorConfirmationPopupType.BuyAndEquipCyberware : VendorConfirmationPopupType.BuyNotEquipableCyberware;
              this.OpenConfirmationPopup(itemData, this.m_VendorDataManager.GetBuyingPrice(InventoryItemData.GetID(itemData)), type, n"OnBuyConfirmationPopupClosed");
            };
          };
        };
      } else {
        if !InventoryItemData.IsEquipped(itemData) && this.m_equiped {
          this.EquipCyberware(itemGameData);
        };
      };
    } else {
      if evt.actionName.IsAction(n"disassemble_item") && !InventoryItemData.IsEquipped(itemData) && !InventoryItemData.IsVendorItem(itemData) {
        this.OpenConfirmationPopup(itemData, this.m_VendorDataManager.GetSellingPrice(InventoryItemData.GetID(itemData)), VendorConfirmationPopupType.SellCyberware, n"OnSellConfirmationPopupClosed");
      };
    };
  }