require_relative 'document'

module SheepAChangelog
  module Parser
    def self.parse(contents)
      doc = Document.parse(contents)
      doc
    end
  end
end
