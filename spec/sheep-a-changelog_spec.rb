require 'sheep-a-changelog'
require 'sheep-a-changelog/parser'

RSpec.describe 'sheep-a-changelog' do
  before do
    allow(SheepAChangelog::Parser).to receive(:parse).and_return(:parsed)
  end
  it 'calls parser' do
    expect(SheepAChangelog.parse(:changelog)).to eq(:parsed)
  end
end
