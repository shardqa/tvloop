-- Simple test script for MPV channel switching
local mp = require 'mp'
local msg = require 'mp.msg'

msg.info("Test script loaded successfully!")

-- Test function
local function test_function()
    mp.osd_message("Test script is working!", 3)
    msg.info("Test function called")
end

-- Add a test key binding
mp.add_key_binding("t", "test-function", test_function)

-- Show message on load
mp.osd_message("Test script loaded! Press 't' to test.", 5)

msg.info("Test script initialization complete")
