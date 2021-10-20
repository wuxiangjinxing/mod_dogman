this.riding_warhorse <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Item = null,
		Name = "Warhorse"
	},
	function setItem( _i )
	{
		if (typeof _i == "instance")
		{
			this.m.Item = _i;
		}
		else
		{
			this.m.Item = this.WeakTableRef(_i);
		}
	}

	function setName( _n )
	{
		this.m.Name = _n;
	}

	function getName()
	{
		return this.m.Name;
	}

	function create()
	{
		this.m.Type = this.Const.EntityType.Wardog;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Wardog.XP;
		this.m.IsActingImmediately = true;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(-4, -25);
		this.m.DecapitateBloodAmount = 0.5;
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/ambience/buildings/caravan_horse_neighing_00.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_01.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_02.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_03.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_04.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/misc/donkey_death_02.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/misc/donkey_hurt_01.wav",
			"sounds/misc/donkey_hurt_02.wav",
			"sounds/misc/donkey_hurt_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/misc/donkey_idle_02.wav",
			"sounds/misc/donkey_idle_03.wav",
			"sounds/misc/donkey_idle_04.wav",
			"sounds/misc/donkey_idle_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = [
			"sounds/ambience/buildings/caravan_horse_hooves_00.wav",
			"sounds/ambience/buildings/caravan_horse_hooves_01.wav",
			"sounds/ambience/buildings/caravan_horse_hooves_02.wav",
			"sounds/ambience/buildings/caravan_horse_hooves_03.wav",
			"sounds/ambience/buildings/caravan_horse_hooves_04.wav",
			"sounds/ambience/buildings/caravan_horse_hooves_05.wav",
			"sounds/ambience/buildings/caravan_horse_hooves_06.wav",
			"sounds/ambience/buildings/caravan_horse_hooves_07.wav"
		];
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/wardog_agent");
		this.m.AIAgent.setActor(this);
	}

	function setVariant( _v )
	{
		this.m.Items.getAppearance().Body = "bust_horsenaked_body_10" + _v;
		this.getSprite("body").setBrush("bust_horsenaked_body_10" + _v);
		this.getSprite("head").setBrush("bust_horsehead_10" + _v);
		this.setDirty(true);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			local flip = this.Math.rand(0, 100) < 50;
			local appearance = this.getItems().getAppearance();
			local decal;
			this.m.IsCorpseFlipped = flip;
			decal = _tile.spawnDetail(this.getSprite("body").getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.setBrightness(0.9);
			decal.Scale = 0.95;

			if (appearance.CorpseArmor != "")
			{
				decal = _tile.spawnDetail(appearance.CorpseArmor, this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.setBrightness(0.9);
				decal.Scale = 0.95;
			}
			else if(this.hasSprite("Capa"))
			{
				decal = _tile.spawnDetail(this.getSprite("Capa").getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.setBrightness(0.9);
				decal.Scale = 0.95;			     
			}

			if (_fatalityType != this.Const.FatalityType.Decapitated)
			{
				decal = _tile.spawnDetail(this.getSprite("head").getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.setBrightness(0.9);
				decal.Scale = 0.95;
			}
			else if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [
					this.getSprite("head").getBrush().Name + "_dead"
				];
				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-15, 5), 0.0, "bust_head_dead_bloodpool");
				decap[0].setBrightness(0.9);
				decap[0].Scale = 0.95;
				decap[0].setHorizontalFlipping(true);
			}

			if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				_tile.spawnDetail(this.getSprite("body").getBrush().Name + "_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				_tile.spawnDetail(this.getSprite("body").getBrush().Name + "_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
			}

			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			corpse.IsResurrectable = false;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		if (this.m.Item != null && !this.m.Item.isNull())
		{
			this.m.Item.setEntity(null);

			if (this.m.Item.getContainer() != null)
			{
				if (this.m.Item.getCurrentSlotType() == this.Const.ItemSlot.Bag)
				{
					this.m.Item.getContainer().removeFromBag(this.m.Item.get());
				}
				else
				{
					this.m.Item.get().removeSelf();
				}
			}

			this.m.Item = null;
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = !this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("armor").setHorizontalFlipping(flip);
		this.getSprite("helmet").setHorizontalFlipping(flip);		
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		this.getSprite("injury_body").setHorizontalFlipping(flip);		

		if (!this.Tactical.State.isScenarioMode())
		{
			local f = this.World.FactionManager.getFaction(this.getFaction());

			if (f != null)
			{
				this.getSprite("socket").setBrush(f.getTacticalBase());
			}
		}
		else
		{
			this.getSprite("socket").setBrush(this.Const.FactionBase[this.getFaction()]);
		}
	}

	function onActorKilled( _actor, _tile, _skill )
	{
		this.actor.onActorKilled(_actor, _tile, _skill);

		if (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local XPgroup = _actor.getXPValue();
			local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

			foreach( bro in brothers )
			{
				bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
			}
		}
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Warhorse);
		b.TargetAttractionMult = 0.1;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		local variant = this.Math.rand(1, 4);
		this.m.Items.getAppearance().Body = "bust_horsenaked_body_10" + variant;
		this.setAlwaysApplySpriteOffset(true);
		this.addSprite("socket").setBrush("bust_base_player");
		local body = this.addSprite("body");
		body.setBrush("bust_horsenaked_body_10" + variant);
		local armor = this.addSprite("armor");
		this.addSprite("head").setBrush("bust_horsehead_10" + variant);
		local helmet = this.addSprite("helmet");
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_horsehead_100_injured");
		local injury_body = this.addSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_horsenaked_body_100_injured");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.46;
		this.setSpriteOffset("status_rooted", this.createVec(8, -15));
		this.setSpriteOffset("status_stunned", this.createVec(0, -25));
		this.setSpriteOffset("arrow", this.createVec(0, -25));
		this.setSpriteOffset("arrow", this.createVec(0, -25));
		this.m.Skills.add(this.new("scripts/skills/actives/warhorse_attack"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
		
		if (this.isAlive())
		{
		this.m.Item.get().m.Hitpoints = this.m.Hitpoints;

		if (this.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
		{
			this.m.Item.get().m.Acondition = this.getItems().getItemAtSlot(this.Const.ItemSlot.Body).m.Condition;
		}

		if (this.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
		{
			this.m.Item.get().m.Hcondition = this.getItems().getItemAtSlot(this.Const.ItemSlot.Head).m.Condition;
		}
		}
	}

});

