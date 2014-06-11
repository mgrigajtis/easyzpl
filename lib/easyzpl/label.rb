# This module is a wrapper for writing confusing ZPL and ZPL2 code
module Easyzpl
  # This is the label object
  class Label
    attr_accessor :label_data
    attr_accessor :quantity

    # Called when the new method is invoked
    def initialize
      # Create the array that will hold the data
      self.label_data = []

      # Set the default quantity to one
      self.quantity = 1

      # The start of the label
      label_data.push('^XA')
    end

    # Set the number of labels to print
    def change_quantity(q)
      q = 1 unless numeric?(q)
      self.quantity = q
    end

    # Set the home position of the label
    # All other X and Y coordinates are
    # relative to this
    def home_position(x, y)
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      label_data.push('^LH' + x.to_s + ',' + y.to_s)
    end

    # Draws a square border on dot in width
    def draw_border(x, y, length, width)
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      return unless numeric?(length) && numeric?(width)
      label_data.push('^FO' + x.to_s + ',' + y.to_s + '^GB' + length.to_s +
                      ',' + width.to_s + ',1^FS')
    end

    # Prints text
    def text_field(text, x, y, params = {})
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      options = { height: 10.to_s, width: 10.to_s }.merge(params)
      label_data.push('^FO' + x.to_s + ',' + y.to_s + '^AFN,' +
                      options[:height].to_s + ',' + options[:width].to_s +
                      '^FD' + text + '^FS')
    end

    # Prints a bar code in barcode39 font
    def bar_code_39(bar_code_string, x, y)
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      label_data.push('^FO' + x.to_s + ',' + y.to_s + '^B3N,Y,20,N,N^FD' +
                      bar_code_string + '^FS')
    end

    # Renders the ZPL code as a string
    def to_s
      return '' unless label_data.length > 0
      label_data.map! { |l| "#{l}" }.join('') + '^PQ' + quantity.to_s + '^XZ'
    end

    protected

    # Returns true if a variable is number, false if not
    def numeric?(variable)
      true if Integer(variable) rescue false
    end
  end
end
