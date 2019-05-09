require_relative 'document'
require_relative 'node'
require 'git'

KEEP_A_CACHANGELOG_PREAMBLE = [
  'All notable changes to this project will be documented in this file.',
  '',
  'The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),',
  'and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).',
  '',
].freeze

module SheepAChangelog
  class RepoInspector
    def initialize(path, options = {})
      @git = ::Git.open(path)
      @options = options
      @tag_prefix = @options[:tag_prefix] || 'v'
    end

    def root_commit
      head = @git.gcommit('HEAD')
      head = head.parent while head.parent
      head
    end

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
        next if msg =~ /^(Merge|Release)/

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

    def anchor_url
      remote_url = @git.remotes.first.url
      _match, _user, host, path = remote_url
        .match(/([^@]+)@([^:]+):(.*)\.git/).to_a
      "https://#{host}/#{path}"
    end

    def milestone_refs
      [
        root_commit.to_s,
        *@git.tags.map(&:name)
          .select { |t| t.start_with?(@tag_prefix) },
        'HEAD',
      ]
    end

    def format_version(version_tag)
      return 'Unreleased' if version_tag == 'HEAD'

      version_tag.reverse.chomp(@tag_prefix.reverse).reverse
    end

    def create_milestone_nodes
      anchors = []
      nodes = milestone_refs
        .each_cons(2)
        .each_with_object([]) do |ts, ver_nodes|
        from, to = ts
        # TODO: No date on Unreleased
        date = @git.gcommit(to).date.strftime('%Y-%m-%d')
        title = "[#{format_version(to)}] - #{date}"
        messages = @git.log
          .between(from, to).map(&:message).map { |msg| msg.split("\n").first }
        ver_node = RepoInspector.create_version_node(messages, title)
        ver_nodes.unshift(ver_node)
        anchors
          .unshift(
            url: "#{anchor_url}/compare/#{from}...#{to}",
            v: format_version(to),
          )
      end
      [nodes, anchors]
    end

    def init_changelog
      root_node = Node.new([], :empty, 0)
      h1_node = Node.new(KEEP_A_CACHANGELOG_PREAMBLE, 'Changelog', 1)

      nodes, anchors = create_milestone_nodes
      h1_node.nodes = nodes
      root_node.nodes = [h1_node]
      root_node.anchors = anchors
      root_node
    end

    def suggest_unreleased
      doc = init_changelog
      doc.nodes.first.nodes.first
    end
  end
end
