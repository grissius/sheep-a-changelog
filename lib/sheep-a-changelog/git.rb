require_relative 'document'
require_relative 'node'
require 'git'

module SheepAChangelog
  module Git
    def self.categorieze(msg)
      case msg
      when /secur/i
        :security
      when /^add/i
        :added
      when /^change/i
        :changed
      when /^deprecate/i
        :deprecated
      when /^remove/i
        :removed
      when /^fix/i
        :fixed
      else
        :default
      end
    end

    def self.create_version_node(messages, title)
      buckets = messages.each_with_object(Hash.new([])) do |m, res|
        res[categorieze(m)] += [m]
      end
      ver_node = Node.new([], title, 2)
      # TODO: Handle default
      ver_node.nodes = buckets.keys.sort.each_with_object([]) do |k, res|
        lines = (buckets[k]).map { |l| ' - ' + l } + ['']
        node = Node.new(lines, k.to_s, 3)
        res << node
      end
      ver_node
    end

    def self.init_changelog(path)
      g = ::Git.open(path)
      tags = g.tags
      root_node = Node.new([], :empty, 0)
      h1_node = Node.new(['TODO', ''], 'Changelog', 1)

      h1_node.nodes = tags.map(&:name).each_cons(2).each_with_object([]) do |ts, ver_nodes|
        title = "[#{ts[1]}] - #{g.gcommit(ts[1]).date.strftime('%Y-%m-%d')}"
        messages = g.log.between(*ts).map(&:message).map { |msg| msg.split("\n").first }
        ver_node = create_version_node(messages, title)
        ver_nodes.unshift(ver_node)
      end
      root_node.nodes = [h1_node]
      puts root_node.to_s
    end
  end
end
