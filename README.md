<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/b/b9/Sheep%2C_Stodmarsh_6.jpg" height="170" width="170"/>
</p>

# Sheep a changelog

[![Build Status](https://img.shields.io/travis/com/grissius/sheep-a-changelog/master.svg?style=flat-square)](https://travis-ci.com/grissius/sheep-a-changelog)
[![Coverage Status](https://img.shields.io/coveralls/github/grissius/sheep-a-changelog.svg?style=flat-square)](https://coveralls.io/github/grissius/sheep-a-changelog?branch=master)
[![Gem](https://img.shields.io/gem/v/sheep-a-changelog.svg?style=flat-square)](https://rubygems.org/gems/sheep-a-changelog)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/grissius/sheep-a-changelog.svg?style=flat-square)](https://codeclimate.com/github/grissius/sheep-a-changelog)
[![License](https://img.shields.io/github/license/grissius/sheep-a-changelog.svg?style=flat-square)](https://github.com/grissius/sheep-a-changelog/blob/master/LICENSE)

:sheep: Simple, particular, example driven parser of keep-a-changelog format.

## About

Parse a markdown changelog in [keep-a-changelog](https://keepachangelog.com) format to the optimal resolution depth to perform semantic tasks.

## Install

See [RubyGems](https://rubygems.org/gems/sheep-a-changelog) for installation instructions (simply add to your Gemfile).

Sheep-a-changelog requires at least ruby 2.2, and is [tested](https://travis-ci.com/grissius/sheep-a-changelog) on several minor versions up to 2.5.

## Getting started

```ruby
require 'sheep-a-changelog'

# Load keep-a-changelog markdown file as a string
contents = File.read('./path/to/CHANGELOG.md')

# Create an abstraction for it using the parser
# SheepAChangelog.parse: string -> SheepAChangelog.Node
doc = SheepAChangelog.parse(contents)

# TODO temper with the structure

# Serialize back to string
updated = doc.to_s

# Save back
File.write('./path/to/CHANGELOG.md', updated)
```

## Features

- :construction: Ensure unreleased
- :construction: Release
- :construction: Initialize
- :construction: Sort type sections
- :construction: Fix typos in type sections

## License
Licensed under [MIT](./LICENSE)