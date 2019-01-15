module SheepAChangelog
  module Manipulator
    def self.unreleased(doc)
      p '--------'
      p Manipulator.first_version(doc).title
      p '--------'

      x = doc.nodes.first.nodes.first
      p x.title
      x.title = '....'
      p x.title
      p doc.nodes.first.nodes.first.title
    end
    
    def self.version_nodes(node)
      if node.level != 0
        nil
      else
        node.nodes.first.nodes
      end
    end

    def self.first_version(node)
      Manipulator.version_nodes(node).first
    end
  end
end
