local gt = this.getroottable();

gt.Const.Tactical.Actor.Warhorse <- {
	XP = 75,
	ActionPoints = 12,
	Hitpoints = 150,
	Bravery = 60,
	Stamina = 150,
	MeleeSkill = 60,
	RangedSkill = 0,
	MeleeDefense = 10,
	RangedDefense = 10,
	Initiative = 150,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	Armor = [
		0,
		0
	],
	FatigueRecoveryRate = 20
};

gt.Const.Tactical.Actor.Warwolf <- {
	XP = 400,
	ActionPoints = 12,
	Hitpoints = 220,
	Bravery = 90,
	Stamina = 250,
	MeleeSkill = 80,
	RangedSkill = 0,
	MeleeDefense = 10,
	RangedDefense = 10,
	Initiative = 160,
	FatigueEffectMult = 1.0,
	MoraleEffectMult = 1.0,
	FatigueRecoveryRate = 25,
	Armor = [
		60,
		60
	]
};

gt.Const.accelvariant <- [
	0,
	1,
	1,
	0.8,
	0.7,
	0.6,
	0.5,
	0.7,
	0.5
];

gt.Const.Tactical.Magical<- {

	function onApplyFire( _tile, _entity )
	{
		if (_entity.getCurrentProperties().IsImmuneToFire)
		{
			return;
		}

		this.Tactical.spawnIconEffect("status_effect_116", _tile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
		local sounds = [
			"sounds/combat/dlc6/status_on_fire_01.wav",
			"sounds/combat/dlc6/status_on_fire_02.wav",
			"sounds/combat/dlc6/status_on_fire_03.wav"
		];
		this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Actor, _entity.getPos());
		local damageMult = 1.0;

		if (_entity.getType() == this.Const.EntityType.Schrat)
		{
			damageMult = 3.0;
		}

		if (_entity.getFlags().has("undead") && !_entity.getFlags().has("skeleton"))
		{
			damageMult = 2.0;
		}
		
		if (_entity.getSkills().hasSkill("racial.skeleton"))
		{
			damageMult = 0.33;
		}

		if (_entity.getSkills().hasSkill("items.firearms_resistance") || _entity.getSkills().hasSkill("racial.serpent"))
		{
			damageMult = 0.66;
		}

		local damage = this.Math.rand(25, 40);
		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = damage * damageMult;
		hitInfo.DamageArmor = damage;
		hitInfo.DamageDirect = 0.2;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		hitInfo.Injuries = this.Const.Injury.Burning;
		hitInfo.IsPlayingArmorSound = false;
		_entity.onDamageReceived(_entity, null, hitInfo);

		if ((!_entity.isAlive() || _entity.isDying()) && !_entity.isPlayerControlled() && (_tile.Properties.Effect == null || _tile.Properties.Effect.IsByPlayer))
		{
			this.updateAchievement("BurnThemAll", 1, 1);
		}
	}
	
};
	