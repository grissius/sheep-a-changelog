require_relative 'node'

module SheepAChangelog
  module Parser
    def self.parse(contents)
      doc = Node.parse(contents)
      doc
    end
  end
end
