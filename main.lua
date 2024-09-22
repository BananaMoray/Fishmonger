
-- Fishmonger v1.0.0
-- Frithuritaks feat. SmoothSpatula
log.info("Successfully loaded ".._ENV["!guid"]..".")

mods.on_all_mods_loaded(function()
    for _, m in pairs(mods) do
        if type(m) == "table" and m.RoRR_Modding_Toolkit then
            Alarm = m.Alarm
            Buff = m.Buff
            Helper = m.Helper
            Object = m.Object
            Resources = m.Resources
            Skill = m.Skill
            State = m.State
            Survivor = m.Survivor
            Survivor_Log = m.Survivor_Log
            break
        end
    end
end)

if hot_reloading then
    __initialize()
end
hot_reloading = true

local PATH = _ENV["!plugins_mod_folder_path"]
local NAMESPACE = "BananaMoray"

__initialize = function()
    -- Display Explosion hitbox
    gm.object_set_visible(gm.constants.oExplosionAttack, true)

    -- == Section Sprites == --

    -- Menu Sprites

    -- Resources.sprite_load(namespace, identifier, path, [img_num], [x_orig], [y_orig])
    local sFishmongerPortrait = Resources.sprite_load(NAMESPACE, "sFishmongerPortrait", path.combine(PATH, "Sprites", "sFishmongerPortrait.png"), 3)
    local sFishmongerPortraitSmall = Resources.sprite_load(NAMESPACE, "sFishmongerPortraitSmall", path.combine(PATH, "Sprites", "sFishmongerPortraitSmall.png"))
    local sFishmongerSkills = Resources.sprite_load(NAMESPACE, "sFishmongerSkills", path.combine(PATH, "Sprites", "sFishmongerSkills.png"), 9)
    local sSelectFishmonger = Resources.sprite_load(NAMESPACE, "sSelectFishmonger", path.combine(PATH, "Sprites", "sSelectFishmonger.png"), 4, 28, 0)

    local bullet_path = path.combine(PATH, "Sprites", "IWBTSBullet.png")

    -- In Game Sprites
    local sprites = {
        idle = Resources.sprite_load(NAMESPACE, "sFishmongerIdle", path.combine(PATH, "Sprites", "sFishmongerIdle.png"), 10, 26, 19),
        walk = Resources.sprite_load(NAMESPACE, "sFishmongerWalk", path.combine(PATH, "Sprites", "sFishmongerWalk.png"), 10, 23, 19),
        jump = Resources.sprite_load(NAMESPACE, "sFishmongerJump", path.combine(PATH, "Sprites", "sFishmongerJump.png"), 2, 26, 19),
        jump_peak = Resources.sprite_load(NAMESPACE, "sFishmongerJumpPeak", path.combine(PATH, "Sprites", "sFishmongerJumpPeak.png"), 2, 26, 19),
        fall = Resources.sprite_load(NAMESPACE, "sFishmongerFall", path.combine(PATH, "Sprites", "sFishmongerFall.png"), 1, 26, 19),
        climb = Resources.sprite_load(NAMESPACE, "sFishmongerClimb", path.combine(PATH, "Sprites", "sFishmongerClimb.png"), 6, 18, 19, 3),
        death = Resources.sprite_load(NAMESPACE, "sFishmongerDeath", path.combine(PATH, "Sprites", "sFishmongerDeath.png"), 8, 45, 19),
        decoy = Resources.sprite_load(NAMESPACE, "sFishmongerDummy", path.combine(PATH, "Sprites", "sFishmongerDummy.png"), 1, 16, 15),
        drone_idle = Resources.sprite_load(NAMESPACE, "sDronePlayerFishmongerIdle", path.combine(PATH, "Sprites", "sDronePlayerFishmongerIdle.png"), 4, 13, 18),
        drone_shoot = Resources.sprite_load(NAMESPACE, "sDronePlayerFishmongerShoot", path.combine(PATH, "Sprites", "sDronePlayerFishmongerShoot.png"), 4, 42, 18)
    }
    

    -- local attack1_sprite = Resources.sprite_load(NAMESPACE, "sFishmongerAttack1", path.combine(PATH, "Sprites","sFishmongerAttack1.png"), 14, 44, 35)
    local sFishmongerPrimary1_1 = Resources.sprite_load(NAMESPACE, "sFishmongerPrimary1_1", path.combine(PATH, "Sprites", "sFishmongerPrimary1_1.png"), 8, 44, 35)
    local sFishmongerPrimary1_2 = Resources.sprite_load(NAMESPACE, "sFishmongerPrimary1_2", path.combine(PATH, "Sprites", "sFishmongerPrimary1_2.png"), 8, 44, 35)
    local sFishmongerUtility1 = Resources.sprite_load(NAMESPACE, "sFishmongerUtility1", path.combine(PATH, "Sprites", "sFishmongerUtility1.png"), 9, 23, 19)
    local sFishmongerSpecial1 = Resources.sprite_load(NAMESPACE, "sFishmongerSpecial1", path.combine(PATH, "Sprites", "sFishmongerSpecial1.png"), 7, 12, 19)
    local sFishmongerSpecial1Boosted = Resources.sprite_load(NAMESPACE, "sFishmongerSpecial1Boosted", path.combine(PATH, "Sprites", "sFishmongerSpecial1Boosted.png"), 7, 12, 19)
    -- bait bucket --
    local sFishmongerBait = Resources.sprite_load(NAMESPACE, "sFishmongerBait", path.combine(PATH, "Sprites", "sFishmongerBait.png"), 1, 7, 19)
    -- Splash
    local sFishmongerGeyser = Resources.sprite_load(NAMESPACE, "sFishmongerGeyser", path.combine(PATH, "Sprites", "sFishmongerGeyser.png"), 9, 32, 50)


    -- Sprite Offsets

    -- Sprite Speeds
    gm.sprite_set_speed(sprites.idle, 0.65, 1) -- idle animation speed
    gm.sprite_set_speed(sprites.walk, 0.7, 1) -- walk animation speed
    gm.sprite_set_speed(sprites.death, 1, 1) 
    -- gm.sprite_set_speed(attack1_sprite, 1, 1)
    gm.sprite_set_speed(sFishmongerUtility1, 1, 1)
    gm.sprite_set_speed(sFishmongerSpecial1, 1, 1)
    gm.sprite_set_speed(sFishmongerSpecial1Boosted, 1, 1)
    gm.sprite_set_speed(sSelectFishmonger, -5, 0) -- loadout Speed

    -- == Section Audio == --

    local shoot_sfx = gm.audio_create_stream(path.combine(PATH, "Sprites", "shoot.ogg"))
    if shoot_sfx ~= -1 then 
        log.info("Loaded death sfx.")
    else
        log.info("Failed to load sfx")
    end

    -- == Section Setup + Stats == --

    local bullet_speed = 10.0
    local jump_force = 8.0

    -- Primary
    local hook_combo_counter = 30
    local hook_attack_offset = 64
    local hook_width = 75
    local hook_height = 35

    -- Utility
    local splash_damage = 1.0
    local splash_knockup_force = 8.0
    local splash_width = 40
    local splash_height = 25
    local slash_slide_force = 5

    -- Create a new survivor
    local fishmonger = Survivor.new(NAMESPACE, "fishmonger")

    -- Set the selection animation of the survivor
    fishmonger.sprite_loadout = sSelectFishmonger

    -- Set the portraits of the survivor
    fishmonger.sprite_portrait = sFishmongerPortrait
    fishmonger.sprite_portrait_small = sFishmongerPortraitSmall

    -- The survivor's walk animation on the title screen when selected
    fishmonger.sprite_title = sprites.walk
    
    -- The survivor's idle animation
    fishmonger.sprite_idle = sprites.idle
    
    -- The survivor's idle animation when beating the game
    fishmonger.sprite_credits = sprites.idle
    
    -- The color of the character's skill names in the character select
    fishmonger:set_primary_color(238, 173, 105)
    
    -- Set the Prophet cape offset for the survivor
    fishmonger:set_cape_offset(0, -9, 3, -1)

    -- Set the survivor's sprites to those we previously loaded
    fishmonger:set_animations(sprites)

    -- Set the survivor's starting stats
    -- (maxhp, damage, regen, armor, attack_speed, critical_chance, maxshield)
    fishmonger:set_stats_base(110, 24, 0.01)
    
    -- Set the survivor's starting physics stats
    -- (hmax, vmax, gravity1, gravity2, accel)
    fishmonger:set_stats_base(nil, jump_force)
    
    -- Set the survivor's leveling stats
    --(maxhp, damage, regen, armor, attack_speed, critical_chance))
    fishmonger:set_stats_level()


    -- Create survivor log
    local fishmonger_log = Survivor_Log.new(fishmonger)


    -- == Section skills == --

    local skill_hook = fishmonger:get_primary()
    -- (Sprite Skill, Subimage)
    skill_hook:set_skill_icon(sFishmongerSkills, 0)
    -- (Damage, Cooldown)
    skill_hook:set_skill_properties(1.0, 15)

    local skill_ensnaringNet = fishmonger:get_secondary()
    skill_ensnaringNet:set_skill_icon(sFishmongerSkills, 1)
    skill_ensnaringNet:set_skill_properties(10.0, 0)
    skill_ensnaringNet:set_skill_animation(sprites.idle)
    skill_ensnaringNet.require_key_press = true

    local skill_splash = fishmonger:get_utility()
    skill_splash:set_skill_icon(sFishmongerSkills, 2)
    skill_splash:set_skill_properties(10.0, 1 * 60)
    skill_splash:set_skill_animation(sFishmongerUtility1)
    skill_splash.require_key_press = true

    local skill_liveBait = fishmonger:get_special()
    skill_liveBait:set_skill_icon(sFishmongerSkills, 3)
    skill_liveBait:set_skill_properties(10.0, 5 * 60)
    skill_liveBait:set_skill_animation(sFishmongerSpecial1)
    skill_liveBait.require_key_press = true

    --(namespace, identifier, cooldown, damage, sprite_id, sprite_subimage, animation, is_primary, is_utility)
    -- Create alt special
    local skill_stillFishing = Skill.new(
        NAMESPACE,
        skill_liveBait.identifier.."2",
        5 * 60,
        10.0,
        sFishmongerSkills,
        5,
        sprites.idle,
        false,
        false
    )
    skill_stillFishing.require_key_press = true
    fishmonger:add_special(skill_stillFishing)

    -- Create boosted specials (for scepter)
    local skill_liveBaitBoosted = Skill.new(
        NAMESPACE,
        skill_liveBait.identifier.."Boosted",
        5 * 60,
        20.0,
        sFishmongerSkills,
        4,
        sFishmongerSpecial1Boosted,
        false,
        false
    )
    skill_liveBaitBoosted.require_key_press = true
    skill_liveBait:set_skill_upgrade(skill_liveBaitBoosted)

    local skill_stillFishingBoosted = Skill.new(
        NAMESPACE,
        skill_stillFishing.identifier.."Boosted",
        5 * 60,
        20.0,
        sFishmongerSkills,
        6,
        sprites.idle,
        false,
        false
    )
    skill_stillFishingBoosted.require_key_press = true
    skill_stillFishing:set_skill_upgrade(skill_stillFishingBoosted)


    -- Create State skill
    local state_hookA = State.new(NAMESPACE, skill_hook.identifier.."A")
    local state_hookB = State.new(NAMESPACE, skill_hook.identifier.."B")
    local state_ensnaringNet = State.new(NAMESPACE, skill_ensnaringNet.identifier)
    local state_splash = State.new(NAMESPACE, skill_splash.identifier)
    local state_liveBait = State.new(NAMESPACE, skill_liveBait.identifier)
    local state_liveBaitBoosted = State.new(NAMESPACE, skill_liveBaitBoosted.identifier)
    local state_stillFishing = State.new(NAMESPACE, skill_stillFishing.identifier)
    local state_stillFishingBoosted = State.new(NAMESPACE, skill_stillFishingBoosted.identifier)


    -- Setup the Primary skill

    local fishmonger_decr_counter = nil
    fishmonger_decr_counter = function(actor)
        if actor.fishmonger_count == 0 then return end

        actor.fishmonger_count = actor.fishmonger_count - 1
        Alarm.create(fishmonger_decr_counter, 1, actor)
    end

    skill_hook:onActivate(function(actor, skill, index)
        local actorAC = actor.value

        if actorAC.fishmonger_count == 0 then
            gm.actor_set_state(actorAC, state_hookA.value)
            actorAC.fishmonger_count = hook_combo_counter
            Alarm.create(fishmonger_decr_counter, 1, actorAC)
        else
            actorAC.fishmonger_count = 0
            gm.actor_set_state(actorAC, state_hookB.value)
        end
    end)

    state_hookA:onEnter(function(actor, data)
        actor.image_index = 0
        data.fired = 0
    end)

    state_hookA:onStep(function(actor, data)
        local actorAC = actor.value

        actorAC:skill_util_fix_hspeed()
        
        actorAC:actor_animation_set(sFishmongerPrimary1_1, 0.25)

        if data.fired == 0 and actorAC.image_index >= 3 then
            local damage = actorAC:skill_get_damage(skill_hook.value)

            local attack_offset = hook_attack_offset
            if actorAC:skill_util_facing_direction() == 180 then 
                attack_offset = -attack_offset
            end

            if actorAC:is_authority() then
                if not actorAC:skill_util_update_heaven_cracker(actorAC, damage) then
                    local buff_shadow_clone = Buff.find("ror", "shadowClone")
                    for i=0, gm.get_buff_stack(actorAC, buff_shadow_clone.value) do
                        local attack = gm._mod_attack_fire_explosion(actorAC, actorAC.x + attack_offset, actorAC.y, hook_width, hook_height, damage, -1, gm.constants.sSparks17_PROV)
                        attack.attack_info.stun = true
                        attack.attack_info.climb = i * 8
                    end
                end
            end

            -- gm.sound_play_at(gm.constants.wMercenaryShoot1_3, 1, 1, actorAC.x, actorAC.y, 500)
            actorAC:sound_play(gm.constants.wMercenaryShoot1_3, 1, 0.9 + math.random() * 0.2)
            data.fired = 1
        end

        actorAC:skill_util_exit_state_on_anim_end()
    end)
    
    state_hookB:onEnter(function(actor, data)
        actor.image_index = 0
        data.fired = 0
    end)

    state_hookB:onStep(function(actor, data)
        local actorAC = actor.value

        actorAC:skill_util_fix_hspeed()

        actorAC:actor_animation_set(sFishmongerPrimary1_2, 0.25)

        if data.fired == 0 and actorAC.image_index >= 3 then
            local damage = actorAC:skill_get_damage(skill_hook.value)

            local attack_offset = hook_attack_offset
            if actorAC:skill_util_facing_direction() == 180 then 
                attack_offset = -attack_offset
            end

            if actorAC:is_authority() then
                if not actorAC:skill_util_update_heaven_cracker(actorAC, damage) then
                    local buff_shadow_clone = Buff.find("ror", "shadowClone")
                    for i=0, gm.get_buff_stack(actorAC, buff_shadow_clone.value) do
                        local attack = gm._mod_attack_fire_explosion(actorAC, actorAC.x + attack_offset, actorAC.y, hook_width, hook_height, damage, -1, gm.constants.sSparks17_PROV)
                        attack.attack_info.stun = true
                        attack.attack_info.climb = i * 8
                    end
                end
            end

            actorAC:sound_play(gm.constants.wMercenaryShoot1_3, 1, 0.9 + math.random() * 0.2)
            data.fired = 1
        end

        actorAC:skill_util_exit_state_on_anim_end()
    end)


    -- Setup the Secondary skill


    -- Setup the Utility skill

    -- Splash Object
    local splash_direction = 1
    local splash = Object.new(NAMESPACE, "fishmongerSplash")
    splash:set_sprite(sFishmongerGeyser)
    splash:set_depth(1)

    splash:onCreate(function(inst)
        inst.image_index = 0
        inst.image_xscale = splash_direction
        inst.knockup_force = splash_knockup_force
        inst.damage = splash_damage
        inst.fired = 0
    end)

    splash:onStep(function(inst)
        inst.image_speed = 0.25

        if inst.fired == 0 and inst.image_index >= 1 then
            local attack = gm._mod_attack_fire_explosion_noparent(inst.x, inst.y, splash_width, splash_height, 1, inst.damage, false, -1, gm.constants.sSparks17_PROV)
            attack.attack_info.stun = true -- change stun duration?
            attack.attack_info.knockup = inst.knockup_force
            
            inst.fired = 1
        elseif inst.image_index >= 8.0 then
            inst:destroy()
        end
    end)

    skill_splash:onActivate(function(actor, skill, index)
        gm.actor_set_state(actor.value, state_splash.value)
    end)

    state_splash:onEnter(function(actor, data)
        actor.image_index = 0
        data.fired = 0
        data.slide = 0
    end)

    state_splash:onStep(function(actor, data)
        local actorAC = actor.value

        actorAC:skill_util_fix_hspeed()

        actorAC:actor_animation_set(actorAC:actor_get_skill_animation(skill_splash.value), 0.25)

        if data.fired == 0 and actorAC.image_index >= 0 then
            local damage = actorAC:skill_get_damage(skill_splash.value)

            local attack_offset = 20
            if actorAC:skill_util_facing_direction() == 180 then 
                attack_offset = -attack_offset
            end
            
            if actorAC:is_authority() then
                local buff_shadow_clone = Buff.find("ror", "shadowClone")
                for i=0, gm.get_buff_stack(actorAC, buff_shadow_clone.value) do
                    local attack = gm._mod_attack_fire_explosion(actorAC, actorAC.x + attack_offset, actorAC.y, splash_width, splash_height, damage, -1, gm.constants.sSparks17_PROV)
                    attack.attack_info.stun = true -- change stun duration?
                    attack.attack_info.climb = i * 8

                    splash_direction = gm.cos(gm.degtorad(actorAC:skill_util_facing_direction()))
                    splash:create(actorAC.x + attack_offset, actorAC.y)
                end
            end

            actorAC:sound_play(gm.constants.wGeyser, 1, 0.9 + math.random() * 0.2)
            data.fired = 1
        elseif data.slide == 0 and actorAC.image_index >= 2 then

            actorAC.pHspeed = -gm.cos(gm.degtorad(actorAC:skill_util_facing_direction())) * actorAC.pHmax * slash_slide_force

            actorAC:sound_play(gm.constants.wCommandoRoll, 1, 0.9 + math.random() * 0.2)
            data.slide = 1
        end

        if data.slide == 1 and actorAC.image_index >= 8.0 then
            if actorAC.invincible <= 5 then
                actorAC.invincible = 0
            end
        else
            if actorAC.invincible < 5 then 
                actorAC.invincible = 5
            end
        end

        actorAC:skill_util_exit_state_on_anim_end()
    end)


    -- Setup the Special1 skill


    -- Setup the Special1 Boosted skill


    -- Setup the Special2 skill


    -- Setup the Special2 Boosted skill
    

end
