this.actives_horsecharge <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false,
		SoundOnAttack = [
			"sounds/ambience/buildings/caravan_horse_hooves_00.wav",
			"sounds/ambience/buildings/caravan_horse_hooves_01.wav",
			"sounds/ambience/buildings/caravan_horse_hooves_02.wav",
			"sounds/ambience/buildings/caravan_horse_hooves_03.wav",
			"sounds/ambience/buildings/caravan_horse_hooves_04.wav",
			"sounds/ambience/buildings/caravan_horse_hooves_05.wav",
			"sounds/ambience/buildings/caravan_horse_hooves_06.wav",
			"sounds/ambience/buildings/caravan_horse_hooves_07.wav"
		]
	},
	function create()
	{
		this.m.ID = "actives.horse_charge";
		this.m.Name = "Horse Charge";
		this.m.Description = "A powerful charge towards a target 3 or 4 tiles away. Target should be in straight line. The heavier and the faster you are, the more damage you do.";
		this.m.KilledString = "Smashed";
		this.m.Icon = "skills/active_52.png";
		this.m.IconDisabled = "skills/active_52_sw.png";
		this.m.Overlay = "active_52";
		this.m.SoundOnUse = [
			"sounds/ambience/buildings/caravan_horse_neighing_00.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_01.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_02.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_03.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_04.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_05.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/knockback_hit_01.wav",
			"sounds/combat/knockback_hit_02.wav",
			"sounds/combat/knockback_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.HitChanceBonus = 0;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.MinRange = 2;
		this.m.MaxRange = 3;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local fat = 0;
		local body = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		local head = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

		if (body != null)
		{
			fat = fat - body.getStaminaModifier();
		}

		if (head != null)
		{
			fat = fat - head.getStaminaModifier();
		}

		if (main != null)
		{
			fat = fat - main.getStaminaModifier();
		}

		if (off != null)
		{
			fat = fat - off.getStaminaModifier();
		}

		body = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory).m.ArmorScript;
		head = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory).m.HelmetScript;

		if (body != null)
		{
			fat = fat - body.getStaminaModifier();
		}

		if (head != null)
		{
			fat = fat - head.getStaminaModifier();
		}

		fat = 30 + fat;
		local bonus = this.Math.pow(fat / 15, 0.35) * 100;
		bonus = this.Math.floor(bonus) - 100;
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "Total Weight : " + fat + ""
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/regular_damage.png",
			text = "Damage Bonus : + " + bonus + "% damage"
		});

		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used while rooted[/color]"
			});
		}

		if (main != null)
		{
		if (main.getCategories() == "Polearm, Two-Handed" || main.getCategories() == "Spear, Two-Handed")
		{
		}
		else
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used without Polearm or Two-handed Spear[/color]"
			});
		}
		}

		return ret;
	}

	function isUsable()
	{
		local Mainhand = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

        if (Mainhand != null)
		{
		if (Mainhand.getCategories() == "Polearm, Two-Handed" || Mainhand.getCategories() == "Spear, Two-Handed")
		{
		 if (this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory).m.Ride == true)
		 {			
			return this.skill.isUsable() && !this.getContainer().getActor().getCurrentProperties().IsRooted && !this.m.IsSpent && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
		 }	
		}
		}
	}
	
	function onUpdate( _properties )
	{
		 if (this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory).m.Ride != true)
		 {		
			this.m.IsHidden = true;
	     }
	} 

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsEmpty)
		{
			return false;
		}

		if (this.Math.abs(_targetTile.Level - _originTile.Level) > this.m.MaxLevelDifference)
		{
			return false;
		}

		local myPos = _originTile.Pos;
		local targetPos = _targetTile.Pos;
		local distance = _originTile.getDistanceTo(_targetTile);
		local Dx = (targetPos.X - myPos.X) / distance;
		local Dy = (targetPos.Y - myPos.Y) / distance;

		for( local i = 0; i < distance; i = ++i )
		{
			local x = myPos.X + Dx * i;
			local y = myPos.Y + Dy * i;
			local tileCoords = this.Tactical.worldToTile(this.createVec(x, y));
			local tile = this.Tactical.getTile(tileCoords);

			if (!tile.IsOccupiedByActor && !tile.IsEmpty)
			{
				return false;
			}

			if (tile.hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
			{
				return false;
			}

			if (this.Math.abs(tile.Level - _originTile.Level) > 1)
			{
				return false;
			}
		}

		return true;
	}

	function addResources()
	{
		this.skill.addResources();

		foreach( r in this.m.SoundOnAttack )
		{
			this.Tactical.addResource(r);
		}
	}

	function onUse( _user, _targetTile )
	{
		this.m.IsSpent = true;
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();
		local destTile = [];

		if (_user.getTile().IsVisibleForPlayer || _targetTile.IsVisibleForPlayer)
		{
			local myPos = _user.getPos();
			local targetPos = _targetTile.Pos;
			local distance = _user.getTile().getDistanceTo(_targetTile);
			local Dx = (targetPos.X - myPos.X) / distance;
			local Dy = (targetPos.Y - myPos.Y) / distance;

			for( local i = 0; i < distance; i = ++i )
			{
				local x = myPos.X + Dx * i;
				local y = myPos.Y + Dy * i;
				local tile = this.Tactical.worldToTile(this.createVec(x, y));

				if (this.Tactical.isValidTile(tile.X, tile.Y) && this.Const.Tactical.DustParticles.len() != 0)
				{
					for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, this.Tactical.getTile(tile), this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
					}
					
                    tile = this.Tactical.getTile(tile);
					destTile.push(tile); 
				}
			}
		}

		this.getContainer().setBusy(true);
				
		local dir;	
		destTile.push(_targetTile); 
		local potentialVictims = [];
		
		for( local i = 0; i != 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);

				if (!tile.IsOccupiedByActor)
				{
				}
				else
				{
					local actor2 = tile.getEntity();

					if (actor2.isAlliedWith(actor))
					{
					}
					else
					{
						potentialVictims.push(actor2);
					}
				}
			}
		}		
		
		if (potentialVictims.len() == 0)
		{
		return;
		}

		local target = potentialVictims[this.Math.rand(0, potentialVictims.len() - 1)];
	
		local tag = {
			Skill = this,
			User = _user,
			OldTile = _user.getTile(),
			TargetTile = target.getTile(),
			OnRepelled = this.onRepelled
		};

        local horse = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
		local spmanage = this.getContainer().getActor().getSkills().getSkillByID("effects.warhorsespeed");
		spmanage.m.move = 1;

		for( local i = 0; i < myTile.getDistanceTo(_targetTile); i = i )
		{
			spmanage.m.distance += 1;
			dir = destTile[i].getDirectionTo(destTile[i + 1]);

			if (spmanage.m.dir == null)
			{
				spmanage.m.dir = dir;
			}
			else if (spmanage.m.dir == dir)
			{
				spmanage.m.accel = this.Math.max(0, spmanage.m.accel + 2 - (destTile[i + 1].Level - destTile[i].Level));
				local accel = this.Math.pow(spmanage.m.accel, 0.7);
				accel = this.Math.floor(horse.m.Initiative * 0.25 * accel);
				spmanage.m.speedbonus = this.Math.min(horse.m.Initiative, spmanage.m.speedbonus + accel);
				spmanage.m.dir = dir;
			}
			else if (dir == spmanage.m.dir - 1 || dir == spmanage.m.dir + 1 || dir == spmanage.m.dir + 5 || dir == spmanage.m.dir - 5)
			{
				spmanage.m.accel = this.Math.max(0, spmanage.m.accel - 1 - (destTile[i + 1].Level - destTile[i].Level));
				spmanage.m.speedbonus = this.Math.round(spmanage.m.speedbonus * 0.8);
				spmanage.m.dir = dir;
			}
			else
			{
				spmanage.m.accel = 0;
				spmanage.m.speedbonus = 0;
				spmanage.m.dir = dir;
			}

			i = ++i;
		}

		this.Tactical.getNavigator().teleport(_user, _targetTile, this.onTeleportDone.bindenv(this), tag, false, 3.0);
		return true;
	}

	function onTeleportDone( _entity, _tag )
	{
		local myTile = _entity.getTile();
		local ZOC = [];
		this.getContainer().setBusy(false);

		for( local i = 0; i != 6; i = i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = myTile.getNextTile(i);

				if (!tile.IsOccupiedByActor)
				{
				}
				else
				{
					local actor = tile.getEntity();

					if (actor.isAlliedWith(_entity) || actor.getCurrentProperties().IsStunned)
					{
					}
					else
					{
						ZOC.push(actor);
					}
				}
			}

			i = ++i;
			i = i;
		}

		foreach( actor in ZOC )
		{
			if (!actor.onMovementInZoneOfControl(_entity, true))
			{
				continue;
			}

			if (actor.onAttackOfOpportunity(_entity, true))
			{
				if (_tag.OldTile.IsVisibleForPlayer || myTile.IsVisibleForPlayer)
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_entity) + " charges and is repelled");
				}

				if (!_entity.isAlive() || _entity.isDying())
				{
					return;
				}

				local dir = myTile.getDirectionTo(_tag.OldTile);

				if (myTile.hasNextTile(dir))
				{
					local tile = myTile.getNextTile(dir);

					if (tile.IsEmpty && this.Math.abs(tile.Level - myTile.Level) <= 1 && tile.getDistanceTo(actor.getTile()) > 1)
					{
						_tag.TargetTile = tile;
						this.Time.scheduleEvent(this.TimeUnit.Virtual, 50, _tag.OnRepelled, _tag);
						return;
					}
				}
			}
		}

		this.spawnAttackEffect(_tag.TargetTile, this.Const.Tactical.AttackEffectBash);
		local s = this.m.SoundOnUse;
		this.m.SoundOnUse = this.m.SoundOnAttack;
		this.attackEntity(_entity, _tag.TargetTile.getEntity());
		this.m.SoundOnUse = s;
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onRepelled( _tag )
	{
		this.Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, null, null, false);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local fat = 0;
			local body = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Body);
			local head = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);
			local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

			if (body != null)
			{
				fat = fat - body.getStaminaModifier();
			}

			if (head != null)
			{
				fat = fat - head.getStaminaModifier();
			}

			if (main != null)
			{
				fat = fat - main.getStaminaModifier();
			}

			if (off != null)
			{
				fat = fat - off.getStaminaModifier();
			}

			body = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory).m.ArmorScript;
			head = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory).m.HelmetScript;

			if (body != null)
			{
				fat = fat - body.getStaminaModifier();
			}

			if (head != null)
			{
				fat = fat - head.getStaminaModifier();
			}

			fat = 30 + fat;
			local bonus = this.Math.pow(fat / 15, 0.25);
			_properties.MeleeDamageMult *= bonus;
		}
	}

	function onAdded()
	{
		this.getContainer().getActor().getSkills().add(this.new("scripts/skills/effects/effect_warhorsespeed"));		
	}

	function onRemoved()
	{
		this.getContainer().getActor().getSkills().removeByID("effects.warhorsespeed");			
	}

});

