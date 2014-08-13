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

      # Set the DPIs
      self.pdf_dpi = 72
      self.printer_dpi = params[:dots]

      # Set the field orientation
      self.field_orientation = params[:field_orientation]

      # Set the number of variable fields
      self.variable_fields_count = 0

      # Create the array that will hold the data
      self.label_data = []

      # Set the default quantity to one
      self.quantity = 1

      # The start of the label
      label_data.push('^XA')
      label_data.push('^FWB') if field_orientation == :landscape
      label_data.push('^DF' + name + '^FS')

      init_prawn(params)
    end

    # Sets a variable field that can be recalled
    def variable_text_field(x, y, params = {})
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      options = { height: 0.1, width: 0.1 }.merge(params)

      # update the variable field count
      self.variable_fields_count += 1

      label_data.push('^FO' + Integer(x * printer_dpi).to_s + ',' +
                      Integer(y * printer_dpi).to_s + '^AF,' +
                      Integer(options[:height] * printer_dpi).to_s + ',' +
                      Integer(options[:width] * printer_dpi).to_s +
                       '^FN' + variable_fields_count.to_s + '^FS')

      # return unless label_height > 0 && label_width > 0
      # pdf.text_box '{Variable Field ' + variable_fields_count.to_s + '}',
      #              at: [Integer(x * pdf_dpi), Integer(label_width * pdf_dpi) -
      #              Integer(y * pdf_dpi) -
      #              Integer(options[:height] / 10) * pdf_dpi],
      #              size: Integer(options[:height] * pdf_dpi) if label_height &&
      #              label_width
    end

    # Sets a variable bar code that can be recalled
    def variable_bar_code_39(x, y, params = {})
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      options = { height: 0.1, width: 0.1 }.merge(params)

      # update the variable field count
      self.variable_fields_count += 1

      label_data.push('^FO' + Integer(x * printer_dpi).to_s + ',' +
                      Integer(y * printer_dpi).to_s)

      if params[:orientation] == :landscape
        label_data.push('^B3B,')
      else
        label_data.push('^B3N,')
      end

      label_data.push('Y,' + Integer(options[:height] * printer_dpi).to_s + ',N,N^FN' +
                      variable_fields_count.to_s + '^FS')

      # return unless label_height && label_width
      # options = { height: 20 }.merge(params)
      # draw_bar_code_39('VARIABLEFIELD' + variable_fields_count.to_s,
      #                  Integer(x * pdf_dpi), Integer(y * pdf_dpi),
      #                  Integer(options[:height] * pdf_dpi))
    end
  end
end
