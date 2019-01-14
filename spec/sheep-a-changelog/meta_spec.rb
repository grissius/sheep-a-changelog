require 'sheep-a-changelog/meta'

RSpec.describe 'Meta data' do
  it 'works and is unchanged' do
    meta = %i[author name description email license homepage summary]
           .map { |m| [m, SheepAChangelog::Meta.public_send(m)] }.to_h
    expect(meta).to match_snapshot
  end
end
