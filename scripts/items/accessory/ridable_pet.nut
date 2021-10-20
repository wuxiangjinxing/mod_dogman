this.ridable_pet <- this.inherit("scripts/items/accessory/accessory", {
	m = {
		Skill = null,
		Entity = null,
		Script = "scripts/entity/tactical/riding_warhorse",
		Type = this.Const.Tactical.Actor.Warhorse,	
		Ride = false,
		Bodysprite = "bust_horsenaked_body_10",		
		Headsprite = "bust_horsehead_10",	
		Injuheadprite = "bust_horsehead_100_injured",			
		Injubodysprite = "bust_horsenaked_body_100_injured",			
		Rideroffset = this.createVec(-3, 5),
		Petoffset = this.createVec(10, -25),
		Weaponoffset = this.createVec(-3, 5),
		Shieldoffset = this.createVec(-3, 5),
		RiderRoffset = this.createVec(3, 5),
		PetRoffset = this.createVec(-10, -25),	
		WeaponRoffset = this.createVec(3, 5),
		ShieldRoffset = this.createVec(3, 5),		
		ArmorScript = null,
		Armorvariant = null,
		Capavariant = 0,
		HelmetScript = null,
		Helmetvariant = null,		
		AconditionMax = 0,
		Acondition = 0,
		HconditionMax = 0,
		Hcondition = 0,
		Base = [
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0
		],
		Hitpoints = 0,
		Fatigue = 0,
		Fatigue2 = 0,
		Initiative = 0,
		Initiative2 = 0,
		Days = 0,
		LastSound = "",
		UnleashSounds = [],
		DamageReceived = [],
		Death = [],
		Efaction = null,
		OriginalAgent = null,	
        Haspathfiner = false	
		ShakeCharacterLayers = [
			[
				"dddog",
				"dddog3",
			],
			[
				"dddog2",
				"dddog5",
			]
	    ]
	}, 
	function randomize()
	{
		local type = this.m.Type;
		this.m.Base[0] = this.Math.floor(type.ActionPoints * this.Math.rand(85, 115) / 100);
		this.m.Base[1] = this.Math.floor(type.Hitpoints * this.Math.rand(85, 115) / 100);
		this.m.Base[2] = this.Math.floor(type.Bravery * this.Math.rand(85, 115) / 100);
		this.m.Base[3] = this.Math.floor(type.Stamina * this.Math.rand(85, 115) / 100);
		this.m.Base[4] = this.Math.floor(type.MeleeSkill * this.Math.rand(85, 115) / 100);
		this.m.Base[5] = this.Math.floor(type.RangedSkill * this.Math.rand(85, 115) / 100);
		this.m.Base[6] = this.Math.floor(type.MeleeDefense * this.Math.rand(85, 115) / 100);
		this.m.Base[7] = this.Math.floor(type.RangedDefense * this.Math.rand(85, 115) / 100);
		this.m.Base[8] = this.Math.floor(type.Initiative * this.Math.rand(85, 115) / 100);
		this.m.Base[9] = this.Math.floor(type.FatigueRecoveryRate * this.Math.rand(85, 115) / 100);
		this.m.Hitpoints = this.m.Base[1];
		this.m.Fatigue2 = this.m.Base[3];
		this.m.Initiative2 = this.m.Base[8];
	}

	function isAllowedInBag()
	{
		return false;
	}

	function getScript()
	{
		return this.m.Script;
	}

	function getArmorScript()
	{
		return this.m.ArmorScript;
	}

	function getHelmetScript()
	{
		return this.m.HelmetScript;
	}

	function isUnleashed()
	{
		return this.m.Entity != null;
	}

	function getName()
	{
		return this.item.getName();
	}

	function setName( _n )
	{
		this.m.Name = _n;
	}

	function getDescription()
	{
		return this.item.getDescription();
	}

	function create()
	{
		this.accessory.create();	
		this.m.Variant = this.Math.rand(0, 7);
		this.updateVariant();
		this.m.ID = "accessory.ridable_pet";
		this.m.Name = "Pet";
		this.m.Description = "";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = false;
		this.m.IsChangeableInBattle = false;
		this.m.Value = 200;
		this.randomize();
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.m.SlotType == this.Const.ItemSlot.Accessory)
		{
			result.push({
				id = 64,
				type = "text",
				text = "Worn in Accessory Slot"
			});
		}
		else
		{
			result.push({
				id = 64,
				type = "text",
				text = "Carried in Bag"
			});
		}

		result.push({
			id = 65,
			type = "text",
			text = "Usable in Combat"
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 4,
			type = "progressbar",
			icon = "ui/icons/armor_head.png",
			value = this.m.Hcondition,
			valueMax = this.m.HconditionMax,
			text = "" + this.m.Hcondition + " / " + this.m.HconditionMax + "",
			style = "armor-head-slim"
		});
		result.push({
			id = 4,
			type = "progressbar",
			icon = "ui/icons/armor_body.png",
			value = this.m.Acondition,
			valueMax = this.m.AconditionMax,
			text = "" + this.m.Acondition + " / " + this.m.AconditionMax + "",
			style = "armor-body-slim"
		});
		result.push({
			id = 5,
			type = "progressbar",
			icon = "ui/icons/health.png",
			value = this.m.Hitpoints,
			valueMax = this.m.Base[1],
			text = "" + this.m.Hitpoints + " / " + this.m.Base[1] + "",
			style = "hitpoints-slim"
		});
		result.push({
			id = 5,
			type = "progressbar",
			icon = "ui/icons/fatigue.png",
			value = this.m.Fatigue,
			valueMax = this.m.Fatigue2,
			text = "" + this.m.Fatigue + " / " + this.m.Fatigue2 + "",
			style = "fatigue-slim"
		});
		local bra = this.m.Base[2];
		local ini = this.m.Initiative2;
		local mes = this.m.Base[4];
		local ras = this.m.Base[5];
		local med = this.m.Base[6];
		local rad = this.m.Base[7];
		local rec = this.m.Base[9];
		local spacebra;
		local spacemes;
		local spaceras;

		if (bra < 10 || mes < 10 || ras < 10)
		{
			spacebra = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
			spacemes = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
			spaceras = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		}
		else
		{
			spacebra = "&nbsp;&nbsp;&nbsp;&nbsp;";
			spacemes = "&nbsp;&nbsp;&nbsp;&nbsp;";
			spaceras = "&nbsp;&nbsp;&nbsp;&nbsp;";

			if (bra < 10 || mes < 10 || ras < 10)
			{
				spacebra = spacebra + "&nbsp;&nbsp;";
				spacemes = spacemes + "&nbsp;&nbsp;";
				spaceras = spaceras + "&nbsp;&nbsp;";
			}
		}

		if (bra < 10)
		{
			spacebra = spacebra + "&nbsp;&nbsp;";
			spacemes = spacemes + "&nbsp;&nbsp;";
			spaceras = spaceras + "&nbsp;&nbsp;";
		}
		else if (bra >= 10)
		{
			spacemes = spacemes + "&nbsp;&nbsp;";
			spaceras = spaceras + "&nbsp;&nbsp;";

			if (bra >= 100)
			{
				spacemes = spacemes + "&nbsp;&nbsp;";
				spaceras = spaceras + "&nbsp;&nbsp;";

				if (bra >= 1000)
				{
					spacemes = spacemes + "&nbsp;&nbsp;";
					spaceras = spaceras + "&nbsp;&nbsp;";
				}
			}
		}

		if (mes < 10)
		{
			spacebra = spacebra + "&nbsp;&nbsp;";
			spacemes = spacemes + "&nbsp;&nbsp;";
			spaceras = spaceras + "&nbsp;&nbsp;";
		}
		else if (mes >= 10)
		{
			spacebra = spacebra + "&nbsp;&nbsp;";
			spaceras = spaceras + "&nbsp;&nbsp;";

			if (mes >= 100)
			{
				spacebra = spacebra + "&nbsp;&nbsp;";
				spaceras = spaceras + "&nbsp;&nbsp;";
			}
		}

		if (ras < 10)
		{
			spacebra = spacebra + "&nbsp;&nbsp;";
			spacemes = spacemes + "&nbsp;&nbsp;";
			spaceras = spaceras + "&nbsp;&nbsp;";
		}
		else if (ras >= 10)
		{
			spacebra = spacebra + "&nbsp;&nbsp;";
			spacemes = spacemes + "&nbsp;&nbsp;";

			if (ras >= 100)
			{
				spacebra = spacebra + "&nbsp;&nbsp;";
				spacemes = spacemes + "&nbsp;&nbsp;";
			}
		}

		result.push({
			id = 9,
			type = "text",
			text = "[img]gfx/ui/icons/action_points.png[/img] Action Points : " + this.m.Base[0] + ""
		});
		result.push({
			id = 9,
			type = "text",
			text = "[img]gfx/ui/icons/bravery.png[/img] " + bra + spacebra + "[img]gfx/ui/icons/initiative.png[/img] " + ini + ""
		});
		result.push({
			id = 9,
			type = "text",
			text = "[img]gfx/ui/icons/melee_skill.png[/img] " + mes + spacemes + "[img]gfx/ui/icons/melee_defense.png[/img] " + med + ""
		});
		result.push({
			id = 9,
			type = "text",
			text = "[img]gfx/ui/icons/ranged_skill.png[/img] " + ras + spaceras + "[img]gfx/ui/icons/ranged_defense.png[/img] " + rad + ""
		});
		result.push({
			id = 9,
			type = "text",
			text = "[img]gfx/ui/icons/fatigue.png[/img] Fatigue Recovery 1 turn : " + rec + ""
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play(this.m.DamageReceived[this.Math.rand(0, this.m.DamageReceived.len() - 1)], this.Const.Sound.Volume.Inventory);
	}

	function updateVariant()
	{
		this.setEntity(this.m.Entity);
	}

	function setEntity( _e )
	{
		this.m.Entity = _e;
		this.m.Icon = "tools/" + this.m.Bodysprite + "" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.accessory.onEquip();	
		this.m.Efaction = this.getContainer().getActor().getFaction();
		if (this.m.Ride == true)
		{
		this.onRide();
		}
	}
	
	function onUnequip()
	{
		this.accessory.onUnequip();	
		if (this.m.Ride == true)
		{
		this.offRide();
		}	
	}

	function removearmor()
	{
		if (this.m.Capavariant != 0 && this.World.Assets.getStash().hasEmptySlot())
		{
					local bbb = this.new("scripts/items/armor/special/warhorse_app_caparison");
					bbb.m.Variant = this.m.Capavariant;
                    bbb.updateVariant();					
					this.World.Assets.getStash().add(bbb);	
					this.m.Capavariant = 0;
		}
		if (this.m.ArmorScript != null && this.World.Assets.getStash().hasEmptySlot())
		{
			for( local i = 1; i < 14; i = i )
			{
				if (this.m.ArmorScript.getID() == this.new("scripts/items/armor/special/warhorse_armor_0" + i).getID())
				{
					local bbb = this.new("scripts/items/armor/special/warhorse_armor_0" + i + "_upgrade");
					bbb.m.Variant = this.m.Armorvariant;
                    bbb.updateVariant();	
					bbb.m.Condition = this.m.Acondition;
					this.World.Assets.getStash().add(bbb);	
					this.m.ArmorScript = null;
		            this.m.Armorvariant = null;
					this.m.Acondition = 0;
					this.m.AconditionMax = 0;
					break;					
				}

				i = ++i;
			}		
		}
		if (this.m.HelmetScript != null && this.World.Assets.getStash().hasEmptySlot())
		{
			for( local i = 1; i < 14; i = i )
			{
				if (this.m.HelmetScript.getID() == this.new("scripts/items/armor/special/warhorse_helmet_0" + i).getID())
				{
					local bbb = this.new("scripts/items/armor/special/warhorse_helmet_0" + i + "_upgrade");	
					bbb.m.Variant = this.m.Helmetvariant;
                    bbb.updateVariant();	
					bbb.m.Condition = this.m.Hcondition;
					this.World.Assets.getStash().add(bbb);	
					this.m.HelmetScript = null;
		            this.m.Helmetvariant = null;
					this.m.Hcondition = 0;
					this.m.HconditionMax = 0;
					break;					
				}

				i = ++i;
			}		
		}		
	}

	function onCombatFinished()
	{
		this.setEntity(null);
        this.m.Ride = true;  			
		this.m.Initiative = this.m.Initiative2;
		this.m.Fatigue = 0;
	}

	function onActorDied( _onTile )
	{
		if (!this.isUnleashed() && _onTile != null)
		{
		    this.m.Ride = false;
			local Pct = this.m.Hitpoints / this.m.Base[1];
			local entity = this.Tactical.spawnEntity(this.getScript(), _onTile.Coords.X, _onTile.Coords.Y);		
			entity.setItem(this);
			entity.setName(this.getName());
			entity.setVariant(this.getVariant());
			entity.m.BaseProperties.Hitpoints = this.m.Base[1];
			entity.setFatigue(this.m.Fatigue);
			entity.m.BaseProperties.ActionPoints = this.m.Base[0];
			entity.m.BaseProperties.Bravery = this.m.Base[2];
			entity.m.BaseProperties.Stamina = this.m.Base[3];
			entity.setHitpointsPct(Pct);
			entity.m.BaseProperties.MeleeSkill = this.m.Base[4];
			entity.m.BaseProperties.RangedSkill = this.m.Base[5];
			entity.m.BaseProperties.MeleeDefense = this.m.Base[6];
			entity.m.BaseProperties.RangedDefense = this.m.Base[7];
			entity.m.BaseProperties.Initiative = this.m.Base[8];
			entity.m.BaseProperties.FatigueRecoveryRate = this.m.Base[9];
			entity.m.Skills.update()
		    entity.setDirty(true);				
			this.setEntity(entity);
			if (this.m.Efaction == this.Const.Faction.Player)
			{
			entity.setFaction(this.Const.Faction.PlayerAnimals);
			}
			else
			{
			entity.setFaction(this.m.Efaction);
			}

			if (this.m.ArmorScript != null)
			{
				local item = this.m.ArmorScript;
				item.setCondition(this.m.Acondition);
				if (this.m.Capavariant != 0)
				{
				item.m.Variant = this.m.Capavariant;
				item.updateVariant2();				
				}
				else
				{
				item.m.Variant = this.m.Armorvariant;
				item.updateVariant();
				}
				entity.getItems().equip(item);
			}
			else if (this.m.Capavariant != 0)
			{
			local variant = this.m.Capavariant > 9 ? this.m.Variant : "0" + this.m.Capavariant;	
			entity.addSprite("Capa").setBrush("horse_armor_capa_" + variant);					
			}
			
			if (this.m.HelmetScript != null)
			{
				entity.setSpriteOffset("helmet", this.createVec(15, -13));
				local item = this.m.HelmetScript;			
				item.setCondition(this.m.Hcondition);
				item.m.Variant = this.m.Helmetvariant;
				item.updateVariant();				
				entity.getItems().equip(item);
			}

			if (!this.World.getTime().IsDaytime)
			{
				entity.getSkills().add(this.new("scripts/skills/special/night_effect"));
			}

			this.Sound.play(this.m.UnleashSounds[this.Math.rand(0, this.m.UnleashSounds.len() - 1)], this.Const.Sound.Volume.Skill, _onTile.Pos);
		}
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		local s;

		do
		{
			s = _type[this.Math.rand(0, _type.len() - 1)];
		}
		while (this.m.LastSound == s && _type.len() > 1);

		this.Sound.play(s, _volume, this.getContainer().getActor().getTile(), _pitch);
		this.m.LastSound = s;
	}

	function ChangeEquip()
	{
	     local fat = 0;
		 
			if (this.m.ArmorScript != null)
			{
                fat = fat + this.m.ArmorScript.m.StaminaModifier;
			}
			if (this.m.HelmetScript != null)
			{	
                fat = fat + this.m.HelmetScript.m.StaminaModifier;			
			}
		
		this.m.Fatigue2 = this.m.Base[3] + fat;
		this.m.Initiative2 = this.m.Base[8] + fat;	
	}

	function onHorseDamageReceived( _attacker, _skill, _hitInfo )
	{
		local actor = this.getContainer().getActor();

		if ((_hitInfo.DamageRegular + _hitInfo.DamageArmor) / 2 == 0)
		{
			return;
		}

		local armordamage = this.Math.round(_hitInfo.DamageArmor);
		local regulardamage = this.Math.round(_hitInfo.DamageRegular);
		local regulardamagewitharmor1 = this.Math.round(_hitInfo.DamageDirect * _hitInfo.DamageRegular);
		this.m.Fatigue = this.Math.min(this.m.Fatigue2, this.m.Fatigue + 4);
		this.m.Initiative = this.m.Initiative2 - this.m.Fatigue;
		local armorHitSound;
		local Hdamage;
		local random = this.Math.rand(1, 100);

		if (random <= 15)
		{
			regulardamage = this.Math.round(_hitInfo.DamageRegular * 1.5);
			regulardamagewitharmor1 = this.Math.round(_hitInfo.DamageDirect * _hitInfo.DamageRegular * 1.5);

			if (this.m.Hcondition > 1)
			{
			
			if (this.m.HelmetScript != null)
			{
			armorHitSound = this.m.HelmetScript.m.ImpactSound;
			}
			else
			{
			armorHitSound = this.m.DamageReceived;			
			}
			
				if (armordamage < this.m.Hcondition)
				{
					this.m.Hcondition -= armordamage;
					this.m.Hitpoints -= this.Math.max(0, this.Math.round(regulardamagewitharmor1 - this.m.Hcondition / 10));
					Hdamage = this.Math.max(0, this.Math.round(regulardamagewitharmor1 - this.m.Hcondition / 10));
					this.Sound.play(armorHitSound[this.Math.rand(0, armorHitSound.len() - 1)], this.Const.Sound.Volume.ActorArmorHit, actor.getTile().Pos);
					this.Tactical.EventLog.log("" + this.getName() + "\'s Head armor is hit for " + armordamage + " damage.");
					this.Changeappearance();
				}
				else if (armordamage == this.m.Hcondition)
				{
					this.m.Hcondition = 0;
					this.m.Hitpoints -= regulardamagewitharmor1;
					Hdamage = regulardamagewitharmor1;
					this.Sound.play(armorHitSound[this.Math.rand(0, armorHitSound.len() - 1)], this.Const.Sound.Volume.ActorArmorHit, actor.getTile().Pos);
					this.Tactical.EventLog.log("" + this.getName() + "\'s Head armor is hit for " + armordamage + " damage and has been destroyed!");
					this.Changeappearance();
				}
				else
				{
					local aaa = this.m.Hcondition / _hitInfo.DamageArmor;
					this.m.Hcondition = 0;
					this.m.Hitpoints -= this.Math.round((_hitInfo.DamageRegular * (1 - aaa) + _hitInfo.DamageDirect * _hitInfo.DamageRegular * aaa) * 1.5);
					Hdamage = this.Math.round((_hitInfo.DamageRegular * (1 - aaa) + _hitInfo.DamageDirect * _hitInfo.DamageRegular * aaa) * 1.5);
					this.Sound.play(armorHitSound[this.Math.rand(0, armorHitSound.len() - 1)], this.Const.Sound.Volume.ActorArmorHit, actor.getTile().Pos);
					this.Tactical.EventLog.log("" + this.getName() + "\'s Head armor is hit for " + armordamage + " damage and has been destroyed!");
					this.Changeappearance();
				}
			}
			else
			{
				this.m.Hitpoints -= regulardamage;
				Hdamage = regulardamage;
				this.Changeappearance();
			}
		}
		else if (this.m.Acondition > 1)
		{
			if (this.m.ArmorScript != null)
			{
			armorHitSound = this.m.ArmorScript.m.ImpactSound;
			}
			else
			{
			armorHitSound = this.m.DamageReceived;			
			}	

			if (armordamage < this.m.Acondition)
			{
				this.m.Acondition -= armordamage;
				this.m.Hitpoints -= this.Math.max(0, this.Math.round(regulardamagewitharmor1 - this.m.Acondition / 10));
				Hdamage = this.Math.max(0, this.Math.round(regulardamagewitharmor1 - this.m.Acondition / 10));
				this.Sound.play(armorHitSound[this.Math.rand(0, armorHitSound.len() - 1)], this.Const.Sound.Volume.ActorArmorHit, actor.getTile().Pos);
				this.Tactical.EventLog.log("" + this.getName() + "\'s Body armor is hit for " + armordamage + " damage.");
				this.Changeappearance();
			}
			else if (armordamage == this.m.Acondition)
			{
				this.m.Acondition = 0;
				this.m.Hitpoints -= regulardamagewitharmor1;
				Hdamage = regulardamagewitharmor1;
				this.Sound.play(armorHitSound[this.Math.rand(0, armorHitSound.len() - 1)], this.Const.Sound.Volume.ActorArmorHit, actor.getTile().Pos);
				this.Tactical.EventLog.log("" + this.getName() + "\'s Body armor is hit for " + armordamage + " damage and has been destroyed!");
				this.Changeappearance();
			}
			else
			{
				local aaa = this.m.Acondition / _hitInfo.DamageArmor;
				this.m.Acondition = 0;
				this.m.Hitpoints -= this.Math.round(_hitInfo.DamageRegular * (1 - aaa) + _hitInfo.DamageDirect * _hitInfo.DamageRegular * aaa);
				Hdamage = this.Math.round(_hitInfo.DamageRegular * (1 - aaa) + _hitInfo.DamageDirect * _hitInfo.DamageRegular * aaa);
				this.Sound.play(armorHitSound[this.Math.rand(0, armorHitSound.len() - 1)], this.Const.Sound.Volume.ActorArmorHit, actor.getTile().Pos);
				this.Tactical.EventLog.log("" + this.getName() + "\'s Body armor is hit for " + armordamage + " damage and has been destroyed!");
				this.Changeappearance();
			}
		}
		else
		{
			this.m.Hitpoints -= regulardamage;
			Hdamage = regulardamage;
			this.Changeappearance();
		}

		if (this.Math.max(0, Hdamage) <= 0 && armordamage >= 0)
		{
			if ((actor.m.IsFlashingOnHit || actor.getCurrentProperties().IsStunned || actor.getCurrentProperties().IsRooted) && !actor.isHiddenToPlayer() && _attacker != null && _attacker.isAlive())
			{
				local layers = random <= 15 ? this.m.ShakeCharacterLayers[1] : this.m.ShakeCharacterLayers[0];
				local recoverMult = 1.0;
				this.Tactical.getShaker().cancel(actor);
				this.Tactical.getShaker().shake(actor, _attacker.getTile(), actor.m.IsShakingOnHit ? 2 : 3, this.Const.Combat.ShakeEffectArmorHitColor, this.Const.Combat.ShakeEffectArmorHitHighlight, this.Const.Combat.ShakeEffectArmorHitFactor, this.Const.Combat.ShakeEffectArmorSaturation, layers, recoverMult);
			}
		}
		else if ((actor.m.IsFlashingOnHit || actor.getCurrentProperties().IsStunned || actor.getCurrentProperties().IsRooted) && !actor.isHiddenToPlayer() && _attacker != null && _attacker.isAlive())
		{
			local layers = random <= 15 ? this.m.ShakeCharacterLayers[1] : this.m.ShakeCharacterLayers[0];
			local recoverMult = this.Math.minf(1.5, this.Math.maxf(1.0, Hdamage * 2.0 / this.m.Base[1]));
			this.Tactical.getShaker().cancel(actor);
			this.Tactical.getShaker().shake(actor, _attacker.getTile(), actor.m.IsShakingOnHit ? 2 : 3, this.Const.Combat.ShakeEffectHitpointsHitColor, this.Const.Combat.ShakeEffectHitpointsHitHighlight, this.Const.Combat.ShakeEffectHitpointsHitFactor, this.Const.Combat.ShakeEffectHitpointsSaturation, layers, recoverMult);
		}

		if (this.m.Hitpoints > 0)
		{
			if (Hdamage > 0)
			{
			  	if (random <= 15)
				{
				this.Tactical.EventLog.log("" + this.getName() + "\'s Head is hit for " + Hdamage + " damage.");
				}
				else
				{
				this.Tactical.EventLog.log("" + this.getName() + "\'s body is hit for " + Hdamage + " damage.");
                }
				
				if (Hdamage < this.Const.Combat.PlayPainSoundMinDamage)
				{
					this.playSound(this.m.DamageReceived, this.Const.Sound.Volume.Actor * 0.5);
				}
				else
				{
					this.playSound(this.m.DamageReceived, this.Const.Sound.Volume.Actor);
				}
			}
		}
		else
		{
			this.ondogdied(_attacker, _skill, _hitInfo);
		}
	}

	function ondogdied( _attacker, _skill, _hitInfo )
	{
		local actor = this.getContainer().getActor();
		local variant;
		this.Tactical.EventLog.log("" + _attacker.getName() + " has killed " + this.getName() + "");
		this.playSound(this.m.Death, this.Const.Sound.Volume.Actor);
		this.removeSelf();

		if (actor.getTile() != null)
		{
			local decal;
			decal = actor.getTile().spawnDetail(this.m.Bodysprite + this.getVariant() + "_dead", this.Const.Tactical.DetailFlag.Corpse, true);
			decal.setBrightness(0.9);
			decal.Scale = 0.95;
			decal = actor.getTile().spawnDetail(this.m.Headsprite + this.getVariant() + "_dead", this.Const.Tactical.DetailFlag.Corpse, true);
			decal.setBrightness(0.9);
			decal.Scale = 0.95;

			if (this.m.Capavariant != 0)
			{
		        variant = this.m.Capavariant > 9 ? this.m.Capavariant : "0" + this.m.Capavariant;					
				decal = actor.getTile().spawnDetail("horse_armor_capa_" + variant + "_dead", this.Const.Tactical.DetailFlag.Corpse, true);
				decal.setBrightness(0.9);
				decal.Scale = 0.95;			
			}
			else if (this.m.ArmorScript != null)
			{
		        variant = this.m.Armorvariant > 9 ? this.m.Armorvariant : "0" + this.m.Armorvariant;					
				decal = actor.getTile().spawnDetail("horse_armor_body_" + variant + "_dead", this.Const.Tactical.DetailFlag.Corpse, true);
				decal.setBrightness(0.9);
				decal.Scale = 0.95;
			}

			if (this.m.HelmetScript != null)
			{
		        variant = this.m.Helmetvariant > 9 ? this.m.Helmetvariant : "0" + this.m.Helmetvariant;					
				decal = actor.getTile().spawnDetail("horse_armor_head_" + variant + "_dead", this.Const.Tactical.DetailFlag.Corpse, true);
				decal.setBrightness(0.9);
				decal.Scale = 0.95;
			}

			this.spawnTerrainDropdownEffect(actor.getTile());
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsHeadAttached = true;
			corpse.IsResurrectable = false;
			actor.getTile().Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(actor.getTile());
		}
	}

	function spawnTerrainDropdownEffect( _tile )
	{
		if (_tile.IsVisibleForPlayer && this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype].len() != 0)
		{
			for( local i = 0; i < this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype].len(); i = i )
			{
				if (this.Tactical.getWeather().IsRaining && !this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].ApplyOnRain)
				{
				}
				else
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Brushes, _tile, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Delay, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Quantity, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].LifeTimeQuantity, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].SpawnRate, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Stages);
				}

				i = ++i;
			}
		}
	}

	function onFactionChanged( _faction )
	{
	    this.item.onFactionChanged( _faction );

		local actor = this.getContainer().getActor();	
		local flip = !actor.isAlliedWithPlayer();	
		actor.getSprite("dddog").setHorizontalFlipping(flip);
		actor.getSprite("dddog2").setHorizontalFlipping(flip);
		actor.getSprite("dddog3").setHorizontalFlipping(flip);
		actor.getSprite("dddog4").setHorizontalFlipping(flip);
		actor.getSprite("dddog5").setHorizontalFlipping(flip);
		actor.getSprite("dddog6").setHorizontalFlipping(flip);
		
		if (flip)
		{
		local offset = this.m.RiderRoffset;			
		actor.setSpriteOffset("quiver", offset);
		actor.setSpriteOffset("body", offset);
		actor.setSpriteOffset("tattoo_body", offset);
		actor.setSpriteOffset("injury_body", offset);
		actor.setSpriteOffset("armor", offset);
		actor.setSpriteOffset("surcoat", offset);
		actor.setSpriteOffset("armor_upgrade_back", offset);
		actor.setSpriteOffset("armor_upgrade_front", offset);
		actor.setSpriteOffset("shaft", offset);
		actor.setSpriteOffset("head", offset);
		actor.setSpriteOffset("closed_eyes", offset);
		actor.setSpriteOffset("eye_rings", offset);
		actor.setSpriteOffset("tattoo_head", offset);
		actor.setSpriteOffset("injury", offset);
		actor.setSpriteOffset("beard", offset);
		actor.setSpriteOffset("hair", offset);
		actor.setSpriteOffset("helmet", offset);
		actor.setSpriteOffset("helmet_damage", offset);
		actor.setSpriteOffset("beard_top", offset);
		actor.setSpriteOffset("body_blood", offset);
		actor.setSpriteOffset("accessory", offset);
		actor.setSpriteOffset("accessory_special", offset);
		actor.setSpriteOffset("dirt", offset);
		actor.setSpriteOffset("permanent_injury_1", offset);
		actor.setSpriteOffset("permanent_injury_2", offset);
		actor.setSpriteOffset("permanent_injury_3", offset);
		actor.setSpriteOffset("permanent_injury_4", offset);
		actor.setSpriteOffset("bandage_1", offset);
		actor.setSpriteOffset("bandage_2", offset);
		actor.setSpriteOffset("bandage_3", offset);	
		offset = this.m.ShieldRoffset;	
		actor.setSpriteOffset("shield_icon", offset);
		offset = this.m.WeaponRoffset;
		actor.setSpriteOffset("arms_icon", offset);			
		offset = this.m.PetRoffset;
		actor.setSpriteOffset("dddog", offset);
		actor.setSpriteOffset("dddog2", offset);
		actor.setSpriteOffset("dddog3", offset);
		actor.setSpriteOffset("dddog5", offset);
		actor.setSpriteOffset("dddog4", offset);
		actor.setSpriteOffset("dddog6", offset);	
		}

		actor.setDirty(true);
	}
	
	function onRide()
	{
        local actor = this.getContainer().getActor();	  
	    actor.setAlwaysApplySpriteOffset(true);
		local offset = this.m.Rideroffset;
		actor.setSpriteOffset("quiver", offset);
		actor.setSpriteOffset("body", offset);
		actor.setSpriteOffset("tattoo_body", offset);
		actor.setSpriteOffset("injury_body", offset);
		actor.setSpriteOffset("armor", offset);
		actor.setSpriteOffset("surcoat", offset);
		actor.setSpriteOffset("armor_upgrade_back", offset);
		actor.setSpriteOffset("armor_upgrade_front", offset);
		actor.setSpriteOffset("shaft", offset);
		actor.setSpriteOffset("head", offset);
		actor.setSpriteOffset("closed_eyes", offset);
		actor.setSpriteOffset("eye_rings", offset);
		actor.setSpriteOffset("tattoo_head", offset);
		actor.setSpriteOffset("injury", offset);
		actor.setSpriteOffset("beard", offset);
		actor.setSpriteOffset("hair", offset);
		actor.setSpriteOffset("helmet", offset);
		actor.setSpriteOffset("helmet_damage", offset);
		actor.setSpriteOffset("beard_top", offset);
		actor.setSpriteOffset("body_blood", offset);
		actor.setSpriteOffset("accessory", offset);
		actor.setSpriteOffset("accessory_special", offset);
		actor.setSpriteOffset("dirt", offset);
		actor.setSpriteOffset("permanent_injury_1", offset);
		actor.setSpriteOffset("permanent_injury_2", offset);
		actor.setSpriteOffset("permanent_injury_3", offset);
		actor.setSpriteOffset("permanent_injury_4", offset);
		actor.setSpriteOffset("bandage_1", offset);
		actor.setSpriteOffset("bandage_2", offset);
		actor.setSpriteOffset("bandage_3", offset);
		offset = this.m.Shieldoffset;		
		actor.setSpriteOffset("shield_icon", offset);
		offset = this.m.Weaponoffset;	
		actor.setSpriteOffset("arms_icon", offset);	
		local dddog = actor.addSprite("dddog");
		dddog.setBrush(this.m.Bodysprite + this.getVariant());
		local dddog2 = actor.addSprite("dddog2");
		dddog2.setBrush(this.m.Headsprite + this.getVariant());
		local variant;

		local dddog3 = actor.addSprite("dddog3");
			if (this.m.Capavariant != 0)
			{
		    variant = this.m.Capavariant > 9 ? this.m.Capavariant : "0" + this.m.Capavariant;			
			dddog3.setBrush("horse_armor_capa_" + variant);			
			}			
			else if (this.m.ArmorScript != null)
			{
		    variant = this.m.Armorvariant > 9 ? this.m.Armorvariant : "0" + this.m.Armorvariant;			
			dddog3.setBrush("horse_armor_body_" + variant);
			}

		local dddog5 = actor.addSprite("dddog5");
			if (this.m.HelmetScript != null)
			{
		    variant = this.m.Helmetvariant > 9 ? this.m.Helmetvariant : "0" + this.m.Helmetvariant;				
			dddog5.setBrush("horse_armor_head_" + variant);
			}

		offset = this.m.Petoffset;
		actor.setSpriteOffset("dddog", offset);
		actor.setSpriteOffset("dddog2", offset);
		actor.setSpriteOffset("dddog3", offset);
		actor.setSpriteOffset("dddog5", offset);
		local dddog4 = actor.addSprite("dddog4");
		dddog4.setBrush(this.m.Injuheadprite);
		dddog4.Visible = false;
		local dddog6 = actor.addSprite("dddog6");
		dddog6.setBrush(this.m.Injubodysprite);
		dddog6.Visible = false;
		actor.setSpriteOffset("dddog4", offset);
		actor.setSpriteOffset("dddog6", offset);
		this.Changeappearance();	
        this.onFactionChanged(actor.getFaction());	
	}		

    function offRide()
	{
		local actor = this.getContainer().getActor();

		if (actor.isNull())
		{
			return;
		}

		actor.setAlwaysApplySpriteOffset(false);
		local offset = this.createVec(0, 0);
		actor.setSpriteOffset("quiver", offset);
		actor.setSpriteOffset("body", offset);
		actor.setSpriteOffset("tattoo_body", offset);
		actor.setSpriteOffset("injury_body", offset);
		actor.setSpriteOffset("armor", offset);
		actor.setSpriteOffset("surcoat", offset);
		actor.setSpriteOffset("armor_upgrade_back", offset);
		actor.setSpriteOffset("armor_upgrade_front", offset);
		actor.setSpriteOffset("shaft", offset);
		actor.setSpriteOffset("head", offset);
		actor.setSpriteOffset("closed_eyes", offset);
		actor.setSpriteOffset("eye_rings", offset);
		actor.setSpriteOffset("tattoo_head", offset);
		actor.setSpriteOffset("injury", offset);
		actor.setSpriteOffset("beard", offset);
		actor.setSpriteOffset("hair", offset);
		actor.setSpriteOffset("helmet", offset);
		actor.setSpriteOffset("helmet_damage", offset);
		actor.setSpriteOffset("beard_top", offset);
		actor.setSpriteOffset("body_blood", offset);
		actor.setSpriteOffset("accessory", offset);
		actor.setSpriteOffset("accessory_special", offset);
		actor.setSpriteOffset("dirt", offset);
		actor.setSpriteOffset("permanent_injury_1", offset);
		actor.setSpriteOffset("permanent_injury_2", offset);
		actor.setSpriteOffset("permanent_injury_3", offset);
		actor.setSpriteOffset("permanent_injury_4", offset);
		actor.setSpriteOffset("bandage_1", offset);
		actor.setSpriteOffset("bandage_2", offset);
		actor.setSpriteOffset("bandage_3", offset);
		this.resetRender();		
		actor.removeSprite("dddog");
		actor.removeSprite("dddog2");
		actor.removeSprite("dddog3");
		actor.removeSprite("dddog4");
		actor.removeSprite("dddog5");
		actor.removeSprite("dddog6");		
	}

	function resetRender()
	{
	    local actor = this.getContainer().getActor();
		actor.m.IsRaising = false;
		actor.m.IsSinking = false;
		actor.m.IsRaisingShield = false;
		actor.m.IsLoweringShield = false;
		actor.m.IsRaisingWeapon = false;
		actor.m.IsLoweringWeapon = false;
		actor.setRenderCallbackEnabled(false);
		actor.setSpriteOffset("shield_icon", this.createVec(0, 0));
		actor.setSpriteOffset("arms_icon", this.createVec(0, 0));
		actor.getSprite("arms_icon").Rotation = 0;
		actor.getSprite("status_rooted").Visible = false;
		actor.getSprite("status_rooted_back").Visible = false;
	}

	function onTurnStart()
	{
		if (this.m.Ride == true)
		{	
		this.m.Fatigue = this.Math.max(0, this.m.Fatigue - this.m.Base[9]);
		this.m.Initiative = this.m.Initiative2 - this.m.Fatigue;
		}
	}	
	
	function Changeappearance()
	{
		local actor = this.getContainer().getActor();
        local variant;		

		if (actor.isNull())
		{
			return;
		}

		if (!actor.hasSprite("dddog4"))
		{
			return;
		}

		local sprite = actor.getSprite("dddog4");
		local sprite2 = actor.getSprite("dddog6");

		if (this.m.Hitpoints / this.m.Base[1] >= 0.5)
		{
			if (sprite.Visible)
			{
				sprite.Visible = false;
			}

			if (sprite2.Visible)
			{
				sprite2.Visible = false;
			}

			actor.setDirty(true);
		}
		else
		{
			if (!sprite.Visible)
			{
				sprite.Visible = true;
			}

			if (!sprite2.Visible)
			{
				sprite2.Visible = true;
			}

			actor.setDirty(true);
		}
 
			if (this.m.Capavariant != 0)
			{
		    variant = this.m.Capavariant > 9 ? this.m.Capavariant : "0" + this.m.Capavariant;
			
				if (this.m.Hitpoints / this.m.Base[1] >= 0.5)
				{
					actor.getSprite("dddog3").setBrush("horse_armor_capa_" + variant);
				}
				else
				{
					actor.getSprite("dddog3").setBrush("horse_armor_capa_" + variant + "_damaged");
				}					
			}	 
			else if (this.m.ArmorScript != null)
			{
		    variant = this.m.Armorvariant > 9 ? this.m.Armorvariant : "0" + this.m.Armorvariant;	
			
				if (this.m.Acondition / this.m.AconditionMax >= 0.5)
				{
					actor.getSprite("dddog3").setBrush("horse_armor_body_" + variant);
				}
				else
				{
					actor.getSprite("dddog3").setBrush("horse_armor_body_" + variant + "_damaged");
				}
			}		

			if (this.m.HelmetScript != null)
			{
		    variant = this.m.Helmetvariant > 9 ? this.m.Helmetvariant : "0" + this.m.Helmetvariant;	
			
				if (this.m.Hcondition / this.m.HconditionMax >= 0.5)
				{
					actor.getSprite("dddog5").setBrush("horse_armor_head_" + variant);
				}
				else if (this.m.Hcondition == 0)
				{
					actor.getSprite("dddog5").setBrush("");
				}
				else 
				{
					actor.getSprite("dddog5").setBrush("horse_armor_head_" + variant + "_damaged");
				}				
			}
	}		
	
	function onSerialize( _out )
	{
		this.accessory.onSerialize(_out);
		_out.writeString(this.m.Name);

		for( local i = 0; i < 10; i = i )
		{
			_out.writeF32(this.m.Base[i]);
			i = ++i;
		}

		_out.writeF32(this.m.Hitpoints);
		_out.writeF32(this.m.Fatigue2);
		_out.writeF32(this.m.Initiative2);
		_out.writeF32(this.m.Days);
		_out.writeF32(this.m.Acondition);
		_out.writeF32(this.m.AconditionMax);
		_out.writeF32(this.m.Hcondition);
		_out.writeF32(this.m.HconditionMax);

		if (this.m.ArmorScript != null)
		{
			_out.writeI32(this.m.ArmorScript.ClassNameHash);
			this.m.ArmorScript.onSerialize(_out);
		}
		else
		{
			_out.writeI32(0);
		}

		if (this.m.HelmetScript != null)
		{
			_out.writeU32(this.m.HelmetScript.ClassNameHash);
			this.m.HelmetScript.onSerialize(_out);
		}
		else
		{
			_out.writeU32(0);
		}
		_out.writeF32(this.m.Armorvariant);
		_out.writeF32(this.m.Helmetvariant);
		_out.writeF32(this.m.Capavariant);		
	}

	function onDeserialize( _in )
	{
		this.accessory.onDeserialize(_in);
		this.m.Name = _in.readString();

		for( local i = 0; i < 10; i = i )
		{
			this.m.Base[i] = _in.readF32();
			i = ++i;
		}

		this.m.Hitpoints = _in.readF32();
		this.m.Fatigue2 = _in.readF32();
		this.m.Initiative2 = _in.readF32();
		this.m.Days = _in.readF32();
		this.m.Acondition = _in.readF32();
		this.m.AconditionMax = _in.readF32();
		this.m.Hcondition = _in.readF32();
		this.m.HconditionMax = _in.readF32();

		if (_in.getMetaData().getVersion() >= 36)
		{
			local upgrade = _in.readI32();

			if (upgrade != 0)
			{
				this.m.ArmorScript = this.new(this.IO.scriptFilenameByHash(upgrade));
				this.m.ArmorScript.onDeserialize(_in);
			}

			upgrade = _in.readU32();

			if (upgrade != 0)
			{
				this.m.HelmetScript = this.new(this.IO.scriptFilenameByHash(upgrade));
				this.m.HelmetScript.onDeserialize(_in);
			}
		}

		this.m.Armorvariant = _in.readF32();
		this.m.Helmetvariant = _in.readF32();
		this.m.Capavariant = _in.readF32();		
		this.updateVariant();
	}

});

