require 'sheep-a-changelog/parser'

KEEPACHANGELOG = File.read(File.expand_path('examples/keepachangelog.md', __dir__)).freeze

RSpec.describe SheepAChangelog::Parser do
  it 'parse' do
    expect(SheepAChangelog::Parser.parse(KEEPACHANGELOG).to_s).to eql(KEEPACHANGELOG)
  end
end
