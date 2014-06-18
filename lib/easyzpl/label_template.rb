require_relative 'label'
require 'prawn'
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'

# This module is a wrapper for writing confusing ZPL and ZPL2 code
module Easyzpl
  # This is the label template object
  # This gets uploaded and saved on the printer
  class LabelTemplate < Easyzpl::Label
    attr_accessor :variable_fields_count

    # Called when the new method is invoked
    def initialize(name, params = {})
      return if name.nil?
      return if name.strip.empty?

      # Set the number of variable fields
      self.variable_fields_count = 0

      # Create the array that will hold the data
      self.label_data = []

      # Set the default quantity to one
      self.quantity = 1

      # The start of the label
      label_data.push('^XA^DF' + name + '^FS')

      init_prawn(params)
    end

    # Sets a variable field that can be recalled
    def variable_text_field(x, y, params = {})
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      options = { height: 10, width: 10 }.merge(params)

      # update the variable field count
      self.variable_fields_count += 1

      label_data.push('^FO' + x.to_s + ',' + y.to_s + '^AFN,' +
                      options[:height].to_s + ',' + options[:width].to_s +
                       '^FN' + variable_fields_count.to_s + '^FS')

      return unless label_height > 0 && label_width > 0
      pdf.text_box '{Variable Field ' + variable_fields_count.to_s + '}',
                   at: [x, label_width - y - Integer(options[:height] / 10)],
                   size: options[:height] if label_height && label_width
    end

    # Sets a variable bar code that can be recalled
    def variable_bar_code_39(x, y, params = {})
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)

      # update the variable field count
      self.variable_fields_count += 1

      label_data.push('^FO' + x.to_s + ',' + y.to_s + '^B3N,Y,20,N,N^FN' +
                      variable_fields_count.to_s + '^FS')

      return unless label_height && label_width
      options = { height: 20 }.merge(params)
      draw_bar_code_39('VARIABLEFIELD' + variable_fields_count.to_s,
                       x, y, options[:height])
    end
  end
end
