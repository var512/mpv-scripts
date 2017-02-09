--
-- Requires quick-scale.lua
-- Usage: <key> script-message toggle_pip
--
local options = {
    show_messages = true,
    width = 820,
    height = 440,
}

(require "mp.options").read_options(options, "toggle-pip")

local cfg = {
    ontop = nil,
    window_scale = nil,
}

local is_fullscreen = false
local is_enabled = false
local message = ""

function on_file_loaded(event)
    update_config()
end

function on_end_file(event)
    restore_properties()
end

function update_config(event)
    cfg.ontop = mp.get_property_bool("ontop", false)
    cfg.window_scale = mp.get_property("window-scale", 1.0)
end

function restore_properties(event)
    mp.set_property_bool("ontop", cfg.ontop)
    mp.set_property("window-scale", cfg.window_scale)
end

function toggle_pip(event)
    is_fullscreen = mp.get_property_bool("fullscreen", false)

    if is_fullscreen then
        mp.set_property_bool("fullscreen", false)
        is_enabled = false

        if options.show_messages then
            message = "Fullscreen detected: PIP enabled by default"
            mp.msg.info(message)
        end
    end

    if options.show_messages then
        message = "PIP " .. (is_enabled and "Disabled" or "Enabled")
        mp.osd_message(message)
        mp.msg.info(message)
    end

    if is_enabled then
        mp.set_property_number("window-scale", cfg.window_scale)
    else
        if not is_fullscreen then
            update_config()
        end

        mp.command("script-message Quick_Scale " .. options.width .. " " .. options.height .. " 1 0")
    end

    is_enabled = not is_enabled

    mp.set_property_native("ontop", is_enabled)
end

mp.register_event("file-loaded", on_file_loaded)
mp.register_event("end-file", on_end_file)
mp.register_script_message("toggle_pip", toggle_pip)
