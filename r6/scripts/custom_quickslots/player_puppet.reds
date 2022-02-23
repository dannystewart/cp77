import CustomQuickslotsConfig.*

@addField(PlayerPuppet)
public let m_customHotkeysConsumablesInventory: wref<CustomHotkeysConsumablesInventory>;

@addField(PlayerPuppet)
private let m_customHotkeysTransactionSystem: wref<TransactionSystem>;

@addField(PlayerPuppet)
private let m_customHotkeysInventoryListener: wref<InventoryScriptListener>;

@addField(PlayerPuppet)
private let m_customHotkeysInventoryManager: ref<InventoryDataManagerV2>;

@addField(PlayerPuppet)
public let m_customHotkeysIsInProgressConsumingHealingItem: Bool;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  wrappedMethod();

  let inventoryListenerCallback: ref<CustomHotkeysConsumablesInventory> = new CustomHotkeysConsumablesInventory();
  this.m_customHotkeysConsumablesInventory = inventoryListenerCallback;

  this.m_customHotkeysTransactionSystem = GameInstance.GetTransactionSystem(this.GetGame());
  this.m_customHotkeysInventoryListener = this.m_customHotkeysTransactionSystem.RegisterInventoryListener(this, inventoryListenerCallback);

  this.m_customHotkeyPlayerButtonData = new CustomHotkeyPlayerButtonData();
  this.m_customHotkeyPlayerButtonData.SetPlayer(this);
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
  this.m_customHotkeysConsumablesInventory = null;

  this.m_customHotkeysTransactionSystem.UnregisterInventoryListener(this, this.m_customHotkeysInventoryListener);
  this.m_customHotkeysInventoryListener = null;

  wrappedMethod();
}

@addMethod(PlayerPuppet)
public func CustomHotkeysSetupInventoryListerner() -> Void {
  this.m_customHotkeysInventoryManager = new InventoryDataManagerV2();
  this.m_customHotkeysInventoryManager.Initialize(this);
  
  let items: array<ItemID>;
  this.m_customHotkeysInventoryManager.MarkToRebuild();
  let itemTypes: array<gamedataItemType>;
  ArrayPush(itemTypes, gamedataItemType.Con_Edible);
  ArrayPush(itemTypes, gamedataItemType.Con_LongLasting);
  ArrayPush(itemTypes, gamedataItemType.Con_Inhaler);
  ArrayPush(itemTypes, gamedataItemType.Con_Injector);
  ArrayPush(itemTypes, gamedataItemType.Gad_Grenade);
  this.m_customHotkeysInventoryManager.GetPlayerItemsIDsByTypes(itemTypes, items);

  this.m_customHotkeysConsumablesInventory.Setup(this, items); 
}

@wrapMethod(EquipmentSystem)
private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
  wrappedMethod(request);

  let player: wref<PlayerPuppet> = request.owner as PlayerPuppet;
  if IsDefined(player) {
    player.CustomHotkeysSetupInventoryListerner();
  }
}

public class CustomHotkeyPlayerButtonData {
  private let player: wref<PlayerPuppet>;
  
  private let crouchHeld: Bool;
  private let dropBodyHeld: Bool;
  private let quickMeleeHeld: Bool;

  private let modifiersForDpadLeft: array<CName>;
  private let modifiersForDpadRight: array<CName>;
  private let modifiersForDpadUp: array<CName>;
  private let modifiersForDpadDown: array<CName>;

  public func ObserveAction(action: ListenerAction) -> Void {
    let actionName: CName = ListenerAction.GetName(action);
    let actionType: gameinputActionType = ListenerAction.GetType(action);  
    
    let shouldSendEvent: Bool = false;
    if Equals(actionType, gameinputActionType.BUTTON_HOLD_COMPLETE) {  
      if Equals(actionName, n"DropCarriedObject") {
        this.dropBodyHeld = true;
        shouldSendEvent = true;
      } else {
        if Equals(actionName, n"ToggleCrouch") {
          this.crouchHeld = true;
          shouldSendEvent = true;
        } else {
          if Equals(actionName, n"QuickMelee") {
            this.quickMeleeHeld = true;
            shouldSendEvent = true;
          }
        }
      }
    } else {
      if Equals(actionType, gameinputActionType.BUTTON_RELEASED) {
        if Equals(actionName, n"DropCarriedObject") || Equals(actionName, n"click") {
          this.dropBodyHeld = false;
          shouldSendEvent = true;
        } else {
          if Equals(actionName, n"ToggleCrouch") {
            this.crouchHeld = false;
            shouldSendEvent = true;
          } else {
            if Equals(actionName, n"QuickMelee") {
              this.quickMeleeHeld = false;
              shouldSendEvent = true;
            }
          }
        }
      }
    }

    if shouldSendEvent {
      let evt: ref<HotKeyHoldButtonHeldEvent> = new HotKeyHoldButtonHeldEvent();
      evt.isNormalDpadLeftProhibited = this.IsNormalDpadLeftProhibited();
      evt.isNormalDpadRightProhibited = this.IsNormalDpadRightProhibited();
      evt.isNormalDpadUpProhibited = this.IsNormalDpadUpProhibited();
      evt.isNormalDpadDownProhibited = this.IsNormalDpadDownProhibited();
      this.player.QueueEvent(evt);
    }
  }

