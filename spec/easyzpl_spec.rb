require 'spec_helper'

describe 'Testing easyzpl Gem' do
  context 'When creating an empty label' do
    it 'should output a blank label' do
      label = Easyzpl::Label.new
      expect(label.to_s).to eq('^XA^PQ1^XZ')
    end
  end

  context 'When creating a simple lable' do
    it 'should output a label with the text "Zebra" and a barcode representation.' do
      label = Easyzpl::Label.new
      label.home_position(30, 30)
      label.draw_border(0, 0, 400, 300)
      label.text_field('ZEBRA', 10, 10)
      label.bar_code_39('ZEBRA', 10, 30)
      expect(label.to_s).to eq('^XA^LH30,30^FO0,0^GB400,300,1^FS^FO10,10^AFN,10,10^FDZEBRA^FS^FO10,30^B3N,Y,20,N,N^FDZEBRA^FS^PQ1^XZ')
    end
  end
end
