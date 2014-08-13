require_relative 'label'

# This module is a wrapper for writing confusing ZPL and ZPL2 code
module Easyzpl
  # This is the stored label object
  class StoredLabel < Easyzpl::Label
    attr_accessor :variable_fields_count

    # Called when the new method is invoked
    def initialize(name)
      return if name.nil?
      return if name.strip.empty?

      # Set the number of variable fields
      self.variable_fields_count = 0

      # Set the DPIs
      self.pdf_dpi = 72
      self.printer_dpi = params[:dots]

      # Set the field orientation
      self.field_orientation = params[:field_orientation]

      # Create the array that will hold the data
      self.label_data = []

      # Set the default quantity to one
      self.quantity = 1

      # The start of the label
      label_data.push('^XA^XF' + name + '^FS')
    end

    # Adds a variable that is to be applied to the saved template
    def add_field(value)
      return if value.nil?
      return if value.strip.empty?

      # Increment the variable field count
      self.variable_fields_count += 1

      # Add the field
      label_data.push('^FN' + variable_fields_count.to_s +
                      '^FD' + value + '^FS')
    end
  end
end
