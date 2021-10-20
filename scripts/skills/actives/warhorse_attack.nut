this.warhorse_attack <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.warhorse_kick";
		this.m.Name = "Kick";
		this.m.Description = "";
		this.m.KilledString = "Mangled";
		this.m.Icon = "skills/horse_charge.png";
		this.m.Overlay = "horse_charge";
		this.m.SoundOnUse = [
			"sounds/ambience/buildings/caravan_horse_neighing_00.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_01.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_02.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_03.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_04.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_05.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/bash_hit_01.wav",
			"sounds/combat/bash_hit_02.wav",
			"sounds/combat/bash_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsUsingActorPitch = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 50;
		_properties.DamageRegularMax += 65;
		_properties.DamageArmorMult *= 0.7;
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

