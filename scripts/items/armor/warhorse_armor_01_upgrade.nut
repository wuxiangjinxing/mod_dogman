this.warhorse_armor_01_upgrade <- this.inherit("scripts/items/item", {
	m = {
		StaminaModifier = -10,	
	},
	function create()
	{
		this.m.ID = "misc.warhorse_armor_01_upgrade";
		this.m.Name = "Warhorse Leather Armor";
		this.m.Description = "A leather Armor that can be donned by any warhorse to give it protection in combat.";
		this.m.Variant = 1;
		this.updateVariant();		
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 400;
		this.m.Condition = 95;
		this.m.ConditionMax = 95;		
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
			icon = "ui/icons/armor_body.png",
			value = this.getCondition(),
			valueMax = this.getConditionMax(),
			text = "" + this.getCondition() + " / " + this.getConditionMax() + "",
			style = "armor-body-slim"
		});
			result.push({
				id = 5,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Maximum Fatigue [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color]"
			});		
		result.push({
			id = 65,
			type = "text",
			text = "Right-click or drag onto a warhorse equipped by the currently selected character in order to use. This item will be consumed in the process."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}
	
	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Icon = "armor_upgrades/horse_armor_body_" + variant + ".png";
	}	

	function onUse( _actor, _item = null )
	{
		local horse = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) : _item;

		if (horse == null || horse.getID() != "accessory.ridable_warhorse")
		{
			return false;
		}

		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);

		if (horse.getArmorScript())
		{
			for( local i = 1; i < 14; i = i )
			{
				if (horse.m.ArmorScript.getID() == this.new("scripts/items/armor/special/warhorse_armor_0" + i).getID())
				{
				    local aaa = horse.m.Acondition; 
					local vari = horse.m.Armorvariant;	
					local bbb = this.new("scripts/items/armor/special/warhorse_armor_0" + i + "_upgrade");
					bbb.m.Condition = aaa;
					bbb.m.Variant = vari;
                    bbb.updateVariant();					
					this.World.Assets.getStash().add(bbb);
					break;					
				}

				i = ++i;
			}
		}

		horse.m.ArmorScript = this.new("scripts/items/armor/special/warhorse_armor_01");
		horse.m.Acondition = this.m.Condition;
		horse.m.AconditionMax = this.m.ConditionMax;
		horse.m.Armorvariant = this.m.Variant;
		horse.ChangeEquip()
		horse.Changeappearance();
		return true;
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.updateVariant();
	}

});

