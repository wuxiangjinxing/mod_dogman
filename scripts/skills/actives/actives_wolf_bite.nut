this.actives_wolf_bite <- this.inherit("scripts/skills/skill", {
	m = {
		  done = 0	
	},

	function create()
	{
		this.m.ID = "actives.riding_wolf_bite";
		this.m.Name = "Bite";
		this.m.Description = "";
		this.m.KilledString = "Mangled";
		this.m.Icon = "skills/active_71.png";
		this.m.Overlay = "active_71";
		this.m.SoundOnUse = [
			"sounds/enemies/wolf_bite_01.wav",
			"sounds/enemies/wolf_bite_02.wav",
			"sounds/enemies/wolf_bite_03.wav",
			"sounds/enemies/wolf_bite_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.25;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.IsHidden = true;
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 50;
			_properties.DamageRegularMax = 70;
			_properties.DamageArmorMult = 0.8;
		}	
	
		local actor = this.getContainer().getActor();		
	
		if (!_skill.isAttack())
		{
		return;
		}	
		
        if (this.m.done == actor.m.ActionPoints)
		{
		return;
		}		  	   	
		
		if (_skill == this)
		{
		return;
		}
		
		if (actor.getTile().getDistanceTo(_targetEntity.getTile()) > 1)
		{
		return;
		}
			
        if (this.Tactical.TurnSequenceBar.getActiveEntity().getID() != this.getContainer().getActor().getID())
		{
		return;
		}		
		
		if (this.Math.rand(1, 100) <= 60)
		{
		return;
		}	
		
		if (!this.getContainer().getActor().isHiddenToPlayer() && _targetEntity.getTile().IsVisibleForPlayer)
		{
			this.getContainer().setBusy(true);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, function ( _skill )
			{
				if (_targetEntity.isAlive())
				{
			      this.attackEntity(this.getContainer().getActor(), _targetEntity)
				  this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill, actor.getTile().Pos);
				  this.getContainer().setBusy(false);
				}
			}.bindenv(this), _skill);		
			
	       this.m.done = actor.m.ActionPoints;			
		   return;
		}	
		else
		{
			if (_targetEntity.isAlive())
			{		
			this.attackEntity(this.getContainer().getActor(), _targetEntity)
			}
		}	
	}

	function onTurnStart()
	{
	  this.m.done = this.getContainer().getActor().m.ActionPoints;	
	}

});

