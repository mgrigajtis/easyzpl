require 'prawn'
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'

# This module is a wrapper for writing confusing ZPL and ZPL2 code
module Easyzpl
  # This is the label object
  class Label
    attr_accessor :label_data
    attr_accessor :quantity
    attr_accessor :pdf
    attr_accessor :label_width
    attr_accessor :label_height

    # Called when the new method is invoked
    def initialize(params = {})
      # Create the array that will hold the data
      self.label_data = []

      # If we got parameters, store them
      # Remember, we only need them for Prawn
      self.label_width = params[:width] || 0
      self.label_height = params[:height] || 0

      # Set the default quantity to one
      self.quantity = 1

      # Start creating a Prawn document in memory,
      # this can later be saved as a PDF and also
      # an image
      return unless label_height && label_width
      self.pdf = Prawn::Document.new

      # The start of the zpl label
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
      return unless numeric?(length) && numeric?(width)
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)

      label_data.push('^FO' + x.to_s + ',' + y.to_s + '^GB' + length.to_s +
                      ',' + width.to_s + ',1^FS')

      # PDF creation if the label height & width has been set
      return unless label_height && label_width
      pdf.stroke_axis
      pdf.stroke do
        pdf.rectangle [x, y], length, width * -1
      end
    end

    # Prints text
    def text_field(text, x, y, params = {})
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      options = { height: 10.to_s, width: 10.to_s }.merge(params)
      label_data.push('^FO' + x.to_s + ',' + y.to_s + '^AFN,' +
                      options[:height].to_s + ',' + options[:width].to_s +
                      '^FD' + text + '^FS')

      return unless label_height && label_width
      pdf.text_box text, at: [x, Integer(label_height) - y -
                    Integer(options[:height]) - 1]
    end

    # Prints a bar code in barcode39 font
    def bar_code_39(bar_code_string, x, y)
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      label_data.push('^FO' + x.to_s + ',' + y.to_s + '^B3N,Y,20,N,N^FD' +
                      bar_code_string + '^FS')

      return unless label_height && label_width
      pdf.bounding_box [x, Integer(label_height) - y -
                      50 - 1], width: 100 do
        barcode = Barby::Code39.new(bar_code_string)
        barcode.annotate_pdf(pdf)
      end
    end

    # Renders the ZPL code as a string
    def to_s
      return '' unless label_data.length > 0
      label_data.map! { |l| "#{l}" }.join('') + '^PQ' + quantity.to_s + '^XZ'
    end

    def to_pdf(filename)
      return unless label_height && label_width
      pdf.render_file(filename)
    end

    protected

    # Returns true if a variable is number, false if not
    def numeric?(variable)
      true if Integer(variable) rescue false
    end
  end
end
