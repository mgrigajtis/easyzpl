require 'prawn'
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'

# This module is a wrapper for writing confusing ZPL and ZPL2 code
module Easyzpl
  # This is the label object
  class Label
    attr_accessor :invert
    attr_accessor :label_data
    attr_accessor :quantity
    attr_accessor :pdf
    attr_accessor :label_width
    attr_accessor :label_height
    attr_accessor :printer_dpi
    attr_accessor :pdf_dpi
    attr_accessor :field_orientation

    # Called when the new method is invoked
    def initialize(params = {})
      # Create the array that will hold the data
      self.label_data = []

      # Set the default quantity to one
      self.quantity = 1

      # Set the DPIs
      self.pdf_dpi = 72
      self.printer_dpi = params[:dots]

      # Set the field orientation
      self.field_orientation = params[:field_orientation]

      # See if invert is set to true
      self.invert = params[:invert]

      # The start of the label
      label_data.push('^XA')
      label_data.push('^POI') if invert
      label_data.push('^LT' + Integer(params[:offset] * printer_dpi).to_s) unless params[:offset].nil?
      label_data.push('^LL' + Integer(params[:height] * printer_dpi).to_s) unless params[:height].nil?
      label_data.push('^PW' + Integer(params[:width] * printer_dpi).to_s) unless params[:width].nil?
      label_data.push('^FWB') if field_orientation == :landscape

      # Initialize Prawn
      # init_prawn(params)
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
    def draw_border(x, y, height, width)
      return unless numeric?(height) && numeric?(width)
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)

      label_data.push('^FO' + Integer(x * printer_dpi).to_s + ',' +
                      Integer(y * printer_dpi).to_s + '^GB' +
                      Integer(height * printer_dpi).to_s +
                      ',' + Integer(width * printer_dpi).to_s + ',1^FS')

      # draw_rectangle(x * pdf_dpi, y * pdf_dpi, height * pdf_dpi, width * pdf_dpi)
    end

    # Prints text
    def text_field(text, x, y, params = {})
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      options = { height: 0.1,
                  width: 0.1 }.merge!(params)
      label_data.push('^FO' + Integer(x * printer_dpi).to_s + ',' + Integer(y *
                      printer_dpi).to_s)

      if params[:orientation] == :landscape
        label_data.push('^A0N,')
      else
        label_data.push('^A0B,')
      end

      label_data.push(Integer(options[:height] * printer_dpi).to_s + ',' +
                      Integer(options[:width] * printer_dpi).to_s + '^FD' +
                      text + '^FS')

      # return unless label_height > 0 && label_width > 0
      # pdf.text_box text, at: [x, label_width - y -
      #                    Integer((options[:height] * pdf_dpi) / 10)],
      #                    size: (options[:height] *
      #                    pdf_dpi) if label_height && label_width
    end

    # Prints a bar code in barcode39 font
    def bar_code_39(bar_code_string, x, y, params = {})
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      label_data.push('^FO' + Integer(x * printer_dpi).to_s + ',' +
                      Integer(y * printer_dpi).to_s + '^B3N,Y,20,N,N^FD' +
                      bar_code_string + '^FS')

      # return unless label_height && label_width
      # options = { height: 20 }.merge!(params) { |key, v1, v2| v1 }
      # draw_bar_code_39(bar_code_string, Integer(x * pdf_dpi),
      #                  Integer(y * pdf_dpi), (options[:height] * pdf_dpi))
    end

    # Prints a bar code in barcode39 font
    def bar_code_128(bar_code_string, x, y, params = {})
      x                       = 0 unless numeric?(x)
      y                       = 0 unless numeric?(y)
      height                  = numeric?(params[:height]) ? params[:height] : 0.2
      interpretation          = params[:interpretation] == :true ? 'Y' : 'N'
      interpretation_location = params[:interpretation_location] == :above ? 'Y' : 'N'
      check_digit             = params[:check_digit] == :true ? 'Y' : 'N'
      mode                    = { :ucc_case => 'U',
                                  :auto     => 'A',
                                  :ucc_ean  => 'D' }[params[:mode]] || 'N'
      orientation             = { :portrait => 'R',
                                  90        => 'R',
                                  180       => 'I',
                                  270       => 'B' }[params[:orientation]] || 'N'
      label_data.push('^FO' + Integer(x * printer_dpi).to_s + ',' +
                      Integer(y * printer_dpi).to_s + '^BC' +
                      orientation + ',' +
                      Integer(height* printer_dpi).to_s + ',' +
                      interpretation + ',' +
                      interpretation_location + ',' +
                      check_digit + ',' +
                      mode + '^FD' +
                      bar_code_string + '^FS')

      # return unless label_height && label_width
      # options = { height: 20 }.merge!(params) { |key, v1, v2| v1 }
      # draw_bar_code128_(bar_code_string, Integer(x * pdf_dpi),
      #                   Integer(y * pdf_dpi), (options[:height] * pdf_dpi))
    end

    # Prints a bar code in barcode39 font
    def bar_code_qr(bar_code_string, x, y, params = {})
      x                = 0 unless numeric?(x)
      y                = 0 unless numeric?(y)
      magnification    = numeric?(params[:magnification]) ? params[:magnification] : default_qr_code_magnification
      error_correction = { :ultra    => 'H',
                           :high     => 'Q',
                           :standard => 'M',
                           :density  => 'L' }[params[:error_correction]] || (params[:error_correction]).nil? ? 'Q' : 'M'
      mask             = numeric?(params[:mask]) ? params[:mask] : 7
      model            = { 1          => 1,
                           :standard  => 1,
                           2          => 2,
                           :enhanced  => 2 }[params[:model]] || 2
      label_data.push('^FO' + Integer(x * printer_dpi).to_s + ',' +
                      Integer(y * printer_dpi).to_s + '^BQN,' +
                      Integer(model).to_s + ',' +
                      Integer(magnification).to_s + ',' +
                      error_correction + ',' +
                      Integer(mask).to_s + '^FD' +
                      bar_code_string + '^FS')

      # return unless label_height && label_width
      # options = { height: 20 }.merge!(params) { |key, v1, v2| v1 }
      # draw_bar_code128_(bar_code_string, Integer(x * pdf_dpi),
      #                   Integer(y * pdf_dpi), (options[:height] * pdf_dpi))
    end

    # Prints a bar code in pdf417 font
    def bar_code_pdf417(bar_code_string, x, y, params = {})
      x = 0 unless numeric?(x)
      y = 0 unless numeric?(y)
      label_data.push('^FO' + Integer(x * printer_dpi).to_s + ',' +
                      Integer(y * printer_dpi).to_s + '^B7N,Y,20,N,N^FD' +
                      bar_code_string + '^FS')

      # return unless label_height && label_width
      # options = { height: 20 }.merge!(params)
      # draw_bar_code_39(bar_code_string, Integer(x * pdf_dpi),
      #                  Integer(y * pdf_dpi), (options[:height] * pdf_dpi))
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

    def set_barcode_field_default
    end

    def default_qr_code_magnification
      if self.printer_dpi < 100
        1
      elsif self.printer_dpi >= 1000
        10
      else
        (self.printer_dpi / 100).floor
      end
    end

    def init_prawn(params)
      self.label_width = (params[:width] * pdf_dpi) || 0
      self.label_height = (params[:height] * pdf_dpi) || 0

      return unless label_height > 0 && label_width > 0
      self.pdf = Prawn::Document.new
    end

    # Returns true if a variable is number, false if not
    def numeric?(variable)
      true if Integer(variable) rescue false
    end

    # Draws the PDF rectangle (border)
    def draw_rectangle(x, y, height, width)
      return unless label_height > 0 && label_width > 0
      pdf.stroke_axis
      pdf.stroke do
        pdf.rectangle [x * pdf_dpi, label_width - (y * pdf_dpi) -
                      (width * pdf_dpi)], height,
                      (width * pdf_dpi) * -1
      end
    end

    # Draws the PDF bar code 39
    def draw_bar_code_39(bar_code_string, x, y, height)
      return unless label_height > 0 && label_width > 0
      pdf.bounding_box [x, Integer(label_width) - y - (height * pdf_dpi)],
                       width: (height * pdf_dpi) do
        barcode = Barby::Code39.new(bar_code_string)
        barcode.annotate_pdf(pdf, height: (height * pdf_dpi))
      end
    end
  end
end
