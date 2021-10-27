(global short g_assault_control 0)

(script startup deadlock_main
    ;(device_set_position wall_door 1)

	(chud_cinematic_fade 0 0)
	(cinematic_show_letterbox TRUE)
    (fade_out 0 0 0 0)
    (sleep 30)
    (ai_place intro_pelican)    
    (fade_in 0 0 0 150)

    (wake enc_assault)
    (ai_place wall_marines_vehicles)
    (ai_place wall_marines)
    
    (ai_place wall_covies)
    
    (ai_place wall_left_cave_covies)
    (ai_place distant_banshees 2)
    (ai_place distant_hornets)
    (ai_place wall_covies_backup02)

    (sleep 300)
    (cinematic_show_letterbox FALSE)
    (chud_cinematic_fade 1 0.5)
)

(global vehicle introPelican NONE)

(script command_script intro_pelican_drop
    (set introPelican (ai_vehicle_get_from_starting_location intro_pelican/starting_locations_0))
    (unit_open introPelican)

    (cs_vehicle_speed 0.6)

    (ai_place intro_squad)
    (vehicle_load_magic introPelican "pelican_p_l05" (player0))
    (ai_vehicle_enter_immediate intro_squad introPelican "pelican_p_r")

    (sleep 30)
    (cs_fly_to_and_face intro_insert/departure_01 intro_insert/departure_01)
    (cs_fly_to_and_face intro_insert/dropoff_pelican intro_insert/intro_lookat)
    (sleep 90)
    (sleep (ai_play_line intro_squad 040MA_160))
    (vehicle_unload introPelican "pelican_p")
    (ai_migrate intro_squad wall_marines)
    
    (sleep 60)
    (unit_close introPelican)
    
    (sleep 200)
    ;(vs_go_to wall_marines_vehicles TRUE intro_insert/midtrail)
    (cs_fly_to_and_face intro_insert/departure_01 intro_insert/departure_01)
    (cs_fly_to_and_face intro_insert/departure_02 intro_insert/departure_02)
    (ai_erase intro_pelican)
)

(script continuous open_door_for_hunters
    ;Don't open the door if the player is about to
    (if (= (volume_test_players controlpanel) FALSE)
        (begin
            (if (volume_test_object trigger_volumes_3 door_hunters)
                (begin 
                    ;Send a signal to the door device on this map to open until it is open
                    (if (!= (device_get_position wall_door) 1)
                        (begin
                            ;(print "opening")
                            (device_group_change_only_once_more_set door TRUE)
                            (device_set_position wall_door 1)
                        )
                    )
                )
                ;Else
                (begin 
                    ;(print "closing")
                    (device_set_power wall_door 1)
                    (device_group_change_only_once_more_set door TRUE) 
                    (device_set_position wall_door 0)
                )
            )
        )

        ;Else
        (begin
            (if (= (device_get_position wall_door) 1)
                (begin
                    (print "End Mission")
                    ;(fade_out 0 0 0 0)
                    ;End update loops
                    (sleep_forever air_battle_loop)
                    (sleep_forever reinforce_loop)
                    (set g_assault_control 2)
                    (sleep_forever open_door_for_hunters)
                )
            )
        )
    )
)

(script continuous air_battle_loop
    (if (< g_assault_control 2)
        (begin 
            (sleep 300)
            (if (= (ai_living_count distant_banshees) 0) 
                (ai_place distant_banshees)
            )

            (if (= (ai_living_count distant_hornets) 0) 
                (ai_place distant_hornets)
            )

            (cs_run_command_script ally_wraith/driver wraith_shoot)
        )
    )
)

;Running a continuous loop for the enemies
(script continuous reinforce_loop
    (if (= g_assault_control 1)
        (begin
            (sleep 100)
            (sleep_until 
            (and 
                (<= (ai_living_count wall_left_cave_covies) 4)
                (<= (ai_living_count phantom_wall) 0)
            ))
            (print "Ghosts dead in loop!")
            (ai_place phantom_wall)
            (ai_cannot_die phantom_wall TRUE)

            (if (<= (ai_living_count wall_covies_backup) 2)
                (ai_place wall_covies_backup)
                (vs_go_to wall_covies_backup TRUE wall_dropoff/bunker)
            )

            (if (= (ai_living_count wall_covies_backup02) 0)
                (ai_place wall_covies_backup02)
                (vs_go_to wall_covies_backup TRUE wall_dropoff/front_top_of_wall)
            )

            (if (= (ai_living_count enemy_banshees) 0)
                (ai_place enemy_banshees)
            )

            (if (= (ai_living_count door_hunters) 0)
                (ai_place door_hunters)
            )
        )
    )
)

