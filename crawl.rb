#!/usr/bin/env ruby

require 'json'
require 'httpi'
require 'neo4j'

require 'pry'

Neo4j::Config[:storage_path] = "neo4j"

class User
  include Neo4j::NodeMixin

  index :name

  def followers(user)
    r = HTTPI::Request.new
    r.url = "http://github.com/api/v2/json/user/show/#{user}/followers"
    res = HTTPI.get r
    JSON.parse res.body
  end

  def following(user)
    r = HTTPI::Request.new
    r.url = "http://github.com/api/v2/json/user/show/#{user}/following"
    res = HTTPI.get r
    JSON.parse res.body
  end

end

binding.pry
