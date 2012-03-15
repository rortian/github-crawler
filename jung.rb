
require 'java'

require 'pry'

jung_dir = File.join(File.dirname(__FILE__),"jung")

jung_jars = File.join jung_dir,'*.jar'

Dir.glob(jung_jars).each {|f| require f }

module Jung

  java_import 'edu.uci.ics.jung.graph.DirectedSparseGraph'

  java_import 'edu.uci.ics.jung.algorithms.scoring.PageRank'

  java_import 'edu.uci.ics.jung.graph.util.Pair'

  java_import 'edu.uci.ics.jung.graph.util.EdgeType'

end

binding.pry
