::mods_registerJS("mod_removablehorsearmor.js");

::mods_hookNewObjectOnce("ui/screens/character/character_screen", function(o) {
    o._aa_onBrotherSelected <- function(id) { m._aa_SelectedBrotherId <- id; }

    o.detachhorseArmor <- function()
    {
      if("_aa_SelectedBrotherId" in m)
      {
        local bro = Tactical.getEntityByID(m._aa_SelectedBrotherId);
        if(bro != null)
        {
          local acce = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
          if(acce != null)
          {
            if ("onRide" in acce)
            {
              acce.removearmor();
			  acce.ChangeEquip();
              acce.onUnequip();
              acce.onEquip();			  
              loadData();		  
            }
          }
        }
      }
    }
  });

::mods_hookNewObjectOnce("states/world_state", function(o) {
    local keyHandler = o.helper_handleContextualKeyInput;
    o.helper_handleContextualKeyInput = function(key)
    {
      if(key.getKey() == 16 && key.getModifier() == 4 && key.getState() == 0 && isInCharacterScreen()) // alt-D
      {
        if(!Tactical.isActive() && m.CharacterScreen.isInStashMode()) m.CharacterScreen.detachhorseArmor();
        return true;
      }
      else
      {
        return keyHandler(key);
      }
    }
  });
  

::mods_hookExactClass("ai/tactical/behaviors/ai_attack_default", function ( o )
{
		o.m.PossibleSkills.extend([
			"actives.warhorse_kick",
			"actives.fire_breath22",
			"actives.ridable_gorge",
			"actives.ridable_gorge2"
		]);	
});
::mods_hookExactClass("ai/tactical/behaviors/ai_charge", function ( o )
{
		o.m.PossibleSkills.extend([
			"actives.horse_charge"
		]);	
});
::mods_hookExactClass("ai/tactical/behaviors/ai_engage_melee", function ( o )
{
		o.m.PossibleSkills.extend([
			"actives.horse_charge"
		]);	
});
::mods_hookExactClass("ai/tactical/behaviors/ai_attack_thresh", function ( o )
{
		o.m.PossibleSkills.extend([
			"actives.ridable_tail_slam_big"
		]);	
});
::mods_hookExactClass("ai/tactical/behaviors/ai_attack_swing", function ( o )
{
		o.m.PossibleSkills.extend([
			"actives.ridable_tail_slam"
		]);	
});

::mods_hookNewObject("entity/tactical/tactical_entity_manager", function ( obj )
{
	local spawn = obj.spawn;
	obj.spawn = function ( _properties )
	{
	   spawn( _properties );
	   
		local actors = this.Tactical.Entities.getAllInstances();
		
		foreach( i in actors )
		{
			foreach( a in i )
			{
			 if (a.getSkills().hasSkill("actives.ridable_gorge"))
			 {				 
			   a.getSkills().getSkillByID("actives.ridable_gorge").spawntail();
			 }			
			 if (a.getSkills().hasSkill("actives.ridable_gorge2"))
			 {				 
			   a.getSkills().getSkillByID("actives.ridable_gorge2").spawntail();
			 }
			}
		}	   
	}
});

