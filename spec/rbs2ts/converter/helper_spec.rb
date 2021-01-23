RSpec.describe Rbs2ts::Converter::Helper do
  describe 'indent' do
    it 'get indented text' do
      expect(Rbs2ts::Converter::Helper.indent("aaa\nbbb\nccc")).to eq("  aaa\n  bbb\n  ccc")
    end
  end

  describe 'convert_name' do
    it 'remove some charactors' do
      expect(Rbs2ts::Converter::Helper.convert_name('Foo::Bar')).to eq('FooBar')
      expect(Rbs2ts::Converter::Helper.convert_name('@val')).to eq('val')
    end

    it 'convert snakecase to camelcase' do
      expect(Rbs2ts::Converter::Helper.convert_name('foo_bar_baz')).to eq('fooBarBaz')
      expect(Rbs2ts::Converter::Helper.convert_name('FooBarBaz')).to eq('FooBarBaz')
    end

    it 'avoid ts reserved word' do
      expect(Rbs2ts::Converter::Helper.convert_name('const')).to eq('constType')
      expect(Rbs2ts::Converter::Helper.convert_name('void')).to eq('voidType')
    end
  end
end