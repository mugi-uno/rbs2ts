RSpec.describe Rbs2ts::Converter::Declarations::Declarations do
  describe 'Class' do
    it 'convert Class' do
      expect(TestUtil.to_ts(
        <<~RBS
          class Foo
            attr_reader reader: String
            attr_accessor accesor: String
            attr_writer writer: String
            attr_reader record: {
              a: String,
              b: Integer
            }

            def to_s: () -> String
            def self.new: () -> AnObject
            def self?.sqrt: (Numeric) -> Numeric
          end
        RBS
      )).to eq(
        <<~TS
          export namespace Foo {
            export type reader = string;
            export type accesor = string;
            export type record = {
              a: string;
              b: number;
            };
            export type toSReturnType = string;
            export type newReturnType = AnObject;
            export type sqrtReturnType = number;
          };
        TS
        .chomp
      )
    end
  end

  describe 'Alias' do
    it 'convert Alias' do
      expect(TestUtil.to_ts(
        <<~RBS
          type Foo = String
          type Bar = Integer
          type Baz = Bool
          type FooBarBaz = Foo | Bar | Baz
        RBS
      )).to eq(
        <<~TS
          export type Foo = string;
  
          export type Bar = number;
  
          export type Baz = boolean;
  
          export type FooBarBaz = Foo | Bar | Baz;
        TS
        .chomp
      )
    end
  end
end
