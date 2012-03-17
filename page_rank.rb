
require './jung'

require './user'

fac = Jung::DirectedSparseGraph.factory

net = fac.create

User.all.each {|u| net.add_vertex u.name }

Thread.new do

  User.all.each do |current|
    name = current.name
    current.following.each do |f|
      pair = Jung::Pair.new name,f.name
      net.add_edge "#{name}#{f.name}",pair,EdgeType::DIRECTED
    end
  end

end

binding.pry

