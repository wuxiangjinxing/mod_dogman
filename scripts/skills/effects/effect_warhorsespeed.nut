this.effect_warhorsespeed <- this.inherit("scripts/skills/skill", {
	m = {
          distance = 0,
		  move = 0,
		  done = 0
		  speedbonus = 0,
		  dir = null,
		  accel = 0,		  
	},
	function create()
	{
		this.m.ID = "effects.warhorsespeed";
		this.m.Name = "Speed management";
		this.m.Icon = "skills/horse_management.png";
		this.m.Description = "Horse is running! If you move straight, speed will be increased. If you try to change direction little bit, speed will be slightly decreased. Otherwise, if you change direction drastically, speed will be 0. If you hit any enemy, speed drops by 10. If you attack the enemy again in the same spot, your speed will be zero. So keep let horse keep running! When speed is more than 50, you will get some Melee Skill, Melee Defense and Ranged Defense buff. On the other hand, when you stop for a while, you get the penalty. Also, it's hard to use any Ranged Weapon on the horse and any damage dealt by enemy will make horse speed 0. When speed is more than 70, this character needs 1 less action point to move.";
		this.m.Type = this.Const.SkillType.StatusEffect;
	}

	function getTooltip()
	{
        local horse = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
		local bonus = 0;	
		local bonus2 = 0;		
		if (this.m.speedbonus >= 50 && this.m.move == 1)
		{
		bonus = this.m.speedbonus / 50;
		bonus = this.Math.floor(bonus * 100);
		bonus = bonus * 0.01;
        bonus = this.Math.pow(bonus, 0.5) - 0.6;
		bonus = this.Math.round(bonus * 100);			
		}
		if (this.m.speedbonus >= 50)
		{
        bonus2 = this.Math.pow(this.m.speedbonus, 0.7)
        bonus2 = this.Math.floor(bonus2);		
		}				
		
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			}
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}			
		];			
		
		  if (this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory).m.Ride == true)
		  {		  			
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Inflicts [color=" + this.Const.UI.Color.PositiveValue + "]" + bonus + "[/color]% more damage while using melee weapons."
			});
			if (- 10 + bonus2 < 0)
			{
			bonus2 = 10 - bonus2;
			
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "- [color=" + this.Const.UI.Color.NegativeValue + "]" + bonus2 + "[/color] Melee Defense"
			});	
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "- [color=" + this.Const.UI.Color.NegativeValue + "]" + bonus2 + "[/color] Ranged Defense"
			});				
			}
			if (- 10 + bonus2 > 0)
			{
			bonus2 = bonus2 - 10;			
			
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "+ [color=" + this.Const.UI.Color.PositiveValue + "]" + bonus2 + "[/color] Melee Defense"
			});	
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "+ [color=" + this.Const.UI.Color.PositiveValue + "]" + bonus2 + "[/color] Ranged Defense"
			});					
			}			
			ret.push({
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] Ranged Skill"
			});
			if (this.m.speedbonus >= 70)
			{
			 ret.push({
			  id = 7,
			  type = "text",
			  icon = "ui/icons/action_points.png",
			  text = "[color=" + this.Const.UI.Color.PositiveValue + "]1[/color] Less Action Point per tile moved."
		     });
			}
		  }
		  else
		  {
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Now this character is unmounted."
			});			  
		  }
		
		return ret;
	}

	function onUpdate( _properties )
	{
        local horse = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
		local bonus = 0;	
		local bonus2 = 0;
		if (this.m.speedbonus >= 50 && this.m.move == 1)
		{
		bonus = this.m.speedbonus / 50;
		bonus = this.Math.floor(bonus * 100);
		bonus = bonus * 0.01;
        bonus = this.Math.pow(bonus, 0.5) - 0.6;	
		}

		if (this.m.speedbonus >= 50)
		{
        bonus2 = this.Math.pow(this.m.speedbonus, 0.7)
        bonus2 = this.Math.floor(bonus2);		
		}		
		
		if (this.m.speedbonus >= 70)
		{
		_properties.MovementAPCostAdditional -= 1;	
		}				
		 if (this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory).m.Ride == true)
		 {					
 		_properties.MeleeDamageMult *= 1 + bonus;  
		_properties.MeleeDefense += - 10 + bonus2;	
		_properties.RangedDefense += - 10 + bonus2;	
		_properties.RangedSkillMult *= 0.8;	
		}
	}   
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.m.IsTargeted != true)
		{
		return;
		}	
		
        if (this.m.done == this.getContainer().getActor().m.ActionPoints)
		{
		return;
		}		  
	   
	    if (this.m.move == 1)
		{
		  this.m.speedbonus = this.Math.max(0, this.m.speedbonus - 10);
		  this.m.accel = this.Math.max(0, this.m.accel - 1);	
		  this.m.move = 0;
		  this.m.done = this.getContainer().getActor().m.ActionPoints;			  
		}
		else 
		{
          this.m.accel = 0; 		
		  this.m.speedbonus = 0;
		  this.m.done = this.getContainer().getActor().m.ActionPoints;			  
		}					
	}	
	
	function onTurnStart()
	{
	    this.m.done = this.getContainer().getActor().m.ActionPoints;		
	    this.m.distance = 0;
	}	
	
	function onTurnEnd()
	{
		if (this.m.distance < 3)
		{
          this.m.accel = 0;		
		  this.m.speedbonus = 0;		
		}
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{	      		
		if (_skill.m.IsAttack != true)
		{
		return;
		}	
		
        this.m.accel = 0;		
		this.m.speedbonus = 0;
		this.m.dir = null;						
	}	

});

