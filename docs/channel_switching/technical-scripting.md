# 🔧 Script Extensions

## Adding Channel Categories
```lua
-- In mpv_channel_switcher.lua, add category support
local function get_channel_category(channel_name)
    if channel_name:match("news") then
        return "news"
    elseif channel_name:match("music") then
        return "music"
    else
        return "general"
    end
end
```

## Custom Channel Commands
```lua
-- Add custom commands for specific channels
mp.register_script_message("channel-info", function(channel_name)
    local info = get_channel_details(channel_name)
    mp.osd_message(info, 5)
end)
```

## Channel Metadata
```lua
-- Add metadata support for channels
local function get_channel_metadata(channel_name)
    local metadata = {
        filipe_deschamps = {
            category = "tech",
            language = "pt",
            description = "Tech tutorials in Portuguese"
        },
        jovem_nerd = {
            category = "entertainment", 
            language = "pt",
            description = "Entertainment content"
        }
    }
    return metadata[channel_name] or {}
end
```

## Custom Time Calculation
```lua
-- Override default time calculation
local function custom_time_calculation(channel_dir)
    -- Your custom logic here
    local custom_start_time = get_custom_start_time(channel_dir)
    local custom_duration = get_custom_duration(channel_dir)
    
    return calculate_position(custom_start_time, custom_duration)
end
```

## Channel Validation
```lua
-- Add validation for channel files
local function validate_channel(channel_dir)
    local required_files = {"state.json", "playlist.txt"}
    
    for _, file in ipairs(required_files) do
        local file_path = channel_dir .. "/" .. file
        if not io.open(file_path, "r") then
            return false, "Missing file: " .. file
        end
    end
    
    return true
end
```

## Event Hooks
```lua
-- Add event hooks for channel switching
mp.register_event("file-loaded", function()
    local current_file = mp.get_property("filename")
    if current_file then
        log_channel_switch(current_file)
    end
end)

local function log_channel_switch(filename)
    local log_file = io.open("/tmp/channel_switches.log", "a")
    if log_file then
        log_file:write(os.date() .. " - Switched to: " .. filename .. "\n")
        log_file:close()
    end
end
```
