@replaceMethod(CraftingSystem)
public final const func GetItemFinalUpgradeCost(itemData: wref<gameItemData>) -> array<IngredientData> {
    let i: Int32;
    let ingredients: array<IngredientData>;
    let tempStat: Float;
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    let upgradeNumber: Float = itemData.GetStatValueByType(gamedataStatType.WasItemUpgraded);
    upgradeNumber += 1.00;
    ingredients = this.GetItemBaseUpgradeCost(itemData.GetItemType(), RPGManager.GetItemQuality(itemData));
    i = 0;
    while i < ArraySize(ingredients) {
      // Start of change
      // Replacing the following line to use a fixed upgradeNumber.
      // ingredients[i].quantity = ingredients[i].quantity * Cast<Int32>(upgradeNumber);
      ingredients[i].quantity = ingredients[i].quantity * Cast<Int32>(8.00);
      // End of change
      ingredients[i].baseQuantity = ingredients[i].quantity;
      i += 1;
    };
    tempStat = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_playerCraftBook.GetOwner().GetEntityID()), gamedataStatType.UpgradingCostReduction);
    if tempStat > 0.00 {
      i = 0;
      while i < ArraySize(ingredients) {
        ingredients[i].quantity = Cast<Int32>(Cast<Float>(ingredients[i].quantity) * (1.00 - tempStat));
        i += 1;
      };
    };
    return ingredients;
  }
