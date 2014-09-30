# Easyzpl
[![Build Status](https://travis-ci.org/mgrigajtis/easyzpl.svg?branch=master)](https://travis-ci.org/mgrigajtis/easyzpl)

Makes it easy to write ZPL & ZPL2.  This Gem translates your Ruby Code
into ZPL.  You can then send your ZPL to your printers.  In the future,
this Gem will be able to directly interact with your Zebra Printers.

This Gem now outputs your Gem as a PDF Document (Prawn is now a dependency),
because wouldn't it be nice to be able to see what your labels look like
before trying to print?  You're welcome.

## Installation

Add this line to your application's Gemfile:

    gem 'easyzpl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install easyzpl

## Usage - the following is an example of an AIAG template
```
# This file generates the ZPL for the AIAG template
require 'rubygems'
require 'easyzpl'

# There are 72 dots in an inch (usually)
# In the case of our printer, there are 203
dots = 193

# The dimensions of the label
label_x = 0
label_y = 0
label_width = 4
label_height = 6.5
label_fields_orientation = :landscape

# The dimensions of the header border
header_width = 1.2
header_height = 6.5
header_x = 0
header_y = 0

# The dimensions of the quantity border
quant_x = header_width
quant_y = header_height - (label_height / 2)
quant_height = label_height / 2
quant_width = 1.1

# The quantity text label
quant_text_label = 'QUANTITY'
quant_text_x = header_width + 0.1
quant_text_y = label_height - (quant_height - 2.5)
quant_text_height = 0.1
quant_text_width = 0.1

# The actual quantity text
qty_x = header_width + 0.1
qty_y = label_height - (quant_height - 0.5)
qty_width = 0.1
qty_height = 0.1

# The quantity bar code
qty_bar_code_x = header_width + 0.1 + 0.3
qty_bar_code_y = label_height - (quant_height - 0.5)
qty_bar_code_height = 0.3

# The dimensions of the serial supplier border
supplier_x = header_width + quant_width
supplier_y = header_height - 4
supplier_width = 0.8
supplier_height = 4

# The dimensions of the serial serial border
serial_x = header_width + quant_width + supplier_width
serial_y = header_height - 4
serial_width = 0.92
serial_height = 4

# The Header Text
header_text_x = 0.1
header_text_y = 0.001
header_text_height = 1.0
header_text_width = 0.5

# Supplier Name
supplier_name = 'Some Company'
supplier_name_x = header_width + 0.1
supplier_name_y = 0.2
supplier_name_height = 0.1
supplier_name_width = 0.1

# Supplier Address
supplier_address = '253 Street Name'
supplier_address_x = header_width + supplier_name_height + 0.15
supplier_address_y = 0.2
supplier_address_height = 0.1
supplier_address_width = 0.1

# Supplier city\state
supplier_city_state = 'City, FL 32953'
supplier_city_state_x = header_width + supplier_name_height + supplier_address_height + 0.2
supplier_city_state_y = 0.2
supplier_city_state_height = 0.1
supplier_city_state_width = 0.1

# The supplier header that goes in the supplier bar code box
supplier_header = 'SUPPLIER'
supplier_header_width = 0.1
supplier_header_height = 0.1
supplier_header_x = header_width + quant_width + 0.1
supplier_header_y = label_height - 0.75 - supplier_header_width

# The supplier number that goes in the supplier bar code box
supplier_number_x = header_width + quant_width + 0.1
supplier_number_y = label_height - 3.5 - supplier_header_width
supplier_number_height = 0.1
supplier_number_width = 0.1

# The supplier bar code that goes in the supplier bar code box
supplier_bar_code_x = header_width + quant_width + supplier_number_height + 0.2
supplier_bar_code_y = label_height - 3.5 - supplier_header_width
supplier_bar_code_height = 0.3

## The serial number header that goes in the serial number bar code box
serial_header = 'SERIAL'
serial_header_height = 0.1
serial_header_width = 0.1
serial_header_x = header_width + quant_width + supplier_width + 0.1
serial_header_y = label_height - 0.75 - serial_header_width

# The serial number that goes in the serial number bar code box
serial_number_width = 0.1
serial_number_height = 0.1
serial_number_x = header_width + quant_width + supplier_width + 0.1
serial_number_y = label_height - 3.5 - serial_header_width

# The serial bar code that goes in the serial number bar code box
serial_bar_code_x = header_width + quant_width + supplier_width + serial_number_height + 0.2
serial_bar_code_y = label_height - 3.5 - serial_header_width
serial_bar_code_height = 0.3

# Generate the new label
label = Easyzpl::LabelTemplate.new('AiagLabel',
                                   dots: dots,
                                   width: label_width,
                                   field_orientation: label_fields_orientation,
                                   height: label_height)

label.home_position(30, 30) # 30,30 seems to be the standard for Zebra labels

# Draw the border around the entire label
label.draw_border(label_x, label_y, label_width, label_height)

# Draw the header border
label.draw_border(header_x, header_y, header_width, header_height)

# Draw the quantity border
label.draw_border(quant_x, quant_y, quant_width, quant_height)

# Draw the supplier border
label.draw_border(supplier_x, supplier_y, supplier_width, supplier_height)

# Draw the serial border
label.draw_border(serial_x, serial_y, serial_width, serial_height)

# Print the header text
label.variable_text_field(header_text_x, header_text_y,
                          width: header_text_width, height: header_text_height)

# Print the quantity label
label.text_field(quant_text_label,
                 quant_text_x,
                 quant_text_y,
                 width: quant_text_width,
                 height: quant_text_height)

# Print the quantity
label.variable_text_field(qty_x,
                          qty_y,
                          width: qty_width,
                          height: qty_height)

# Print the quantity bar code
label.variable_bar_code_39(qty_bar_code_x,
                           qty_bar_code_y,
                           orientation: :landscape,
                           height: qty_bar_code_height)

# Print the supplier name and address
label.text_field(supplier_name,
                 supplier_name_x,
                 supplier_name_y,
                 width: supplier_name_width,
                 height: supplier_name_height)

label.text_field(supplier_address,
                 supplier_address_x,
                 supplier_address_y,
                 width: supplier_address_width,
                 height: supplier_address_height)

label.text_field(supplier_city_state,
                 supplier_city_state_x,
                 supplier_city_state_y,
                 width: supplier_city_state_width,
                 height: supplier_city_state_height)

# Print the supplier header
label.text_field(supplier_header,
                 supplier_header_x,
                 supplier_header_y,
                 width: supplier_header_width,
                 height: supplier_header_height)

# Print the supplier number
label.variable_text_field(supplier_number_x,
                          supplier_number_y,
                          width: supplier_number_width,
                          height: supplier_number_height)

# Print the supplier bar code
label.variable_bar_code_39(supplier_bar_code_x,
                           supplier_bar_code_y,
                           orientation: :landscape,
                           height: supplier_bar_code_height)

# Print the serial header
label.text_field(serial_header,
                 serial_header_x,
                 serial_header_y,
                 orientation: :landscape,
                 height: serial_header_height,
                 width: serial_header_width)

# Print the serial number
label.variable_text_field(serial_number_x,
                          serial_number_y,
                          height: serial_number_height,
                          width: serial_number_width)

# Print the serial bar code
label.variable_bar_code_39(serial_bar_code_x,
                           serial_bar_code_y,
                           orientation: :landscape,
                           height: serial_bar_code_height)

# Generate the label code
puts label.to_s
```
## Contributing

1. Fork it ( https://github.com/[my-github-username]/easyzpl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
