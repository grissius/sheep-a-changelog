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
# See features section

# Serialize back to string
updated = doc.to_s

# Save back
File.write('./path/to/CHANGELOG.md', updated)
```

## Features

### Release
This method performs the following actions:
- Rename current _unreleased_ version log to _new version_
- Add anchor for _new version_
- Add empty _unreleased_
- Update _unreleased_ anchor

It accepts arguments
1. `new_version` - semver format
2. `tag_prefix` - prefix for `new_version` for git tags (used for anchors). Defaults to `v`
3. `date` - date of the release, defaults to now

```ruby
doc.release('2.0.0', 'v', Time.utc(2017, 6, 20))
```


### Inspect element
```ruby
node.build_tree
# :title - heading (string) or :empty for top-level node
# :lines - string[] of contents belonging to this node, without anchors and child nodes
# :anchors - { :v, :url } of anchor nodes
# :nodes - child nodes
```
```yaml
  :title: :empty
  :lines: []
  :anchors:
  - :v: Unreleased
    :url: https://github.com/olivierlacan/keep-a-changelog/compare/v1.0.0...HEAD
  - :v: 1.0.0
    :url: https://github.com/olivierlacan/keep-a-changelog/compare/v0.3.0...v1.0.0
  :nodes:
  - :title: Changelog
    :lines:
    - All notable changes to this project will be documented in this file.
    - ''
    - The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
    - and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
    - ''
    :anchors: []
    :nodes:
    - :title: "[1.0.0] - 2017-06-20"
      :lines: []
      :anchors: []
      :nodes:
      - :title: Added
        :lines:
        - '- "Frequently Asked Questions" section.'
        - ''
        :anchors: []
        :nodes: []
```

### Latest version title
Returns the contents of the heading for the latest version.
```ruby
doc.latest_version_title
# --> "[1.0.0] - 2017-06-20"
```

### Diff prefix
Returns URL prefix for the anchors. If multiple used, return the most frequent.
```ruby
doc.diff_prefix
# --> "https://github.com/olivierlacan/keep-a-changelog/compare/"
```

### Rename version
Rename version. Looking for exact match. This only changes the title and keeps the contents (inlcuding all children intact.)
```ruby
doc.rename_version('[Unreleased]', new_version)
```

### Add anchor
```ruby
doc.add_anchor('LABEL', 'vFROM', 'vTO')
# adds "[LABEL]: {diff_prefix}/vFROM...vTO" as the topmost anchor
```

## Todo

- :heavy_check_mark: Ensure unreleased
- :heavy_check_mark: Release
- :construction: Initialize
- :construction: Sort type sections
- :construction: Fix typos in type sections

## License
Licensed under [MIT](./LICENSE)