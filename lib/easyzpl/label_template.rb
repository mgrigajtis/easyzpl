require_relative 'label'

# This module is a wrapper for writing confusing ZPL and ZPL2 code
module Easyzpl
  # This is the label template object
  # This gets uploaded and saved on the printer
  class LabelTemplate < Easyzpl::Label
    attr_accessor :variable_fields_count

    # Called when the new method is invoked
    def initialize(name)
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
    end

    # Sets a variable field that can be recalled
    def variable_text_field(x, y)
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)

      # update the variable field count
      self.variable_fields_count += 1

      label_data.push('^FO' + x.to_s + ',' + y.to_s + '^FN' +
                      variable_fields_count.to_s + '^FS')
    end

    # Sets a variable bar code that can be recalled
    def variable_bar_code_39(x, y)
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)

      # update the variable field count
      self.variable_fields_count += 1

      label_data.push('^FO' + x.to_s + ',' + y.to_s + '^B3N,Y,20,N,N^FN' +
                      variable_fields_count.to_s + '^FS')
    end
  end
end
