require_relative 'document'
require_relative 'node'
require 'git'

module SheepAChangelog
  module Git
    def self.categorieze(msg)
      trim_first = -> (s) { s.split(' ').drop(1).join(' ').capitalize }
      case msg
      when /secur/i
        [:security, msg]
      when /^add/i
        [:added, trim_first.call(msg)]
      when /^change/i
        [:changed, trim_first.call(msg)]
      when /^update/i, /^refactor/i
        [:changed, msg]
      when /^deprecate/i
        [:deprecated, trim_first.call(msg)]
      when /^remove/i
        [:removed, trim_first.call(msg)]
      when /^fix/i
        [:fixed, trim_first.call(msg)]
      else
        [:_default, msg]
      end
    end

    def self.create_version_node(messages, title)
      buckets = messages.each_with_object(Hash.new([])) do |msg, res|
        next if msg.match?(/^(Merge|Release)/)
        c, m = categorieze(msg)
        res[c] += [m]
      end
      ver_node = Node.new([], title, 2)
      # TODO: Handle default
      ver_node.nodes = buckets.keys.sort.each_with_object([]) do |k, res|
        lines = (buckets[k]).map { |l| ' - ' + l } + ['']
        node = Node.new(lines, k.to_s.capitalize, 3)
        res << node
      end
      ver_node
    end

    def self.init_changelog(path)
      g = ::Git.open(path)
      tags = g.tags
      last = g.gcommit('HEAD')
      while (last.parent)
        last = last.parent
      end
      root_node = Node.new([], :empty, 0)
      h1_node = Node.new(['TODO', ''], 'Changelog', 1)

      anchors = []
      milestone_refs = [last.to_s, *tags.map(&:name)]
      h1_node.nodes = milestone_refs.each_cons(2).each_with_object([]) do |ts, ver_nodes|
        from, to = ts
        title = "[#{to}] - #{g.gcommit(to).date.strftime('%Y-%m-%d')}"
        messages = g.log.between(from, to).map(&:message).map { |msg| msg.split("\n").first }
        ver_node = create_version_node(messages, title)
        ver_nodes.unshift(ver_node)
        url = ''
        anchors.unshift(url: "#{url}/compare/#{from}...#{to}", v: to)
      end
      root_node.nodes = [h1_node]
      root_node.anchors = anchors
      puts root_node.to_s
    end
  end
end
