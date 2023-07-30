#define LEADERSHIP "leadership"
#define LEADERSHIP_BOS "leadership_bos"
#define LEADERSHIP_NCR "leadership_ncr"
#define LEADERSHIP_LEGION "leadership_legion"
#define LEADERSHIP_TOWN "leadership_town"
#define VAULT_SCIENTIST "vault_scientist"
#define LEADERSHIP_VAULT "leadership_vault"
#define OUTLAW "outlaw_positions"
#define ELITE_NCR "ncr_elite"
#define ELITE_BOS "bos_elite"
#define ELITE_LEGION "leg_elite"

GLOBAL_LIST_INIT(whitelist_jobs_combined_list, list(LEADERSHIP, LEADERSHIP_BOS, LEADERSHIP_NCR, LEADERSHIP_LEGION, LEADERSHIP_TOWN, VAULT_SCIENTIST, LEADERSHIP_VAULT,
													OUTLAW, ELITE_NCR, ELITE_BOS, ELITE_LEGION))

/datum/admins/proc/add_ckey_to_whitelist()
	set category = "Admin"
	set desc="Lets you add a ckey to the jobs whitelist"
	set name="Add to job whitelist"

	if(!check_rights(R_ADMIN))
		return

	if(!SSdbcore.Connect())
		to_chat(src, span_danger("Failed to establish database connection."))
		return

	var/choosen_ckey = sanitizeSQL(input(src, "Enter desired Ckey", "Ckey") as text|null)
	var/choosen_whitelist = sanitizeSQL(input(src, "Pick desired jobs", "Jobs") as anything in GLOB.whitelist_jobs_combined_list)
	var/confirm = input(src, "Do you wish to confirm the addition?", "Confirmation") as anything in list("yes", "no")
	if (confirm != "yes")
		return
	var/datum/db_query/query_add_whitelist = SSdbcore.NewQuery(
		"INSERT INTO [format_table_name("role_whitelist")] (whitelist, ckey) VALUES (:choosen_whitelist, :choosen_ckey)",
		list("choosen_whitelist" = choosen_whitelist, "choosen_ckey" = choosen_ckey)
	)
	if(!query_add_whitelist.warn_execute())
		qdel(query_add_whitelist)
		return
	qdel(query_add_whitelist)

	log_admin("[key_name(usr)] has added [choosen_ckey] to the jobs [choosen_whitelist].")
	message_admins("[key_name_admin(usr)] has added [choosen_ckey] to the jobs [choosen_whitelist].")
	SSblackbox.record_feedback("nested tally", "add_ckey_to_joblist", 1, list("Add Ckey to Jobs Whitelist", "[choosen_ckey]:[choosen_whitelist]"))

/datum/admins/proc/remove_ckey_from_whitelist()
	set category = "Admin"
	set desc="Lets you remove a ckey from the jobs whitelist"
	set name="Remove from job whitelist"

	if(!check_rights(R_ADMIN))
		return

	if(!SSdbcore.Connect())
		to_chat(src, span_danger("Failed to establish database connection."))
		return

	var/choosen_ckey = sanitizeSQL(input(src, "Enter desired Ckey", "Ckey") as text|null)
	var/choosen_whitelist = sanitizeSQL(input(src, "Pick desired jobs", "Jobs") as anything in GLOB.whitelist_jobs_combined_list)
	var/confirm = input(src, "Do you wish to confirm the addition?", "Confirmation") as anything in list("yes", "no")
	if (confirm != "yes")
		return
	var/datum/db_query/query_remove_whitelist = SSdbcore.NewQuery(
		"DELETE FROM [format_table_name("role_whitelist")] WHERE whitelist = :choosen_whitelist AND ckey = :choosen_ckey",
		list("choosen_whitelist" = choosen_whitelist, "choosen_ckey" = choosen_ckey)
	)
	if(!query_remove_whitelist.warn_execute())
		qdel(query_remove_whitelist)
		return
	qdel(query_remove_whitelist)

	log_admin("[key_name(usr)] has added [choosen_ckey] to the jobs [choosen_whitelist].")
	message_admins("[key_name_admin(usr)] has added [choosen_ckey] to the jobs [choosen_whitelist].")
	SSblackbox.record_feedback("nested tally", "add_ckey_to_joblist", 1, list("Add Ckey to Jobs Whitelist", "[choosen_ckey]:[choosen_whitelist]"))
