#!/usr/bin/env ruby

require 'json'
require 'httpi'
require 'neo4j'

require 'pry'

Neo4j::Config[:storage_path] = "neo4j"

class User
  include Neo4j::NodeMixin
  property :name

  has_n :followers

  has_n :following

  index :name

  rule :all

  def fetch_followers
    r = HTTPI::Request.new
    r.url = "http://github.com/api/v2/json/user/show/#{name}/followers"
    res = HTTPI.get r
    JSON.parse res.body
  end

  def fetch_following
    r = HTTPI::Request.new
    r.url = "http://github.com/api/v2/json/user/show/#{name}/following"
    res = HTTPI.get r
    JSON.parse res.body
  end

  def self.find_or_create(name)
    finding = self.find("name: #{name}")
    if(finding.size == 0)
      self.new :name => name
    else
      finding.first
    end
  end
end

to_fetch = ["rortian"]

to_fetch.each do |name|
  Neo4j::Transaction.run do
    current = User.find_or_create name
    current.fetch_following["users"].each do |following|
      current.following << User.find_or_create(name)
    end
  end
end