;Running a continuous loop for the allies
(script continuous unsc_reinforce_loop
    (if (>= g_assault_control 1)
        (begin
            (sleep 100)
            (sleep_until 
            (and
                (<= (ai_living_count wall_marines) 5)
                (<= (ai_living_count reinforce_pelican) 0)
            ))
            (print "Marines dead in loop!")
            (ai_place reinforce_pelican)
            (ai_cannot_die reinforce_pelican TRUE)
            
            (sleep 100)
            (ai_place reinforce_ally_phantom)
            (ai_cannot_die reinforce_ally_phantom TRUE)
        )
    )
)

(script continuous garbage_collect_loop
    (sleep 200)
    (print "garbage collecting")
    ;Halo 3 makes me sad with how little it can handle the scars of war...
    (add_recycling_volume front_door_volume 30 30)
    (add_recycling_volume air_cleanup 0 10)
)

(script dormant enc_assault
    (print "Bunkering")
    (ai_place ally_wraith_phantom)
    (sleep 700)
    (print "going in")
    (ai_set_objective gr_assualting_marines testing_allies)
    (ai_set_objective gr_assaulting_veh wall_vehicle_area)

    (sleep_until (volume_test_object front_door_volume (ai_get_object gr_assualting_marines)) 1)
    ;(print "open doors")
    ;(device_set_position wall_door 1)
    (ai_place phantom_wall)
    (ai_place door_hunters)
    (set g_assault_control 1)
    (ai_place wall_covies_backup)
    (vs_go_to wall_covies_backup TRUE wall_dropoff/bunker)
)

(global vehicle phantom01 NONE)

(script command_script unload_phantom
    (set phantom01 (ai_vehicle_get_from_starting_location phantom_wall/starting_locations_0))

    (object_cannot_take_damage phantom01)
    
    (ai_place phantom_wall_inf_01)
    (ai_place phantom_wall_ghosts)
    (ai_vehicle_enter_immediate phantom_wall_inf_01 phantom01 "phantom_p")
    (vehicle_load_magic phantom01 "phantom_sc01" (ai_vehicle_get_from_starting_location phantom_wall_ghosts/driver01))
	(vehicle_load_magic phantom01 "phantom_sc02" (ai_vehicle_get_from_starting_location phantom_wall_ghosts/driver02))

    (sleep 30)
    ;Set its approach speed
    (cs_vehicle_speed 0.5)
    (sleep 30)
    ;Fly to a point we set up in Sapien under "Script data"
    (cs_fly_to_and_face wall_dropoff/midtown wall_dropoff/midtown)
    (cs_fly_to_and_face wall_dropoff/dropoff wall_dropoff/dropoff)
    (sleep 30)
    ;Hover
    (vehicle_hover phantom01 TRUE)
    (sleep 30)
    (vehicle_unload phantom01 "phantom_sc01")
    (vehicle_unload phantom01 "phantom_sc02")
    ;Open the phantom
    (unit_open phantom01)
    (sleep 30)
        (sleep 15)
        ;Begin unloading
        (print "start unload")
        (begin_random
            (begin 
                (print "unload p rf")
                (vehicle_unload phantom01 "phantom_p_rf")
                (sleep (random_range 5 15))
            )
            (begin
                (print "unload p rb")
                (vehicle_unload phantom01 "phantom_p_rb")
                (sleep (random_range 5 15))
            )   
        )
        (print "midway")
        (begin_random
            (begin 
                (print "unload p rf")
                (vehicle_unload phantom01 "phantom_p_mr_f")
                (sleep (random_range 5 15))
            )
            (begin
                (print "unload p rb")
                (vehicle_unload phantom01 "phantom_p_mr_b")
                (sleep (random_range 5 15))
            )
        )

        (vehicle_unload phantom01 "phantom_p")
        (ai_migrate phantom_wall_inf_01 wall_left_cave_covies)
        (sleep 90)
    ;Close unit up
    (unit_close phantom01)
    ;Hover and attack
    (vehicle_hover phantom01 FALSE)
    (cs_vehicle_speed 1.0)
    (cs_fly_to_and_face phantom_fallback/retreat phantom_fallback/retreat)

    ;(sleep_until (<= (objects_distance_to_object) phantom01 phantom_fallback/retreat) 5)
    (ai_erase phantom_wall)
)

(global vehicle pelican01 NONE)

