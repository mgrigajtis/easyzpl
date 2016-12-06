require 'spec_helper'

describe 'Testing easyzpl Gem' do

  context 'When accessing the stored template' do
    it 'should output a label with only two fields of data that are passed into a saved template' do
      label = Easyzpl::StoredLabel.new('Template1')
      label.add_field('ZEBRA')
      label.add_field('ZEBRA')
      expect(label.to_s).to eq('^XA^XFTemplate1^FS^FN1^FDZEBRA^FS^FN2^FDZEBRA^FS^PQ1^XZ')
    end
  end

end
