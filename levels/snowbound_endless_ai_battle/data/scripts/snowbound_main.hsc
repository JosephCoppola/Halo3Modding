
(script startup snowbound_main
    (wake final_trigger)

    (kill_volume_enable kill_zone_1)
    (kill_volume_enable kill_zone_2)
    (kill_volume_enable kill_zone_3)
    (kill_volume_enable kill_zone_4)
    (kill_volume_enable kill_zone_5)

    ;(sleep_forever reinforce_loop)
    ;(sleep_forever reinforce_sens)
    ;(sleep_forever unsc_reinforce_loop)
    ;(sleep_forever elites_reinforce_loop)
    ;(sleep_forever covies_reinforce_loop)
    
    ;(cinematic_show_letterbox 1)
    ;(cinematic_set_title title_1)
	;(cinematic_title_to_gameplay)
	(print "Start")
    (ai_place pelican_squad_01 1)
    (ai_place r_pelican_01)
    (ai_place r_phantom_01)

    (sleep 700)
    (ai_place r_pelican_01)
    (ai_place r_phantom_01)
)

(script continuous bomb_set
    (sleep_until (= (device_get_position bomb) 1))
    (object_create_anew flood_bomb)
    (object_create_anew upperbomb)
    (print "Boom in 5 seconds")
    (sleep 200)
    (sound_impulse_start "sound\levels\120_halo\trunch_run\huge_expl.sound" NONE 1)
    (object_damage_damage_section upperbomb "death" 100)
    (sleep 20)
    (object_damage_damage_section flood_bomb "death" 100)

    (sleep_forever reinforce_loop)
    (sleep_forever reinforce_sens)
    (sleep_forever unsc_reinforce_loop)
    (sleep_forever elites_reinforce_loop)
    (sleep_forever covies_reinforce_loop)
    (sleep_forever covies_bugger_loop)

    (object_damage_damage_section met_a "main" 1)
    (object_damage_damage_section met_b "main" 1)
    (object_damage_damage_section met_c "main" 1)
    
    ;(sleep 120)
    (sleep 20)
    ;(object_create_anew flood_bomb)
    ;(object_create_anew upperbomb)

    (sleep_forever bomb_set)
)

(script dormant final_trigger
    (sleep_until (= (volume_test_players final) true))
    (print "Time for final fight")
    (kill_volume_disable kill_zone_5)
)

(script continuous garbage_collect_loop
    (sleep 200)
    (print "garbage collecting")
    ;Halo 3 makes me sad with how little it can handle the scars of war...
    (add_recycling_volume hill 15 5)
)

;(script continuous test
;    (sleep 10)
;    (object_damage_damage_section flood_bomb "death" 100)
;    (sleep 20)
;    (object_damage_damage_section upperbomb "death" 100)
;    (sleep 20)
;    (object_create_anew flood_bomb)
;    (object_create_anew upperbomb)
;)

(script continuous ally_objective_loop
    (unsc_objectives)
)

(script continuous covie_objective_loop
    (covie_objectives)
)

(script static void unsc_objectives
    (print "Setting up objectives")
    (ai_set_objective gr_allies ally_bunker)

    (sleep_until (>= (ai_task_count ally_bunker/tasks_0) 3))

    (print "Assaulting allies")
    (ai_set_objective gr_allies assault_middle)

    (sleep_until (<= (ai_living_count gr_allies) 2))

    (print "Bunkering allies")
    (ai_set_objective gr_allies ally_bunker)

    (sleep 100)
    ;(unsc_objectives)
)

(script static void covie_objectives
    (print "Setting up covie objectives")
    (ai_set_objective gr_allies ally_bunker)

    (sleep_until (>= (ai_living_count gr_covies) 3))

    (print "Assaulting covies")
    (ai_set_objective gr_covies assault_middle)

    (sleep_until 
        (<= (ai_living_count gr_covies) 2)
    )

    (print "Bunkering covies")
    (ai_set_objective gr_covies covies_bunker)

    (sleep 100)
    ;(covie_objectives)
)


(script continuous reinforce_sens
    (sleep_until (<= (ai_living_count sens) 2))
    (sleep 180)
    (ai_place sens)
)

