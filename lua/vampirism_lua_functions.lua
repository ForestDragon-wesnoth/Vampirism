--#textdomain wesnoth-vampirism
_ = wesnoth.textdomain "wesnoth-vampirism"
debug_utils = wesnoth.require "~add-ons/1The_Great_Steppe_Era/lua/debug_utils.lua"


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
          tooltip = _"TODO"
        } })

        table.insert(s, { "element", {
          text = _"Level: <span color='#ff0000'>".. (u.variables.vampirism_level and (tostring(u.variables.vampirism_level)) or "0").. "</span> ".._"XP: <span color='#ff0000'>".. (u.variables.vampirism_xp and (tostring(u.variables.vampirism_xp)) or "0").."/".. (u.variables.vampirism_max_xp and (tostring(u.variables.vampirism_max_xp)) or "0").. "</span>\n",
          tooltip = _"TODO"
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