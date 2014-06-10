require 'spec_helper'

describe 'Testing easyzpl Gem' do
  context 'When creating an empty label' do
    it 'should output a blank label' do
      label = Easyzpl::Label.new
      label.to_s.should eq('^XA^PQ1^XZ')
    end
  end
end
