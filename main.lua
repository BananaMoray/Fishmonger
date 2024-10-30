-- Fishmonger v1.0.0
-- Frithuritaks feat. SmoothSpatula
log.info("Successfully loaded ".._ENV["!guid"]..".")

mods["RoRRModdingToolkit-RoRR_Modding_Toolkit"].auto()

if hot_reloading then
    initialize()
end
hot_reloading = true

local PATH = _ENV["!plugins_mod_folder_path"]
local NAMESPACE = "BananaMoray"

initialize = function()
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

    local sFishmongerSecondary1 = Resources.sprite_load(NAMESPACE, "sFishmongerSecondary1", path.combine(PATH, "Sprites", "sFishmongerSecondary1.png"), 12, 36, 20)

    local sFishmongerUtility1 = Resources.sprite_load(NAMESPACE, "sFishmongerUtility1", path.combine(PATH, "Sprites", "sFishmongerUtility1.png"), 9, 23, 19)
    local sFishmongerSpecial1 = Resources.sprite_load(NAMESPACE, "sFishmongerSpecial1", path.combine(PATH, "Sprites", "sFishmongerSpecial1.png"), 7, 12, 19)
    local sFishmongerSpecial1Boosted = Resources.sprite_load(NAMESPACE, "sFishmongerSpecial1Boosted", path.combine(PATH, "Sprites", "sFishmongerSpecial1Boosted.png"), 7, 12, 19)
    -- bait bucket --
    local sFishmongerBait = Resources.sprite_load(NAMESPACE, "sFishmongerBait", path.combine(PATH, "Sprites", "sFishmongerBait.png"), 1, 7, 19)
    -- Splash
    local sFishmongerGeyser = Resources.sprite_load(NAMESPACE, "sFishmongerGeyser", path.combine(PATH, "Sprites", "sFishmongerGeyser.png"), 9, 32, 50)
    -- Net
    local sFishmongerNet = Resources.sprite_load(NAMESPACE, "sFishmongerNet", path.combine(PATH, "Sprites", "sFishmongerNet.png"), 7, 48, 19)
    -- Live Bait
    local sFishmongerLiveBait = Resources.sprite_load(NAMESPACE, "sFishmongerSpecialFish", path.combine(PATH, "Sprites", "sFishmongerSpecialFish.png"), 8, 12, 19)

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
    local hook_attack_offset = 56
    local hook_width = 100
    local hook_height = 35

    -- Secondary 
    local ensnaring_net_duration = 60
    local ensnaring_net_stun_duration = 10

    -- Utility
    local splash_damage = 1.0
    local splash_knockup_force = 8.0
    local splash_width = 40
    local splash_height = 25
    local slash_slide_force = 5

    -- Special
    local live_bait_duration = 120
    local live_bait_damage_cooldown = 50
    local live_bait_width = 30
    local live_bait_height = 30
    local live_bait_number = 6
    local live_bait_scale = 0.3

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
    fishmonger:set_primary_color(Color.from_rgb(238, 173, 105))
    
    -- Set the Prophet cape offset for the survivor
    fishmonger:set_cape_offset(0, -9, 3, -1)

    -- Set the survivor's sprites to those we previously loaded
    fishmonger:set_animations(sprites)

    -- Set the survivor's starting stats
    -- (maxhp, damage, regen, armor, attack_speed, critical_chance, maxshield)

    --[[------------------------------------------
        SECTION STATS
    ------------------------------------------]]--

    fishmonger:set_stats_base({ -- Set the player's starting stats
        maxhp = 110,
        damage = 24,
        regen = 0.01, -- health regen per frame, so 0.6 per second
        -- vmax = jump_force
    })
    
    fishmonger:set_stats_level({  -- Set the player's leveling stats
        maxhp = 16,
        damage = 4,
        regen = 0.002, -- gain 0.12 health regen per level
        armor = 4
    })

    -- Create survivor log
    local fishmonger_log = Survivor_Log.new(fishmonger)


    -- == Section skills == --

    local skill_hook = fishmonger:get_primary()
    -- (Sprite Skill, Subimage)
    skill_hook:set_skill_icon(sFishmongerSkills, 0)
    -- (Damage, Cooldown)
    skill_hook:set_skill_properties(1.0, 15)

    local skill_ensnaring_net = fishmonger:get_secondary()
    skill_ensnaring_net:set_skill_icon(sFishmongerSkills, 1)
    skill_ensnaring_net:set_skill_properties(2.0, 0)
    skill_ensnaring_net:set_skill_animation(sprites.idle)
    skill_ensnaring_net.require_key_press = true

    local skill_splash = fishmonger:get_utility()
    skill_splash:set_skill_icon(sFishmongerSkills, 2)
    skill_splash:set_skill_properties(3.0, 1 * 60)
    skill_splash:set_skill_animation(sFishmongerUtility1)
    skill_splash.require_key_press = true

    local skill_live_bait = fishmonger:get_special()
    skill_live_bait:set_skill_icon(sFishmongerSkills, 3)
    skill_live_bait:set_skill_properties(0.8, 5 * 60)
    skill_live_bait:set_skill_animation(sFishmongerSpecial1)
    skill_live_bait.require_key_press = true

    --(namespace, identifier, cooldown, damage, sprite_id, sprite_subimage, animation, is_primary, is_utility)
    -- Create alt special
    local skill_still_fishing = Skill.new(
        NAMESPACE,
        skill_live_bait.identifier.."2",
        5 * 60,
        10.0,
        sFishmongerSkills,
        5,
        sprites.idle,
        false,
        false
    )
    skill_still_fishing.require_key_press = true
    fishmonger:add_special(skill_still_fishing)

    -- Create boosted specials (for scepter)
    local skill_live_bait_boosted = Skill.new(
        NAMESPACE,
        skill_live_bait.identifier.."Boosted",
        5 * 60,
        20.0,
        sFishmongerSkills,
        4,
        sFishmongerSpecial1Boosted,
        false,
        false
    )
    skill_live_bait_boosted.require_key_press = true
    skill_live_bait:set_skill_upgrade(skill_live_bait_boosted)

    local skill_still_fishing_boosted = Skill.new(
        NAMESPACE,
        skill_still_fishing.identifier.."Boosted",
        5 * 60,
        20.0,
        sFishmongerSkills,
        6,
        sprites.idle,
        false,
        false
    )
    skill_still_fishing_boosted.require_key_press = true
    skill_still_fishing:set_skill_upgrade(skill_still_fishing_boosted)


    -- Create State skill
    local state_hookA = State.new(NAMESPACE, skill_hook.identifier.."A")
    local state_hookB = State.new(NAMESPACE, skill_hook.identifier.."B")
    local state_ensnaring_net = State.new(NAMESPACE, skill_ensnaring_net.identifier)
    local state_splash = State.new(NAMESPACE, skill_splash.identifier)
    local state_live_bait = State.new(NAMESPACE, skill_live_bait.identifier)
    local state_live_bait_boosted = State.new(NAMESPACE, skill_live_bait_boosted.identifier)
    local state_still_fishing = State.new(NAMESPACE, skill_still_fishing.identifier)
    local state_still_fishing_boosted = State.new(NAMESPACE, skill_still_fishing_boosted.identifier)


    --[[
        Subsection Primary Skill 
    ]]--

    local fishmonger_decr_counter = nil
    fishmonger_decr_counter = function(actor)
        if actor.fishmonger_count == 0 then return end

        actor.fishmonger_count = actor.fishmonger_count - 1
        Alarm.create(fishmonger_decr_counter, 1, actor)
    end

    skill_hook:onActivate(function(actor, skill, index)

        if actor.fishmonger_count == 0 then
            GM.actor_set_state(actor, state_hookA.value)
            actor.fishmonger_count = hook_combo_counter
            Alarm.create(fishmonger_decr_counter, 1, actor)
        else
            actor.fishmonger_count = 0
            GM.actor_set_state(actor, state_hookB.value)
        end
    end)

    state_hookA:onEnter(function(actor, data)
        actor.image_index = 0
        data.fired = 0
    end)

    state_hookA:onStep(function(actor, data)
        actor:skill_util_fix_hspeed()
        
        actor:actor_animation_set(sFishmongerPrimary1_1, 0.25)

        if data.fired == 0 and actor.image_index >= 3 then

            local attack_offset = hook_attack_offset
            if actor:skill_util_facing_direction() == 180 then 
                attack_offset = -attack_offset
            end

            if actor:is_authority() then
                if not actor:skill_util_update_heaven_cracker(actor, skill_hook.damage) then
                    local buff_shadow_clone = Buff.find("ror", "shadowClone")
                    for i=0, GM.get_buff_stack(actor, buff_shadow_clone) do
                        local attack = GM._mod_attack_fire_explosion(actor, actor.x + attack_offset, actor.y, hook_width, hook_height, skill_hook.damage, -1, gm.constants.sSparks17_PROV)
                        attack.attack_info.stun = true
                        attack.attack_info.climb = i * 8
                    end
                end
            end

            -- gm.sound_play_at(gm.constants.wMercenaryShoot1_3, 1, 1, actor.x, actor.y, 500)
            actor:sound_play(gm.constants.wMercenaryShoot1_3, 1, 0.9 + math.random() * 0.2)
            data.fired = 1
        end

        actor:skill_util_exit_state_on_anim_end()
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
                    for i=0, GM.get_buff_stack(actorAC, buff_shadow_clone.value) do
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

    --[[
        Subsection Secondary Skill
    ]]--

    -- Ensnaring net

    local ensnaring_net_direction = 1
    local ensnaring_team = 1
    local ensnaring_net = Object.new(NAMESPACE, "fishmongerNet")
    ensnaring_net:set_sprite(sFishmongerNet)
    ensnaring_net:set_depth(1)

    ensnaring_net:onCreate(function(inst)
        inst.image_index = 0
        inst.image_xscale = ensnaring_net_direction
        inst.floored = 0
        inst.gravity = 0.1
        inst.hspeed = 1.5 * ensnaring_net_direction
        inst.vspeed = -0.5
        inst.gravity_direction = 270

        local selfData = inst:get_data()
        selfData.stopped = 0
        selfData.team = ensnaring_team
    end)

    ensnaring_net:onStep(function(inst)
        local selfData = inst:get_data()
        inst.image_speed = 0.15

        local actors = inst:get_collisions(gm.constants.pActor)
        for _, actor in ipairs(actors) do
            if (actor.team and actor.team ~= selfData.team)
            or (actor.parent and actor.parent.team and actor.parent.team ~= selfData.parent.team) then
                GM.apply_buff(actor, 10, ensnaring_net_stun_duration, 1) -- apply stun
            end
        end
        if selfData.stopped > 0 then
            inst.image_index = 4.0
            inst.vspeed = 0
            inst.hspeed = 0
            selfData.stopped = selfData.stopped + 1
            if selfData.stopped > ensnaring_net_duration then
                inst:destroy()
            end
        elseif inst:is_colliding(gm.constants.pSolidBulletCollision) then
            inst.gravity = 0
            inst.vspeed = 0
            inst.hspeed = 0
            selfData.stopped = 1
        elseif inst.image_index > 5.0 then
            inst.image_index = 4.0
            inst.hspeed = 1.5*inst.image_xscale
        end

    end)

    -- Skill

    skill_ensnaring_net:onActivate(function(actor, skill, index)
        GM.actor_set_state(actor, state_ensnaring_net)
    end)

    state_ensnaring_net:onEnter(function(actor, data)
        actor.image_index = 0
        data.fired = 0
    end)

    state_ensnaring_net:onStep(function(actor, data)
        actor:skill_util_fix_hspeed()

        actor:actor_animation_set(sFishmongerSecondary1, 0.20)

        if data.fired == 0 and actor.image_index >= 8 then
            local damage = actor:skill_get_damage(skill_ensnaring_net.value)

            local attack_offset = 60
            if actor:skill_util_facing_direction() == 180 then 
                attack_offset = -attack_offset
            end
            
            if actor:is_authority() then
                local buff_shadow_clone = Buff.find("ror", "shadowClone")
                for i=0, GM.get_buff_stack(actor, buff_shadow_clone) do
                    ensnaring_net_direction = gm.cos(gm.degtorad(actor:skill_util_facing_direction()))
                    ensnaring_team = actor.team
                    ensnaring_net:create(actor.x + attack_offset, actor.y - 3)
                end
            end

            actor:sound_play(gm.constants.wGeyser, 1, 0.9 + math.random() * 0.2)
            data.fired = 1
        end

        actor:skill_util_exit_state_on_anim_end()
    end)


    --[[
        Subsection Utility Skill 
    ]]--

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
        --if inst.fired == 0 and inst.image_index >= 1 then
            --local attack = gm._mod_attack_fire_explosion_noparent(inst.x, inst.y, splash_width, splash_height, 1, inst.damage, false, -1, gm.constants.sSparks17_PROV)
            --attack.attack_info.stun = true -- change stun duration?
            --attack.attack_info.knockup = inst.knockup_force
            
        --    inst.fired = 1
        --else
        if inst.image_index >= 8.0 then
            inst:destroy()
        end
    end)

    skill_splash:onActivate(function(actor, skill, index)
        GM.actor_set_state(actor, state_splash)
    end)

    state_splash:onEnter(function(actor, data)
        actor.image_index = 0
        data.fired = 0
        data.slide = 0
    end)

    state_splash:onStep(function(actor, data)
        actor:skill_util_fix_hspeed()

        actor:actor_animation_set(actor:actor_get_skill_animation(skill_splash.value), 0.25)

        if data.fired == 0 and actor.image_index >= 0 then
            local damage = actor:skill_get_damage(skill_splash.value)

            local attack_offset = 20
            if actor:skill_util_facing_direction() == 180 then 
                attack_offset = -attack_offset
            end
            
            if actor:is_authority() then
                local buff_shadow_clone = Buff.find("ror", "shadowClone")
                for i=0, GM.get_buff_stack(actor, buff_shadow_clone) do
                    local attack = GM._mod_attack_fire_explosion(actor, actor.x + attack_offset, actor.y, splash_width, splash_height, damage, -1, gm.constants.sSparks17_PROV)
                    attack.attack_info.stun = true -- change stun duration?
                    attack.attack_info.climb = i * 8
                    attack.attack_info.knockup = splash_knockup_force

                    splash_direction = gm.cos(gm.degtorad(actor:skill_util_facing_direction()))
                    splash:create(actor.x + attack_offset, actor.y)
                end
            end

            actor:sound_play(gm.constants.wGeyser, 1, 0.9 + math.random() * 0.2)
            data.fired = 1
        elseif data.slide == 0 and actor.image_index >= 2 then

            actor.pHspeed = -gm.cos(gm.degtorad(actor:skill_util_facing_direction())) * actor.pHmax * slash_slide_force

            actor:sound_play(gm.constants.wCommandoRoll, 1, 0.9 + math.random() * 0.2)
            data.slide = 1
        end

        if data.slide == 1 and actor.image_index >= 8.0 then
            if actor.invincible <= 5 then
                actor.invincible = 0
            end
        else
            if actor.invincible < 5 then 
                actor.invincible = 5
            end
        end

        actor:skill_util_exit_state_on_anim_end()
    end)

    --[[
        Subsection Special Skill 
    ]]--

    -- Fishies
    local live_bait_direction = 1
    local live_bait = Object.new(NAMESPACE, "fishmongerLiveBait")
    live_bait:set_sprite(sFishmongerLiveBait)
    ensnaring_net:set_depth(1)

    live_bait:onCreate(function(inst)
        local selfData = inst:get_data()
        selfData.nb = math.random(0, 3) * 2
        selfData.duration = 200
        selfData.lastDamaged = 0

        inst.image_index = selfData.nb

        inst.image_xscale = live_bait_direction*live_bait_scale
        inst.vspeed = -0.1
        inst.gravity = 0.15
        inst.image_speed = 0
        inst.hspeed = (math.random()*0.5 + 0.3) * live_bait_direction
    end)

    live_bait:onStep(function(inst)
        local selfData = inst:get_data()

        inst.image_angle = inst.image_angle + 3

        if inst:is_colliding(gm.constants.pSolidBulletCollision) then
            inst.vspeed = -2
        end

        if selfData.lastDamaged < 0 then
            local actors = inst:get_collisions(gm.constants.pActor)
            for _, actor in ipairs(actors) do
                if (actor.team and actor.team ~= selfData.team)
                or (actor.parent and actor.parent.team and actor.parent.team ~= selfData.team) then
                    GM._mod_attack_fire_explosion(selfData.parent, inst.x, inst.y, live_bait_width, live_bait_height, skill_live_bait.damage, -1, gm.constants.sSparks17_PROV)
                    selfData.lastDamaged = live_bait_damage_cooldown
                end
            end
        else 
            selfData.lastDamaged = selfData.lastDamaged -1
        end        

        selfData.duration = selfData.duration - 1
        if selfData.duration < 0 then 
            inst:destroy()
        end
    end)

    -- Skill

    skill_live_bait:onActivate(function(actor, skill, index)
        GM.actor_set_state(actor, state_live_bait)
    end)

    state_live_bait:onEnter(function(actor, data)
        actor.image_index = 0
        data.fired = 0
    end)

    state_live_bait:onStep(function(actor, data)
        actor:skill_util_fix_hspeed()

        actor:actor_animation_set(sFishmongerSpecial1, 0.25)

        if data.fired == 0 and actor.image_index >=4 then
            local damage = actor:skill_get_damage(skill_ensnaring_net.value)

            local attack_offset = 20
            if actor:skill_util_facing_direction() == 180 then 
                attack_offset = -attack_offset
            end
            
            if actor:is_authority() then
                local buff_shadow_clone = Buff.find("ror", "shadowClone")
                for i=0, GM.get_buff_stack(actor, buff_shadow_clone) do
                    for i=0, live_bait_number-1 do
                        local inst = live_bait:create(actor.x + attack_offset, actor.y)
                        local instData = inst:get_data()
                        instData.parent = actor
                        instData.team = actor.team
                        instData.direction = gm.cos(gm.degtorad(actor:skill_util_facing_direction()))
                        live_bait_direction = gm.cos(gm.degtorad(actor:skill_util_facing_direction()))
                    end
                end
            end

            actor:sound_play(gm.constants.wGeyser, 1, 0.9 + math.random() * 0.2)
            data.fired = 1
        end

        actor:skill_util_exit_state_on_anim_end()
    end)



    --[[
        Subsection Special Upgraded Skill 
    ]]--


    -- Setup the Special1 Boosted skill


    -- Setup the Special2 skill


    -- Setup the Special2 Boosted skill
    

end

Initialize(initialize)
