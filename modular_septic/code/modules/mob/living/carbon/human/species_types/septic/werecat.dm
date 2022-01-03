/datum/species/werecat
	name = "Perluni"
	id = SPECIES_WERECAT
	default_color = "4B4B4B"
	species_traits = list(
		MUTCOLORS,
		EYECOLOR,
		LIPS,
		HAS_FLESH,
		HAS_BONE,
		HAIR,
	)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BEAST
	mutant_bodyparts = list()
	default_mutant_bodyparts = list(
		"tail" = ACC_RANDOM,
		"snout" = ACC_RANDOM,
		"ears" = ACC_RANDOM,
		"horns" = "None",
	)
	liked_food = GROSS|MEAT|FRIED
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	limbs_icon = 'modular_septic/icons/mob/human/species/mammal/mammal_parts_greyscale.dmi'
	limbs_id = "mammal"
	examine_icon_state = "werecat"
	say_mod = "mrowls"
	mutanttongue = /obj/item/organ/tongue/cat
	//barbed, knotted pp
	default_genitals = list(ORGAN_SLOT_PENIS = /obj/item/organ/genital/penis/knotted/barbed,
							ORGAN_SLOT_TESTICLES = /obj/item/organ/genital/testicles,
							ORGAN_SLOT_VAGINA = /obj/item/organ/genital/vagina,
							ORGAN_SLOT_WOMB = /obj/item/organ/genital/womb,
							ORGAN_SLOT_BREASTS = /obj/item/organ/genital/breasts,
							ORGAN_SLOT_ANUS = /obj/item/organ/genital/anus,
							)

/datum/species/werecat/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/main_color
	var/second_color
	var/random = rand(1,5)
	//Choose from a variety of mostly coldish, animal, matching colors
	switch(random)
		if(1)
			main_color = "BBAA88"
			second_color = "AAAA99"
		if(2)
			main_color = "777766"
			second_color = "888877"
		if(3)
			main_color = "AA9988"
			second_color = "AAAA99"
		if(4)
			main_color = "EEEEDD"
			second_color = "FFEEEE"
		if(5)
			main_color = "DDCC99"
			second_color = "DDCCAA"
	returned["mcolor"] = main_color
	returned["mcolor2"] = second_color
	returned["mcolor3"] = second_color
	return returned

/datum/species/werecat/get_random_body_markings(list/passed_features)
	var/name = pick("Werecat", "Floof", "Floofer")
	var/datum/body_marking_set/body_marking_set = GLOB.body_marking_sets[name]
	var/list/markings = list()
	if(body_marking_set)
		markings = assemble_body_markings_from_set(body_marking_set, passed_features, src)
	return markings

/datum/species/werecat/random_name(gender,unique,lastname)
	var/randname
	if(gender == MALE)
		randname = pick(GLOB.first_names_male_werecat)
	else
		randname = pick(GLOB.first_names_female_werecat)

	if(lastname)
		randname += " [lastname]"
	else
		randname += " [pick(GLOB.last_names_werecat)]"

	return randname