(script continuous reinforce_loop
    (sleep 10)
    (sleep_until (<= (ai_living_count assaulting_flood) 7))
    
    (begin_random
        (begin
            (object_create_anew met_a)
            (scenery_animation_start met_a objects\scenery\flood\flood_meteor\flood_meteor "flood_meteor_rock_my_world")
            (sleep (scenery_get_animation_time met_a))
            (object_damage_damage_section met_a "main" 1)
            (sleep 1)
            (ai_place flood_reinforce)
            (ai_migrate flood_reinforce assaulting_flood)
            (object_destroy met_a)
        )
        (begin
            (if (<= (ai_living_count flood_reinforce_b) 1)
                (begin
                    (object_create_anew met_b)
                    (scenery_animation_start met_b objects\scenery\flood\flood_meteor\flood_meteor "flood_meteor_rock_my_world")
                    (sleep (scenery_get_animation_time met_b))
                    (object_damage_damage_section met_b "main" 1)
                    (sleep 1)
                    (ai_place flood_reinforce_b)
                    (object_destroy met_b)
                )
            )
        )
        (begin
            (object_create_anew met_c)
            (scenery_animation_start met_c objects\scenery\flood\flood_meteor\flood_meteor "flood_meteor_rock_my_world")
            (sleep (scenery_get_animation_time met_c))
            (object_damage_damage_section met_c "main" 1)
            (sleep 1)
            (ai_place flood_reinforce_c)
            (ai_migrate flood_reinforce_c assaulting_flood)
            (object_destroy met_c)
        )
    )

    (if (<= (ai_living_count flood_basement_1) 0)
        (ai_place flood_basement_1)
    )
)

;Running a continuous loop for the allies
(script continuous unsc_reinforce_loop
    (sleep 100)
    (sleep_until 
    (and
        (= unsc_reinforce FALSE)
        (or 
            (<= (ai_living_count assaulting_allies_veh_heavy) 0)
            (<= (ai_living_count assaulting_allies) 2))
        )
    ) 
    (print "Marines dead in loop!")
    (ai_place r_pelican_01)
    (ai_cannot_die r_pelican_01 TRUE)
)

;Running a continuous loop for the allies
(script continuous elites_reinforce_loop
    (sleep 100)
    (sleep_until 
        (<= (ai_living_count sq_lb_elites) 0)
    )
    (print "Elites dead in loop!")
    (add_recycling_volume clean_pods 0 0)
    (ai_place sq_lb_elites)
)

;Running a continuous loop for the allies
(script continuous covies_reinforce_loop
    (sleep 100)
    (sleep_until
        (and
            (= covie_reinforce FALSE)        
            (or
                (<= (ai_living_count phantom_wraith) 0)
                (and 
                    (<= (ai_living_count phantom_squad_01) 1)
                    (<= (ai_living_count phantom_squad_02) 1)
                    (<= (ai_living_count phantom_squad_03) 0)
                    (<= (ai_living_count phantom_squad_04) 1)
                )
            )
        )
    )
    (print "Wraith dead in loop!")
    (ai_place r_phantom_01)
)

(script continuous covies_bugger_loop
    (sleep_until (<= (ai_living_count buggers) 1))
    (sleep 200)
    (ai_place buggers)
)

(script command_script test_flood
    (cs_jump_to_point 8 3)
    (sleep 10)
    (cs_enable_pathfinding_failsafe false)
    (cs_force_combat_status 3)
    (cs_jump_to_point 6 3)
    (sleep 10)
    (cs_jump_to_point 8 3)
    (cs_jump_to_point 2 3)
    (ai_migrate ai_current_actor assaulting_flood)
    (cs_go_by flood/p8 flood/p9)
)

