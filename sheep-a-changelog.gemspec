require_relative 'lib/sheep-a-changelog/meta'

Gem::Specification.new do |s|
  s.name = SheepAChangelog::Meta.name
  s.version = SheepAChangelog::Meta.version
  s.homepage = SheepAChangelog::Meta.homepage
  s.license = SheepAChangelog::Meta.license
  s.author = SheepAChangelog::Meta.author
  s.email = SheepAChangelog::Meta.email

  s.summary = SheepAChangelog::Meta.summary
  s.description = SheepAChangelog::Meta.description

  s.files = Dir['lib/**/*',
                '*.gemspec',
                'LICENSE*',
                'README*',
                'VERSION']

  s.required_ruby_version = '>= 2.2'

  s.add_runtime_dependency 'git', '~> 1.5'

  s.add_development_dependency 'coveralls', '~> 0.8'
  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'rspec-cheki', '~> 0.1'
  s.add_development_dependency 'rubocop', '~> 0.61.1'
  s.add_development_dependency 'simplecov', '~> 0.12'
  s.add_development_dependency 'yard', '~> 0.9'
end
