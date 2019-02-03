require 'sheep-a-changelog/node'
require 'sheep-a-changelog/document'

changelog = File.read(File.expand_path('examples/keepachangelog.md', __dir__))

RSpec.describe SheepAChangelog::Document do
  subject(:doc) { SheepAChangelog::Document.new(changelog.split("\n")) }

  it 'is same as top-level node' do
    expect(doc.build_tree).to eq(SheepAChangelog::Node.new(changelog.split("\n"), :empty, 0).build_tree)
  end

  it 'version_root' do
    expect(doc.version_root.nodes.map(&:title)).to match_snapshot
  end

  it 'first_version' do
    expect(doc.first_version).to match(/Unreleased/)
  end

  it 'diff_prefix' do
    expect(doc.diff_prefix).to match('https://github.com/olivierlacan/keep-a-changelog/compare/')
  end

  it 'rename_version' do
    new_version = 'foo_bar'
    doc.rename_version('[Unreleased]', new_version)
    expect(doc.first_version).to match(new_version)
    expect(doc.build_tree).to match_snapshot
  end

  it 'add_anchor' do
    new_version = 'foo_bar'
    doc.add_anchor('LABEL', 'vFROM', 'vTO')
    expect(doc.anchors).to match_snapshot
  end
end