  public func SetModifiers(modifiersForDpadLeft: array<CName>, modifiersForDpadRight: array<CName>, modifiersForDpadUp: array<CName>, modifiersForDpadDown: array<CName>) -> Void {
    this.modifiersForDpadLeft = modifiersForDpadLeft;
    this.modifiersForDpadRight = modifiersForDpadRight;
    this.modifiersForDpadUp = modifiersForDpadUp;
    this.modifiersForDpadDown = modifiersForDpadDown;
  }

  public func SetPlayer(player: ref<PlayerPuppet>) {
    this.player = player;
  }

  public func IsNormalDpadLeftProhibited() -> Bool {
    return this.IsNormalDpadDirProhibited(this.modifiersForDpadLeft);
  }

  public func IsNormalDpadRightProhibited() -> Bool {
    return this.IsNormalDpadDirProhibited(this.modifiersForDpadRight);
  }

  public func IsNormalDpadUpProhibited() -> Bool {
    return this.IsNormalDpadDirProhibited(this.modifiersForDpadUp);
  }

  public func IsNormalDpadDownProhibited() -> Bool {
    return this.IsNormalDpadDirProhibited(this.modifiersForDpadDown);
  }
  
  private func IsNormalDpadDirProhibited(dpadDirModifiers: array<CName>) -> Bool {
    if this.player.PlayerLastUsedKBM() {
      return false;
    }

    let i: Int32 = 0;
    while i < ArraySize(dpadDirModifiers) {
      if Equals(dpadDirModifiers[i], n"DropCarriedObject") && this.dropBodyHeld {
        return true;
      }
      if Equals(dpadDirModifiers[i], n"ToggleCrouch") && this.crouchHeld {
        return true;
      }
      if Equals(dpadDirModifiers[i], n"QuickMelee") && this.quickMeleeHeld {
        return true;
      }
      i += 1;
    }
    return false;
  }
}

@addField(PlayerPuppet)
private let m_customHotkeyPlayerButtonData: ref<CustomHotkeyPlayerButtonData>;

@addMethod(PlayerPuppet)
public func GetCustomHotkeyPlayerButtonData() -> ref<CustomHotkeyPlayerButtonData> {
  return this.m_customHotkeyPlayerButtonData;
}

@wrapMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  this.m_customHotkeyPlayerButtonData.ObserveAction(action);

  wrappedMethod(action, consumer);
}

public class CustomHotkeysConsumablesInventory extends InventoryScriptCallback {
  private let foods: array<array<ItemID>>;
  private let drinks: array<array<ItemID>>;
  private let alcohols: array<array<ItemID>>;
  private let maxDocs: array<array<ItemID>>;
  private let bounceBacks: array<array<ItemID>>;
  private let boosters: array<ItemID>;
  private let healthBooster: ItemID;
  private let staminaBooster: ItemID;
  private let memoryBooster: ItemID;
  private let carryCapacityBooster: ItemID;
  private let grenades: array<array<array<ItemID>>>;
  private let player: wref<PlayerPuppet>;
  private let itemQualityMap: ref<inkIntHashMap>;
  private let setupComplete: Bool;

  public func Setup(player: ref<PlayerPuppet>, items: array<ItemID>) -> Void {
    this.player = player;
    this.SetupItemQualityMapAndArrays();
    
    for item in items {
      this.addItem(item);
    }
    this.setupComplete = true;
  }

