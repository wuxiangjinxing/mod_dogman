this.warhorse_armor_03 <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "armor.body.warhorse_armor_03";
		this.m.Name = "Warhorse Armor";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 240;
		this.m.ConditionMax = 240;
		this.m.StaminaModifier = -28;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;	
		this.m.Sprite = "horse_armor_body_" + variant;
		this.m.SpriteDamaged = "horse_armor_body_" + variant + "_damaged";
		this.m.SpriteCorpse = "horse_armor_body_" + variant + "_dead";
	}
	function updateVariant2()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;	
		this.m.Sprite = "horse_armor_capa_" + variant;
		this.m.SpriteDamaged = "horse_armor_capa_" + variant + "_damaged";
		this.m.SpriteCorpse = "horse_armor_capa_" + variant + "_dead";
	}	
	
});

