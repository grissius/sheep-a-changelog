require_relative 'node'

module SheepAChangelog
  class Document < Node
    def initialize(lines)
      super(lines, :empty, 0)
    end
  end
end