  public func GetItemQuality(item: ItemID) -> Int32 {
    return this.itemQualityMap.Get(TDBID.ToNumber(ItemID.GetTDBID(item)));
  }

  public func CycleGrenade(type: CustomQuickslotItemType, currentItem: ItemID) -> ItemID {
    let emptyItem: ItemID;
    if !this.setupComplete {
      return emptyItem;
    }

    let index: Int32 = this.GetGrenadeArrayIndexByItemType(type);
    if index == -1 {
      return emptyItem;
    }
    
    let currentQuality = this.GetItemQuality(currentItem);
    if currentQuality == -1 {
      currentQuality = 0;
    }

    let nextQuality: Int32 = (currentQuality + 1) % ArraySize(this.grenades[index]);
    let firstCheckedQuality: Int32 = nextQuality;
    while true {
      if ArraySize(this.grenades[index][nextQuality]) > 0 {
        return this.grenades[index][nextQuality][0];
      }
      nextQuality = (nextQuality + 1) % ArraySize(this.grenades[index]);
      if nextQuality == firstCheckedQuality {
        break;
      }
    }

    let emptyItem: ItemID;
    return emptyItem;
  }

  public func GetGrenadeWithExactQuality(type: CustomQuickslotItemType, quality: Int32) -> ItemID {
    let emptyItem: ItemID;
    let index: Int32 = this.GetGrenadeArrayIndexByItemType(type);
    if index == -1 {
      return emptyItem;
    }

    if ArraySize(this.grenades[index]) <= quality {
      return emptyItem;
    }

    if ArraySize(this.grenades[index][quality]) > 0 {
      return this.grenades[index][quality][0];
    }

    return emptyItem;
  }

  public func GetGrenadeWithPreferredQuality(type: CustomQuickslotItemType, grenadeQuality: GrenadeQuality) -> ItemID {
    let emptyItem: ItemID;
    if !this.setupComplete {
      return emptyItem;
    }

    let index: Int32 = this.GetGrenadeArrayIndexByItemType(type);
    if index == -1 {
      return emptyItem;
    }
    let quality: Int32 = EnumInt(grenadeQuality);
    if quality == -1 {
      quality = 0;
    }

    if ArraySize(this.grenades[index]) <= quality {
      quality = ArraySize(this.grenades[index]) - 1;
    }

    if quality == -1 {
      return emptyItem;
    }

    let startQuality: Int32 = quality;
    while true {
      if ArraySize(this.grenades[index][quality]) > 0 {
        return this.grenades[index][quality][0];
      }
      quality = (quality + 1) % ArraySize(this.grenades[index]);
      if quality == startQuality {
        break;
      }
    }
    return emptyItem;
  }

  private func GetGrenadeArrayIndexByResourceName(path: CName) -> Int32 {
    if Equals(path, n"Preset_Grenade_Biohazard_Default") {
      return 0;
    }
    if Equals(path, n"Preset_Grenade_Cutting_Default") {
      return 1;
    }
    if Equals(path, n"Preset_Grenade_EMP_Default") {
      return 2;
    }
    if Equals(path, n"Preset_Grenade_Flash_Default") {
      return 3;
    }
    if Equals(path, n"Preset_Grenade_Frag_Default") {
      return 4;
    }
    if Equals(path, n"Preset_Grenade_Incendiary_Default") {
      return 5;
    }
    if Equals(path, n"Preset_Grenade_Frag_Ozob") {
      return 6;
    }
    if Equals(path, n"Preset_Grenade_Recon_Default") {
      return 7;
    }
    return -1;
  }

  private func GetGrenadeArrayIndexByItemType(type: CustomQuickslotItemType) -> Int32 {
    switch type {
      case CustomQuickslotItemType.BiohazardGrenade:
        return 0;
      case CustomQuickslotItemType.CuttingGrenade:
        return 1;
      case CustomQuickslotItemType.EMPGrenade:
        return 2;
      case CustomQuickslotItemType.FlashGrenade:
        return 3;
      case CustomQuickslotItemType.FragGrenade:
        return 4;
      case CustomQuickslotItemType.IncendiaryGrenade:
        return 5;
      case CustomQuickslotItemType.OzobsNose:
        return 6;
      case CustomQuickslotItemType.ReconGrenade:
        return 7;
      default:
        return -1;
    }
  }

