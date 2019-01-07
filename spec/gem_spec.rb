RSpec.describe 'gemspec' do
  it 'gem built' do
    expect(system('gem build sheep-a-changelog.gemspec > /dev/null')).to be_truthy, 'Building gem failed'
  end
end
