
// Fixes a bug where there was no filters for the Stash inventory.
@replaceMethod(FullscreenVendorGameController)
  private final func PopulateVendorInventory() -> Void {
    let BuybackVendorInventoryData: ref<VendorInventoryItemData>;
    let cacheItem: ref<SoldItem>;
    let i: Int32;
    let items: array<ref<IScriptable>>;
    let j: Int32;
    let localQuantity: Int32;
    let playerMoney: Int32;
    let specialOffers: array<InventoryItemData>;
    let storageItems: array<ref<gameItemData>>;
    let vendorInventory: array<InventoryItemData>;
    let vendorInventoryData: ref<VendorInventoryItemData>;
    let vendorInventorySize: Int32;
    this.m_vendorFilterManager.Clear();
    this.m_vendorFilterManager.AddFilter(ItemFilterCategory.AllItems);
    if IsDefined(this.m_vendorUserData) {
      specialOffers = this.ConvertGameDataIntoInventoryData(this.m_VendorDataManager.GetVendorSpecialOffers(), this.m_VendorDataManager.GetVendorInstance(), true);
      vendorInventory = this.ConvertGameDataIntoInventoryData(this.m_VendorDataManager.GetVendorInventoryItems(), this.m_VendorDataManager.GetVendorInstance(), true);
      vendorInventorySize = ArraySize(vendorInventory);
      if ArraySize(specialOffers) <= 0 {
        inkWidgetRef.SetVisible(this.m_specialOffersWrapper, false);
      } else {
        inkWidgetRef.SetVisible(this.m_specialOffersWrapper, true);
      };
      playerMoney = this.m_VendorDataManager.GetLocalPlayerCurrencyAmount();
      i = 0;
      while i < vendorInventorySize {
        cacheItem = this.m_soldItems.GetItem(InventoryItemData.GetID(vendorInventory[i]));
        vendorInventoryData = new VendorInventoryItemData();
        vendorInventoryData.ItemData = vendorInventory[i];
        this.m_InventoryManager.GetOrCreateInventoryItemSortData(vendorInventoryData.ItemData, this.m_uiScriptableSystem);
        vendorInventoryData.IsVendorItem = true;
        vendorInventoryData.IsEnoughMoney = playerMoney >= Cast<Int32>(InventoryItemData.GetBuyPrice(vendorInventory[i]));
        vendorInventoryData.IsDLCAddedActiveItem = this.m_uiScriptableSystem.IsDLCAddedActiveItem(ItemID.GetTDBID(InventoryItemData.GetID(vendorInventory[i])));
        vendorInventoryData.ComparisonState = this.GetComparisonState(vendorInventoryData.ItemData);
        if cacheItem != null {
          localQuantity = InventoryItemData.GetQuantity(vendorInventory[i]);
          if cacheItem.quantity == localQuantity {
            vendorInventoryData.IsBuybackStack = true;
          } else {
            if localQuantity > cacheItem.quantity {
              InventoryItemData.SetQuantity(vendorInventoryData.ItemData, localQuantity - cacheItem.quantity);
              BuybackVendorInventoryData = new VendorInventoryItemData();
              BuybackVendorInventoryData.ItemData = vendorInventory[i];
              this.m_InventoryManager.GetOrCreateInventoryItemSortData(BuybackVendorInventoryData.ItemData, this.m_uiScriptableSystem);
              BuybackVendorInventoryData.IsVendorItem = true;
              BuybackVendorInventoryData.IsEnoughMoney = playerMoney >= Cast<Int32>(InventoryItemData.GetBuyPrice(vendorInventory[i]));
              BuybackVendorInventoryData.ComparisonState = this.GetComparisonState(vendorInventoryData.ItemData);
              BuybackVendorInventoryData.IsBuybackStack = true;
              InventoryItemData.SetQuantity(BuybackVendorInventoryData.ItemData, cacheItem.quantity);
              ArrayPush(items, BuybackVendorInventoryData);
            } else {
              cacheItem;
            };
          };
        };
        if vendorInventoryData.IsBuybackStack {
          this.m_vendorFilterManager.AddFilter(ItemFilterCategory.Buyback);
        } else {
          this.m_vendorFilterManager.AddItem(InventoryItemData.GetGameItemData(vendorInventoryData.ItemData));
        };
        ArrayPush(items, vendorInventoryData);
        i += 1;
      };
    } else {
      if IsDefined(this.m_storageUserData) {
        storageItems = this.m_VendorDataManager.GetStorageItems();
        j = 0;
        while j < ArraySize(storageItems) {
          vendorInventoryData = new VendorInventoryItemData();
          storageItems[j].ReinitializePlayerStats(this.m_player.GetGame(), this.m_player.GetEntityID());
          this.m_InventoryManager.GetCachedInventoryItemData(storageItems[j], vendorInventoryData.ItemData);
          this.m_InventoryManager.GetOrCreateInventoryItemSortData(vendorInventoryData.ItemData, this.m_uiScriptableSystem);
          InventoryItemData.SetIsVendorItem(vendorInventoryData.ItemData, true);
          vendorInventoryData.IsVendorItem = true;
          vendorInventoryData.IsEnoughMoney = true;
          vendorInventoryData.ComparisonState = this.GetComparisonState(vendorInventoryData.ItemData);
          ArrayPush(items, vendorInventoryData);
		  // The fix, items were missing from the filter manager.
		  this.m_vendorFilterManager.AddItem(InventoryItemData.GetGameItemData(vendorInventoryData.ItemData));
          j += 1;
        };
      };
    };
    this.m_vendorDataSource.Reset(items);
    this.m_vendorFilterManager.SortFiltersList();
    this.m_vendorFilterManager.InsertFilter(0, ItemFilterCategory.AllItems);
    this.SetFilters(this.m_vendorFiltersContainer, this.m_vendorFilterManager.GetIntFiltersList(), n"OnVendorFilterChange");
    this.m_vendorItemsDataView.EnableSorting();
    this.m_vendorItemsDataView.SetFilterType(this.m_lastVendorFilter);
    this.m_vendorItemsDataView.SetSortMode(this.m_vendorItemsDataView.GetSortMode());
    this.m_vendorItemsDataView.DisableSorting();
    this.ToggleFilter(this.m_vendorFiltersContainer, EnumInt(this.m_lastVendorFilter));
    inkWidgetRef.SetVisible(this.m_vendorFiltersContainer, ArraySize(items) > 0);
    this.PlayLibraryAnimation(n"vendor_grid_show");
  }
  
  

// Fixes items disappearing (visually) when transferring from stash or vendor.
@wrapMethod(FullscreenVendorGameController)
private final func Update() -> Void {
    this.m_InventoryManager.ClearInventoryItemDataCache();
	wrappedMethod();
}
@wrapMethod(FullscreenVendorGameController)  
protected cb func OnUIVendorItemSoldEvent(evt: ref<UIVendorItemsSoldEvent>) -> Bool {
    this.m_InventoryManager.ClearInventoryItemDataCache();
	wrappedMethod(evt);
}
@wrapMethod(FullscreenVendorGameController)  
protected cb func OnUIVendorItemBoughtEvent(evt: ref<UIVendorItemsBoughtEvent>) -> Bool {
    this.m_InventoryManager.ClearInventoryItemDataCache();
	wrappedMethod(evt);
}
@wrapMethod(FullscreenVendorGameController)  
protected cb func OnCraftingComplete(value: Variant) -> Bool {
    this.m_InventoryManager.ClearInventoryItemDataCache();
	wrappedMethod(value);
}
