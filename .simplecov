require 'simplecov'

SimpleCov.start do
  add_filter '/tmp/'
  add_filter '/var/tmp/'
  add_filter 'bats-run-'
  add_filter '.bats.src'
  add_filter 'node_modules/'
  add_filter '/usr/'
  add_filter '/bin/'
  add_filter '/sbin/'
  add_filter '/lib/'
  add_filter '/lib64/'
  add_filter 'environment'
  
  add_group 'Core', 'core/'
  add_group 'Players', 'players/'
  add_group 'Scripts', 'scripts/'
  add_group 'Tests', 'tests/'
end
