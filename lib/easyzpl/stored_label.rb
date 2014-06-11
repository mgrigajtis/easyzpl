require_relative 'label'

# This module is a wrapper for writing confusing ZPL and ZPL2 code
module Easyzpl
  # This is the stored label object
  class StoredLabel < Easyzpl::Label
    attr_accessor :variable_fields_count

  end
end
