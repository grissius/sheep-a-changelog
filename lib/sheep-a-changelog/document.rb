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

    def rename_version(from, to)
      parent = version_root
      parent.nodes = parent.nodes.map do |node|
        Node.new(node.all_lines, to, 2) if node.title == from
      end
    end
  end
end
