#!/usr/bin/env ruby

require 'json'
require 'httpi'
require 'neo4j'
require 'set'

require 'pry'

Neo4j::Config[:storage_path] = "neo4j"

class User
  include Neo4j::NodeMixin
  property :name,:visited

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
      self.new :name => name,:visited => false
    else
      finding.first
    end
  end
end

to_visit = Set.new

User.all.each do |u|
  if(!u.visited)
    to_visit << u.name
  end
end

HTTPI.log = false

def crawl(&block)
  Thread.new do
    block.call
  end
  block
end

yo = crawl do 
  while(to_visit.size > 0)
    name = to_visit.to_a.sample
    Neo4j::Transaction.run do
      current = User.find_or_create name
      current.fetch_following["users"].uniq.each do |following|
        user = User.find_or_create(following)
        current.following << user
        if(!user.visited)
          to_visit << user.name
        end
      end
      current.visited = true
      to_visit -= [name]
  end
  sleep 1
  end
end

crawled = User.all.size - to_visit.size

monitor = Thread.new do
  while (to_visit.size > 0 )
    sleep 60
    now_crawled = User.all.size - to_visit.size
    if(now_crawled == crawled)
      crawl &yo
    end
    crawled = now_crawled
  end
end

binding.pry

