module CustomQuickslotsConfig

// There is no longer any user configuration in this file.

enum CustomQuickslotItemType {
  Food = 0,
  Drink = 1,
  Alcohol = 2,
  HealthBooster = 3,
  StaminaBooster = 4,
  MemoryBooster = 5,
  CarryCapacityBooster = 6,
  OxyBooster = 7,
  MaxDoc = 8,
  BounceBack = 9,
  OpticalCamo = 10,
  BloodPump = 11,
  ProjectileLauncher = 12,
  BiohazardGrenade = 13,
  CuttingGrenade = 14,
  EMPGrenade = 15,
  FlashGrenade = 16,
  FragGrenade = 17,
  IncendiaryGrenade = 18,
  OzobsNose = 19,
  ReconGrenade = 20
}

enum GrenadeQuality {
  Regular = 0,
  Sticky = 1,
  Homing = 2
}

public class CustomQuickslot {
  public let keyboardInput: CName;
  public let gamepadInput: CName;
  public let gamepadHoldModifier: CName;
  public let itemType: CustomQuickslotItemType;
  public let grenadeCycle: Bool;
  public let grenadeQuality: GrenadeQuality;
}
