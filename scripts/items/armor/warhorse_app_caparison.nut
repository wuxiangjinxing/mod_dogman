this.warhorse_app_caparison <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.warhorse_caparison_upgrade";
		this.m.Name = "Warhorse Caparison";
		this.m.Description = "A caparison that can be donned by any warhorse. It's just costume and has no durability. It can be used only with Armor.";
		this.m.Variant = this.Math.rand(1, 9);
		this.updateVariant();		
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 500;	
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
		this.m.Icon = "caparison_upgrades/horse_armor_capa_" + variant + ".png";
	}	

	function onUse( _actor, _item = null )
	{
		local horse = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) : _item;

		if (horse == null || horse.getID() != "accessory.ridable_warhorse")
		{
			return false;
		}

		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);

		if (horse.m.Capavariant != 0)
		{
					local vari = horse.m.Capavariant;	
					local bbb = this.new("scripts/items/armor/special/warhorse_app_caparison");
					bbb.m.Variant = vari;
                    bbb.updateVariant();					
					this.World.Assets.getStash().add(bbb);				
		}
		
		horse.m.Capavariant = this.m.Variant;
		horse.Changeappearance();
		return true;
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.updateVariant();
	}

});

