require 'sheep-a-changelog/repo_inspector'

RSpec.describe SheepAChangelog::RepoInspector do
  it 'init_changelog' do
    inspector = SheepAChangelog::RepoInspector
    root_path = File.expand_path('../..', __dir__)
    doc = inspector.init_changelog(root_path)
    expect(doc.to_s).to match_snapshot
  end
end
