require_relative 'node'

module SheepAChangelog
  class Document < Node
    def initialize(lines)
      super(lines, :empty, 0)
    end

    # Return parent node to version nodes
    def version_root
      nodes.first
    end

    # Return title of the latest version node
    def latest_version_title(n = 0)
      version_root.nodes[n].title
    end

    # Return the latest version
    def latest_version(n = 0)
      latest_version_title(n).match(/^\[(\S+)\].*/).to_a[1]
    end

    def add_empty_version(name)
      version_root.nodes.unshift(Node.new([''], name, 2))
    end

    def diff_prefix
      anchors.map { |a| a[:url].match(%r{^(.*\/)(.*\.\.\..*)$}).to_a[1] }
        .each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }
        .to_a
        .min { |a, b| b[1] <=> a[1] }
        .first
    end

    def rename_version(from, to)
      parent = version_root
      parent.nodes.map! do |node|
        if node.title == from
          cloned = node.clone
          cloned.title = to
          cloned
        else
          node
        end
      end
    end

    def add_anchor(name, from, to)
      anchors.unshift(v: name, url: "#{diff_prefix}#{from}...#{to}")
    end

    def remove_anchor_unreleased
      anchors.reject! { |a| a[:v] == 'Unreleased' }
    end

    def to_s
      (all_lines + ['']).join("\n")
    end

    def release(version, tag_prefix, t = Time.now)
      remove_anchor_unreleased
      rename_version('[Unreleased]', "[#{version}] - #{t.strftime('%Y-%m-%d')}")
      add_anchor(version, tag_prefix + latest_version(1), tag_prefix + version)
      add_empty_version('[Unreleased]')
      add_anchor('Unreleased', tag_prefix + version, 'HEAD')
    end
  end
end
