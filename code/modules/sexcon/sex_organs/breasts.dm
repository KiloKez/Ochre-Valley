/obj/item/organ/breasts
	name = "breasts"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_BREASTS
	organ_dna_type = /datum/organ_dna/breasts
	accessory_type = /datum/sprite_accessory/breasts/pair
	var/breast_size = DEFAULT_BREASTS_SIZE
	var/lactating = FALSE
	// Kez TODO: should probably use reagants property for this instead?
	var/milk_stored = 0
	var/milk_max = 75
	var/in_use = FALSE
	// Kez TODO: Add milk color and flavor attributes here?

/obj/item/organ/breasts/New()
	..()
	milk_max = max(75, breast_size * 100)

/obj/item/organ/breasts/Initialize()
	create_reagents(milk_max)
	reagents.add_reagent(/datum/reagent/consumable/milk, rand(6,milk_max))
	. = ..()

/obj/item/organ/breasts/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()

/obj/item/organ/breasts/Remove(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()




///  Lots of code copied from udders -- would it make more sense to just create an udder object
///  that the breasts uses instead of copying stuff over?

/obj/item/organ/breasts/proc/generateMilk()
	reagents.add_reagent(/datum/reagent/consumable/milk, 1)

/obj/item/organ/breasts/proc/milk(obj/O, mob/user)
	var/obj/item/reagent_containers/glass/G = O
	if(in_use)
		return
	if(G.reagents.total_volume >= G.volume)
		to_chat(user, span_warning("[O] is full."))
		return
	if(!reagents.has_reagent(/datum/reagent/consumable/milk, 5))
		to_chat(user, "<span class='warning'>The breasts are dry. Wait a bit longer...</span>")
		return
	beingmilked()
	playsound(O, pick('modular/Creechers/sound/milking1.ogg', 'modular/Creechers/sound/milking2.ogg'), 100, TRUE, -1)
	if(do_after(user, 20, target = src))
		reagents.trans_to(O, rand(5,10))
		user.visible_message("<span class='notice'>[user] milks [src] using \the [O].</span>", "<span class='notice'>I milk [src] using \the [O].</span>")

/obj/item/organ/breasts/proc/beingmilked()
	in_use = TRUE
	//Caustic Edit
	spawn(20)
		in_use = FALSE
	//Caustic Edit End