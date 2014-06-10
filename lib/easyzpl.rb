require 'easyzpl/version'

# This module is a wrapper for writing confusing ZPL and ZPL2 code
module Easyzpl
  # This is the label object
  class Label
    attr_accessor :label_data

    def initialize
      self.label_data = []
      label_data.push('^XA')
    end

    def home_position(x, y)
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      label_data.push('^LH' + x.to_s + ',' + y.to_s)
    end

    def text_field(text, x, y, params = {})
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      options = { height: 10.to_s, width: 10.to_s }.merge(params)
      label_data.push('^FO' + x.to_s + ',' + y.to_s + '^AFN' +
        options[:height] + ',' + options[:width] + '^FD' + text + '^FS')
    end

    def bar_code_39(bar_code_string, x, y)
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      label_data.push('^FO' + x.to_s + ',' + y.to_s + '^B3N,Y,20,N,N^FD' +
        bar_code_string + '^FS')
    end

    def to_s
      return '' unless label_data.length > 0
      label_data.map! { |l| "#{l}" }.join('') + '^XZ'
    end

    private

    def numeric?(variable)
      true if Integer(variable) rescue false
    end
  end
end
