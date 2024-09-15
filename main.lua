
-- Fishmonger v1.0.0
-- Frithuritaks feat. SmoothSpatula
log.info("Successfully loaded ".._ENV["!guid"]..".")

mods.on_all_mods_loaded(function()
    for _, m in pairs(mods) do
        if type(m) == "table" and m.RoRR_Modding_Toolkit then
            Callback = m.Callback
            Helper = m.Helper
            Instance = m.Instance
            Item = m.Item
            Net = m.Net
            Player = m.Player
            Survivor = m.Survivor
            Resources = m.Resources
            Actor = m.Actor
            Alarm = m.Alarm
            break
        end
    end
end)

if hot_reloading then
    __initialize()
    local player = Player.get_client()
    if player then
        Survivor.survivor_init(player)
    end
end
hot_reloading = true

__initialize = function()
    -- == Section Sprites == --

    -- Menu Sprites

    -- Resources.sprite_load(path, [img_num], [remove_back], [smoooth], [x_orig], [y_orig], [speed])
    local portrait_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites", "sFishmongerPortrait.png"), 1)
    local portraitsmall_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites", "sFishmongerPortraitSmall.png"))
    local skills_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites", "sFishmongerSkills.png"), 9, false, false)
    local loadout_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites", "sSelectFishmonger.png"), 4, false, false, 28, 0)

    local bullet_path = path.combine(_ENV["!plugins_mod_folder_path"], "Sprites", "IWBTSBullet.png")

    -- In Game Sprites
    
    local idle_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites", "sFishmongerIdle.png"), 10, false, false, 26, 19)
    local jump_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerJump.png"), 2, false, false, 26, 19)
    local jump_peak_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerJumpPeak.png"), 2, false, false, 26, 19)
    local jumpfall_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerFall.png"), 1, false, false, 26, 19)
    local walk_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerWalk.png"), 10, false, false, 23, 19)
    local climb_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerClimb.png"), 6, false, false, 18, 19, 3)
    local death_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerDeath.png"), 8, false, false, 45, 19)
    

    local attack1_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerAttack1.png"), 14, false, false, 44, 35)
    local secondary1_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerSecondary1.png"), 9, false, false, 23, 19)
    local special1_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerSpecial1.png"), 7, false, false, 12, 19)
    local special2_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerSpecial2.png"), 7, false, false, 12, 19)
    -- bait bucket --
    local bait_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerBait.png"), 1, false, false, 7, 19)

    -- Sprite Offsets

    -- Sprite Speeds
    gm.sprite_set_speed(idle_sprite, 0.65, 1) -- idle animation speed
    gm.sprite_set_speed(walk_sprite, 0.7, 1) -- walk animation speed
    gm.sprite_set_speed(attack1_sprite, 1, 1)
    gm.sprite_set_speed(secondary1_sprite, 1, 1)
    gm.sprite_set_speed(special1_sprite, 1, 1)
    gm.sprite_set_speed(special2_sprite, 1, 1)
    gm.sprite_set_speed(loadout_sprite, -5, 0) -- loadout Speed
    gm.sprite_set_speed(death_sprite, 1, 1) 

    -- == Section Audio == --

    local shoot_sfx = gm.audio_create_stream(_ENV["!plugins_mod_folder_path"].."/Sprites/shoot.ogg")
    if shoot_sfx ~= -1 then 
        log.info("Loaded death sfx.")
    else
        log.info("Failed to load sfx")
    end

    -- == Section Setup + Stats == --

    local Fish_id = -1
    local Fish = nil

    local bullet_speed = 10.0
    local jump_force = 8.0

    local normal_hp = 1
    local normal_elite_hp = 3
    local boss_hp = 6
    local boss_elite_hp = 9
    local providence_hp = 20

    -- function setup_survivor(namespace, identifier, name, description, end_quote,
    -- loadout_sprite, portrait_sprite, portraitsmall_sprite, palette_sprite, 
    -- walk_sprite, idle_sprite, death_sprite, jump_sprite, jump_peak_sprite, jumpfall_sprite, climb_sprite,
    -- colour, cape_array)
    Fish, Fish_id = Survivor.setup_survivor(
        "FishedMongered", "fish", "Fishmonger", "The <y>Fishmonger</c> is here?!", "...",
        loadout_sprite, portrait_sprite, portraitsmall_sprite, loadout_sprite,
        walk_sprite, idle_sprite, death_sprite, jump_sprite, jump_peak_sprite, jumpfall_sprite, climb_sprite,
        {["r"]=238, ["g"] = 173, ["b"] = 105}, {[1] = 0.0, [2] = -9.0, [3] = 3.0}
    )
    -- function setup_stats(survivor_id, armor, attack_speed, movement_speed, critical_chance, damage, hp_regen, maxhp, maxbarrier, maxshield, maxhp_cap, jump_force)
    Survivor.setup_stats(Fish_id, nil, 1.0, nil, 1.0, nil, nil, 110,  nil, nil, nil, jump_force)

    -- function setup_level_stats(survivor_id, armor_level, attack_speed_level, critical_chance_level, damage_level, hp_regen_level, maxhp_level)
    Survivor.setup_level_stats(Fish_id, nil, nil, nil, nil, nil, nil)

    -- == Section skills == --

    -- function setup_skill(skill_ref, name, description, 
    -- sprite, sprite_subimage, animation, 
    -- cooldown, damage, is_primary, skill_id)
    Survivor.setup_skill(Fish.skill_family_z[0], "Fishing Rod", "Whip opponents and keep them at a distance.", 
        skills_sprite, 0, attack1_sprite,
        15.0, 1.0, false, 160)

    Fish.skill_family_z[0].does_change_activity_state = false
    Fish.skill_family_z[0].override_strafe_direction = false
    Fish.skill_family_z[0].require_key_press = false

    Survivor.setup_skill(Fish.skill_family_x[0], "Fishing Rod Double Deluxe ++", "Turns enemies into <y>burgers</c>. That's lowkey <y>fucked up</c> ngl.", 
        skills_sprite, 4, idle_sprite,
        0.0, 10.0, false, 160)

    Fish.skill_family_x[0].does_change_activity_state = false
    Fish.skill_family_x[0].override_strafe_direction = false
    Fish.skill_family_x[0].require_key_press = true

    Survivor.setup_skill(Fish.skill_family_c[0], "Bait Bucket", "Lmao dumbass explode now.",
        skills_sprite, 3, special2_sprite,
        5.0*60, 10.0, false, 122)
    
    Fish.skill_family_c[0].does_change_activity_state = false
    Fish.skill_family_c[0].override_strafe_direction = false
    Fish.skill_family_c[0].require_key_press = true

    Survivor.setup_skill(Fish.skill_family_v[0], "Bait Bucket", "Lmao dumbass explode now.",
        skills_sprite, 3, special2_sprite,
        5.0*60, 10.0, false, 122)

    Fish.skill_family_v[0].does_change_activity_state = false
    Fish.skill_family_v[0].override_strafe_direction = false
    Fish.skill_family_v[0].require_key_press = true

    Survivor.setup_empty_skill(Fish.skill_family_x[0])
    Survivor.setup_empty_skill(Fish.skill_family_c[0])

    -- == Section callbacks == --

    -- attacking

    local custom_sprite = 0
    gm.pre_script_hook(gm.constants.callback_execute, function(self, other, result, args)
        if self.class ~= Fish_id then return end
        if args[1].value == Fish.skill_family_z[0].on_activate then
            self.sprite_index = attack1_sprite
            gm.sound_play_at(gm.constants.wMercenaryShoot1_3, 1, 1, self.x, self.y, 500)
            local attack_offset = 64
            if gm.actor_get_facing_direction(self) == 180 then 
                attack_offset = -attack_offset
            end
            Actor.fire_explosion(self, self.x + attack_offset, self.y, 25, 25, 100, 1, 85)
            custom_sprite = custom_sprite +1
        end
    end)


    local function setBucket(inst)
        if inst.parent.class ~= Fish_id then return end
        inst.sprite_index = bait_sprite
        inst.sprite_idle = bait_sprite
    end

    gm.post_script_hook(gm.constants.instance_create_depth, function(self, other, result, args)
        if result.value.object_name == "oArtiSnap" then
            Alarm.create(setBucket, 1, result.value, other)
            Alarm.create(setBucket, 2, result.value, other)
        end
    end)

    --Survivor.add_callback(Fish_id, "onPlayerInit", Fish_init)
    --Survivor.add_callback(Fish_id, "onPlayerStep", onFishStep)
end
