MoreBloodDecals = { 
    description = ""
}

function MoreBloodDecals:new()

registerForEvent("onInit", function()


	--The following values determine how far from an NPC splatters may spawn
	TweakDB:SetFlat("WeaponFxPackage.Settings.characterDismembermentPiercingMaxDistance", 2)
	TweakDB:SetFlat("WeaponFxPackage.Settings.characterPseudoPiercingMaxDistance", 3)
	TweakDB:SetFlat("WeaponFxPackage.Settings.characterSurroundingDecalsMaxDistance", 2)

	--The following values determine how many splatters may spawn from a single gunshot wound. The actual number of splatters tends to be dramatically lower than the numbers set here.
	TweakDB:SetFlat("WeaponFxPackage.Settings.characterSurroundingDecalsCountMax", 60)
	TweakDB:SetFlat("WeaponFxPackage.Settings.characterSurroundingDecalsCountMin", 30)

	--The following values determine the "spread" of the splatters. Think of it like a paintball shotgun; these parameters determine their direction and spread.
	TweakDB:SetFlat("WeaponFxPackage.Settings.characterSurroundingDecalsDirectionAngle", 200)
	TweakDB:SetFlat("WeaponFxPackage.Settings.characterSurroundingDecalsConeAngle", 200)

	--The following values determine whether splatters spawn offscreen or behind obstacles on surfaces the player can't see
	TweakDB:SetFlat("WeaponFxPackage.Settings.offscreenGuaranteedSpawnRadiusSQ", 90)
	TweakDB:SetFlat("WeaponFxPackage.Settings.chanceToSpawnOffscreenAtMaxRadius", 100)
	TweakDB:SetFlat("WeaponFxPackage.Settings.enableCameraFrustumCulling", false)

	--The following values determine the chance of splatters being spawned on a gunshot, but testing has shown that these values don't seem to have an effect in-game
	TweakDB:SetFlat("BaseStats.BulletSurroundingHitVFxChance.max", 1)
	TweakDB:SetFlat("BaseStats.BulletSurroundingHitVFxChance.min", 0)
	TweakDB:SetFlat("BaseStats.BulletSurroundingHitVFxChanceModifier.value", 0)
	TweakDB:SetFlat("BaseStats.BulletPseudoPierceHitVFxChance.max", 1)
	TweakDB:SetFlat("BaseStats.BulletPseudoPierceHitVFxChance.min", 0)
	TweakDB:SetFlat("BaseStats.BulletPseudoPierceHitVFxChanceModifier.value", 0)

	--The following values change the particle effect that spawns when a hit occurs, so that those weapons actually draw blood instead of dust
	TweakDB:SetFlat("WeaponFxPackage.KatanaFxPackage.vfx_impact_character_flesh_head", "WeaponFxPackage.MaterialFxCharacterFleshHead")
	TweakDB:SetFlat("WeaponFxPackage.KatanaFxPackage.vfx_impact_character_flesh", "WeaponFxPackage.MaterialFxCharacterFlesh")
	TweakDB:SetFlat("WeaponFxPackage.KnifeFxPackage.vfx_impact_character_flesh_head", "WeaponFxPackage.MaterialFxCharacterFleshHead")
	TweakDB:SetFlat("WeaponFxPackage.KnifeFxPackage.vfx_impact_character_flesh", "WeaponFxPackage.MaterialFxCharacterFlesh")
	TweakDB:SetFlat("WeaponFxPackage.MonoWireFxPackage.vfx_impact_character_flesh", "WeaponFxPackage.MaterialFxCharacterFlesh")


	--The following values change the attack type for melee weapons that can dismember, allowing splatters to spawn on dismemberment
	--Katana
	TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack1.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack2.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack3.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack4.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaComboAttackAbstract.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaCrouchAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaDeflectAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaEquipAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaFinalAttack1.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaFinalAttack2.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaFinalAttack3.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaFinalAttack4.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaFinalAttack5.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaFinalAttack6.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaFinalAttackAbstract.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaJumpAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaSafeAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaSprintAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaStrongAttack1.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaStrongAttack2.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaStrongAttack3.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("KatanaAttacks.KatanaStrongAttackAbstract.attackType", "AttackType.Ranged")
	--Monowire
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresComboAttack1.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresComboAttack2.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresComboAttack3.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresComboAttack4.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresComboAttackAbstract.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresCrouchAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresBlockAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresThrowAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresFinalAttack1.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresFinalAttack2.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresFinalAttack3.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresFinalAttack4.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresFinalAttack5.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresFinalAttackAbstract.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresJumpAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresSafeAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresSprintAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresStrongAttack1.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresStrongAttack2.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresStrongAttack3.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresStrongAttack4.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresStrongAttack5.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MonoWiresAttacks.MonoWiresStrongAttackAbstract.attackType", "AttackType.Ranged")
	--MantisBlades
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesComboAttack1.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesComboAttack2.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesComboAttack3.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesComboAttack4.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesComboAttack5.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesComboAttack6.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesComboAttack7.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesComboAttack8.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesComboAttack9.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesComboAttack10.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesComboAttackAbstract.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesBlockAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesCrouchAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesJumpAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesDeflectAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesSprintAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesStrongAttack1.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesStrongAttack2.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesStrongAttackAbstract.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("MantisBladesAttacks.MantisBladesFinalAttackAbstract.attackType", "AttackType.Ranged")
	--OneHandBladeAttacks
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeComboAttack1.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeComboAttack2.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeComboAttack3.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeComboAttack4.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeComboAttackAbstract.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeBlockAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeCrouchAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeDeflectAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeSprintAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeJumpAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeSafeAttack.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeStrongAttack1.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeStrongAttack2.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeStrongAttack3.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeStrongAttackAbstract.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeFinalAttack1.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeFinalAttack2.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeFinalAttack3.attackType", "AttackType.Ranged")
	TweakDB:SetFlat("OneHandBladeAttacks.OneHandBladeFinalAttackAbstract.attackType", "AttackType.Ranged")

	--The following values probably determine how far splatters can spawn from dismemberment, and at what angles
	TweakDB:SetFlat("WeaponFxPackage.MaterialFxCharacterFlesh.pierce_far_distance", 20)
	TweakDB:SetFlat("WeaponFxPackage.MaterialFxCharacterFlesh.pierce_near_distance", 4)
	TweakDB:SetFlat("WeaponFxPackage.MaterialFxCharacterFlesh.reflected_angle_max", 90)
	TweakDB:SetFlat("WeaponFxPackage.MaterialFxCharacterFleshHead.pierce_far_distance", 20)
	TweakDB:SetFlat("WeaponFxPackage.MaterialFxCharacterFleshHead.pierce_near_distance", 4)
	TweakDB:SetFlat("WeaponFxPackage.MaterialFxCharacterFleshHead.reflected_angle_max", 90)

    end)

