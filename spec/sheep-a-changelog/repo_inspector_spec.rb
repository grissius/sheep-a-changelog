require 'sheep-a-changelog/repo_inspector'

root_path = File.expand_path('../..', __dir__)

RSpec.describe SheepAChangelog::RepoInspector do
  it 'init_changelog' do
    inspector = SheepAChangelog::RepoInspector.new(root_path)
    doc = inspector.init_changelog
    # removed unreleased
    nodes = doc.nodes.first.nodes
    doc.nodes.first.nodes = doc.nodes.first.nodes.reject do |n|
      tag, date_str = n.title.split(' - ')
      bail = Date::strptime(date_str, '%Y-%m-%d') > Date.new(2019, 02, 16)
      # TODO: use tag and bail to reject anchors
      bail
    end
    expect(doc.to_s).to match_snapshot
  end
  it 'suggest_unreleased' do
    inspector = SheepAChangelog::RepoInspector.new(root_path)
    doc = inspector.suggest_unreleased
    expect(doc.to_s).to match(/^## \[Unreleased\]/)
  end
end
