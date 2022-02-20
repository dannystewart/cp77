@replaceMethod(DamageSystem)
public final func ProcessArmor(hitEvent: ref<gameHitEvent>) -> Void {
  let statsSystem: ref<StatsSystem>;
  let damageReductionPerArmorPoint: Float;
  let attacksPerSec: Float;
  let armorPoints: Float;
  let effectiveReduction: Float;
  let weapon: wref<WeaponObject>;
  let instigator: wref<GameObject>;
  let attackValues: array<Float>;
  let i: Int32;
  let reducedValue: Float;
  weapon = hitEvent.attackData.GetWeapon();
  if weapon != null && WeaponObject.CanIgnoreArmor(weapon) {
    return ;
  };
  if instigator.IsPlayer() || weapon == null {
    return ;
  };

  statsSystem = GameInstance.GetStatsSystem(hitEvent.target.GetGame());
  instigator = hitEvent.attackData.GetInstigator();
  if instigator.IsPlayer() && weapon != null {
    attacksPerSec = statsSystem.GetStatValue(Cast(weapon.GetEntityID()), gamedataStatType.AttacksPerSecond);
  } else {
    if instigator != null {
      attacksPerSec = statsSystem.GetStatValue(Cast(instigator.GetEntityID()), gamedataStatType.TBHsBaseSourceMultiplierCoefficient);
    };
  };
  
  // get dps for calculation in the loop below
  let level: Float = GameInstance.GetStatsSystem(hitEvent.target.GetGame()).GetStatValue(Cast(instigator.GetEntityID()), gamedataStatType.PowerLevel);
  let dps: Float = GameInstance.GetStatsDataSystem(hitEvent.target.GetGame()).GetValueFromCurve(n"puppet_powerLevelToDPS", level, n"puppet_powerLevelToDPS");
  
  armorPoints = statsSystem.GetStatValue(Cast(hitEvent.target.GetEntityID()), gamedataStatType.Armor);
  attackValues = hitEvent.attackComputed.GetAttackValues();
  i = 0;
  while i < ArraySize(attackValues) {
    if attackValues[i] > 0.00 {
      
      // Use our own attacksPerSec value based on the NPC's intended DPS.
      // The devs named this variable attacksPerSec but it's actually secs per attack. If it were really attacks per sec it should be divided not multiplied.
      // ALSO, the values have no relation to actual seconds of game play. They kind of consistantly use DPS everywhere,
      // like if one enemy has 2x DPS of another they do twice the damage per hit with the same weapon, but the values don't make sense for the amount of time between attacks.
      if !instigator.IsPlayer() && dps > 0.0 {
        // A stat curve value would have to chanage for DPS to be 0, so very unlikely, but probably best to check.
        attacksPerSec = attackValues[i] / dps;
      }

      reducedValue = attackValues[i] - TweakDBInterface.GetFloat(t"Constants.DamageSystem.dpsReductionPerArmorPoint", 1.00) * armorPoints * attacksPerSec;
      if reducedValue < 1.00 {
        reducedValue = 1.00;
      };
      attackValues[i] = reducedValue;
    };
    i += 1;
  };
  hitEvent.attackComputed.SetAttackValues(attackValues);
}