  private func GetBestQualityItem(itemArrays: array<array<ItemID>>) -> ItemID {
    let i: Int32 = ArraySize(itemArrays) - 1;
    while i >= 0 {
      if ArraySize(itemArrays[i]) > 0 {
        return itemArrays[i][0];
      }
      i -= 1;
    }
    let emptyItem: ItemID;
    return emptyItem;
  }

  public func GetNewItem(type: gamedataConsumableBaseName) -> ItemID {
    let itemToReturn: ItemID;
    
    switch type {
      case gamedataConsumableBaseName.Edible:
        itemToReturn = this.GetBestQualityItem(this.foods);
        break;
      case gamedataConsumableBaseName.Drinkable:
        itemToReturn = this.GetBestQualityItem(this.drinks);
        break;
      case gamedataConsumableBaseName.Alcohol:
        itemToReturn = this.GetBestQualityItem(this.alcohols);
        break;
      case gamedataConsumableBaseName.FirstAidWhiff:
        itemToReturn = this.GetBestQualityItem(this.maxDocs);
        break;
      case gamedataConsumableBaseName.BonesMcCoy70:
        itemToReturn = this.GetBestQualityItem(this.bounceBacks);
        break;
      case gamedataConsumableBaseName.HealthBooster:
      case gamedataConsumableBaseName.MemoryBooster:
      case gamedataConsumableBaseName.StaminaBooster:
      case gamedataConsumableBaseName.CarryCapacityBooster:
      case gamedataConsumableBaseName.OxyBooster:
        let i: Int32 = 0;
        while i < ArraySize(this.boosters) {
          let item: ItemID = this.boosters[i];
          let tweakId: TweakDBID = ItemID.GetTDBID(item);
          let consumable: ref<ConsumableItem_Record> = TweakDBInterface.GetConsumableItemRecord(tweakId);
          if IsDefined(consumable) {
            let consumableType: gamedataConsumableBaseName = consumable.ConsumableBaseName().Type();
            if Equals(type, consumableType) {
              itemToReturn = this.boosters[i];
            }
          }
          i += 1;
        }
        break;
      default:
        break;
    }

    return itemToReturn;
  }

  public func OnItemQuantityChanged(itemID: ItemID, diff: Int32, total: Uint32, flaggedAsSilent: Bool) -> Void {
    let totalInt: Int32 = Cast(total);
    if diff > 0 && diff == totalInt {
      this.addItem(itemID);
    } else {
      if diff < 0 && totalInt == 0 {
        this.removeItem(itemID);
      }
    }

    let evt: ref<CustomHotkeyItemQuantityChangedEvent> = new CustomHotkeyItemQuantityChangedEvent();
    evt.itemID = itemID;
    evt.diff = diff;
    evt.total = total;
    this.player.QueueEvent(evt);
  }

  private func addItem(itemID: ItemID) -> Void {
    let tweakId: TweakDBID = ItemID.GetTDBID(itemID);
    let quality: Int32 = this.itemQualityMap.Get(TDBID.ToNumber(tweakId));
    if quality == -1 {
      // if it's an item we haven't categorized, it goes in the lowest category
      quality = 0;
    }

    let consumable: ref<ConsumableItem_Record> = TweakDBInterface.GetConsumableItemRecord(tweakId);
    if IsDefined(consumable) {
      let type: gamedataConsumableBaseName = consumable.ConsumableBaseName().Type();  
      switch type {
        case gamedataConsumableBaseName.Edible:
          ArrayPush(this.foods[quality < ArraySize(this.foods) ? quality : 0], itemID);
          break;
        case gamedataConsumableBaseName.Drinkable:
          ArrayPush(this.drinks[quality < ArraySize(this.drinks) ? quality : 0], itemID);
          break;
        case gamedataConsumableBaseName.Alcohol:
          ArrayPush(this.alcohols[quality < ArraySize(this.alcohols) ? quality : 0], itemID);
          break;
        case gamedataConsumableBaseName.FirstAidWhiff:
          ArrayPush(this.maxDocs[quality < ArraySize(this.maxDocs) ? quality : 0], itemID);
          break;
        case gamedataConsumableBaseName.BonesMcCoy70:
          ArrayPush(this.bounceBacks[quality < ArraySize(this.bounceBacks) ? quality : 0], itemID);
          break;
        case gamedataConsumableBaseName.HealthBooster:
        case gamedataConsumableBaseName.MemoryBooster:
        case gamedataConsumableBaseName.StaminaBooster:
        case gamedataConsumableBaseName.CarryCapacityBooster:
        case gamedataConsumableBaseName.OxyBooster:
          ArrayPush(this.boosters, itemID);
          break;
        default:
          break;
      }
      return;
    }
    
    let grenade: ref<Grenade_Record> = TweakDBInterface.GetGrenadeRecord(tweakId);
    if IsDefined(grenade) {
      let index: Int32 = this.GetGrenadeArrayIndexByResourceName(grenade.AppearanceResourceName());
      if index != -1 {
        ArrayPush(this.grenades[index][quality < ArraySize(this.grenades[index]) ? quality : 0], itemID);
      }
    }
  }

