require 'sheep-a-changelog/repo_inspector'

RSpec.describe SheepAChangelog::RepoInspector do
  it 'init_changelog' do
    root_path = File.expand_path('../..', __dir__)
    inspector = SheepAChangelog::RepoInspector.new(root_path)
    doc = inspector.init_changelog
    expect(doc.to_s).to match_snapshot
  end
end
