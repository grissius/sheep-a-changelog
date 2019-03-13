require_relative 'sheep-a-changelog/parser'
require_relative 'sheep-a-changelog/repo_inspector'

module SheepAChangelog
  def self.parse(changelog)
    Parser.parse(changelog)
  end

  def self.init_changelog(path = Dir.pwd)
    RepoInspector.init_changelog(Dir.pwd)
  end
end
