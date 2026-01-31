--#textdomain wesnoth-vampirism
_ = wesnoth.textdomain "wesnoth-vampirism"
--debug_utils = wesnoth.require "~add-ons/1The_Great_Steppe_Era/lua/debug_utils.lua"


-- NOTE: this check the ability TAG, not ability id
function vampirism_has_ability(unit, ability)
    -- Returns true/false depending on whether unit has the given ability
    local has_ability = false
    local abilities = wml.get_child(unit.__cfg, "abilities")
    if abilities then
        if wml.get_child(abilities, ability) then has_ability = true end
    end
    return has_ability
end

function vampirism_attach_unit_status_renderer()
  local old_unit_weapons = wesnoth.interface.game_display.unit_weapons
  function wesnoth.interface.game_display.unit_weapons()
    local s = old_unit_weapons()
    local u = wesnoth.interface.get_displayed_unit()
    if u then
      if vampirism_has_ability(u, "vampirism") == true then
  
        table.insert(s, { "element", {
          text = _"Blood: <span color='#ff0000'>".. (u.variables.vampirism_blood and (tostring(u.variables.vampirism_blood)) or "0").."/".. (u.variables.vampirism_max_blood and (tostring(u.variables.vampirism_max_blood)) or "0").. "</span>\n",
          tooltip = _"Blood is the main currency in the Vampirism mod. The main ways of gaining Blood are: \n1. attacking living enemies with the 'drain' special \n2. ending your turn in a village \n\nHunger rate (how much blood you lose per turn): <span color='#ff0000'>"..(u.variables.vampirism_hunger_rate and (tostring(u.variables.vampirism_hunger_rate)) or "0").."</span>"
        } })

        --using XP colors that are somewhat similar to default xp colors

        local xp_prefix=_"XP: <span color='#0090ff'>"

        --purple XP color after maxing out vampire level, to make it similar to AMLA

        --TODO: adjust the level/xp tooltip to mention AMLAs

        if u.variables.vampirism_level then
            if u.variables.vampirism_level >= 10 then
                xp_prefix=_"XP: <span color='#9a05de'>"
            end
        end

        table.insert(s, { "element", {
          text = _"Level: <span color='#ff0000'>".. (u.variables.vampirism_level and (tostring(u.variables.vampirism_level)) or "0").. "</span> "..xp_prefix.. (u.variables.vampirism_xp and (tostring(u.variables.vampirism_xp)) or "0").."/".. (u.variables.vampirism_max_xp and (tostring(u.variables.vampirism_max_xp)) or "0").. "</span>\n",
          tooltip = _"Vampire level affects your power as a vampire - it increases your HP/damage/some other stats, and lets you unlock various vampire upgrades. However, higher vampire level also has downsides - you take more damage from sunlight, your arcane/fire resistances get lower, and your Hunger rate is increased (how much Blood you lose per turn)\n\nto level up as a vampire, you need Vampire XP, separate from normal XP. Vampire XP is gained when you gain Blood, spend Blood on Powers, and kill enemies (you also gain more Vampire XP when you use a drain attack to kill an enemy, instead of just killing normally)."
        } })
      end

      if vampirism_has_ability(u, "vampire_slumber") == true then
        if u.variables.vampirism_slumber_turns_left and u.variables.vampirism_slumber_turns_left > 0 then
  
            table.insert(s, { "element", {
              text = _"Slumber turns left: ".. (u.variables.vampirism_slumber_turns_left and (tostring(u.variables.vampirism_slumber_turns_left))).."\n",
              tooltip = _"Number of turns until this vampire wakes up from Slumber automatically. (though you can spend blood to wake up the vampire manually)"
            } })
        end
      end



    end
    return s
  end
end