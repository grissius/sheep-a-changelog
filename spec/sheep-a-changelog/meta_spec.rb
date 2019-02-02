require 'sheep-a-changelog/meta'

RSpec.describe 'Meta data' do
  it 'works and is unchanged' do
    meta = %i[author name description email license homepage summary]
           .map { |m| [m, SheepAChangelog::Meta.public_send(m)] }.to_h
    expect(meta).to match_snapshot
  end
  it 'version returns semver' do
    expect(SheepAChangelog::Meta.version).to match(/[0-9]+\.[0-9]+\.[0-9]+/)
  end
end