  private func removeItem(itemID: ItemID) -> Void {
    let tweakId: TweakDBID = ItemID.GetTDBID(itemID);
    let quality: Int32 = this.itemQualityMap.Get(TDBID.ToNumber(tweakId));
    if quality == -1 {
      // if it's an item we haven't categorized, it goes in the lowest category
      quality = 0;
    }
    
    let consumable: ref<ConsumableItem_Record> = TweakDBInterface.GetConsumableItemRecord(tweakId);
    if IsDefined(consumable) {
      let type: gamedataConsumableBaseName = consumable.ConsumableBaseName().Type();
      switch type {
        case gamedataConsumableBaseName.Edible:
          ArrayRemove(this.foods[quality < ArraySize(this.foods) ? quality : 0], itemID);
          break;
        case gamedataConsumableBaseName.Drinkable:
          ArrayRemove(this.drinks[quality < ArraySize(this.drinks) ? quality : 0], itemID);
          break;
        case gamedataConsumableBaseName.Alcohol:
          ArrayRemove(this.alcohols[quality < ArraySize(this.alcohols) ? quality : 0], itemID);
          break;
        case gamedataConsumableBaseName.FirstAidWhiff:
          ArrayRemove(this.maxDocs[quality < ArraySize(this.maxDocs) ? quality : 0], itemID);
          break;
        case gamedataConsumableBaseName.BonesMcCoy70:
          ArrayRemove(this.bounceBacks[quality < ArraySize(this.bounceBacks) ? quality : 0], itemID);
          break;
        case gamedataConsumableBaseName.HealthBooster:
        case gamedataConsumableBaseName.MemoryBooster:
        case gamedataConsumableBaseName.StaminaBooster:
        case gamedataConsumableBaseName.CarryCapacityBooster:
        case gamedataConsumableBaseName.OxyBooster:
          ArrayRemove(this.boosters, itemID);
          break;
        default:
          break;
      }
      return;
    }

    let grenade: ref<Grenade_Record> = TweakDBInterface.GetGrenadeRecord(tweakId);
    if IsDefined(grenade) {
      let index: Int32 = this.GetGrenadeArrayIndexByResourceName(grenade.AppearanceResourceName());
      if index != -1 {
        ArrayRemove(this.grenades[index][quality < ArraySize(this.grenades[index]) ? quality : 0], itemID);
      }
    }
  }

