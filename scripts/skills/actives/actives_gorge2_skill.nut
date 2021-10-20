this.actives_gorge2_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.ridable_gorge2";
		this.m.Name = "Gorge";
		this.m.Description = "";
		this.m.Icon = "skills/active_107.png";
		this.m.IconDisabled = "skills/active_107_sw.png";
		this.m.Overlay = "active_107";
		this.m.SoundOnUse = [
			"sounds/enemies/lindwurm_gorge_01.wav",
			"sounds/enemies/lindwurm_gorge_02.wav",
			"sounds/enemies/lindwurm_gorge_03.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/enemies/lindwurm_gorge_hit_01.wav",
			"sounds/enemies/lindwurm_gorge_hit_02.wav",
			"sounds/enemies/lindwurm_gorge_hit_03.wav"
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
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.DirectDamageMult = 0.35;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 50;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		return ret;
	}	

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
		local items = this.getContainer().getActor().getItems();
		local off = items.getItemAtSlot(this.Const.ItemSlot.Offhand);
		local actor = this.getContainer().getActor();
		
			_properties.DamageRegularMin = 80;
			_properties.DamageRegularMax = 140;
			_properties.DamageArmorMult = 1.5;	

			if (this.canDoubleGrip())
			{
				_properties.DamageTotalMult /= 1.25;
			}	

			if (off == null && !items.hasBlockedSlot(this.Const.ItemSlot.Offhand) && actor.getSkills().hasSkill("perk.duelist") || off != null && off.isItemType(this.Const.Items.ItemType.Tool) && actor.getSkills().hasSkill("perk.duelist"))
			{
				_properties.DamageDirectAdd -= 0.25;
			}			
		}
	}

	function canDoubleGrip()
	{
		local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		return main != null && off == null && main.isDoubleGrippable();
	}

	function onUse( _user, _targetTile )
	{
	    local actor = this.getContainer().getActor();
	    local aaa = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);		
	    aaa.getTail().setFatigue(this.Math.max(0, aaa.getTail().getFatigue() + 15));
		aaa.m.Fatigue = this.Math.min(aaa.m.Fatigue2, aaa.m.Fatigue + 15);
		return this.attackEntity(_user, _targetTile.getEntity());
	}
	
	function spawntail()
	{
	local actor = this.getContainer().getActor();
	local aaa = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);	
	
			local myTile = actor.getTile();
			local spawnTile;

			if (myTile.hasNextTile(this.Const.Direction.NW) && myTile.getNextTile(this.Const.Direction.NW).IsEmpty)
			{
				spawnTile = myTile.getNextTile(this.Const.Direction.NW);
			}
			else if (myTile.hasNextTile(this.Const.Direction.SW) && myTile.getNextTile(this.Const.Direction.SW).IsEmpty)
			{
				spawnTile = myTile.getNextTile(this.Const.Direction.SW);
			}
			else
			{
				for( local i = 5; i > -1; i = --i )
				{
					if (!myTile.hasNextTile(i))
					{
					}
					else if (myTile.getNextTile(i).IsEmpty)
					{
						spawnTile = myTile.getNextTile(i);
						break;
					}
				}
			}

			if (spawnTile != null)
			{
			    local Pct = aaa.m.Hitpoints / aaa.m.Base[1];
				aaa.m.Tail = this.WeakTableRef(this.Tactical.spawnEntity("scripts/entity/tactical/enemies/riding_reddragon_tail", spawnTile.Coords.X, spawnTile.Coords.Y, this.getID()));
				aaa.m.Tail.setItem(aaa);
				aaa.m.Tail.setItem2(aaa.getContainer().getActor());				
				aaa.m.Tail.setName(aaa.getName());
				aaa.m.Tail.m.BaseProperties.Hitpoints = aaa.m.Base[1];
				aaa.m.Tail.setFatigue(aaa.m.Fatigue);
				aaa.m.Tail.m.BaseProperties.ActionPoints = aaa.m.Base[0];
				aaa.m.Tail.m.BaseProperties.Bravery = aaa.m.Base[2];
				aaa.m.Tail.m.BaseProperties.Stamina = aaa.m.Base[3];
				aaa.m.Tail.setHitpointsPct(Pct);
				aaa.m.Tail.m.BaseProperties.MeleeSkill = aaa.m.Base[4];
				aaa.m.Tail.m.BaseProperties.RangedSkill = aaa.m.Base[5];
				aaa.m.Tail.m.BaseProperties.MeleeDefense = aaa.m.Base[6];
				aaa.m.Tail.m.BaseProperties.RangedDefense = aaa.m.Base[7];
				aaa.m.Tail.m.BaseProperties.Initiative = aaa.m.Base[8];
				aaa.m.Tail.m.BaseProperties.FatigueRecoveryRate = aaa.m.Base[9];
				aaa.m.Tail.m.BaseProperties.Armor[0] = aaa.m.Acondition;
				aaa.m.Tail.m.BaseProperties.Armor[1] = aaa.m.Hcondition;
				if (aaa.m.Efaction == this.Const.Faction.Player)
				{
				aaa.m.Tail.setFaction(this.Const.Faction.PlayerAnimals);
				}
				else
				{
				aaa.m.Tail.setFaction(aaa.m.Efaction);
				}			
				}	
	}
});

