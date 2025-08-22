# 📺 Channel Switching Usage Guide

## Getting Started

### 1. Create Your Channels
```bash
# Create your first channel
./tvloop create youtube filipe_deschamps "https://www.youtube.com/@FilipeDeschamps" 2

# Create your second channel
./tvloop create youtube jovem_nerd "https://www.youtube.com/@JovemNerd" 2
```

### 2. Start Playing
```bash
# Tune in to first channel
./tvloop tune mpv filipe_deschamps
```

### 3. Switch Channels
- Press **2** to switch to jovem_nerd
- Press **1** to switch back to filipe_deschamps
- Press **i** to see channel information

## 🎮 Hotkey Controls

### Channel Switching
- **1-9**: Switch to channel 1-9
- **F1-F5**: Alternative channel switching (function keys)
- **Ctrl+1-5**: Channel switching with Ctrl modifier

### Information
- **i**: Show current channel and available channels
- **c**: Quick channel list (same as 'i')
- **h**: Show channel switching help

## 📺 Usage Examples

### Start with Channel Switching
```bash
# Tune in to first available channel with switching enabled
./tvloop tune mpv

# Tune in to specific channel with switching enabled
./tvloop tune mpv filipe_deschamps
```

### Switch Channels While Playing
1. Start a channel: `./tvloop tune mpv filipe_deschamps`
2. Press **2** to switch to the second channel (jovem_nerd)
3. Press **1** to switch back to the first channel
4. Press **i** to see available channels

### Channel Information
- Press **i** to see:
  - Current channel name
  - List of all available channels
  - Channel numbers for switching

## 🎮 Advanced Usage

### Custom Key Bindings
You can modify `config/mpv_input.conf` to change key bindings:

```bash
# Example: Use different keys
a script-message switch-channel 1
s script-message switch-channel 2
d script-message switch-channel 3
```

### Multiple Channel Types
Channel switching works with any channel type:
- YouTube channels
- Local video channels
- Mixed content channels

### Channel Priority
Channels are numbered based on alphabetical order:
1. `filipe_deschamps` → Key **1**
2. `jovem_nerd` → Key **2**
3. `tech_channel` → Key **3**

## 🔄 Channel Flow
```
Channel 1 (filipe_deschamps) ←→ Channel 2 (jovem_nerd)
     ↑                              ↑
   Press 1                      Press 2
```