::mods_hookExactClass("entity/tactical/player", function ( obj )
{
	local getTooltip = obj.getTooltip;
	obj.getTooltip = function ( _targetedWithSkill = null )
	{
		local tooltip = getTooltip(_targetedWithSkill);
		local b = tooltip.len();
		local aaa = this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
		local spmanage = this.getSkills().getSkillByID("effects.warhorsespeed");

        if (aaa == null)
		{
		return tooltip;		
		}

        if (!("onRide" in aaa))
		{
		return tooltip;		
		}

		if (aaa.m.Ride == true)
		{
				local maxspeed = this.Math.floor(aaa.m.Initiative * this.Const.accelvariant[this.getTile().Type]);
				
				tooltip.insert(b, {
					id = 10,
					type = "text",
					icon = "skills/horse_tooltip.png",
					text = aaa.getName()
				});
				tooltip.insert(b + 1, {
					id = 10,
					type = "progressbar",
					icon = "ui/icons/armor_head.png",
					value = aaa.m.Hcondition,
					valueMax = aaa.m.HconditionMax,
					text = "" + aaa.m.Hcondition + " / " + aaa.m.HconditionMax + "",
					style = "armor-head-slim"
				});
				tooltip.insert(b + 2, {
					id = 10,
					type = "progressbar",
					icon = "ui/icons/armor_body.png",
					value = aaa.m.Acondition,
					valueMax = aaa.m.AconditionMax,
					text = "" + aaa.m.Acondition + " / " + aaa.m.AconditionMax + "",
					style = "armor-head-slim"
				});
				tooltip.insert(b + 3, {
					id = 10,
					type = "progressbar",
					icon = "ui/icons/health.png",
					value = aaa.m.Hitpoints,
					valueMax = aaa.m.Base[1],
					text = "" + aaa.m.Hitpoints + " / " + aaa.m.Base[1] + "",
					style = "hitpoints-slim"
				});
				tooltip.insert(b + 4, {
					id = 10,
					type = "progressbar",
					icon = "ui/icons/fatigue.png",
					value = aaa.m.Fatigue,
					valueMax = aaa.m.Fatigue2,
					text = "" + aaa.m.Fatigue + " / " + aaa.m.Fatigue2 + "",
					style = "fatigue-slim"
				});
				if (this.getSkills().hasSkill("effects.warhorsespeed"))
				{
				tooltip.insert(b + 5, {
					id = 10,
					type = "text",
					icon = "ui/icons/initiative.png",
					text = "Speed bonus : " + spmanage.m.speedbonus + " (Max : " + maxspeed + ")"
				});
				}
		}

		return tooltip;
	};
});
::mods_hookExactClass("entity/tactical/actor", function ( o )
{
	local onDamageReceived = o.onDamageReceived;
	o.onDamageReceived = function ( _attacker, _skill, _hitInfo )
	{	
		local aaa = this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);	
	
        if (aaa == null)
		{
        return onDamageReceived( _attacker, _skill, _hitInfo );	
		}

        if (!("onRide" in aaa))
		{
        return onDamageReceived( _attacker, _skill, _hitInfo );	
		}				
		
		if (aaa.m.Ride == true)
		{
		local random = this.Math.rand(1, 100);		
		if (random <= 70)
		{
		   if (_skill == null)
		   {
		    onDamageReceived( _attacker, _skill, _hitInfo );	
	     	return this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory).onHorseDamageReceived( _attacker, _skill, _hitInfo );
		   }
		   else if (_skill.getID() == "effects.bleeding" || _skill.getID() == "effects.spider_poison")
		   {
           return onDamageReceived( _attacker, _skill, _hitInfo );	
		   }
		   else
		   {
		   return this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory).onHorseDamageReceived( _attacker, _skill, _hitInfo );
		   }			
		}		
		}
        return onDamageReceived( _attacker, _skill, _hitInfo );
	}

	local onMovementStep = o.onMovementStep;
	o.onMovementStep = function ( _tile, _levelDifference )
	{
		local ret = onMovementStep(_tile, _levelDifference);

		if (ret)
		{
		
		local aaa = this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);	

        if (aaa == null)
		{
		return ret;		
		}

        if (!("onRide" in aaa))
		{
		return ret;		
		}
		
		  if (aaa.m.Ride == true)
		  {
				local horse = this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
				local horseCost = horse.m.Haspathfiner == true ? this.Math.round(this.Const.PathfinderMovementFatigueCost[_tile.Type]) : this.Math.round(this.Const.DefaultMovementFatigueCost[_tile.Type]);
				local spmanage = this.getSkills().getSkillByID("effects.warhorsespeed");
				local wolfbite = this.getSkills().getSkillByID("actives.riding_wolf_bite");
				local accelvariant = this.Const.accelvariant[_tile.Type];

				if (_levelDifference != 0)
				{
					horseCost = horseCost + 4;

					if (_levelDifference > 0)
					{
						horseCost = horseCost + this.Const.Movement.LevelClimbingFatigueCost;
					}
				}

				local oritile = this.getTile();
				local dir = oritile.getDirectionTo(_tile);

				if (horse.m.Fatigue + horseCost <= horse.m.Fatigue2)
				{			
					horse.m.Fatigue = this.Math.min(horse.m.Fatigue2, this.Math.round(horse.m.Fatigue + horseCost));
					horse.m.Initiative = horse.m.Initiative2 - horse.m.Fatigue;
					
					if ("getTail" in aaa) 
					{
					aaa.getTail().setFatigue(this.Math.max(0, aaa.getTail().getFatigue() + horseCost));
					}
					
					if (this.getSkills().hasSkill("actives.riding_wolf_bite"))
					{
					wolfbite.m.done = this.m.ActionPoints;		
					}
					
					if (this.getSkills().hasSkill("effects.warhorsespeed"))
					{
					spmanage.m.distance += 1;		
					spmanage.m.move = 1;		
					spmanage.m.done = this.m.ActionPoints;					

					if (spmanage.m.dir == null)
					{
						spmanage.m.dir = dir;
					}
					else if (spmanage.m.dir == dir)
					{
						spmanage.m.accel = this.Math.max(0, spmanage.m.accel + 1 - _levelDifference);		
						local accel = this.Math.pow(spmanage.m.accel, 0.7);
						accel = this.Math.floor(horse.m.Initiative * 0.15 * accel * accelvariant);
						spmanage.m.speedbonus = this.Math.min(horse.m.Initiative * accelvariant, spmanage.m.speedbonus + accel);
						spmanage.m.dir = dir;
					}
					else if (dir == spmanage.m.dir - 1 || dir == spmanage.m.dir + 1 || dir == spmanage.m.dir + 5 || dir == spmanage.m.dir - 5)
					{
						spmanage.m.accel = this.Math.max(0, spmanage.m.accel - 1 - _levelDifference);								
						spmanage.m.speedbonus = this.Math.round(spmanage.m.speedbonus * 0.8);
						spmanage.m.dir = dir;
					}
					else
					{
						spmanage.m.accel = 0;						
						spmanage.m.speedbonus = 0;
						spmanage.m.dir = dir;
					}		
					}
				}
				else
				{
		local apCost = this.Math.max(1, (this.m.ActionPointCosts[_tile.Type] + this.m.CurrentProperties.MovementAPCostAdditional) * this.m.CurrentProperties.MovementAPCostMult);
		local fatigueCost = this.Math.round((this.m.FatigueCosts[_tile.Type] + this.m.CurrentProperties.MovementFatigueCostAdditional) * this.m.CurrentProperties.MovementFatigueCostMult);

		if (_levelDifference != 0)
		{
			apCost = apCost + this.m.LevelActionPointCost;
			fatigueCost = fatigueCost + this.m.LevelFatigueCost;

			if (_levelDifference > 0)
			{
				fatigueCost = fatigueCost + this.Const.Movement.LevelClimbingFatigueCost;
			}
		}

		fatigueCost = fatigueCost * this.m.CurrentProperties.FatigueEffectMult;
		this.m.ActionPoints = this.Math.round(this.m.ActionPoints + apCost);
		this.m.Fatigue = this.Math.min(this.getFatigueMax(), this.Math.round(this.m.Fatigue - fatigueCost));				
					return false;
				}
			}
			else
			{
			return ret;
			}
		}

		return ret;
	};	
	
    local resetRenderEffects = o.resetRenderEffects;
	o.resetRenderEffects = function ()	
	{
		
		local aaa = this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);			
        if (aaa != null)
		{
         if ("onRide" in aaa)
		 {
            if (aaa.m.Ride == true)
			{
				this.m.IsRaising = false;
				this.m.IsSinking = false;
				this.m.IsRaisingShield = false;
				this.m.IsLoweringShield = false;
				this.m.IsRaisingWeapon = false;
				this.m.IsLoweringWeapon = false;
				this.setRenderCallbackEnabled(false);
                local offset = aaa.m.Rideroffset;
			    this.setSpriteOffset("shield_icon", offset);
			    this.setSpriteOffset("arms_icon", offset);
				this.getSprite("arms_icon").Rotation = 0;
				this.getSprite("status_rooted").Visible = false;
				this.getSprite("status_rooted_back").Visible = false;			
			}
		 }
		}
		else
		{
		resetRenderEffects();
		}
	}	
	
	o.onRender = function ()
	{
	     
        local aaa = this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);			 
		if (aaa != null && "onRide" in aaa && aaa.m.Ride == true) 
		{
		}
		else
	    {
		if (this.m.IsRaisingShield)
		{
			if (this.moveSpriteOffset("shield_icon", this.createVec(0, 0), this.Const.Items.Default.RaiseShieldOffset, this.Const.Items.Default.RaiseShieldDuration, this.m.RenderAnimationStartTime))
			{
				this.m.IsRaisingShield = false;

				if (!this.m.IsUsingCustomRendering)
				{
					this.setRenderCallbackEnabled(false);
				}
			}
		}
		else if (this.m.IsLoweringShield)
		{
			if (this.moveSpriteOffset("shield_icon", this.Const.Items.Default.RaiseShieldOffset, this.createVec(0, 0), this.Const.Items.Default.LowerShieldDuration, this.m.RenderAnimationStartTime))
			{
				this.m.IsLoweringShield = false;

				if (!this.m.IsUsingCustomRendering)
				{
					this.setRenderCallbackEnabled(false);
				}
			}
		}
		}

		if (this.m.IsLoweringWeapon)
		{
			local p = (this.Time.getVirtualTimeF() - this.m.RenderAnimationStartTime) / this.Const.Items.Default.LowerWeaponDuration;

			if (this.m.Items.getAppearance().TwoHanded)
			{
				this.getSprite("arms_icon").Rotation = this.Math.minf(1.0, p) * -70.0;
			}
			else
			{
				this.getSprite("arms_icon").Rotation = this.Math.minf(1.0, p) * -33.0;
			}

			if (p >= 1.0)
			{
				this.m.IsLoweringWeapon = false;

				if (!this.m.IsUsingCustomRendering)
				{
					this.setRenderCallbackEnabled(false);
				}
			}
		}
		else if (this.m.IsRaisingWeapon)
		{
			local p = (this.Time.getVirtualTimeF() - this.m.RenderAnimationStartTime) / this.Const.Items.Default.RaiseWeaponDuration;

			if (this.m.Items.getAppearance().TwoHanded)
			{
				this.getSprite("arms_icon").Rotation = (1.0 - this.Math.minf(1.0, p)) * -70.0;
			}
			else
			{
				this.getSprite("arms_icon").Rotation = (1.0 - this.Math.minf(1.0, p)) * -33.0;
			}

			if (p >= 1.0)
			{
				this.m.IsRaisingWeapon = false;

				if (!this.m.IsUsingCustomRendering)
				{
					this.setRenderCallbackEnabled(false);
				}
			}
		}

		if (this.m.IsRaising)
		{
			local p = (this.Time.getVirtualTimeF() - this.m.RenderAnimationStartTime) / (this.Const.Combat.ResurrectAnimationTime * this.m.RenderAnimationSpeed);

			if (p >= 1.0)
			{
				this.setPos(this.createVec(0, 0));
				this.setAlpha(255);
				this.m.IsRaising = false;
				this.m.IsAttackable = true;

				if (!this.m.IsUsingCustomRendering)
				{
					this.setRenderCallbackEnabled(false);
				}
			}
			else
			{
				this.setPos(this.createVec(0, this.Const.Combat.ResurrectAnimationDistance * this.m.RenderAnimationDistanceMult * (1.0 - p)));
			}
		}
		else if (this.m.IsSinking)
		{
			local p = (this.Time.getVirtualTimeF() - this.m.RenderAnimationStartTime) / (this.Const.Combat.ResurrectAnimationTime * this.m.RenderAnimationSpeed);

			if (p >= 1.0)
			{
				this.setPos(this.createVec(0, this.Const.Combat.ResurrectAnimationDistance * this.m.RenderAnimationDistanceMult));
				this.m.IsSinking = false;
				this.m.IsAttackable = true;

				if (!this.m.IsUsingCustomRendering)
				{
					this.setRenderCallbackEnabled(false);
				}
			}
			else
			{
				this.setPos(this.createVec(0, this.Const.Combat.ResurrectAnimationDistance * this.m.RenderAnimationDistanceMult * p));
			}
		}

		if (this.m.IsRaisingRooted)
		{
			local from = this.createVec(this.m.RenderAnimationOffset.X, this.m.RenderAnimationOffset.Y - 100);
			this.moveSpriteOffset("status_rooted_back", from, this.m.RenderAnimationOffset, this.Const.Combat.RootedAnimationTime, this.m.RenderAnimationStartTime);

			if (this.moveSpriteOffset("status_rooted", from, this.m.RenderAnimationOffset, this.Const.Combat.RootedAnimationTime, this.m.RenderAnimationStartTime))
			{
				this.m.IsRaisingRooted = false;

				if (!this.m.IsUsingCustomRendering)
				{
					this.setRenderCallbackEnabled(false);
				}

				this.setDirty(true);
			}
		}
	}	
	
	local checkMorale = o.checkMorale;
	o.checkMorale = function ( _change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false ) 
	{	
        checkMorale( _change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false );
		
        local aaa = this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);			 
		if (aaa != null && "onRide" in aaa && aaa.m.Ride == true && "getTail" in aaa)
		{
		 if (aaa.m.Tail != null && !aaa.m.Tail.isNull() && aaa.m.Tail.isAlive())
		 {		
			aaa.m.Tail.setMoraleState(this.getMoraleState());
		 }	
		}		
	}	
	
	local setFaction = o.setFaction;
	o.setFaction = function ( _f ) 
	{
	   setFaction( _f )
		
        local aaa = this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);			 
		if (aaa != null && "onRide" in aaa && aaa.m.Ride == true && "getTail" in aaa)
		{
		 if (aaa.m.Tail != null && !aaa.m.Tail.isNull() && aaa.m.Tail.isAlive())
		 {
			this.m.Tail.setFaction(_f);
		 }
	    }
	}	
});

