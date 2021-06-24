local delay = require('scripts/libs/delay')

local fall_off_2 = {
    --these offsets will modify the warp landing location so that the player can animate from their spawn location nicely
    pre_animation_offsets={
        x=0,
        y=0,
        z=0
    },
    duration=1,
    animate=function(player_id)
        local player_pos = Net.get_player_position(player_id)
        local area_id = Net.get_player_area(player_id)
        local landing_z = player_pos.z-2
        local fall_duration = 0.3
        local keyframes = {{
            properties={{
                property="Z",
                value=player_pos.z
            }},
            duration=0.0
        }}
        keyframes[#keyframes+1] = {
            properties={{
                property="Z",
                ease="In",
                value=landing_z
            }},
            duration=fall_duration
        }
        Net.animate_player_properties(player_id, keyframes)
        delay.for_player(player_id,function ()
            local sound_path = '/server/assets/landings/earthquake.ogg'
            Net.play_sound(area_id, sound_path)
            Net.shake_player_camera(player_id, 1, 0.5)
            Net.unlock_player_input(player_id)
        end,fall_duration)
    end
}

return fall_off_2