(global boolean covie_reinforce FALSE)
(script command_script unload_phantom
    (set covie_reinforce TRUE)

    (if (= (ai_living_count phantom_wraith) 0)
        (begin 
            (ai_place phantom_wraith)
            (vehicle_load_magic (ai_vehicle_get ai_current_actor) "phantom_lc" (ai_vehicle_get_from_starting_location phantom_wraith/driver))
        )
        ;else
        (begin 
            (if (= (ai_living_count phantom_sc_veh) 0)
                (begin
                    (ai_place phantom_sc_veh)
                    (vehicle_load_magic (ai_vehicle_get ai_current_actor) "phantom_lc" (ai_vehicle_get_from_starting_location phantom_sc_veh/driver))
                )
            )
        )
    )
 
    (if (<= (ai_living_count phantom_squad_01) 1)
        (begin
            (ai_migrate phantom_squad_01 r_overflow)
            (ai_place phantom_squad_01)
            (vehicle_load_magic (ai_vehicle_get ai_current_actor) "phantom_pc" (ai_actors phantom_squad_01))
        )
    )

    (if (<= (ai_living_count phantom_squad_02) 1)
        (begin
            (ai_migrate phantom_squad_02 r_overflow)
            (ai_place phantom_squad_02)
            (vehicle_load_magic (ai_vehicle_get ai_current_actor) "phantom_p_rf" (ai_actors phantom_squad_02))
        )
    )

    (if (<= (ai_living_count phantom_squad_03) 0)
        (begin
            (ai_place phantom_squad_03)
            (vehicle_load_magic (ai_vehicle_get ai_current_actor) "phantom_p_lf" (ai_actors phantom_squad_03))
        )
    )

    (if (<= (ai_living_count phantom_squad_04) 1)
        (begin
            (ai_migrate phantom_squad_04 r_overflow)
            (ai_place phantom_squad_04)
            (vehicle_load_magic (ai_vehicle_get ai_current_actor) "phantom_p_lb" (ai_actors phantom_squad_04))
        )
    )

    ;Set its approach speed
	(cs_vehicle_boost true)
    (cs_vehicle_speed 1.0)
    (sleep 30)
    ;Fly to a point we set up in Sapien under "Script data"
	(cs_fly_to approach/phantom_approach_01)
	(cs_vehicle_boost false)
	;(cs_vehicle_speed 0.5)
    (cs_fly_to troop_drop_points/phantom_lc_drop)
    (cs_face 1 troop_drop_points/pelican_face)

	(sleep 30)
    ;Open the phantom
    (unit_open (ai_vehicle_get ai_current_actor))
    (vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_lc")
    ;(ai_migrate pelican_hog wall_marines_vehicles)
    (sleep 50)
    (vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p")
    (sleep 10)
    (vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_rf")
    (sleep 5)
    (vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_lf")
    (sleep 5)
    (vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_lb")

    (if (<= (ai_living_count phantom_squad_05) 2)
        (begin
            (ai_migrate phantom_squad_05 r_overflow)
            (ai_place phantom_squad_05)
            (vehicle_load_magic (ai_vehicle_get ai_current_actor) "phantom_p" (ai_actors phantom_squad_05))
            (vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p")
        )
    )

    (set covie_reinforce FALSE)
    (sleep 100)
    (unit_close (ai_vehicle_get ai_current_actor))
    (cs_face 0 troop_drop_points/pelican_face)
    (cs_vehicle_boost true)
    (cs_fly_to_and_face troop_drop_points/phantom_exit troop_drop_points/phantom_exit)
    ;(ai_erase reinforce_pelican)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(global boolean unsc_reinforce FALSE)
(script command_script unload_pelican
    (set unsc_reinforce TRUE)
    
    (if (= (ai_living_count assaulting_allies_veh_heavy) 0)
        (begin 
            (ai_place pelican_scorp)
            (vehicle_load_magic (ai_vehicle_get ai_current_actor) "pelican_lc" (ai_vehicle_get_from_starting_location pelican_scorp/driver))
        )
        ;else
        (begin 
            (if (= (ai_living_count assaulting_allies_veh) 0)
                (begin
                    (ai_place pelican_hog)
                    (vehicle_load_magic (ai_vehicle_get ai_current_actor) "pelican_lc" (ai_vehicle_get_from_starting_location pelican_hog/driver))
                )
            )
        )
    )

    (ai_place pelican_squad_01 (- 6 (ai_living_count assaulting_allies)))
    (sleep 1)
    (vehicle_load_magic (ai_vehicle_get ai_current_actor) "pelican_p" (ai_actors pelican_squad_01))

    ;Set its approach speed
	(cs_vehicle_boost true)
    (cs_vehicle_speed 1.0)
    (sleep 30)
    ;Fly to a point we set up in Sapien under "Script data"
	(cs_fly_to approach/pelican_approach)
	(cs_vehicle_boost false)
	;(cs_vehicle_speed 0.5)
    (cs_fly_to_and_face troop_drop_points/pelican_lc_drop_01 troop_drop_points/pelican_lc_drop_01)
    (cs_fly_to_and_face troop_drop_points/pelican_lc_drop_01 troop_drop_points/pelican_face)
	
	(sleep 30)
    ;(ai_vehicle_enter_immediate pelican_squad_01 (ai_vehicle_get ai_current_actor) "pelican_p")
    ;Open the phantom
    (unit_open (ai_vehicle_get ai_current_actor))
    (vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_lc")
    (ai_migrate pelican_scorp assaulting_allies_veh_heavy)
    (ai_migrate pelican_hog assaulting_allies_veh)
    (sleep 30)
    (cs_fly_to_and_face troop_drop_points/pelican_p_drop_01 troop_drop_points/pelican_face)
    (sleep 90)
    (vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p")
    (ai_migrate pelican_squad_01 assaulting_allies)
    (sleep 100)
    (set unsc_reinforce FALSE)
    (unit_close (ai_vehicle_get ai_current_actor))
    (cs_fly_to_and_face troop_drop_points/pelican_exit01 troop_drop_points/pelican_exit01)
    (cs_fly_to_and_face troop_drop_points/pelican_exit02 troop_drop_points/pelican_exit02)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_lb_ins_pod_elite01
	(ai_cannot_die ai_current_actor TRUE)
    ;Create pod insertion device machine
	(object_create_anew dm_ent_pod_elite1)
		(sleep 1)
    ;Attach elite's pod vehicle to the newly created machine
	(objects_attach dm_ent_pod_elite1 "pod_attach" (ai_vehicle_get ai_current_actor) "pod_attach")
		(sleep 1)
	
	(device_set_position dm_ent_pod_elite1 1)
	(sleep_until (>= (device_get_position dm_ent_pod_elite1) 1) 1)
	
	(objects_detach dm_ent_pod_elite1 (ai_vehicle_get ai_current_actor))
	(object_destroy dm_ent_pod_elite1)
		(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get ai_current_actor) "door" 15)
		(sleep 15)
    ;(object_damage_damage_section (ai_vehicle_get ai_current_actor) "hull" 10)
    ;Jump out of the pod
	(ai_vehicle_exit ai_current_actor)
	(ai_cannot_die ai_current_actor FALSE)
    ;Force the AI to get into the fight
    (ai_force_active ai_current_actor TRUE)
    (ai_renew ai_current_actor)
    (ai_berserk ai_current_actor TRUE)
)

(script command_script cs_lb_ins_pod_elite02
    (sleep 10)
	(ai_cannot_die ai_current_actor TRUE)
    ;Create pod insertion device machine
	(object_create_anew dm_ent_pod_elite2)
		(sleep 1)
    ;Attach elite's pod vehicle to the newly created machine
	(objects_attach dm_ent_pod_elite2 "pod_attach" (ai_vehicle_get ai_current_actor) "pod_attach")
		(sleep 1)
	
	(device_set_position dm_ent_pod_elite2 1)
	(sleep_until (>= (device_get_position dm_ent_pod_elite2) 1) 1)
	
	(objects_detach dm_ent_pod_elite2 (ai_vehicle_get ai_current_actor))
	(object_destroy dm_ent_pod_elite2)
		(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get ai_current_actor) "door" 15)
		(sleep 15)
    ;(object_damage_damage_section (ai_vehicle_get ai_current_actor) "hull" 10)
    ;Jump out of the pod
	(ai_vehicle_exit ai_current_actor)
	(ai_cannot_die ai_current_actor FALSE)
    ;Force the AI to get into the fight
    (ai_force_active ai_current_actor TRUE)
    (ai_renew ai_current_actor)
)

(script command_script sens_approach
	(cs_vehicle_boost true)
    (cs_fly_by approach/p0 5)
    (cs_fly_by approach/p1 5)
)

(script command_script bug_approach
	(cs_vehicle_boost true)
    (cs_fly_by approach/p2 5)
    (cs_fly_by approach/p3 5)
)