/atom
	/** I hate that i have to give fucking areas a germ level but it be like that
	 *
	 *  Basically the level of dirtiness on an atom, which will spread to wounds and stuff and cause infections
	 */
	var/germ_level = GERM_LEVEL_AMBIENT
	/// Subtractible armor
	var/datum/subarmor/subarmor
	/// Maximum distance we can be examined from
	var/maximum_examine_distance = 7
	/// The icon_state we use for ghost images on inspect
	var/inspect_icon_state = "what"
	/// Duration of inspection
	var/inspect_duration = 4 SECONDS
	/// Should we ignore any attempts to auto align? Mappers should edit this
	var/manual_align = FALSE
