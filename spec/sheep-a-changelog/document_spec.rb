require 'sheep-a-changelog/node'
require 'sheep-a-changelog/document'

changelog = File.read(File.expand_path('examples/keepachangelog.md', __dir__))
document = SheepAChangelog::Document.new(changelog.split("\n"))

RSpec.describe SheepAChangelog::Document do
  it 'is same as top-level node' do
    expect(document.build_tree).to eq(SheepAChangelog::Node.new(changelog.split("\n"), :empty, 0).build_tree)
  end
end
