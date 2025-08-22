# 🔧 Custom Key Bindings

## Adding More Channels
```bash
# In config/mpv_input.conf, add:
F6 script-message switch-channel 6
F7 script-message switch-channel 7
F8 script-message switch-channel 8
F9 script-message switch-channel 9
```

## Alternative Key Layouts
```bash
# Use letter keys instead of numbers
a script-message switch-channel 1
s script-message switch-channel 2
d script-message switch-channel 3
f script-message switch-channel 4
```

## Function Key Layout
```bash
# Use function keys for channel switching
F1 script-message switch-channel 1
F2 script-message switch-channel 2
F3 script-message switch-channel 3
F4 script-message switch-channel 4
F5 script-message switch-channel 5
```

## Modifier Key Layout
```bash
# Use Ctrl modifier for channel switching
Ctrl+1 script-message switch-channel 1
Ctrl+2 script-message switch-channel 2
Ctrl+3 script-message switch-channel 3
Ctrl+4 script-message switch-channel 4
Ctrl+5 script-message switch-channel 5
```

## Custom Channel Categories
```bash
# Group channels by category
# News channels
n script-message switch-category news

# Music channels  
m script-message switch-category music

# Entertainment channels
e script-message switch-category entertainment
```

## Quick Access Keys
```bash
# Quick channel info
i script-binding show-channel-info

# Channel list
l script-binding show-channel-list

# Help
h script-message show-channel-help
```

## Gaming Controller Support
```bash
# Xbox/PlayStation controller buttons
JOY_RIGHT script-message switch-channel next
JOY_LEFT script-message switch-channel prev
JOY_A script-message switch-channel 1
JOY_B script-message switch-channel 2
```
