require 'sheep-a-changelog/node'
require 'sheep-a-changelog/manipulator'

changelog = File.read(File.expand_path('examples/keepachangelog.md', __dir__))
node = SheepAChangelog::Node.new(changelog.split("\n"))

RSpec.describe SheepAChangelog::Manipulator do
  it 'structure is hierarchically parsed' do
    p SheepAChangelog::Manipulator.unreleased(node)
  end
end
