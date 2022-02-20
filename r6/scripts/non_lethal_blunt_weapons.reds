module NonLethalBluntWeapons

public func QuickMeleeShouldBeNonLethal()     -> Bool { return true; }
public func TwoHandedClubsShouldBeNonLethal() -> Bool { return true; }
public func HammersShouldBeNonLethal()        -> Bool { return true; }

@wrapMethod(DamageSystem)
private final func ConvertDPSToHitDamage(hitEvent: ref<gameHitEvent>) -> Void {
  CheckForWeaponThatShouldBeNonLethal(hitEvent);
    
  wrappedMethod(hitEvent);
}

public func CheckForWeaponThatShouldBeNonLethal(hitEvent: ref<gameHitEvent>) -> Void { 
  let weapon: ref<WeaponObject> = hitEvent.attackData.GetWeapon();
  if !IsDefined(weapon) {
    return;
  }

  let attackType: gamedataAttackType = hitEvent.attackData.GetAttackType();
  if Equals(attackType, gamedataAttackType.QuickMelee) && QuickMeleeShouldBeNonLethal() {
    hitEvent.attackData.AddFlag(hitFlag.Nonlethal, n"");
    return;
  }

  let weaponType: gamedataItemType = WeaponObject.GetWeaponType(weapon.GetItemID());
  
  switch weaponType {
    case gamedataItemType.Wea_Hammer:
      if HammersShouldBeNonLethal() {
        hitEvent.attackData.AddFlag(hitFlag.Nonlethal, n"");
      }
      break;
    case gamedataItemType.Wea_TwoHandedClub:
      if TwoHandedClubsShouldBeNonLethal() {
        hitEvent.attackData.AddFlag(hitFlag.Nonlethal, n"");
      }
      break;
    case gamedataItemType.Wea_OneHandedClub:
    case gamedataItemType.Cyb_StrongArms:
      hitEvent.attackData.AddFlag(hitFlag.Nonlethal, n"");
      break;
    default:
      break;
  }
}
