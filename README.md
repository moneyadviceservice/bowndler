# Bowndler

Integrate bower and bundler, by making bower aware of gem bundles.

NOTE:
- this is experimental, your results may vary
- this readme needs to be updated, we know its light on detail. It is highly recommended that you read the source before using bowndler.

## Installation

Add this line to your application's Gemfile:

    gem 'bowndler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bowndler

## Usage

1. rename bower.json to bower.json.erb
2. add `"my_gem": "<%= gem_path('my_gem') %>"` to "paths" in the bower.json.erb, for any gem that has its own bower.json
3. instead of running `bower <command>`, run `bowndler <command>` and bowndler will make sure the bower.json is up to date. e.g. `bowndler install`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
