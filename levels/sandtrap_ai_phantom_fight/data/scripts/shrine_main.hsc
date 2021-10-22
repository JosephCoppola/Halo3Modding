(script startup shrine_main
	; Set up the guardian turrets (THIS IS ORIGINALLY HERE, REMOVE IF YOU WANT)
	(vehicle_auto_turret turret_north0 tv_turret_north0 185.0 195.0 10.0)
	(vehicle_auto_turret turret_north1 tv_turret_north1 195.0 205.0 10.0)
	(vehicle_auto_turret turret_side0 tv_turret_side0 185.0 190.0 10.0)
	(vehicle_auto_turret turret_side1 tv_turret_side1 182.5 190.0 10.0)
	(vehicle_auto_turret turret_south0 tv_turret_south0 189.0 195.0 10.0)
	(vehicle_auto_turret turret_south1 tv_turret_south1 190.0 200.0 10.0)

    ;Place the various AI squads that exist in scene
    ;Spawning this phantom squad will result in 
    ;unload_phantom below being executed, as in Sapien I 
    ;set the phantom fire teams "placement script" (In the properties palette) to 'unload_phantom'
    (ai_place phantom)
    (ai_place Start_Tank)
    (ai_place squads_4)
    (ai_place start_hornet)
    (ai_place start_banshees)
    (ai_place marine_hog)
    (ai_place squads_8)
    (ai_place squads_9)
)

;Declare the phantom globally, for some reason
(global vehicle phantom_vehi NONE)

;Our actual unload script
(script command_script unload_phantom
    ;Get a reference to our phantom
    (set phantom_vehi (ai_vehicle_get_from_starting_location phantom/starting_locations_0))
    ;Place some grunts to pick up
    (ai_place grunt_phantom_1)
    (ai_place grunt_phantom_2)
    (sleep 30)
    ;Pick up the grunts and insert them into these two positions
    (ai_vehicle_enter_immediate grunt_phantom_1 phantom_vehi "phantom_p_mr_f")
    (ai_vehicle_enter_immediate grunt_phantom_2 phantom_vehi "phantom_p_mr_b")
    ;There are more loading positions in phantoms, including the two below
    ;as well as a slot for vehicles
    ;(ai_vehicle_enter_immediate grunt_phantom_2 phantom_vehi "phantom_p_rf")
    ;(ai_vehicle_enter_immediate grunt_phantom_2 phantom_vehi "phantom_p_rb")
    (sleep 30)
    ;Set its approach speed
    (cs_vehicle_speed 0.5)
    (sleep 30)
    ;Fly to a point we set up in Sapien under "Script data"
    (cs_fly_to_and_face dropoff/dropspot dropoff/dropspot)
    (sleep 30)
    ;Hover
    (vehicle_hover phantom_vehi TRUE)
    (sleep 30)
    ;Open the phantom
    (unit_open phantom_vehi)
    (sleep 30)
        (sleep 15)
        ;Begin unloading
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
    ;Close unit up
    (unit_close phantom_vehi)
    ;Hover and attack
    (vehicle_hover phantom_vehi FALSE)
)
