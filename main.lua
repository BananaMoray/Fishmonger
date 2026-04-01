
-- Fishmonger v1.0.3
-- Frithuritaks feat. SmoothSpatula

local envy = mods["LuaENVY-ENVY"]
envy.auto()
mods["ReturnsAPI-ReturnsAPI"].auto{
    namespace = "fishmonger",
    mp = true
}

local PATH = _ENV["!plugins_mod_folder_path"]
local NAMESPACE = "fishmonger"

local initialize = function()
    --[[------------------------------------------
░░░░░░░░      ░░░       ░░░       ░░░        ░░        ░░        ░░░      ░░
▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒
▓▓▓▓▓▓▓▓      ▓▓▓       ▓▓▓       ▓▓▓▓▓▓  ▓▓▓▓▓▓▓▓  ▓▓▓▓▓      ▓▓▓▓▓      ▓▓
█████████████  ██  ████████  ███  ██████  ████████  █████  ██████████████  █
████████      ███  ████████  ████  ██        █████  █████        ███      ██
    ------------------------------------------]]--

    -- Menu Sprites

    local sFishmongerPortrait = Sprite.new("sFishmongerPortrait", path.combine(PATH, "Sprites", "sFishmongerPortrait.png"), 3)
    local sFishmongerPortraitSmall = Sprite.new("sFishmongerPortraitSmall", path.combine(PATH, "Sprites", "sFishmongerPortraitSmall.png"))
    local sFishmongerPortraitBig = Sprite.new("sFishmongerPortraitBig", path.combine(PATH, "Sprites", "sFishmongerPortraitBig.png"))
    local sFishmongerSkills = Sprite.new("sFishmongerSkills", path.combine(PATH, "Sprites", "sFishmongerSkills.png"), 9)
    local sSelectFishmonger = Sprite.new("sSelectFishmonger", path.combine(PATH, "Sprites", "sSelectFishmonger.png"), 4, 28, 0)

    -- In Game Sprites
    local sprites = {
        idle = Sprite.new("sFishmongerIdle", path.combine(PATH, "Sprites", "sFishmongerIdle.png"), 10, 26, 19),
        walk = Sprite.new("sFishmongerWalk", path.combine(PATH, "Sprites", "sFishmongerWalk.png"), 10, 23, 19),
        jump = Sprite.new("sFishmongerJump", path.combine(PATH, "Sprites", "sFishmongerJump.png"), 2, 26, 19),
        jump_peak = Sprite.new("sFishmongerJumpPeak", path.combine(PATH, "Sprites", "sFishmongerJumpPeak.png"), 2, 26, 19),
        fall = Sprite.new("sFishmongerFall", path.combine(PATH, "Sprites", "sFishmongerFall.png"), 1, 26, 19),
        climb = Sprite.new("sFishmongerClimb", path.combine(PATH, "Sprites", "sFishmongerClimb.png"), 6, 18, 19, 3),
        death = Sprite.new("sFishmongerDeath", path.combine(PATH, "Sprites", "sFishmongerDeath.png"), 8, 45, 19),
        decoy = Sprite.new("sFishmongerDummy", path.combine(PATH, "Sprites", "sFishmongerDummy.png"), 1, 16, 15),
        drone_idle = Sprite.new("sDronePlayerFishmongerIdle", path.combine(PATH, "Sprites", "sDronePlayerFishmongerIdle.png"), 4, 13, 18),
        drone_shoot = Sprite.new("sDronePlayerFishmongerShoot", path.combine(PATH, "Sprites", "sDronePlayerFishmongerShoot.png"), 4, 42, 18)
    }
    

    -- local attack1_sprite = Sprite.new("sFishmongerAttack1", path.combine(PATH, "Sprites","sFishmongerAttack1.png"), 14, 44, 35)
    local sFishmongerPrimary1_1 = Sprite.new("sFishmongerPrimary1_1", path.combine(PATH, "Sprites", "sFishmongerPrimary1_1.png"), 8, 44, 35)
    local sFishmongerPrimary1_2 = Sprite.new("sFishmongerPrimary1_2", path.combine(PATH, "Sprites", "sFishmongerPrimary1_2.png"), 8, 44, 35)

    local sFishmongerSecondary1 = Sprite.new("sFishmongerSecondary1", path.combine(PATH, "Sprites", "sFishmongerSecondary1.png"), 12, 36, 20)

    local sFishmongerUtility1 = Sprite.new("sFishmongerUtility1", path.combine(PATH, "Sprites", "sFishmongerUtility1.png"), 9, 23, 19)
    local sFishmongerSpecial1 = Sprite.new("sFishmongerSpecial1", path.combine(PATH, "Sprites", "sFishmongerSpecial1.png"), 7, 12, 19)
    local sFishmongerSpecial1Boosted = Sprite.new("sFishmongerSpecial1Boosted", path.combine(PATH, "Sprites", "sFishmongerSpecial1Boosted.png"), 7, 12, 19)
    -- bait bucket --
    local sFishmongerBait = Sprite.new("sFishmongerBait", path.combine(PATH, "Sprites", "sFishmongerBait.png"), 1, 7, 19)
    -- Splash
    local sFishmongerGeyser = Sprite.new("sFishmongerGeyser", path.combine(PATH, "Sprites", "sFishmongerGeyser.png"), 9, 32, 50)
    -- Net
    local sFishmongerNet = Sprite.new("sFishmongerNet", path.combine(PATH, "Sprites", "sFishmongerNet.png"), 7, 48, 19)
    gm.sprite_set_bbox_mode(sFishmongerNet.value, 2)
    gm.sprite_set_bbox(sFishmongerNet.value, 45, 10, 90, 32)
    -- Live Bait
    local sFishmongerLiveBait = Sprite.new("sFishmongerSpecialFish", path.combine(PATH, "Sprites", "sFishmongerSpecialFish.png"), 8, 12, 19)
    -- Live Bait Boosted
    local sFishmongerLiveBaitBoosted = Sprite.new("sFishmongerSpecialFishBoosted", path.combine(PATH, "Sprites", "sFishmongerSpecialFishBoosted.png"), 4, 24, 24)   

    -- Sprite Offsets

    -- Sprite Speeds
    gm.sprite_set_speed(sprites.idle.value, 0.65, 1) -- idle animation speed
    gm.sprite_set_speed(sprites.walk.value, 0.7, 1) -- walk animation speed
    gm.sprite_set_speed(sprites.death.value, 1, 1) 
    -- gm.sprite_set_speed(attack1_sprite, 1, 1)
    gm.sprite_set_speed(sFishmongerUtility1.value, 1, 1)
    gm.sprite_set_speed(sFishmongerSpecial1.value, 1, 1)
    gm.sprite_set_speed(sFishmongerSpecial1Boosted.value, 1, 1)
    gm.sprite_set_speed(sSelectFishmonger.value, -5, 0) -- loadout Speed

    --[[------------------------------------------
░░░░░░░░      ░░░░      ░░░  ░░░░  ░░   ░░░  ░░       ░░░░      ░░
▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒    ▒▒  ▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒▒▒▒
▓▓▓▓▓▓▓▓      ▓▓▓  ▓▓▓▓  ▓▓  ▓▓▓▓  ▓▓  ▓  ▓  ▓▓  ▓▓▓▓  ▓▓▓      ▓▓
█████████████  ██  ████  ██  ████  ██  ██    ██  ████  ████████  █
████████      ████      ████      ███  ███   ██       ████      ██
    ------------------------------------------]]--

    local sound_select = Sound.new("FishmongerSelect", path.combine(PATH, "Sounds", "Select.ogg"))
    local sound_shark_bite = Sound.new("FishmongerSharkBite", path.combine(PATH, "Sounds", "Cartoon Bite sound effect.ogg"))
    local sound_splash = Sound.new("FishmongerSplash", path.combine(PATH, "Sounds", "splash-fx.ogg"))
    local sound_throw = Sound.new("FishmongerThrow", path.combine(PATH, "Sounds", "Throw Sound Effect - Free.ogg"))
    local sound_fishing_net = Sound.new("FishmongerFishingNet", path.combine(PATH, "Sounds", "Fishing net.ogg"))
    local sound_whip = Sound.new("FishmongerWhip", path.combine(PATH, "Sounds", "whip2.ogg"))
    local sound_fish_throw = Sound.new("FishmongerFishThrow", path.combine(PATH, "Sounds", "FishThrow.ogg"))
    local sound_fish_jump = Sound.new("FishmongerFishJump", path.combine(PATH, "Sounds", "FishJump.ogg"))
    
    --[[------------------------------------------
░░░░░░░░      ░░░        ░░░      ░░░        ░░░      ░░
▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒▒▒
▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓  ▓▓▓▓▓  ▓▓▓▓  ▓▓▓▓▓  ▓▓▓▓▓▓      ▓▓
█████████████  █████  █████        █████  ███████████  █
████████      ██████  █████  ████  █████  ██████      ██
    ------------------------------------------]]--

    local jump_force = 8.0

    -- Primary
    local hook_combo_counter = 30
    local hook_attack_offset = 56
    local hook_width = 100
    local hook_height = 35

    -- Secondary 
    local ensnaring_net_duration = 240
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
    local live_bait_scale = 0.7

    -- Special Boosted
    local live_bait_boosted_height = 40
    local live_bait_boosted_width = 40
    local live_bait_boosted_duration = 240
    local live_bait_boosted_scale = 1.2

    -- Alt Special
    local still_fishing_height = 60
    local still_fishing_width = 120

    -- Alt Special Boosted
    local still_fishing_boosted_height = 80
    local still_fishing_boosted_width = 120

    -- Create a new survivor
    local fishmonger = Survivor.new(NAMESPACE, "fishmonger")

    -- Set the selection animation of the survivor
    fishmonger.sprite_loadout = sSelectFishmonger
    fishmonger.select_sound_id = sound_select

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
    fishmonger.primary_color = Color.from_rgb(238, 173, 105)
    
    -- Set the Prophet cape offset for the survivor
    fishmonger.cape_offset = Array.new({0, -9, 0, -7})

    -- Set the survivor's sprites to those we previously loaded
    Callback.add(fishmonger.on_init, function(actor)
        actor.sprite_idle          = sprites.idle
        actor.sprite_walk          = sprites.walk
        --actor.sprite_walk_last     = sprites.walk_last
        actor.sprite_jump          = sprites.jump
        actor.sprite_jump_peak     = sprites.jump_peak
        actor.sprite_fall          = sprites.fall
        actor.sprite_climb         = sprites.climb
        actor.sprite_death         = sprites.death
        actor.sprite_decoy         = sprites.decoy
        actor.sprite_drone_idle    = sprites.drone_idle
        actor.sprite_drone_shoot   = sprites.drone_shoot
        --actor.sprite_climb_hurt    = sprites.climb_hurt
        --actor.sprite_palette = spr_palette
    end)

    -- Set the survivor's starting stats
    -- (maxhp, damage, regen, armor, attack_speed, critical_chance, maxshield)

    fishmonger:set_stats_base({ -- Set the player's starting stats
        maxhp = 110,
        damage = 14,
        regen = 0.01, -- health regen per frame, so 0.6 per second
        -- vmax = jump_force
    })
    
    fishmonger:set_stats_level({  -- Set the player's leveling stats
        maxhp = 30,
        damage = 4,
        regen = 0.002, -- gain 0.12 health regen per level
        armor = 4
    })

    -- Create survivor log
    local fishmonger_log = SurvivorLog.new_from_survivor(fishmonger)
    fishmonger_log.portrait_id = sFishmongerPortraitBig
    fishmonger_log.sprite_id = sprites.walk
    fishmonger_log.sprite_icon_id = spr_portrait

        --[[------------------------------------------
░░░░░░░░      ░░░  ░░░░  ░░        ░░  ░░░░░░░░  ░░░░░░░░░      ░░
▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒  ▒▒▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒
▓▓▓▓▓▓▓▓      ▓▓▓     ▓▓▓▓▓▓▓▓  ▓▓▓▓▓  ▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓▓▓      ▓▓
█████████████  ██  ███  ██████  █████  ████████  ██████████████  █
████████      ███  ████  ██        ██        ██        ███      ██
    ------------------------------------------]]--

    local skill_hook = fishmonger:get_skills(0)[1]
    skill_hook.sprite, skill_hook.subimage = sFishmongerSkills, 0
    skill_hook.damage, skill_hook.cooldown = 2.0, 15
    skill_hook.is_primary = true
    skill_hook.require_key_press = false
    skill_hook.is_utility = false

    local skill_ensnaring_net = fishmonger:get_skills(1)[1]
    skill_ensnaring_net.sprite, skill_ensnaring_net.subimage = sFishmongerSkills, 1
    skill_ensnaring_net.damage, skill_ensnaring_net.cooldown = 2.0, 5* 60
    skill_ensnaring_net.animation = sprites.idle
    skill_ensnaring_net.require_key_press = true

    local skill_splash = fishmonger:get_skills(2)[1]
    skill_splash.sprite, skill_splash.subimage = sFishmongerSkills, 2
    skill_splash.damage, skill_splash.cooldown = 3.0, 4 * 60
    skill_splash.animation = sFishmongerUtility1
    skill_splash.require_key_press = true

    local skill_live_bait = fishmonger:get_skills(3)[1]
    skill_live_bait.sprite, skill_live_bait.subimage = sFishmongerSkills, 3
    skill_live_bait.damage, skill_live_bait.cooldown = 0.8, 10 * 60
    skill_live_bait.animation = sFishmongerSpecial1
    skill_live_bait.require_key_press = true

 -- Create alt special
    local skill_still_fishing = Skill.new(skill_live_bait.identifier.."2")
    skill_still_fishing.sprite, skill_still_fishing.subimage = sFishmongerSkills, 5
    skill_still_fishing.damage, skill_still_fishing.cooldown = 12.0, 5 * 60
    skill_still_fishing.animation = sprites.idle
    skill_still_fishing.require_key_press = false
    skill_still_fishing.is_utility = false
    --fishmonger:add_skill(3, skill_still_fishing) 

    -- Create boosted specials (for scepter)
    local skill_live_bait_boosted = Skill.new(skill_live_bait.identifier.."Boosted")
    skill_live_bait_boosted.cooldown = 5 * 60
    skill_live_bait_boosted.damage = 20.0
    skill_live_bait_boosted.sprite, skill_live_bait_boosted.subimage = sFishmongerSkills, 4
    skill_live_bait_boosted.animation = sFishmongerSpecial1Boosted
    skill_live_bait_boosted. is_primary = false
    skill_live_bait_boosted.is_utility = false
    skill_live_bait_boosted.require_key_press = true
    skill_live_bait.upgrade_skill = skill_live_bait_boosted
    skill_live_bait_boosted.damage, skill_live_bait_boosted.cooldown = 3, 5 * 60
    skill_live_bait_boosted.animation = sFishmongerSpecial1Boosted

    local skill_still_fishing_boosted = Skill.new(skill_still_fishing.identifier.."Boosted")
    skill_still_fishing_boosted.damage, skill_still_fishing_boosted.cooldown = 20.0, 5 * 60
    skill_still_fishing_boosted.sprite, skill_still_fishing_boosted.subimage = sFishmongerSkills, 6
    skill_still_fishing_boosted.animation = sprites.idle
    skill_still_fishing_boosted.is_utility = false
    skill_still_fishing_boosted.require_key_press = true
    --skill_still_fishing.upgrade_skill = skill_still_fishing_boosted
    skill_still_fishing.upgrade_skill = skill_live_bait_boosted


    -- Create State skill
    local state_hookA = ActorState.new(skill_hook.identifier.."A")
    local state_hookB = ActorState.new(skill_hook.identifier.."B")
    local state_ensnaring_net = ActorState.new(skill_ensnaring_net.identifier)
    local state_splash = ActorState.new(skill_splash.identifier)
    local state_live_bait = ActorState.new(skill_live_bait.identifier)
    local state_live_bait_boosted = ActorState.new(skill_live_bait_boosted.identifier)
    local state_still_fishing = ActorState.new(skill_still_fishing.identifier)
    local state_still_fishing_boosted = ActorState.new(skill_still_fishing_boosted.identifier)

    --[[------------------------------------------
░░░░░░░       ░░░       ░░░        ░░  ░░░░  ░░░      ░░░       ░░░  ░░░░  ░
▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒   ▒▒   ▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒▒  ▒▒  ▒▒
▓▓▓▓▓▓▓       ▓▓▓       ▓▓▓▓▓▓  ▓▓▓▓▓        ▓▓  ▓▓▓▓  ▓▓       ▓▓▓▓▓    ▓▓▓
███████  ████████  ███  ██████  █████  █  █  ██        ██  ███  ██████  ████
███████  ████████  ████  ██        ██  ████  ██  ████  ██  ████  █████  ████
    ------------------------------------------]]--

    local fishmonger_decr_counter = nil
    fishmonger_decr_counter = function(actor)
        local actorData = Instance.get_data(actor)
        if actorData.fishmonger_count == 0 then return end

        actorData.fishmonger_count = actorData.fishmonger_count - 1
        Alarm.add(1, fishmonger_decr_counter, actor)
    end

    Callback.add(skill_hook.on_activate, function(actor, skill, index)
        local actorData = Instance.get_data(actor)
        if actorData.fishmonger_count == 0 then
            actor:set_state(state_hookA)
            actorData.fishmonger_count = hook_combo_counter
            Alarm.add(1, fishmonger_decr_counter, actor)
        else
            actorData.fishmonger_count = 0
            actor:set_state(state_hookB)
        end
    end)

    Callback.add(state_hookA.on_enter, function(actor, data)
        actor.image_index = 0
        data.fired = 0
    end)

    Callback.add(state_hookA.on_step, function(actor, data)
        actor:skill_util_fix_hspeed()
        actor:actor_animation_set(sFishmongerPrimary1_1, 0.25)
        if data.fired == 0 and actor.image_index >= 3 then
            
            local attack_offset = hook_attack_offset
            if actor:skill_util_facing_direction() == 180 then 
                attack_offset = -attack_offset
            end
            
            if gm._mod_net_isHost() then
                if not actor:skill_util_update_heaven_cracker(actor, skill_hook.damage) then
                    local buff_shadow_clone = Buff.find("shadowClone", "ror")
                    for i=0, actor:buff_count(buff_shadow_clone) do
                        local attack = actor:fire_explosion(actor.x + attack_offset, actor.y, hook_width, hook_height, skill_hook.damage, -1, gm.constants.sSparks17_PROV)
                        attack.attack_info.stun = 0.2
                        attack.attack_info.knockback = 4
                        attack.attack_info.knockback_direction = actor.image_xscale
                        attack.attack_info.climb = i * 8
                    end
                end
            end
            actor:sound_play(sound_whip, 2, 0.6 + math.random() * 0.4)
            data.fired = 1
        end

        actor:skill_util_exit_state_on_anim_end()
    end)

    Callback.add(state_hookB.on_enter, function(actor, data)
        actor.image_index = 0
        data.fired = 0
    end)

    Callback.add(state_hookB.on_step, function(actor, data)
        actor:skill_util_fix_hspeed()
        actor:actor_animation_set(sFishmongerPrimary1_2, 0.25)

        if data.fired == 0 and actor.image_index >= 3 then
            local damage = actor:skill_get_damage(skill_hook.value)

            local attack_offset = hook_attack_offset
            if actor:skill_util_facing_direction() == 180 then 
                attack_offset = -attack_offset
            end

            if gm._mod_net_isHost() then
                if not actor:skill_util_update_heaven_cracker(actor, damage) then
                    local buff_shadow_clone = Buff.find("shadowClone", "ror")
                    for i=0, GM.get_buff_stack(actor, buff_shadow_clone.value) do
                        local attack = actor:fire_explosion(actor.x + attack_offset, actor.y, hook_width, hook_height, damage, -1, gm.constants.sSparks17_PROV)
                        attack.attack_info.stun = 0.2
                        attack.attack_info.knockback = 4
                        attack.attack_info.knockback_direction = -actor.image_xscale
                        attack.attack_info.climb = i * 8
                    end
                end
            end

            actor:sound_play(sound_whip, 2, 0.6 + math.random() * 0.4)
            data.fired = 1
        end

        actor:skill_util_exit_state_on_anim_end()
    end)

    --[[------------------------------------------
░░░░░░░░      ░░░        ░░░      ░░░░      ░░░   ░░░  ░░       ░░░░      ░░░       ░░░  ░░░░  ░
▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒    ▒▒  ▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒▒  ▒▒  ▒▒
▓▓▓▓▓▓▓▓      ▓▓▓      ▓▓▓▓  ▓▓▓▓▓▓▓▓  ▓▓▓▓  ▓▓  ▓  ▓  ▓▓  ▓▓▓▓  ▓▓  ▓▓▓▓  ▓▓       ▓▓▓▓▓    ▓▓▓
█████████████  ██  ████████  ████  ██  ████  ██  ██    ██  ████  ██        ██  ███  ██████  ████
████████      ███        ███      ████      ███  ███   ██       ███  ████  ██  ████  █████  ████
    ------------------------------------------]]--

    -- Ensnaring net

    local ensnaring_net = Object.new("fishmongerNet")
    ensnaring_net:set_sprite(sFishmongerNet)
    ensnaring_net:set_depth(-10)

    Callback.add(ensnaring_net.on_create, function(inst)
        inst.image_index = 0
        inst.floored = 0
        inst.gravity = 0.1
        inst.vspeed = -0.5
        inst.gravity_direction = 270
        inst.image_xscale = inst.image_xscale*1.5
        inst.image_yscale = inst.image_yscale*1.5
        inst.image_speed = 0.4
        local selfData = Instance.get_data(inst)
        selfData.stopped = 0
    end)

    Callback.add(ensnaring_net.on_step, function(inst)
        local selfData = Instance.get_data(inst)
        inst.image_speed = 0.15

        local actors = inst:get_collisions(gm.constants.pActor)

        for _, actor in ipairs(actors) do
            if (actor.team and actor.team ~= selfData.team)
            or (actor.parent and actor.parent.team and actor.parent.team ~= selfData.parent.team)
            then
                GM.apply_buff(actor, 10, ensnaring_net_stun_duration, 1) -- apply stun
                actor.value.vspeed = 0
                actor.value.hspeed = 0
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
        elseif inst:is_colliding(gm.constants.pSolidBulletCollision) or inst:is_colliding(gm.constants.pSolidBulletCollision) then
            inst:sound_play(sound_fishing_net, 1, 1)
            inst.gravity = 0
            inst.vspeed = 0
            inst.hspeed = 0
            selfData.stopped = 1
            inst.image_xscale = 1.2*inst.image_xscale
            inst.image_yscale = 1.2*inst.image_yscale
        elseif inst.image_index > 5.0 then
            inst.image_index = 4.0
            inst.hspeed = 1.5*inst.image_xscale
        end

    end)

    -- Skill

    Callback.add(skill_ensnaring_net.on_activate, function(actor, skill, index)
        actor:set_state(state_ensnaring_net)
    end)

    Callback.add(state_ensnaring_net.on_enter, function(actor, data)
        actor.image_index = 0
        data.fired = 0
    end)

    Callback.add(state_ensnaring_net.on_step, function(actor, data)
        actor:skill_util_fix_hspeed()

        actor:actor_animation_set(sFishmongerSecondary1, 0.40)

        if data.fired == 0  and actor.image_index >= 6 then
            data.fired = 1
            actor:sound_play(sound_throw, 1, 0.9 + math.random() * 0.2)
        end

        if data.fired < 2 and actor.image_index >= 8 then
            local damage = actor:skill_get_damage(skill_ensnaring_net.value)

            local attack_offset = 60
            if actor:skill_util_facing_direction() == 180 then 
                attack_offset = -attack_offset
            end
            
            local buff_shadow_clone = Buff.find("shadowClone", "ror")
            for i=0, actor:buff_count(buff_shadow_clone) do
                local net = ensnaring_net:create(actor.x + attack_offset, actor.y - 18)
                net.direction = actor:skill_util_facing_direction()
                net.image_xscale = gm.cos(gm.degtorad(actor:skill_util_facing_direction()))
                net.team = actor.team
                net.hspeed = 1.5 * net.image_xscale
                local instData = Instance.get_data(net)
                instData.parent = actor
                instData.team = actor.team
            end

            
            data.fired = 2
        end

        actor:skill_util_exit_state_on_anim_end()
    end)

    --[[------------------------------------------
░░░░░░░  ░░░░  ░░        ░░        ░░  ░░░░░░░░        ░░        ░░  ░░░░  ░
▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒  ▒▒  ▒▒
▓▓▓▓▓▓▓  ▓▓▓▓  ▓▓▓▓▓  ▓▓▓▓▓▓▓▓  ▓▓▓▓▓  ▓▓▓▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓    ▓▓▓
███████  ████  █████  ████████  █████  ███████████  ████████  ████████  ████
████████      ██████  █████        ██        ██        █████  ████████  ████
    ------------------------------------------]]--

    -- Splash Object
    local splash = Object.new("fishmongerSplash")
    splash:set_sprite(sFishmongerGeyser)
    splash:set_depth(1)

    Callback.add(splash.on_create, function(inst)
        inst.image_index = 0
        inst.knockup_force = splash_knockup_force
        inst.damage = splash_damage
        inst.fired = 0
    end)

    Callback.add(splash.on_step, function(inst)
        inst.image_speed = 0.25
        if inst.image_index >= 8.0 then
            inst:destroy()
        end
    end)

    Callback.add(skill_splash.on_activate, function(actor, skill, index)
        actor:set_state(state_splash)
    end)

    Callback.add(state_splash.on_enter, function(actor, data)
        actor.image_index = 0
        data.fired = 0
        data.slide = 0
    end)

    Callback.add(state_splash.on_step, function(actor, data)
        actor:skill_util_fix_hspeed()

        actor:actor_animation_set(actor:actor_get_skill_animation(skill_splash.value), 0.25)

        if data.fired == 0 and actor.image_index >= 0 then
            local damage = actor:skill_get_damage(skill_splash.value)

            local attack_offset = 20
            if actor:skill_util_facing_direction() == 180 then 
                attack_offset = -attack_offset
            end

            local buff_shadow_clone = Buff.find("shadowClone", "ror")
            for i=0, actor:buff_count(buff_shadow_clone) do
                local attack = actor:fire_explosion(actor.x + attack_offset, actor.y, splash_width, splash_height, damage, -1, gm.constants.sSparks17_PROV)
                
                attack.attack_info.stun = 0.5 -- change stun duration?
                attack.attack_info.climb = i * 8
                attack.attack_info.splashed = true
                attack.attack_info.splashed_direction = gm.cos(gm.degtorad(actor:skill_util_facing_direction()))

                local wave = splash:create(actor.x + attack_offset, actor.y)
                wave.image_xscale = gm.cos(gm.degtorad(actor:skill_util_facing_direction()))
            end

            actor:sound_play(sound_splash, 1, 0.9 + math.random() * 0.2)
            data.fired = 1
        elseif data.slide == 0 and actor.image_index >= 2 then

            actor.pHspeed = -gm.cos(gm.degtorad(actor:skill_util_facing_direction())) * actor.pHmax * slash_slide_force

            actor:sound_play(sound_splash, 1, 0.9 + math.random() * 0.2)
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

    Callback.add(Callback.ON_HIT_PROC, function(attacker, target, hit_info)
        if not hit_info.attack_info.splashed or target.dead == nil then return end

       target.pVspeed = target.pVspeed - 10
       target.pHspeed = target.pHspeed - (4 * hit_info.attack_info.splashed_direction)
    end)

        --[[------------------------------------------
░░░░░░░░      ░░░       ░░░        ░░░      ░░░        ░░░      ░░░  ░░░░░░░░░      ░░
▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒
▓▓▓▓▓▓▓▓      ▓▓▓       ▓▓▓      ▓▓▓▓  ▓▓▓▓▓▓▓▓▓▓▓  ▓▓▓▓▓  ▓▓▓▓  ▓▓  ▓▓▓▓▓▓▓▓▓      ▓▓
█████████████  ██  ████████  ████████  ████  █████  █████        ██  ██████████████  █
████████      ███  ████████        ███      ███        ██  ████  ██        ███      ██
    ------------------------------------------]]--

    --[[------------------------------------------
░░░░░░░        ░░        ░░░      ░░░  ░░░░  ░░        ░░        ░░░      ░░
▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒
▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓  ▓▓▓▓▓▓      ▓▓▓        ▓▓▓▓▓  ▓▓▓▓▓      ▓▓▓▓▓      ▓▓
███████  ███████████  ███████████  ██  ████  █████  █████  ██████████████  █
███████  ████████        ███      ███  ████  ██        ██        ███      ██
    ------------------------------------------]]--

    -- Fishies
    local live_bait = Object.new("fishmongerLiveBait")
    live_bait:set_sprite(sFishmongerLiveBait)
    live_bait:set_depth(1)

    Callback.add(live_bait.on_create, function(inst)
        local selfData = Instance.get_data(inst)
        selfData.nb = math.random(0, 3) * 2
        selfData.duration = 200
        selfData.lastDamaged = 0

        inst.image_index = selfData.nb

        inst.vspeed = -0.1
        inst.gravity = 0.15
        inst.image_speed = 0

        selfData.image_index_offset = 0
    end)

    Callback.add(live_bait.on_step, function(inst)
        local selfData = Instance.get_data(inst)

        inst.image_angle = inst.image_angle + 3*inst.image_xscale

        selfData.image_index_offset = (selfData.image_index_offset + 0.15) % 1.9
        inst.image_index = selfData.nb + selfData.image_index_offset


        -- ground collisions 
        local speedx = inst.hspeed + gm.sign(inst.hspeed) * 0.5
		local speedy = inst.vspeed + gm.sign(inst.vspeed) * 0.5

		local bounce_h = inst:is_colliding(gm.constants.pBlock, inst.x + speedx, inst.y)
		local bounce_v = inst:is_colliding(gm.constants.pBlock, inst.x, inst.y + speedy)
		if bounce_h then
			inst.hspeed = inst.hspeed * -1.0
            inst.image_xscale = - inst.image_xscale
            inst:sound_play(sound_fish_jump, 1, 0.9 + math.random() * 0.2)
		end
		if bounce_v then
			inst.vspeed = -3
            inst:sound_play(sound_fish_jump, 1, 0.9 + math.random() * 0.2)
		end

        -- damage collisions
        if selfData.lastDamaged < 0 then
            local actors = inst:get_collisions(gm.constants.pActor)
            for _, actor in ipairs(actors) do
                if (actor.team and actor.team ~= selfData.team)
                or (actor.parent and actor.parent.team and actor.parent.team ~= selfData.team) then
                    selfData.parent:fire_explosion(inst.x, inst.y, live_bait_width, live_bait_height, skill_live_bait.damage, -1, gm.constants.sSparks17_PROV)
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

    Callback.add(skill_live_bait.on_activate, function(actor, skill, index)
        actor:set_state(state_live_bait)
    end)

    Callback.add(state_live_bait.on_enter, function(actor, data)
        actor.image_index = 0
        data.fired = 0
    end)

    Callback.add(state_live_bait.on_step, function(actor, data)
        actor:skill_util_fix_hspeed()

        actor:actor_animation_set(sFishmongerSpecial1, 0.25)
        if data.fired == 0 and actor.image_index >=2 then
            actor:sound_play(sound_fish_throw, 1, 0.9 + math.random() * 0.2)
            data.fired = 1
        end

        if data.fired < 2 and actor.image_index >=4 then
            local damage = actor:skill_get_damage(skill_live_bait.value)

            local attack_offset = 20
            if actor:skill_util_facing_direction() == 180 then 
                attack_offset = -attack_offset
            end
            
            local buff_shadow_clone = Buff.find("shadowClone", "ror")
            for i=0, actor:buff_count(buff_shadow_clone) do
                for i=0, live_bait_number-1 do
                    local fishie = live_bait:create(actor.x + attack_offset, actor.y - math.random()*40.0 )
                    fishie.direction = actor:skill_util_facing_direction()
                    fishie.parent = actor
                    fishie.team = actor.team
                    if fishie.direction == 180.0 then
                        fishie.image_xscale = - live_bait_scale
                        fishie.hspeed = -(math.random() + 0.3)
                    else
                        fishie.image_xscale = live_bait_scale
                        fishie.hspeed = (math.random() + 0.3)
                    end
                    
                    fishie.image_yscale = live_bait_scale

                    local instData = Instance.get_data(fishie)
                    instData.parent = actor
                    instData.team = actor.team
                end
            end
            data.fired = 2
        end

        actor:skill_util_exit_state_on_anim_end()
    end)


    --[[------------------------------------------
░░░░░░░░      ░░░  ░░░░  ░░░      ░░░       ░░░  ░░░░  ░
▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒  ▒▒▒  ▒▒
▓▓▓▓▓▓▓▓      ▓▓▓        ▓▓  ▓▓▓▓  ▓▓       ▓▓▓     ▓▓▓▓
█████████████  ██  ████  ██        ██  ███  ███  ███  ██
████████      ███  ████  ██  ████  ██  ████  ██  ████  █
    ------------------------------------------]]--

    
    -- Shark
    local live_bait_boosted = Object.new("fishmongerLiveBaitBoosted")
    live_bait_boosted:set_sprite(sFishmongerLiveBaitBoosted)
    live_bait_boosted:set_depth(1)

    Callback.add(live_bait_boosted.on_create, function(inst)
        local selfData = Instance.get_data(inst)
        selfData.duration = live_bait_boosted_duration

        inst.hspeed = 2 * inst.image_xscale
        
        inst.vspeed = - 0.1
        inst.gravity = 0.15

        selfData.previous_x = inst.x
        selfData.previous_y = inst.y
        selfData.chomp = 2
    end)

    Callback.add(live_bait_boosted.on_step, function(inst)
        local selfData = Instance.get_data(inst)

        -- Attack
        if inst.image_index >= 2.0 and selfData.chomp<=0 then 
            selfData.chomp = 5
            local attack = selfData.parent:fire_explosion(inst.x, inst.y, live_bait_boosted_width, live_bait_boosted_height, skill_live_bait_boosted.damage, -1, gm.constants.sSparks17_PROV, true)
            attack.attack_info.shark_bleed = true
            attack.attack_info.execute = true
        else 
            selfData.chomp = selfData.chomp - 1 
        end

        -- Collisions
        local speedx = inst.hspeed + gm.sign(inst.hspeed) * 0.5
		local speedy = inst.vspeed + gm.sign(inst.vspeed) * 0.5

        if speedx < 0.1 then  
            speedx = 0.1
        end

		local bounce_h = inst:is_colliding(gm.constants.pBlock, inst.x + speedx, inst.y)
		local bounce_v = inst:is_colliding(gm.constants.pBlock, inst.x, inst.y + speedy)
		if bounce_h then
			inst.hspeed = inst.hspeed * -1.0
            inst.image_xscale = - inst.image_xscale
            if inst.gravity_direction == 267 then
                inst.gravity_direction = 273
            else 
                inst.gravity_direction = 267
            end
		end
		if bounce_v then
			inst.vspeed = -2.5
		end

        -- Duration
        selfData.duration = selfData.duration - 1
        if selfData.duration < 0 then 
            inst:destroy()
        end
    end)

    -- Skill

    Callback.add(skill_live_bait_boosted.on_activate, function(actor, skill, index)
        actor:set_state(state_live_bait_boosted)
    end)

    Callback.add(state_live_bait_boosted.on_enter, function(actor, data)
        actor.image_index = 0
        data.fired = 0
    end)

    Callback.add(state_live_bait_boosted.on_step, function(actor, data)
        actor:skill_util_fix_hspeed()

        actor:actor_animation_set(sFishmongerSpecial1Boosted, 0.25)

        if data.fired == 0 and actor.image_index >=2 then
            actor:sound_play(sound_fish_throw, 1, 0.9 + math.random() * 0.2)
            data.fired = 1
        end

        if data.fired < 2 and actor.image_index >=4 then

            local attack_offset = 20
            if actor:skill_util_facing_direction() == 180 then 
                attack_offset = -attack_offset
            end
            
            local buff_shadow_clone = Buff.find("shadowClone", "ror")
            for i=0, actor:buff_count(buff_shadow_clone) do
                local shark = live_bait_boosted:create(actor.x + attack_offset, actor.y - 1.1)
                shark.direction = actor:skill_util_facing_direction()
                shark.parent = actor
                shark.team = actor.team
                shark.image_speed = math.log(2.71828 - 1.0 + actor.attack_speed) * 0.2 --log attack speed starts at 1
                
                if shark.direction == 180.0 then
                    shark.image_xscale = -1.0
                    shark.gravity_direction = 273
                else
                    shark.gravity_direction = 267
                end

                local instData = Instance.get_data(shark)
                instData.parent = actor
                instData.team = actor.team
            end
            data.fired = 2
        end

        actor:skill_util_exit_state_on_anim_end()
    end)

    Callback.add(Callback.ON_HIT_PROC, function(attacker, target, hit_info)
        if not hit_info.attack_info.shark_bleed or target.dead == true then return end

        print("applying bleed")

        target:sound_play(sound_shark_bite, 0.8, 2.0)
        if target.hp*5 < target.maxhp and hit_info.attack_info.execute then --kill enemies under 20% hp
            target:kill()
        end
        local dot = GM.instance_create(hit_info.attack_info.x, hit_info.attack_info.y, gm.constants.oDot)
        dot.target = target.id
        dot.parent = hit_info.attack_info.parent.id
        dot.damage = hit_info.attack_info.damage /4
        dot.ticks = 4
        dot.team = hit_info.attack_info.team
        dot.textColor = Color.from_rgb(120, 6, 6)
        dot.sprite_index = gm.constants.sSparks9
    end)

    if 1==1 then return end -- yeah this ending skill aint ready sorry
    --[[--------------------------------------
░░░░░░░       ░░░░      ░░░        ░░        ░
▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒
▓▓▓▓▓▓▓       ▓▓▓  ▓▓▓▓  ▓▓▓▓▓  ▓▓▓▓▓▓▓▓  ▓▓▓▓
███████  ████  ██        █████  ████████  ████
███████       ███  ████  ██        █████  ████
    --------------------------------------]]--
    
    local still_fishing_bait = Object.wrap(gm.constants.oArtiSnap)

    local set_still_fishing = function(inst)
        inst.sprite_index = sFishmongerBait
        inst.is_custom_bait = true
        -- inst.hp = the hp you want
    end

    local still_fishing_damage = Object.new("fishmongerStillFishing")
    still_fishing_damage:set_sprite(sFishmongerLiveBaitBoosted) -- change this sprite
    still_fishing_damage:set_depth(1)

    Callback.add(still_fishing_damage.on_create, function(inst)
        inst.image_speed = 0.25
    end)

    Callback.add(still_fishing_damage.on_step, function(inst)
        local selfData = Instance.get_data(inst)
        if inst.image_index < 0.2 then
            print(selfData.parent)

            --local attack = selfData.parent:fire_explosion(inst.x, inst.y, still_fishing_width, still_fishing_height, skill_still_fishing.damage, -1, gm.constants.sSparks17_PROV)
            --attack.shark_bleed = true
        elseif inst.image_index > 3 then
            inst:destroy()
        end
    end)


    gm.pre_code_execute("gml_Object_oArtiSnap_Destroy_0", function(self, other)
        self:instance_destroy_sync()

        if self.is_custom_bait then
            -- local inst = still_fishing_damage:create(self.x, self.y)
            -- local instData = inst:get_data()
            -- instData.parent = self.parent
            inst = self.parent
            inst:fire_explosion(inst.x, inst.y, still_fishing_width, still_fishing_height, skill_still_fishing.damage, -1, gm.constants.sSparks17_PROV)
            return false
        end
        
    end)

    -- skill

    Callback.add(skill_still_fishing.on_activate, function(actor, skill, index)
        actor:set_state(state_still_fishing)
    end)

    Callback.add(state_still_fishing.on_enter, function(actor, data)
        actor.image_index = 0
        data.fired = 0
    end)

    Callback.add(state_still_fishing.on_step, function(actor, data)
        actor:skill_util_fix_hspeed()

        actor:actor_animation_set(sFishmongerSpecial1, 0.25) -- change to Special2

        if data.fired == 0 and actor.image_index >=4 then
            local attack_offset = 20
            if actor:skill_util_facing_direction() == 180 then 
                attack_offset = -attack_offset
            end
            
            local buff_shadow_clone = Buff.find("shadowClone", "ror")
            for i=0, actor:buff_count(buff_shadow_clone) do
                -- create an oArtiSnap and repurpose it
                local inst = still_fishing_bait:create(actor.x, actor.y)
                inst.parent = actor.value
                inst.sprite_index = sFishmongerBait
                -- inst.hp = the hp you want
                Alarm.add(1, set_still_fishing, inst, actor.value)
                Alarm.add(2, set_still_fishing,  inst, actor.value)
            end

            actor:sound_play(gm.constants.wGeyser, 1, 0.9 + math.random() * 0.2)
            data.fired = 1
        end

        actor:skill_util_exit_state_on_anim_end()
    end)


end

Initialize.add_hotloadable(initialize)