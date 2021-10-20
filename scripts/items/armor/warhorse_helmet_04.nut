this.warhorse_helmet_04 <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.Variant = 1;		
		this.updateVariant();
		this.m.ID = "armor.body.warhorse_helmet_04";
		this.m.Name = "Warhorse Helmet";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Head;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Condition = 140;
		this.m.ConditionMax = 140;
		this.m.StaminaModifier = -10;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;	
		this.m.Sprite = "horse_armor_head_" + variant;
		this.m.SpriteDamaged = "horse_armor_head_" + variant + "_damaged";
		this.m.SpriteCorpse = "horse_armor_head_" + variant + "_dead";
	}

});