  public func SetupItemQualityMapAndArrays() -> Void {
    let map: ref<inkIntHashMap> = new inkIntHashMap();
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityFood1"), 3);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityFood2"), 3);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityFood3"), 3);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityFood4"), 3);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityFood5"), 3);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityFood6"), 3);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityFood7"), 3);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityFood8"), 3);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityFood9"), 3);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityFood10"), 3);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityFood11"), 3);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityFood12"), 3);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityFood13"), 3);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood1"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood2"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood3"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood4"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood5"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood6"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood7"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood8"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood9"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood10"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood11"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood12"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood13"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood14"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood15"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood16"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood17"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood18"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood19"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityFood20"), 2);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood1"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood2"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood3"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood4"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood5"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood6"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood7"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood8"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood9"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood10"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood11"), 0); // Cat Food
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood12"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood13"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood14"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood15"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood16"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood17"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood18"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood19"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood20"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood21"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood22"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood23"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood24"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood25"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood26"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood27"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityFood28"), 1);
    map.Insert(TDBID.ToNumber(t"Items.NomadsFood1"), 3); // In FGR Nomad quality is same as Good
    map.Insert(TDBID.ToNumber(t"Items.NomadsFood2"), 3);
    for i in [0, 1, 2, 3] {
      let food: array<ItemID>;
      ArrayPush(this.foods, food);
    }
    
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityDrink1"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityDrink2"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityDrink3"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityDrink4"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityDrink5"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityDrink6"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityDrink7"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityDrink8"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityDrink9"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityDrink10"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityDrink11"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityDrink1"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityDrink2"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityDrink3"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityDrink4"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityDrink5"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityDrink6"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityDrink7"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityDrink8"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityDrink9"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityDrink10"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityDrink11"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityDrink12"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityDrink13"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityDrink14"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityDrink1"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityDrink2"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityDrink3"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityDrink4"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityDrink5"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityDrink6"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityDrink7"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityDrink8"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityDrink9"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityDrink10"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityDrink11"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityDrink12"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityDrink13"), 0);
    map.Insert(TDBID.ToNumber(t"Items.NomadsDrink1"), 2);
    map.Insert(TDBID.ToNumber(t"Items.NomadsDrink2"), 2);
    for i in [0, 1, 2] {
      let drinks: array<ItemID>;
      ArrayPush(this.drinks, drinks);
    }

    map.Insert(TDBID.ToNumber(t"Items.TopQualityAlcohol1"), 3);
    map.Insert(TDBID.ToNumber(t"Items.TopQualityAlcohol2"), 3);
    map.Insert(TDBID.ToNumber(t"Items.TopQualityAlcohol3"), 3);
    map.Insert(TDBID.ToNumber(t"Items.TopQualityAlcohol4"), 3);
    map.Insert(TDBID.ToNumber(t"Items.TopQualityAlcohol5"), 3);
    map.Insert(TDBID.ToNumber(t"Items.TopQualityAlcohol6"), 3);
    map.Insert(TDBID.ToNumber(t"Items.TopQualityAlcohol7"), 3);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityAlcohol1"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityAlcohol2"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityAlcohol3"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityAlcohol4"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityAlcohol5"), 2);
    map.Insert(TDBID.ToNumber(t"Items.GoodQualityAlcohol6"), 2);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityAlcohol1"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityAlcohol2"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityAlcohol3"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityAlcohol4"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityAlcohol5"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityAlcohol6"), 1);
    map.Insert(TDBID.ToNumber(t"Items.MediumQualityAlcohol7"), 1);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityAlcohol1"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityAlcohol2"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityAlcohol3"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityAlcohol4"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityAlcohol5"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityAlcohol6"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityAlcohol7"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityAlcohol8"), 0);
    map.Insert(TDBID.ToNumber(t"Items.LowQualityAlcohol9"), 0);
    map.Insert(TDBID.ToNumber(t"Items.NomadsAlcohol1"), 2);
    map.Insert(TDBID.ToNumber(t"Items.NomadsAlcohol2"), 2);
    for i in [0, 1, 2, 3] {
      let alcohol: array<ItemID>;
      ArrayPush(this.alcohols, alcohol);
    }

    map.Insert(TDBID.ToNumber(t"Items.FirstAidWhiffV0"), 0);
    map.Insert(TDBID.ToNumber(t"Items.FirstAidWhiffV1"), 1);
    map.Insert(TDBID.ToNumber(t"Items.FirstAidWhiffV2"), 2);
    for i in [0, 1, 2] {
      let maxDoc: array<ItemID>;
      ArrayPush(this.maxDocs, maxDoc);
    }

    map.Insert(TDBID.ToNumber(t"Items.BonesMcCoy70V0"), 0);
    map.Insert(TDBID.ToNumber(t"Items.BonesMcCoy70V1"), 1);
    map.Insert(TDBID.ToNumber(t"Items.BonesMcCoy70V2"), 2);
    for i in [0, 1, 2] {
      let bounceBack: array<ItemID>;
      ArrayPush(this.bounceBacks, bounceBack);
    }

    // populate grenades array^3
    for i in [0, 1, 2, 3, 4, 5, 6, 7] {
      let grenadesArray: array<array<ItemID>>;
      ArrayPush(this.grenades, grenadesArray);
    }

    map.Insert(TDBID.ToNumber(t"Items.GrenadeBiohazardRegular"), 0);
    map.Insert(TDBID.ToNumber(t"Items.GrenadeBiohazardHoming"), 2);
    for i in [0, 1, 2] {
      let grenade: array<ItemID>;
      ArrayPush(this.grenades[0], grenade);
    }
    
    map.Insert(TDBID.ToNumber(t"Items.GrenadeCuttingRegular"), 0);
    for i in [0, 1, 2] {
      let grenade: array<ItemID>;
      ArrayPush(this.grenades[1], grenade);
    }

    map.Insert(TDBID.ToNumber(t"Items.GrenadeEMPRegular"), 0);
    map.Insert(TDBID.ToNumber(t"Items.GrenadeEMPSticky"), 1);
    map.Insert(TDBID.ToNumber(t"Items.GrenadeEMPHoming"), 2);
    for i in [0, 1, 2] {
      let grenade: array<ItemID>;
      ArrayPush(this.grenades[2], grenade);
    }

    map.Insert(TDBID.ToNumber(t"Items.GrenadeFlashRegular"), 0);
    map.Insert(TDBID.ToNumber(t"Items.GrenadeFlashHoming"), 2);
    for i in [0, 1, 2] {
      let grenade: array<ItemID>;
      ArrayPush(this.grenades[3], grenade);
    }

    map.Insert(TDBID.ToNumber(t"Items.GrenadeFragRegular"), 0);
    map.Insert(TDBID.ToNumber(t"Items.GrenadeFragSticky"), 1);
    map.Insert(TDBID.ToNumber(t"Items.GrenadeFragHoming"), 2);
    for i in [0, 1, 2] {
      let grenade: array<ItemID>;
      ArrayPush(this.grenades[4], grenade);
    }

    map.Insert(TDBID.ToNumber(t"Items.GrenadeIncendiaryRegular"), 0);
    map.Insert(TDBID.ToNumber(t"Items.GrenadeIncendiarySticky"), 1);
    map.Insert(TDBID.ToNumber(t"Items.GrenadeIncendiaryHoming"), 2);
    for i in [0, 1, 2] {
      let grenade: array<ItemID>;
      ArrayPush(this.grenades[5], grenade);
    }

    map.Insert(TDBID.ToNumber(t"Items.GrenadeOzobsNose"), 0);
    for i in [0, 1, 2] {
      let grenade: array<ItemID>;
      ArrayPush(this.grenades[6], grenade);
    }

    map.Insert(TDBID.ToNumber(t"Items.GrenadeReconRegular"), 0);
    map.Insert(TDBID.ToNumber(t"Items.GrenadeReconSticky"), 1);
    for i in [0, 1, 2] {
      let grenade: array<ItemID>;
      ArrayPush(this.grenades[7], grenade);
    }

    this.itemQualityMap = map;
  }
}

