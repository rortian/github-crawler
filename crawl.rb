#!/usr/bin/env ruby

require 'json'
require 'httpi'
require 'neo4j'

Neo4j::Config[:storage_path] = "neo4j"

def followers(user)
  r = HTTPI::Request.new
  r.url = "http://github.com/api/v2/json/user/show/#{user}/followers"
  res = HTTPI.get r
  JSON.parse res.body
end

puts followers("rortian").inspect
