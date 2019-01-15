require_relative 'sheep-a-changelog/parser'

module SheepAChangelog
  def self.parse(changelog)
    Parser.parse(changelog)
  end
end
