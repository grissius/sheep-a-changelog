require 'sheep-a-changelog/node'
require 'sheep-a-changelog/document'

changelog = File.read(File.expand_path('examples/keepachangelog.md', __dir__))
node = SheepAChangelog::Node.new(changelog.split("\n"), :empty, 0)

RSpec.describe SheepAChangelog::Node do
  it 'structure is hierarchically parsed' do
    expect(node.build_tree).to match_snapshot
  end
end
