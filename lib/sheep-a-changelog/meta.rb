module SheepAChangelog
  module Meta
    def self.name
      'sheep-a-changelog'.freeze
    end

    def self.version
      File.read(File.expand_path('../../VERSION', __dir__)).strip
    end

    def self.summary
      'Simple, particular, example driven parser of keep-a-changelog format.'
        .freeze
    end

    def self.description
      text = <<-DESCRIPTION
        #{summary}
      DESCRIPTION
      text.strip
    end

    def self.homepage
      'https://github.com/grissius/keep-a-changelog'.freeze
    end

    def self.license
      'MIT'.freeze
    end

    def self.author
      'Jaroslav Šmolík'.freeze
    end

    def self.email
      'grissius@gmail.com'.freeze
    end
  end
end