(script command_script unload_pelican 
    (set pelican01 (ai_vehicle_get_from_starting_location reinforce_pelican/driver))
    
    (if (= (ai_living_count wall_marines_vehicles) 0)
        (ai_place pelican_hog)
    )
    
    (ai_place pelican_inf_01)
    (ai_vehicle_enter_immediate pelican_inf_01 pelican01 "pelican_p")
    (vehicle_load_magic pelican01 "pelican_lc" (ai_vehicle_get_from_starting_location pelican_hog/driver))
    ;Set its approach speed
    (cs_vehicle_speed 0.5)
    (sleep 30)
    ;Fly to a point we set up in Sapien under "Script data"
    (cs_fly_to_and_face intro_insert/departure_01 intro_insert/departure_01)
    (cs_fly_to_and_face intro_insert/hog_dropoff intro_insert/dropoff_lookat)
    ;Open the phantom
    (unit_open pelican01)
    (vehicle_unload pelican01 "pelican_lc")
    (ai_migrate pelican_hog wall_marines_vehicles)
    (sleep 30)
    (cs_fly_to_and_face intro_insert/dropoff_pelican intro_insert/dropoff_lookat)
    (sleep 90)
    (vehicle_unload pelican01 "pelican_p")
    (ai_migrate pelican_inf_01 wall_marines)
    
    (sleep 200)
    ;(vs_go_to wall_marines_vehicles TRUE intro_insert/midtrail)
    (unit_close pelican01)
    (cs_fly_to_and_face intro_insert/departure_01 intro_insert/departure_01)
    (cs_fly_to_and_face intro_insert/departure_02 intro_insert/departure_02)
    (ai_erase reinforce_pelican)
)

(global vehicle allyPhantom NONE)

(script command_script unload_elites
    (set allyPhantom (ai_vehicle_get_from_starting_location reinforce_ally_phantom/driver))

    (ai_place ally_phantom_inf_01)
    (ai_place ally_phantom_inf_02)
    (ai_place ally_phantom_inf_03)

    (ai_vehicle_enter_immediate ally_phantom_inf_01 allyPhantom "phantom_p_lf")
    (ai_vehicle_enter_immediate ally_phantom_inf_02 allyPhantom "phantom_p_rf")
    (ai_vehicle_enter_immediate ally_phantom_inf_03 allyPhantom "phantom_p")
    ;Set its approach speed
    (cs_vehicle_speed 0.5)
    (sleep 30)
    ;Fly to a point we set up in Sapien under "Script data"
    (cs_fly_to_and_face intro_insert/departure_01 intro_insert/departure_01)
    (cs_fly_to_and_face intro_insert/dropoff_phantom intro_insert/dropoff_lookat)

    ;Open the phantom
    (unit_open allyPhantom)
    (sleep 30)
    (vehicle_unload allyPhantom "phantom_p_lf")
    (vehicle_unload allyPhantom "phantom_p_rf")
    (vehicle_unload allyPhantom "phantom_p")
    (sleep 30)
    (ai_migrate ally_phantom_inf_01 wall_marines)
    (ai_migrate ally_phantom_inf_02 wall_marines)
    (ai_migrate ally_phantom_inf_03 wall_marines)
    (sleep 90)
    (cs_fly_to_and_face intro_insert/departure_01 intro_insert/departure_02)
    (cs_fly_to_and_face intro_insert/departure_02 intro_insert/departure_02)
    (ai_erase reinforce_ally_phantom)
)

(global vehicle allyPhantom02 NONE)

(script command_script unload_wraith
    (set allyPhantom02 (ai_vehicle_get_from_starting_location ally_wraith_phantom/driver))
    (cs_vehicle_speed 0.5)

    (ai_place ally_wraith)
    (vehicle_load_magic allyPhantom02 "phantom_lc" (ai_vehicle_get_from_starting_location ally_wraith/driver))
    (cs_fly_to_and_face intro_insert/departure_01 intro_insert/departure_01)
    (cs_fly_to_and_face intro_insert/wraith_dropoff intro_insert/wraith_dropoff)
    (sleep 30)
    ;Hover
    (vehicle_hover allyPhantom02 TRUE)
    (vehicle_unload allyPhantom02 "phantom_lc")
    (vehicle_hover allyPhantom02 FALSE)
    (cs_fly_to_and_face intro_insert/departure_01 intro_insert/departure_02)
    (cs_fly_to_and_face intro_insert/departure_02 intro_insert/departure_02)
    (ai_erase ally_wraith_phantom)
)

(script command_script wraith_shoot
    (print "Wraith Shooting")
    (sleep_until
        (begin
            (begin_random
                (begin
                    (cs_shoot_point TRUE wraith_targets/p0)
                )
                (begin
                    (cs_shoot_point TRUE wraith_targets/p1)
                )
                (begin
                    (cs_shoot_point TRUE wraith_targets/p2)
                )
                (begin
                    (cs_shoot_point TRUE wraith_targets/p3)
                )
            )
            (>= (ai_living_count ally_wraith) 1)
        )
    )
)