# 🔧 Subtitle and Audio Format Handling

## Subtitle Format Handling
```lua
-- Handle different subtitle formats
local function get_subtitle_format(sub_path)
    if sub_path:match("%.srt$") then
        return "srt"
    elseif sub_path:match("%.ass$") then
        return "ass"
    elseif sub_path:match("%.vtt$") then
        return "vtt"
    else
        return "unknown"
    end
end

local function load_subtitles_for_format(video_path)
    local video_name = video_path:match("(.+)%..+$")
    local subtitle_files = {
        video_name .. ".srt",
        video_name .. ".ass",
        video_name .. ".vtt"
    }
    
    for _, sub_file in ipairs(subtitle_files) do
        local file = io.open(sub_file, "r")
        if file then
            file:close()
            mp.commandv("sub-add", sub_file)
            break
        end
    end
end
```

## Audio Format Handling
```lua
-- Handle different audio formats in videos
local function configure_audio_for_format(video_path)
    local format = get_video_format(video_path)
    
    if format == "matroska" then
        -- MKV often has multiple audio tracks
        mp.set_property("audio-channels", "auto")
    elseif format == "avi" then
        -- AVI might need specific audio handling
        mp.set_property("audio-normalize-downmix", "yes")
    end
end
```

## Advanced Subtitle Handling
```lua
-- Advanced subtitle management
local function auto_load_subtitles(video_path)
    local video_dir = video_path:match("(.+)/[^/]+$") or "."
    local video_base = video_path:match("([^/]+)%.[^%.]+$")
    
    if video_base then
        local subtitle_patterns = {
            video_dir .. "/" .. video_base .. ".srt",
            video_dir .. "/" .. video_base .. ".en.srt",
            video_dir .. "/" .. video_base .. ".ass"
        }
        
        for _, pattern in ipairs(subtitle_patterns) do
            local file = io.open(pattern, "r")
            if file then
                file:close()
                mp.commandv("sub-add", pattern, "auto")
                break
            end
        end
    end
end
```

## Usage Examples

### Subtitle Integration
```bash
# Create videos with subtitles
echo "/videos/movie1.mkv|Movie with Subs|7200" > channels/subtitled/playlist.txt
# Ensure matching subtitle files exist:
# /videos/movie1.srt or /videos/movie1.ass
```

### Multi-Language Subtitles
```bash
# Create videos with multiple subtitle options
echo "/videos/movie1.mkv|Multi-Lang Movie|7200" > channels/multilang/playlist.txt
# Files: movie1.en.srt, movie1.es.srt, movie1.fr.srt
```

## See Also
- [Format Extensions](technical-formats.md) - Video format handling
- [Basic Video Sources](technical-videosources-basic.md) - Common video sources