::mods_hookNewObject("states/world/asset_manager", function(o)
	{
		local update = o.update;
		o.update = function(_worldState)
		{
			if (this.World.getTime().Hours != this.m.LastHourUpdated && this.m.IsConsumingAssets)
			{
				local roster = this.World.getPlayerRoster().getAll();
			    local campMultiplier = this.isCamping() ? 1.5 : 1.0;	
				
				foreach(bro in roster)
				{
					local aaa = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
					if ("onRide" in aaa)
					{
						if (aaa.m.Hitpoints < aaa.m.Base[1])
						{
							aaa.m.Hitpoints = this.Math.min(aaa.m.Base[1], aaa.m.Hitpoints + this.Math.floor(aaa.m.Hitpoints * 0.02 * campMultiplier));
							aaa.Changeappearance();
						}
					}
					if ("getTail" in aaa)
					{
						if (aaa.m.Acondition < aaa.m.AconditionMax)
						{
						    local d = this.Math.minf(this.Const.World.Assets.ArmorPerHour * campMultiplier, aaa.m.AconditionMax - aaa.m.Acondition);
							aaa.m.Acondition = aaa.m.Acondition + d;
						    d = this.Math.minf(this.Const.World.Assets.ArmorPerHour * campMultiplier, aaa.m.HconditionMax - aaa.m.Hcondition);
							aaa.m.Hcondition = aaa.m.Hcondition + d;							
						}
					}					
				}

				foreach(bro in roster)
				{
					local aaa = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
					if (aaa != null && "onRide" in aaa && !("getTail" in aaa))
					{
						if (this.m.ArmorParts == 0)
						{
							break;
						}
						if (aaa.m.AconditionMax != 0 && aaa.m.Acondition < aaa.m.AconditionMax)
						{
						    local d = this.Math.minf(this.Const.World.Assets.ArmorPerHour * campMultiplier, aaa.m.AconditionMax - aaa.m.Acondition);
							aaa.m.Acondition = aaa.m.Acondition + d;
							this.m.ArmorParts = this.Math.maxf(0, this.m.ArmorParts - d * 0.067);
							aaa.Changeappearance();
						}
					}
				}
				
				foreach(bro in roster)
				{
					local aaa = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
					if (aaa != null && "onRide" in aaa && !("getTail" in aaa))
					{
						if (this.m.ArmorParts == 0)
						{
							break;
						}
						if (aaa.m.HconditionMax != 0 && aaa.m.Hcondition < aaa.m.HconditionMax)
						{
						    local d = this.Math.minf(this.Const.World.Assets.ArmorPerHour * campMultiplier, aaa.m.HconditionMax - aaa.m.Hcondition);
							aaa.m.Hcondition = aaa.m.Hcondition + d;
							this.m.ArmorParts = this.Math.maxf(0, this.m.ArmorParts - d * 0.067);
							aaa.Changeappearance();
						}
					}
				}				

				local stash = this.World.Assets.getStash().getItems();
				foreach(item in stash)
				{
					if (item != null && item.getItemType() == this.Const.Items.ItemType.Accessory && "onRide" in item)
					{
						if (item.m.Hitpoints < item.m.Base[1])
						{
							item.m.Hitpoints = this.Math.min(item.m.Base[1], item.m.Hitpoints + this.Math.floor(item.m.Hitpoints * 0.02 * campMultiplier));
						}
					}
					if (item != null && item.getItemType() == this.Const.Items.ItemType.Accessory && "getTail" in item)
					{
						if (item.m.Acondition < item.m.AconditionMax)
						{
						    local d = this.Math.minf(this.Const.World.Assets.ArmorPerHour * campMultiplier, item.m.AconditionMax - item.m.Acondition);
							item.m.Acondition = item.m.Acondition + d;
						    d = this.Math.minf(this.Const.World.Assets.ArmorPerHour * campMultiplier, item.m.HconditionMax - item.m.Hcondition);
							item.m.Hcondition = item.m.Hcondition + d;									
						}
					}						
				}
				foreach(item in stash)
				{
					if (item != null && item.getItemType() == this.Const.Items.ItemType.Accessory && "onRide" in item && !("getTail" in item))
					{
						if (this.m.ArmorParts == 0)
						{
							break;
						}
						if (item.m.AconditionMax != 0 && item.m.Acondition < item.m.AconditionMax)
						{
						    local d = this.Math.minf(this.Const.World.Assets.ArmorPerHour * campMultiplier, item.m.AconditionMax - item.m.Acondition);
							item.m.Acondition = item.m.Acondition + d;
							this.m.ArmorParts = this.Math.maxf(0, this.m.ArmorParts - d * 0.067);
						}
					}
				}
				
				foreach(item in stash)
				{
					if (item != null && item.getItemType() == this.Const.Items.ItemType.Accessory && "onRide" in item && !("getTail" in item))
					{
						if (this.m.ArmorParts == 0)
						{
							break;
						}
						if (item.m.HconditionMax != 0 && item.m.Hcondition < item.m.HconditionMax)
						{
						    local d = this.Math.minf(this.Const.World.Assets.ArmorPerHour * campMultiplier, item.m.HconditionMax - item.m.Hcondition);
							item.m.Hcondition = item.m.Hcondition + d;
							this.m.ArmorParts = this.Math.maxf(0, this.m.ArmorParts - d * 0.067);
						}
					}
				}				
							
			}

			update(_worldState);
		}
});


::mods_hookNewObject("items/item_container", function ( o )
{	
	local equip = o.equip;
	o.equip = function( _item )
	 {
		if (_item.getID() == "accessory.ridable_reddragon")
		{
			if (this.getActor().getFlags().has("IsRejuvinated"))
			{
			 return false;			
			}
		}	
      return equip( _item ); 
     }
});

::mods_hookNewObject("entity/world/player_party", function(o)
	{
		local updateStrength = o.updateStrength;
		o.updateStrength = function()
			{
				updateStrength();
				
				local bros = this.World.getPlayerRoster().getAll();

				foreach( i, bro in bros )
				{
					local aaa = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
					
					if (aaa != null && "onRide" in aaa)
					{
 					  if (aaa.getID() == "accessory.ridable_warhorse")
					  {
						this.m.Strength += 20;
					  }	
					}
				}
			}
	});