require 'sheep-a-changelog/parser'

RSpec.describe SheepAChangelog::Parser do
  it 'parses and converts back without a change' do
    changelog = File.read(File.expand_path('examples/keepachangelog.md', __dir__))
    expect(SheepAChangelog::Parser.parse(changelog).to_s).to eql(changelog)
  end
end
