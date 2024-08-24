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
    local skills_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites", "sFishmongerSkills.png"))
    local loadout_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites", "sSelectFishmonger.png"), 4, false, false, 28, 0)

    local bullet_path = path.combine(_ENV["!plugins_mod_folder_path"], "Sprites", "IWBTSBullet.png")

    -- In Game Sprites
    
    local idle_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites", "sFishmongerIdle.png"), 10, false, false, 24, 19)
    local jump_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerJump.png"), 2, false, false, 24, 19)
    local jumpfall_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerFall.png"), 1, false, false, 24, 19)
    local walk_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerWalk.png"), 10, false, false, 24, 19)
    local climb_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerClimb.png"), 2, false, false, 24, 19)

    local attack1_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerAttack1.png"), 5, false, false, 75, 51,2)
    -- bait bucket --
    local bait_sprite = Resources.sprite_load(path.combine(_ENV["!plugins_mod_folder_path"], "Sprites","sFishmongerBait.png"), 1, false, false, 7, 19)

    local bullet_sprite = gm.sprite_add(bullet_path, 1, false, false, 100000, 100000)

    local death_sprite = gm.sprite_duplicate(gm.constants.sGolemDeath)

    -- Body Parts 

    local PartsHead_path = path.combine(_ENV["!plugins_mod_folder_path"], "Sprites", "IWBTSPartsHead.png")
    local PartsHead_sprite = gm.sprite_add(PartsHead_path, 1, true, false, 0, 0)

    local PartsArm_path = path.combine(_ENV["!plugins_mod_folder_path"], "Sprites", "IWBTSPartsArm.png")
    local PartsArm_sprite = gm.sprite_add(PartsArm_path, 1, true, false, 0, 0)

    local PartsLeg_path = path.combine(_ENV["!plugins_mod_folder_path"], "Sprites", "IWBTSPartsLeg.png")
    local PartsLeg_sprite = gm.sprite_add(PartsLeg_path, 1, true, false, 0, 0)

    local PartsBody_path = path.combine(_ENV["!plugins_mod_folder_path"], "Sprites", "IWBTSPartsBody.png")
    local PartsBody_sprite = gm.sprite_add(PartsBody_path, 32, true, false, 0, 0)

    -- Sprite Offsets
    gm.sprite_set_offset(death_sprite, 100000, 100000)

    -- Sprite Speeds
    gm.sprite_set_speed(idle_sprite, 0.65, 1) -- idle animation speed
    gm.sprite_set_speed(walk_sprite, 0.7, 1) -- walk animation speed
    gm.sprite_set_speed(attack1_sprite, 1, 1)
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
    local body_parts = 15

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
        walk_sprite, idle_sprite, death_sprite, jump_sprite, jumpfall_sprite, jumpfall_sprite, nil,
        {["r"]=238, ["g"] = 173, ["b"] = 105}, {[1] = 0.0, [2] = -9.0, [3] = 3.0}
    )
    -- function setup_stats(survivor_id, armor, attack_speed, movement_speed, critical_chance, damage, hp_regen, maxhp, maxbarrier, maxshield, maxhp_cap, jump_force)
    Survivor.setup_stats(Fish_id, nil, 1.0, nil, 1.0, nil, nil, 160,  nil, nil, nil, jump_force)

    -- function setup_level_stats(survivor_id, armor_level, attack_speed_level, critical_chance_level, damage_level, hp_regen_level, maxhp_level)
    Survivor.setup_level_stats(Fish_id, nil, nil, nil, nil, nil, nil)

    -- == Section skills == --

    -- function setup_skill(skill_ref, name, description, 
    -- sprite, sprite_subimage,animation, 
    -- cooldown, damage, is_primary, skill_id)
    Survivor.setup_skill(Fish.skill_family_z[0], "Fishing Rod", "Whip opponents and keep them at a distance.", 
        skills_sprite, 1, attack1_sprite,
        1.0, 3.0, false, 27)

    Fish.skill_family_z[0].does_change_activity_state = false
    Fish.skill_family_z[0].override_strafe_direction = false
    Fish.skill_family_z[0].require_key_press = true

    Survivor.setup_skill(Fish.skill_family_x[0], "Fishing Rod Double Deluxe ++", "Turns enemies into <y>burgers</c>. That's lowkey <y>fucked up</c> ngl.", 
        skills_sprite, 1, idle_sprite,
        0.0, 10.0, false, 160)
    Fish.skill_family_x[0].does_change_activity_state = false
    Fish.skill_family_x[0].override_strafe_direction = false
    Fish.skill_family_x[0].require_key_press = true

    Survivor.setup_skill(Fish.skill_family_c[0], "Bait Bucket", "Lmao dumbass explode now.",
        skills_sprite, 1, idle_sprite,
        33.0, 10.0, false, 122)
    
    Fish.skill_family_c[0].does_change_activity_state = false
    Fish.skill_family_c[0].override_strafe_direction = false
    Fish.skill_family_c[0].require_key_press = true

    Survivor.setup_empty_skill(Fish.skill_family_x[0])
    Survivor.setup_empty_skill(Fish.skill_family_v[0])

    -- == Section callbacks == --
    -- offset = 

    -- attacking
    gm.pre_script_hook(gm.constants.callback_execute, function(self, other, result, args)
        if self.class ~= Fish_id then return end
        if args[1].value == Fish.skill_family_z[0].on_activate then
            self.sprite_index = attack1_sprite
            gm.sound_play_at(gm.constants.wMercenaryShoot1_3, 1, 1, self.x, self.y, 500)
            print("whipper")
            local attack_offset = 80
            if gm.actor_get_facing_direction(self) == 180 then 
                attack_offset = -attack_offset
            end
        gm._mod_attack_fire_explosion(
            self,
            self.x + attack_offset,
            self.y - 15,
            80,
            35,
            self.skills[1].active_skill.damage,
            bullet_sprite,
            bullet_sprite,
            true)
        end
    end)

    gm.post_script_hook(gm.constants.instance_create_depth, function(self, other, result, args)
        if self.class ~= Fish_id then return end
        if result.value.object_name == "oArtiSnap" then
            result.value.sprite_idle = bait_sprite
            print("get bucket")
        end
    end)


    local function onDeath(self)
        if Helper.get_client_player().m_id < 2.0 then
            local head = gm.instance_create_depth(self.x, self.y - 15, 1, gm.constants.oEfNugget)
            local arm1 = gm.instance_create_depth(self.x, self.y - 15, 1, gm.constants.oEfNugget)
            local arm2 = gm.instance_create_depth(self.x, self.y - 15, 1, gm.constants.oEfNugget)
            local leg1 = gm.instance_create_depth(self.x, self.y - 15, 1, gm.constants.oEfNugget)
            local leg2 = gm.instance_create_depth(self.x, self.y - 15, 1, gm.constants.oEfNugget)

            print_struct(arm1)

            head.is_Fish_part = 1.0
            arm1.is_Fish_part = 1.0
            arm2.is_Fish_part = 1.0
            leg1.is_Fish_part = 1.0
            leg2.is_Fish_part = 1.0

            head.image_xscale = 2.0
            arm1.image_xscale = 2.0
            arm2.image_xscale = 2.0
            leg1.image_xscale = 2.0
            leg2.image_xscale = 2.0

            head.image_yscale = 2.0
            arm1.image_yscale = 2.0
            arm2.image_yscale = 2.0
            leg1.image_yscale = 2.0
            leg2.image_yscale = 2.0
            
            head.sprite_index = PartsHead_sprite
            arm1.sprite_index = PartsArm_sprite
            arm2.sprite_index = PartsArm_sprite
            leg1.sprite_index = PartsLeg_sprite
            leg2.sprite_index = PartsLeg_sprite

            for i=1, body_parts do
                local part = gm.instance_create_depth(self.x, self.y - 15, 1, gm.constants.oEfNugget)
                part.sprite_index = PartsBody_sprite
                part.image_speed = 0
                part.image_xscale = 2.0
                part.image_yscale = 2.0
                part.image_index = i
                part.is_Fish_part = 1.0
            end
        end
    end

    Survivor.add_callback(Fish_id, "onPlayerInit", Fish_init)
    Survivor.add_callback(Fish_id, "onPlayerStep", onFishStep)
    Survivor.add_callback(Fish_id, "onPlayerDeath", onDeath)
end