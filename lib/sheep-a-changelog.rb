require_relative 'sheep-a-changelog/parser'
require_relative 'sheep-a-changelog/git'

module SheepAChangelog
  def self.parse(changelog)
    Parser.parse(changelog)
  end

  def self.init_changelog(path = Dir.pwd)
    Git.init_changelog(path)
  end
end
