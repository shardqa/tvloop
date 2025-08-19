require 'simplecov'

SimpleCov.start do
  add_filter '/tmp/'
  add_filter '/var/tmp/'
  add_filter 'bats-run-'
  add_filter '.bats.src'
  
  add_group 'Core', 'core/'
  add_group 'Players', 'players/'
  add_group 'Scripts', 'scripts/'
  add_group 'Tests', 'tests/'
end
