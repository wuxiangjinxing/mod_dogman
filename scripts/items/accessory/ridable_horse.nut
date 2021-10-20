this.ridable_horse <- this.inherit("scripts/items/accessory/ridable_pet", {
	m = {},
	function create()
	{
		this.ridable_pet.create();
		this.m.Variant = this.Math.rand(0, 7);		
		this.m.ID = "accessory.ridable_warhorse";
		this.m.Name = this.Const.Strings.WardogNames[this.Math.rand(0, this.Const.Strings.WardogNames.len() - 1)] + " the Warhorse";		
		this.m.Description = "";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = false;
		this.m.Value = 1000;
		this.m.Script = "scripts/entity/tactical/riding_warhorse";
		this.m.Type = this.Const.Tactical.Actor.Warhorse;
		this.m.Ride = true;				
		this.m.Bodysprite = "bust_horsenaked_body_10";
		this.m.Headsprite = "bust_horsehead_10";		
		this.m.Injuheadprite = "bust_horsehead_100_injured";			
		this.m.Injubodysprite = "bust_horsenaked_body_100_injured";			
		this.m.Rideroffset = this.createVec(-12, 15);
		this.m.Petoffset = this.createVec(10, -13);
		this.m.Weaponoffset = this.createVec(-30, 23);
		this.m.Shieldoffset = this.createVec(0, 23);
		this.m.RiderRoffset = this.createVec(12, 15);
		this.m.PetRoffset = this.createVec(-10, -13);
		this.m.WeaponRoffset = this.createVec(30, 23);
		this.m.ShieldRoffset = this.createVec(0, 23);		
		this.m.UnleashSounds = [
			"sounds/misc/donkey_idle_02.wav",
			"sounds/misc/donkey_idle_03.wav",
			"sounds/misc/donkey_idle_04.wav",
			"sounds/misc/donkey_idle_06.wav"
		];		
		this.m.DamageReceived = [
			"sounds/ambience/buildings/caravan_horse_neighing_00.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_01.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_02.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_03.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_04.wav",
			"sounds/ambience/buildings/caravan_horse_neighing_05.wav"
		];
		this.m.Death = [
			"sounds/misc/donkey_death_02.wav"
		];	
		this.m.Haspathfiner = true;
		this.updateVariant();	
		this.randomize();			
	}

	function getTooltip()
	{
	  local ret = this.ridable_pet.getTooltip();
	  		
			ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "To remove the equipments, press the button Alt + F"
		});		
		return ret;
	}
	
	function onEquip()
	{
		this.ridable_pet.onEquip();
		local charge = this.new("scripts/skills/actives/actives_horsecharge");
		this.addSkill(charge);				
	}
	
	function onRide()
	{
		this.ridable_pet.onRide();	
	}
});

