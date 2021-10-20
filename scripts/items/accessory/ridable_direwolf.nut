this.ridable_direwolf <- this.inherit("scripts/items/accessory/ridable_pet", {
	m = {},
	function create()
	{
		this.ridable_pet.create();
		this.m.Variant = 0;		
		this.m.ID = "accessory.ridable_direwolf";
		this.m.Name = this.Const.Strings.WardogNames[this.Math.rand(0, this.Const.Strings.WardogNames.len() - 1)] + " the Direwolf";		
		this.m.Description = "";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = false;
		this.m.Value = 1000;
		this.m.Script = "scripts/entity/tactical/riding_direwolf";
		this.m.Type = this.Const.Tactical.Actor.Warwolf;
		this.m.Ride = true;				
		this.m.Bodysprite = "bust_direwolf_body_10";
		this.m.Headsprite = "bust_direwolf_head_10";		
		this.m.Injuheadprite = "bust_direwolf_head_100_injured";			
		this.m.Injubodysprite = "bust_direwolf_body_100_injured";			
		this.m.Rideroffset = this.createVec(-12, 15);
		this.m.Petoffset = this.createVec(10, -13);
		this.m.Weaponoffset = this.createVec(-30, 23);
		this.m.Shieldoffset = this.createVec(0, 23);
		this.m.RiderRoffset = this.createVec(12, 15);
		this.m.PetRoffset = this.createVec(-10, -13);
		this.m.WeaponRoffset = this.createVec(30, 23);
		this.m.ShieldRoffset = this.createVec(0, 23);	
		this.m.AconditionMax = 60;
		this.m.Acondition = 60;
		this.m.HconditionMax = 60;
		this.m.Hcondition = 60;		
		this.m.UnleashSounds = [
			"sounds/enemies/wolf_idle_00.wav",
			"sounds/enemies/wolf_idle_01.wav",
			"sounds/enemies/wolf_idle_02.wav",
			"sounds/enemies/wolf_idle_03.wav",
			"sounds/enemies/wolf_idle_04.wav",
			"sounds/enemies/wolf_idle_06.wav",
			"sounds/enemies/wolf_idle_07.wav",
			"sounds/enemies/wolf_idle_08.wav",
			"sounds/enemies/wolf_idle_09.wav"
		];		
		this.m.DamageReceived = [
			"sounds/enemies/wolf_hurt_00.wav",
			"sounds/enemies/wolf_hurt_01.wav",
			"sounds/enemies/wolf_hurt_02.wav",
			"sounds/enemies/wolf_hurt_03.wav"
		];
		this.m.Death = [
			"sounds/enemies/wolf_death_00.wav",
			"sounds/enemies/wolf_death_01.wav",
			"sounds/enemies/wolf_death_02.wav",
			"sounds/enemies/wolf_death_03.wav",
			"sounds/enemies/wolf_death_04.wav",
			"sounds/enemies/wolf_death_05.wav"
		];	
		this.m.Haspathfiner = true;
		this.updateVariant();	
		this.randomize();			
	}
	
	function onEquip()
	{
		this.ridable_pet.onEquip();
		local charge = this.new("scripts/skills/actives/actives_wolf_bite");
		this.addSkill(charge);				
	}
	
	function onRide()
	{
		this.ridable_pet.onRide();	
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

