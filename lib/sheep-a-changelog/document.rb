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

    # Return title of the first (most recent) version node
    def first_version
      version_root.nodes.first.title
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
      parent.nodes = parent.nodes.map do |node|
        if node.title == from
          Node.new(node.all_lines_wo_heading.first, to, 2)
        else
          node
        end
      end
    end
  end
end
