
require 'java'

require 'pry'

jung_dir = File.join(File.dirname(__FILE__),"jung")

jung_jars = File.join jung_dir,'*.jar'

Dir.glob(jung_jars).each {|f| require f }

binding.pry
