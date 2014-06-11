# Easyzpl
[![Build Status](https://travis-ci.org/mgrigajtis/easyzpl.svg?branch=master)](https://travis-ci.org/mgrigajtis/easyzpl)

Makes it easy to write ZPL & ZPL2.

## Installation

Add this line to your application's Gemfile:

    gem 'easyzpl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install easyzpl

## Usage

    require 'rubygems'
    require 'easyzpl'

    # Create a simple label
    label = Easyzpl::Label.new
    label.home_position(30, 30)
    label.draw_border(0, 0, 400, 300)
    label.text_field('ZEBRA', 10, 10)
    label.bar_code_39('ZEBRA', 10, 30)
    puts label.to_s

    # Create a stored template
    label = Easyzpl::LabelTemplate.new('Template1')
    label.home_position(30, 30)
    label.draw_border(0, 0, 400, 300)
    label.variable_text_field(10, 10)
    label.variable_bar_code_39(10, 30)
    puts label.to_s

    # Created ZPL code to access the stored template created above
    label = Easyzpl::StoredLabel.new('Template1')
    label.add_field('ZEBRA')
    label.add_field('ZEBRA')
    puts label.to_s

## Contributing

1. Fork it ( https://github.com/[my-github-username]/easyzpl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