public class CustomHotkeyItemQuantityChangedEvent extends Event {
  public let itemID: ItemID;
  public let diff: Int32;
  public let total: Uint32;
}

@wrapMethod(SubtitlesGameController)
protected func CreateLine(lineSpawnData: ref<LineSpawnData>) -> Void {
  wrappedMethod(lineSpawnData);

  let player: wref<PlayerPuppet> = this.GetPlayerControlledObject() as PlayerPuppet;
  if IsDefined(player) {
    player.SubtitlesPresent(true);
  }
}

@wrapMethod(SubtitlesGameController)
protected func OnHideLine(lineData: subtitleLineMapEntry) -> Void {
  wrappedMethod(lineData);

  let player: wref<PlayerPuppet> = this.GetPlayerControlledObject() as PlayerPuppet;
  if IsDefined(player) && this.m_subtitlesPanel.GetNumChildren() == 0 {
    player.SubtitlesPresent(false);
  }
}

@wrapMethod(SubtitlesGameController)
protected func OnHideLineByData(lineData: subtitleLineMapEntry) -> Void {
  wrappedMethod(lineData);

  if this.m_subtitlesPanel.GetNumChildren() == 0 {
    let player: wref<PlayerPuppet> = this.GetPlayerControlledObject() as PlayerPuppet;
    if IsDefined(player) {
      player.SubtitlesPresent(false);
    }
  }
}

@addMethod(PlayerPuppet)
public func SubtitlesPresent(present: Bool) -> Void {
  let evt: ref<CustomQuickslotsInDialog> = new CustomQuickslotsInDialog();
  evt.subtitlesVisible = present;
  this.QueueEvent(evt);
}

public class CustomQuickslotsInDialog extends Event {
  public let subtitlesVisible: Bool;
}
