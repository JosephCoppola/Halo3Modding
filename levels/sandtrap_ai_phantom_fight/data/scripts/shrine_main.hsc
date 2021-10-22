(script startup shrine_main
	; Set up the turrets
	(vehicle_auto_turret turret_north0 tv_turret_north0 185.0 195.0 10.0)
	(vehicle_auto_turret turret_north1 tv_turret_north1 195.0 205.0 10.0)
	(vehicle_auto_turret turret_side0 tv_turret_side0 185.0 190.0 10.0)
	(vehicle_auto_turret turret_side1 tv_turret_side1 182.5 190.0 10.0)
	(vehicle_auto_turret turret_south0 tv_turret_south0 189.0 195.0 10.0)
	(vehicle_auto_turret turret_south1 tv_turret_south1 190.0 200.0 10.0)

    (ai_place phantom)
    (ai_place Start_Tank)
    (ai_place squads_4)
    (ai_place start_hornet)
    (ai_place start_banshees)
    (ai_place marine_hog)
    (ai_place squads_8)
    (ai_place squads_9)
)

(global vehicle phantom_vehi NONE)

(script command_script unload_phantom 
    (set phantom_vehi (ai_vehicle_get_from_starting_location phantom/starting_locations_0))
    (ai_place grunt_phantom_1)
    (ai_place grunt_phantom_2)
    (sleep 30)
    (ai_vehicle_enter_immediate grunt_phantom_1 phantom_vehi "phantom_p_mr_f")
    (ai_vehicle_enter_immediate grunt_phantom_2 phantom_vehi "phantom_p_mr_b")
    (sleep 30)
    (cs_vehicle_speed 0.5)
    (sleep 30)
    (cs_fly_to_and_face dropoff/dropspot dropoff/dropspot)
    (sleep 30)
    (vehicle_hover phantom_vehi TRUE)
    (sleep 30)
    (unit_open phantom_vehi)
    (sleep 30)
        (sleep 15)
        (print "start unload")
        (begin_random
            (begin 
                (print "unload p rf")
                (vehicle_unload phantom_vehi "phantom_p_rf")
                (sleep (random_range 5 15))
            )
            (begin
                (print "unload p rb")
                (vehicle_unload phantom_vehi "phantom_p_rb")
                (sleep (random_range 5 15))
            )
        )
        (print "midway")
        (begin_random
            (begin 
                (print "unload p rf")
                (vehicle_unload phantom_vehi "phantom_p_mr_f")
                (sleep (random_range 5 15))
            )
            (begin
                (print "unload p rb")
                (vehicle_unload phantom_vehi "phantom_p_mr_b")
                (sleep (random_range 5 15))
            )
        )

        (sleep 90)
    (unit_close phantom_vehi)
    (vehicle_hover phantom_vehi FALSE)
)
