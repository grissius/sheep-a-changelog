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

  it 'latest_version_title' do
    expect(doc.latest_version_title).to match(/Unreleased/)
  end

  it 'diff_prefix' do
    expect(doc.diff_prefix).to match('https://github.com/olivierlacan/keep-a-changelog/compare/')
  end

  it 'rename_version' do
    new_version = 'foo_bar'
    doc.rename_version('[Unreleased]', new_version)
    expect(doc.latest_version_title).to match(new_version)
    expect(doc.build_tree).to match_snapshot
  end

  it 'add_anchor' do
    doc.add_anchor('LABEL', 'vFROM', 'vTO')
    expect(doc.anchors).to match_snapshot
  end

  context 'release' do
    it 'multiple releases' do
      x = doc.to_s
      10.times do |n|
        doc = SheepAChangelog.parse(x)
        doc.release('2.0.0', 'v')
        x = doc.to_s
      end
      expect(x.to_s).to match_snapshot
    end
    it 'keep-a-changelog' do
      changelog2 = File.read(File.expand_path('examples/keepachangelog.2.0.0.md', __dir__))
      doc.release('2.0.0', 'v', Time.utc(2017, 6, 20))
      expect(doc.to_s).to eql(changelog2)
    end
    it 'desmond' do
      desmond = File.read(File.expand_path('examples/desmond.0.2.5.md', __dir__))
      desmonddoc = SheepAChangelog::Document.new(desmond.split("\n"))
      desmond030 = File.read(File.expand_path('examples/desmond.0.3.0.md', __dir__))
      desmonddoc.release('0.3.0', 'v', Time.utc(2018, 11, 14))
      expect(desmonddoc.to_s).to eql(desmond030)
    end
    it 'empty' do
      empty = File.read(File.expand_path('examples/empty.md', __dir__))
      emptydoc = SheepAChangelog.parse(empty)
      emptyX = File.read(File.expand_path('examples/emptyX.md', __dir__))
      emptydoc.release('X', 'version', Time.utc(0))
      expect(emptydoc.to_s).to eql(emptyX)
    end
  end
end
