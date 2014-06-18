require 'spec_helper'

describe 'Testing easyzpl Gem' do
  context 'When creating an empty label' do
    it 'should output a blank label' do
      label = Easyzpl::Label.new
      expect(label.to_s).to eq('^XA^PQ1^XZ')
    end
  end

  context 'When creating a simple lable' do
    it 'should output a label with the text "Zebra" and a barcode representation' do
      label = Easyzpl::Label.new
      label.home_position(30, 30)
      label.draw_border(0, 0, 400, 300)
      label.text_field('ZEBRA', 10, 10)
      label.bar_code_39('ZEBRA', 10, 30)
      expect(label.to_s).to eq('^XA^LH30,30^FO0,0^GB400,300,1^FS^FO10,10^AFN,10,10^FDZEBRA^FS^FO10,30^B3N,Y,20,N,N^FDZEBRA^FS^PQ1^XZ')
    end
  end

  context 'When creating a stored template' do
    it 'should output a label template with one variable text field and one variable barcode' do
      label = Easyzpl::LabelTemplate.new('Template1')
      label.home_position(30, 30)
      label.draw_border(0, 0, 400, 300)
      label.variable_text_field(10, 10)
      label.variable_bar_code_39(10, 30)
      expect(label.to_s).to eq('^XA^DFTemplate1^FS^LH30,30^FO0,0^GB400,300,1^FS^FO10,10^AFN,10,10^FN1^FS^FO10,30^B3N,Y,20,N,N^FN2^FS^PQ1^XZ')
    end
  end

  context 'When accessing the stored template' do
    it 'should output a label with only two fields of data that are passed into a saved template' do
      label = Easyzpl::StoredLabel.new('Template1')
      label.add_field('ZEBRA')
      label.add_field('ZEBRA')
      expect(label.to_s).to eq('^XA^XFTemplate1^FS^FN1^FDZEBRA^FS^FN2^FDZEBRA^FS^PQ1^XZ')
    end
  end
end
