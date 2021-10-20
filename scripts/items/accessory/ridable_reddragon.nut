this.ridable_reddragon <- this.inherit("scripts/items/accessory/ridable_pet", {
	m = {
		Tail = null,
	},
	function create()
	{
		this.ridable_pet.create();
		this.m.Variant = 3;		
		this.m.ID = "accessory.ridable_reddragon";
		this.m.Name = this.Const.Strings.WardogNames[this.Math.rand(0, this.Const.Strings.WardogNames.len() - 1)] + " the Drake";		
		this.m.Description = "";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = false;
		this.m.Value = 1000;
		this.m.Script = "scripts/entity/tactical/enemies/riding_reddragon";
		this.m.Type = this.Const.Tactical.Actor.Lindwurm;
		this.m.Ride = true;				
		this.m.Bodysprite = "bust_dragon_body_10";
		this.m.Headsprite = "bust_dragon_head_10";			
		this.m.Injuheadprite = "bust_dragon_head_103_injured";			
		this.m.Injubodysprite = "bust_dragon_body_103_injured";			
		this.m.Rideroffset = this.createVec(-10, 25);
		this.m.Petoffset = this.createVec(20, -10);
		this.m.Weaponoffset = this.createVec(-30, 25);
		this.m.Shieldoffset = this.createVec(0, 25);
		this.m.RiderRoffset = this.createVec(10, 25);
		this.m.PetRoffset = this.createVec(-20, -10);	
		this.m.WeaponRoffset = this.createVec(30, 25);
		this.m.ShieldRoffset = this.createVec(0, 25);	
		this.m.AconditionMax = 400;
		this.m.Acondition = 400;
		this.m.HconditionMax = 200;
		this.m.Hcondition = 200;		
		this.m.UnleashSounds = [
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
		this.m.DamageReceived = [
			"sounds/enemies/lindwurm_hurt_01.wav",
			"sounds/enemies/lindwurm_hurt_02.wav",
			"sounds/enemies/lindwurm_hurt_03.wav",
			"sounds/enemies/lindwurm_hurt_04.wav"
		];
		this.m.Death = [
			"sounds/enemies/lindwurm_death_01.wav",
			"sounds/enemies/lindwurm_death_02.wav",
			"sounds/enemies/lindwurm_death_03.wav",
			"sounds/enemies/lindwurm_death_04.wav"
		];	
		this.m.Haspathfiner = true;		
		this.updateVariant();	
		this.randomize();		
	}
	
	function randomize()
	{
		local type = this.m.Type;
		this.m.Base[0] = type.ActionPoints;
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
	
	function onEquip()
	{
		this.ridable_pet.onEquip();
		local charge = this.new("scripts/skills/actives/actives_gorge2_skill");
		this.addSkill(charge);			
		local fire = this.new("scripts/skills/actives/actives_friebreath_skill");
		this.addSkill(fire);			
	}	
	
	function onUpdateProperties( _properties )
	{
		_properties.IsImmuneToStun = true;
		_properties.IsImmuneToKnockBackAndGrab = true;
		_properties.IsImmuneToDisarm = true;
		_properties.IsImmuneToRoot = true;
		_properties.IsMovable = false;
        _properties.IsAbleToUseWeaponSkills = false;	
        _properties.IsImmuneToFire = true;	
	}	
	
	function onRide()
	{
		this.ridable_pet.onRide();	
	}
	
	function getTail()
	{
		return this.m.Tail;	
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
		this.getTail().setFatigue(this.Math.max(0, this.getTail().getFatigue() + 4));
		this.m.Fatigue = this.Math.min(this.m.Fatigue2, this.m.Fatigue + 4);
		this.m.Initiative = this.m.Initiative2 - this.m.Fatigue;
		local armorHitSound;
		local Hdamage;
		local random = this.Math.rand(1, 100);

		if (random <= 15)
		{
			regulardamage = this.Math.round(_hitInfo.DamageRegular * 1.5);
			regulardamagewitharmor1 = this.Math.round(_hitInfo.DamageDirect * _hitInfo.DamageRegular * 1.5);

			if (this.getTail().m.BaseProperties.Armor[1] > 1)
			{
			if (this.m.HelmetScript != null)
			{
			armorHitSound = this.m.HelmetScript.m.ImpactSound;
			}
			else
			{
			armorHitSound = this.m.DamageReceived;			
			}
			
				if (armordamage < this.getTail().m.BaseProperties.Armor[1])
				{
					this.getTail().m.BaseProperties.Armor[1] -= armordamage;
					this.getTail().m.Hitpoints -= this.Math.max(0, this.Math.round(regulardamagewitharmor1 - this.getTail().m.BaseProperties.Armor[1] / 10));
					this.m.Hcondition -= armordamage;
					this.m.Hitpoints -= this.Math.max(0, this.Math.round(regulardamagewitharmor1 - this.m.Hcondition / 10));					
					Hdamage = this.Math.max(0, this.Math.round(regulardamagewitharmor1 - this.getTail().m.BaseProperties.Armor[1] / 10));
					this.Sound.play(armorHitSound[this.Math.rand(0, armorHitSound.len() - 1)], this.Const.Sound.Volume.ActorArmorHit, actor.getTile().Pos);
					this.Tactical.EventLog.log("" + this.getName() + "\'s Head armor is hit for " + armordamage + " damage.");
					this.Changeappearance();
				}
				else if (armordamage == this.getTail().m.BaseProperties.Armor[1])
				{
					this.getTail().m.BaseProperties.Armor[1] = 0;
					this.getTail().m.Hitpoints -= regulardamagewitharmor1;
					this.m.Hcondition = 0;
					this.m.Hitpoints -= regulardamagewitharmor1;					
					Hdamage = regulardamagewitharmor1;
					this.Sound.play(armorHitSound[this.Math.rand(0, armorHitSound.len() - 1)], this.Const.Sound.Volume.ActorArmorHit, actor.getTile().Pos);
					this.Tactical.EventLog.log("" + this.getName() + "\'s Head armor is hit for " + armordamage + " damage and has been destroyed!");
					this.Changeappearance();
				}
				else
				{
					local aaa = this.getTail().m.BaseProperties.Armor[1] / _hitInfo.DamageArmor;
					this.getTail().m.BaseProperties.Armor[1] = 0;
					this.getTail().m.Hitpoints -= this.Math.round((_hitInfo.DamageRegular * (1 - aaa) + _hitInfo.DamageDirect * _hitInfo.DamageRegular * aaa) * 1.5);
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
				this.getTail().m.Hitpoints -= regulardamage;
				this.m.Hitpoints -= regulardamage;				
				Hdamage = regulardamage;
				this.Changeappearance();
			}
		}
		else if (this.getTail().m.BaseProperties.Armor[0] > 1)
		{
			if (this.m.ArmorScript != null)
			{
			armorHitSound = this.m.ArmorScript.m.ImpactSound;
			}
			else
			{
			armorHitSound = this.m.DamageReceived;			
			}			

			if (armordamage < this.getTail().m.BaseProperties.Armor[0])
			{
				this.getTail().m.BaseProperties.Armor[0] -= armordamage;
				this.getTail().m.Hitpoints -= this.Math.max(0, this.Math.round(regulardamagewitharmor1 - this.getTail().m.BaseProperties.Armor[0] / 10));
				this.m.Acondition -= armordamage;
				this.m.Hitpoints -= this.Math.max(0, this.Math.round(regulardamagewitharmor1 - this.m.Acondition / 10));				
				Hdamage = this.Math.max(0, this.Math.round(regulardamagewitharmor1 - this.getTail().m.BaseProperties.Armor[0] / 10));
				this.Sound.play(armorHitSound[this.Math.rand(0, armorHitSound.len() - 1)], this.Const.Sound.Volume.ActorArmorHit, actor.getTile().Pos);
				this.Tactical.EventLog.log("" + this.getName() + "\'s Body armor is hit for " + armordamage + " damage.");
				this.Changeappearance();
			}
			else if (armordamage == this.getTail().m.BaseProperties.Armor[0])
			{
				this.getTail().m.BaseProperties.Armor[0] = 0;
				this.getTail().m.Hitpoints -= regulardamagewitharmor1;
				this.m.Acondition = 0;
				this.m.Hitpoints -= regulardamagewitharmor1;				
				Hdamage = regulardamagewitharmor1;
				this.Sound.play(armorHitSound[this.Math.rand(0, armorHitSound.len() - 1)], this.Const.Sound.Volume.ActorArmorHit, actor.getTile().Pos);
				this.Tactical.EventLog.log("" + this.getName() + "\'s Body armor is hit for " + armordamage + " damage and has been destroyed!");
				this.Changeappearance();
			}
			else
			{
				local aaa = this.getTail().m.BaseProperties.Armor[0] / _hitInfo.DamageArmor;
				this.getTail().m.BaseProperties.Armor[0] = 0;
				this.getTail().m.Hitpoints -= this.Math.round(_hitInfo.DamageRegular * (1 - aaa) + _hitInfo.DamageDirect * _hitInfo.DamageRegular * aaa);
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
			this.getTail().m.Hitpoints -= regulardamage;
			this.m.Hitpoints -= regulardamage;			
			Hdamage = regulardamage;
			this.Changeappearance();
		}
		
		this.getTail().m.Skills.update()
		this.getTail().setDirty(true);

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
		 if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		 {
		    local fatalityType = this.Const.FatalityType.None;		 
			this.m.Tail.kill(_attacker, _skill, fatalityType);
			this.m.Tail = null;
		 }			
		}
	}	
	
	function spawnIcon( _brush, _tile )
	{
		if (!_tile.IsVisibleForPlayer)
		{
			return;
		}

		this.Tactical.spawnIconEffect(_brush, _tile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
	}

	function onMovementFinished()
	{
		 if (this.m.Tail != null && !this.m.Tail.isNull() && this.m.Tail.isAlive())
		 {		
			this.Tactical.TurnSequenceBar.moveEntityToFront(this.m.Tail.getID());
		 }	
	}

	function onCombatFinished()
	{
        this.ridable_pet.onCombatFinished();		
        this.m.Tail = null;
	}
	
	function onActorDied( _onTile )
	{
		if (!this.isUnleashed() && _onTile != null)
		{			
		    this.m.Ride = false;	
		    if (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() != this.getContainer().getActor().getID())
			{
			this.m.Tail.removeFromMap();
			}
			else
			{
			this.m.Tail.m.Body = null;
			this.m.Tail.setActionPoints(0);
			this.m.Tail.getSprite("body").setBrush("");
			this.m.Tail.getSprite("socket").setBrush("");				
			this.m.Tail = null;
			}
						
			local Pct = this.m.Hitpoints / this.m.Base[1];
			local entity = this.Tactical.spawnEntity(this.getScript(), _onTile.Coords.X, _onTile.Coords.Y);		
			entity.setItem(this);
			entity.setName(this.getName());
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
			entity.m.BaseProperties.Armor[0] = this.m.Acondition;
			entity.m.BaseProperties.Armor[1] = this.m.Hcondition;	
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
            			
						
			this.Sound.play(this.m.UnleashSounds[this.Math.rand(0, this.m.UnleashSounds.len() - 1)], this.Const.Sound.Volume.Skill, _onTile.Pos);
		}
	}
	
});