end

return MoreBloodDecals:new()

 
 
	--Game.ModStatPlayer("Armor", "1000")
	--TweakDB:SetFlat("WeaponFxPackage.KatanaFxPackage.npc_vfx_set", "WeaponFxPackage.PowerShotgun_inline5")
	--TweakDB:SetFlat("WeaponFxPackage.KatanaFxPackage.player_vfx_set", "WeaponFxPackage.PowerShotgun_inline5")
	--TweakDB:SetFlat("Items.Base_Katana.fxPackage", "WeaponFxPackage.PowerHandgun")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack3.className", "Attack_GameEffect")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack3.effectTag", "player_ray")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack3.range", 200)
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack3.radius", 200)
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack3.userDataPath", "Attacks.Bullet_GameEffect")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack2.className", "Attack_GameEffect")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack2.effectTag", "player_ray")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack2.range", 200)
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack2.radius", 200)
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack2.userDataPath", "Attacks.Bullet_GameEffect")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack1.className", "Attack_GameEffect")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack1.effectTag", "player_ray")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack1.range", 200)
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack1.radius", 200)
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack1.userDataPath", "Attacks.Bullet_GameEffect")
	--TweakDB:SetFlat("Attacks.Slash.attackType", "AttackType.Ranged")
	--TweakDB:SetFlat("Attacks.Slash.className", "Attack_GameEffect")
	--TweakDB:SetFlat("Attacks.Slash.effectName", "weaponShoot")
	--TweakDB:SetFlat("Attacks.Slash.effectTag", "player_ray")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack1.radius", 200)
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack1.range", 200)
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack2.range", 200)
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack3.range", 200)
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack1.effectName", "damage_over_time")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack2.effectName", "damage_over_time")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack3.effectName", "damage_over_time")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack4.effectName", "damage_over_time")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack1.effectTag", "default_DOT")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack2.effectTag", "default_DOT")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack3.effectTag", "default_DOT")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack4.effectTag", "default_DOT")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack1.className", "Attack_GameEffect")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack2.className", "Attack_GameEffect")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack3.className", "Attack_GameEffect")
	--TweakDB:SetFlat("KatanaAttacks.KatanaComboAttack4.className", "Attack_GameEffect")
	--TweakDB:SetFlat("WeaponFxPackage.KatanaFxPackage.npc_vfx_set", "WeaponFxPackage.MaterialFxCharacterFlesh")
	--TweakDB:SetFlat("WeaponFxPackage.KatanaFxPackage.player_vfx_set", "WeaponFxPackage.MaterialFxCharacterFlesh")
	--TweakDB:SetFlat("WeaponFxPackage.MaterialFxCharacterFleshHead.pierce_enter", false)
	--TweakDB:SetFlat("WeaponFxPackage.MaterialFxCharacterFleshHead.pierce_exit", false)
	--TweakDB:SetFlat("WeaponFxPackage.MaterialFxCharacterFlesh.pierce_enter", false)
	--TweakDB:SetFlat("WeaponFxPackage.MaterialFxCharacterFlesh.pierce_exit", false)
	--TweakDB:SetFlat("WeaponFxPackage.KatanaFxPackage.vfx_impact_add_enable", true)