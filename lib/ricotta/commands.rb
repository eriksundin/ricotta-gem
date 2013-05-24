$:.push File.expand_path('../', __FILE__)

require 'commands/dump'
require 'commands/xcode'

global_option '-c', '--config FILE', "Load default options from a configuration file"