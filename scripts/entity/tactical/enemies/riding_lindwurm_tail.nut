this.riding_lindwurm_tail <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Body = null,
		Body2 = null
	},
	
	function setItem( _i )
	{
		if (typeof _i == "instance")
		{
			this.m.Body = _i;
		}
		else
		{
			this.m.Body = this.WeakTableRef(_i);
		}
	}
	
	function setItem2( _i )
	{
		if (typeof _i == "instance")
		{
			this.m.Body2 = _i;
		}
		else
		{
			this.m.Body2 = this.WeakTableRef(_i);
		}
	}
	
	function onTurnEnd()
	{
	this.actor.onTurnEnd();
	  if (this.m.Body == null)
	  {
	   this.removeFromMap();
	  }
	}

	function getBody()
	{			
		return this.m.Body2;
	}
	
	function setName( _n )
	{
		this.m.Name = _n;
	}

	function getName()
	{
		return this.m.Name;
	}
	
	function getInitiative()
	{
		return this.m.Body2 != null ? this.m.Body2.getInitiative() - 1 : 0;
	}	
	
	function getIdealRange()
	{
		return 1;
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);		
	}

	function create()
	{
		this.m.Type = this.Const.EntityType.Lindwurm;
		this.m.BloodType = this.Const.BloodType.Green;
		this.m.XP = this.Const.Tactical.Actor.Lindwurm.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(-10, -25);
		this.m.DecapitateBloodAmount = 1.0;
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/lindwurm_hurt_01.wav",
			"sounds/enemies/lindwurm_hurt_02.wav",
			"sounds/enemies/lindwurm_hurt_03.wav",
			"sounds/enemies/lindwurm_hurt_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/lindwurm_idle_01.wav",
			"sounds/enemies/lindwurm_idle_02.wav",
			"sounds/enemies/lindwurm_idle_03.wav",
			"sounds/enemies/lindwurm_idle_04.wav",
			"sounds/enemies/lindwurm_idle_05.wav",
			"sounds/enemies/lindwurm_idle_06.wav",
			"sounds/enemies/lindwurm_idle_07.wav",
			"sounds/enemies/lindwurm_idle_08.wav",
			"sounds/enemies/lindwurm_idle_09.wav",
			"sounds/enemies/lindwurm_idle_10.wav",
			"sounds/enemies/lindwurm_idle_11.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Attack] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 1.5;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Attack] = 2.0;
		this.m.SoundPitch = this.Math.rand(95, 105) * 0.01;
		this.getFlags().add("body_immune_to_acid");
		this.getFlags().add("head_immune_to_acid");
		this.getFlags().add("lindwurm");
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/lindwurm_tail_agent");
		this.m.AIAgent.setActor(this);			
	}

	function playAttackSound()
	{
		this.playSound(this.Const.Sound.ActorEvent.Attack, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Attack] * (this.Math.rand(75, 100) * 0.01), this.m.SoundPitch * 1.15);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			local flip = this.Math.rand(0, 100) < 50;
			local decal;
			this.m.IsCorpseFlipped = flip;
			local body = this.getSprite("body");
			decal = _tile.spawnDetail("bust_lindwurm_tail_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;
			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = "A Lindwurm";
			corpse.IsHeadAttached = true;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function checkMorale( _change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false )
	{
		this.m.Body2.checkMorale(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
	}

	function kill( _killer = null, _skill = null, _fatalityType = this.Const.FatalityType.None, _silent = false )
	{
		this.actor.kill(_killer, _skill, _fatalityType, _silent);

		if (this.m.Body != null && !this.m.Body.isNull())
		{
			this.m.Body.ondogdied(_killer, _skill, null);
			this.m.Body = null;
		}
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Lindwurm);
		b.IsAffectedByNight = false;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsMovable = false;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToRoot = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_lindwurm_tail_0" + this.Math.rand(1, 1));

		if (this.Math.rand(0, 100) < 90)
		{
			body.varySaturation(0.2);
		}

		if (this.Math.rand(0, 100) < 90)
		{
			body.varyColor(0.08, 0.08, 0.08);
		}

		local head = this.addSprite("head");
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_lindwurm_tail_01_injured");
		local body_blood = this.addSprite("body_blood");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", this.createVec(0, 0));
		this.m.Skills.add(this.new("scripts/skills/racial/lindwurm_racial"));
		this.m.Skills.add(this.new("scripts/skills/actives/actives_tail_slam_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/actives_tail_slam_big_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/tail_slam_split_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/tail_slam_zoc_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/move_tail_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_reach_advantage"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
	}	
	
	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
		
		if (this.isAlive())
		{
		this.m.Body.get().m.Hitpoints = this.m.Hitpoints;
        this.m.Body.get().m.Acondition = this.m.BaseProperties.Armor[0];
        this.m.Body.get().m.Hcondition = this.m.BaseProperties.Armor[1];
		this.m.Body.get().Changeappearance();
		}
	}
	
});

