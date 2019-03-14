require_relative 'sheep-a-changelog/parser'
require_relative 'sheep-a-changelog/repo_inspector'

module SheepAChangelog
  def self.parse(changelog)
    Parser.parse(changelog)
  end

  def self.init_changelog(path = Dir.pwd)
    RepoInspector.new(path).init_changelog
  end
end
