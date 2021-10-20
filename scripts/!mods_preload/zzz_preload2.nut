::mods_hookExactClass("entity/tactical/enemies/orc_warlord", function(obj)
{
        local assignRandomEquipment = obj.assignRandomEquipment; 
		obj.assignRandomEquipment = function ()
		{		
		   if (!this.Tactical.State.getStrategicProperties().IsArenaMode)
		  {
          this.m.Items.equip(this.new("scripts/items/accessory/ridable_direwolf"));
		  }
          assignRandomEquipment();
		};
});

::mods_hookExactClass("entity/tactical/enemies/orc_warrior", function(obj)
{
        local assignRandomEquipment = obj.assignRandomEquipment; 
		obj.assignRandomEquipment = function ()
		{		  
		  if (this.Math.rand(0,5) <= 2)
		  {
		  if (!this.Tactical.State.getStrategicProperties().IsArenaMode)
		  {
          this.m.Items.equip(this.new("scripts/items/accessory/ridable_direwolf"));
		  }
		  }
          assignRandomEquipment();
		};
});

::mods_hookExactClass("entity/tactical/enemies/bandit_raider", function(obj)
{
        local assignRandomEquipment = obj.assignRandomEquipment; 
		obj.assignRandomEquipment = function ()
		{		  
		  if (this.Math.rand(0,5) <= 2)
		  {
		  if (!this.Tactical.State.getStrategicProperties().IsArenaMode)
		  {
		  local item = this.new("scripts/items/accessory/ridable_horse")
		  item.m.HelmetScript = this.new("scripts/items/armor/special/warhorse_helmet_01");
		  item.m.Helmetvariant = this.Math.rand(1, 3);
		  item.m.HconditionMax = this.new("scripts/items/armor/special/warhorse_helmet_01").m.ConditionMax;
		  item.m.Hcondition = this.new("scripts/items/armor/special/warhorse_helmet_01").m.Condition;		  
          this.m.Items.equip(item);
		  }	
		  }
          assignRandomEquipment();
		};
});


::mods_hookExactClass("entity/tactical/enemies/bandit_leader", function(obj)
{
        local assignRandomEquipment = obj.assignRandomEquipment; 
		obj.assignRandomEquipment = function ()
		{		
		  if (!this.Tactical.State.getStrategicProperties().IsArenaMode)
		  {
		  local item = this.new("scripts/items/accessory/ridable_horse")
		  item.m.ArmorScript = this.new("scripts/items/armor/special/warhorse_armor_01");
		  item.m.Armorvariant = 1;
		  item.m.AconditionMax = this.new("scripts/items/armor/special/warhorse_armor_01").m.ConditionMax;
		  item.m.Acondition = this.new("scripts/items/armor/special/warhorse_armor_01").m.Condition;
		  item.m.HelmetScript = this.new("scripts/items/armor/special/warhorse_helmet_03");
		  item.m.Helmetvariant = 13;
		  item.m.HconditionMax = this.new("scripts/items/armor/special/warhorse_helmet_03").m.ConditionMax;
		  item.m.Hcondition = this.new("scripts/items/armor/special/warhorse_helmet_03").m.Condition;		  
          this.m.Items.equip(item);
		  }		 
          assignRandomEquipment();
		};
});


::mods_hookExactClass("entity/tactical/humans/knight", function(obj)
{
        local assignRandomEquipment = obj.assignRandomEquipment; 
		obj.assignRandomEquipment = function ()
		{		
		  if (!this.Tactical.State.getStrategicProperties().IsArenaMode)
		  {
		  local item = this.new("scripts/items/accessory/ridable_horse")
		  item.m.ArmorScript = this.new("scripts/items/armor/special/warhorse_armor_03");
		  item.m.Armorvariant = 3;
		  item.m.AconditionMax = this.new("scripts/items/armor/special/warhorse_armor_03").m.ConditionMax;
		  item.m.Acondition = this.new("scripts/items/armor/special/warhorse_armor_03").m.Condition;
		  item.m.HelmetScript = this.new("scripts/items/armor/special/warhorse_helmet_05");
		  item.m.Helmetvariant = 15;
		  item.m.HconditionMax = this.new("scripts/items/armor/special/warhorse_helmet_05").m.ConditionMax;
		  item.m.Hcondition = this.new("scripts/items/armor/special/warhorse_helmet_05").m.Condition;		  
          this.m.Items.equip(item);
		  }		 
          assignRandomEquipment();
		};
});