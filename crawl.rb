#!/usr/bin/env ruby

require 'json'
require 'httpi'
require 'neo4j'

Neo4j::Config[:storage_path] = "neo4j"
