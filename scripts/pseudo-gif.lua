local options = {
    show_messages = true,
    max_duration = 60,
    extensions = "3gp,avi,flv,gif,m4v,mkv,mp4,mpeg,mpg,ogv,rmvb,webm,wmv",
    protocols = "rtmp,rtsp,http,https,mms,mmst,mmsh,mmshttp,rtp,httpproxy,rtmpe,rtmps,rtmpt,rtmpte,rtmpts,srtp,data,lavf,ffmpeg,udp,ftp,tcp,sftp",
}

(require "mp.options").read_options(options, "pseudo-gif")

local cfg = {
    keep_open = nil,
    loop_file = nil,
    save_position_on_quit = nil,
}

function on_file_loaded(event)
    update_config()
    pseudo_gif()
end

function on_end_file(event)
    restore_properties()
end

function update_config(event)
    cfg.keep_open = mp.get_property("keep-open")
    cfg.loop_file = mp.get_property("loop-file")
    cfg.save_position_on_quit = mp.get_property("save-position-on-quit")
end

function restore_properties(event)
    mp.set_property("keep-open", cfg.keep_open)
    mp.set_property("loop-file", cfg.loop_file)
    mp.set_property("save-position-on-quit", cfg.save_position_on_quit)
end

function set_pseudo_gif_properties()
    mp.set_property("keep-open", "yes")
    mp.set_property("loop-file", "inf")
    mp.set_property("save-position-on-quit", "no")
end

function pseudo_gif(event)
    local duration = math.ceil(mp.get_property_number("duration", 0))

    if (is_whitelisted()) and (duration <= options.max_duration) then
        set_pseudo_gif_properties()

        if options.show_messages then
            message = "Pseudo-gif enabled"
            mp.osd_message(message)
            mp.msg.info(message)
        end
    end
end

function get_file_extension(path)
    return path:match("[^.]+$")
end

function get_protocol(path)
    return path:match("^[^:]+")
end

function is_whitelisted()
    local extensions = split_csv(options.extensions)
    local protocols = split_csv(options.protocols)
    local path = mp.get_property("path", "")
    local ext = get_file_extension(path)
    local prot = get_protocol(path)

    return table.contains(extensions, ext) or table.contains(protocols, prot)
end

function split_csv(csv)
    local table = {}
    csv:gsub("[^,]+", function(m) table[#table + 1] = m end)

    return table
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end

    return false
end

mp.register_event("file-loaded", on_file_loaded)
mp.register_event("end-file", on_end_file)
