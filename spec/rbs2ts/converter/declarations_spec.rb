RSpec.describe Rbs2ts::Converter::Declarations::Declarations do
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
