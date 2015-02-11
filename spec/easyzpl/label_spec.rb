require 'spec_helper'

describe 'Testing easyzpl Gem' do

  context 'When creating an empty label' do
    it 'should output a blank label' do
      label = Easyzpl::Label.new(dots: 203)
      expect(label.to_s).to eq('^XA^PQ1^XZ')
    end
  end

  context 'When creating an empty label with defaults set' do
    it 'should output a blank label with defaults set' do
      label = Easyzpl::Label.new(dots: 203)
      label.reset_barcode_fields_to_default 
      expect(label.to_s).to eq('^XA^BY2,3.0,10^PQ1^XZ')
    end
  end

  context 'When creating an empty label with defaults set' do
    it 'should output a blank label with defaults set' do
      label = Easyzpl::Label.new(:dots                         => 203,
                                 :barcode_default_module_width => 10,
                                 :barcode_default_width_ratio  => 4.0,
                                 :barcode_default_height       => 30)
      label.reset_barcode_fields_to_default
      expect(label.to_s).to eq('^XA^BY10,4.0,30^PQ1^XZ')
    end
  end

  context 'When creating a simple label' do
    it 'should output a label with the text "Zebra" and a barcode representation' do
      label = Easyzpl::Label.new(dots: 203)
      label.home_position(30, 30)
      label.draw_border(0, 0, 400, 300)
      label.text_field('ZEBRA', 10, 10)
      label.bar_code_39('ZEBRA', 10, 30)
      expect(label.to_s).to eq('^XA^LH30,30^FO0,0^GB81200,60900,1^FS^FO2030,2030^A0B,20,20^FDZEBRA^FS^FO2030,6090^B3N,Y,20,N,N^FDZEBRA^FS^PQ1^XZ')
    end
  end

  context 'default_qr_code_magnification' do
    let(:mapping) { { 0    => 1,
                      80   => 1,
                      100  => 1,
                      150  => 1,
                      200  => 2,
                      300  => 3,
                      600  => 6,
                      1500 => 10 } }
    it do
      mapping.each do |key,value|
        label = Easyzpl::Label.new(dots: key)
        expect(label.send(:default_qr_code_magnification)).to eql(value)
      end
    end
  end

end
