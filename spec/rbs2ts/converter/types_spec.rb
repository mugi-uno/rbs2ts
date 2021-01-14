RSpec.describe Rbs2ts::Converter::Types do
  describe 'Bases' do
    it 'convert Bool' do
      expect(TestUtil.to_ts(
        <<~RBS
          type t = bool
        RBS
      )).to eq(
        <<~TS
          type t = boolean;
        TS
        .chomp
      )
    end
  
    it 'convert Void' do
      expect(TestUtil.to_ts(
        <<~RBS
          type t = void
        RBS
      )).to eq(
        <<~TS
          type t = void;
        TS
        .chomp
      )
    end
  
    it 'convert Any' do
      expect(TestUtil.to_ts(
        <<~RBS
          type t1 = any
          type t2 = untyped
        RBS
      )).to eq(
        <<~TS
          type t1 = any;
  
          type t2 = any;
        TS
        .chomp
      )
    end
  
    it 'convert Nil' do
      expect(TestUtil.to_ts(
        <<~RBS
          type t = nil
        RBS
      )).to eq(
        <<~TS
          type t = null;
        TS
        .chomp
      )
    end
  end

  describe 'Record' do
    it 'convert Record' do
      expect(TestUtil.to_ts(
        <<~RBS
          type r = {
            a: String,
            b: Integer,
            r2: {
              aa: String,
              bb: Integer
            }
          }
        RBS
      )).to eq(
        <<~TS
          type r = {
            a: string;
            b: number;
            r2: {
              aa: string;
              bb: number;
            };
          };
        TS
        .chomp
      )
    end
  end

  describe 'Optional' do
    it 'convert Optional' do
      expect(TestUtil.to_ts(
        <<~RBS
          type t = Integer?
        RBS
      )).to eq(
        <<~TS
          type t = number | null | undefined;
        TS
        .chomp
      )
    end
  end

  describe 'Union' do
    it 'convert Union' do
      expect(TestUtil.to_ts(
        <<~RBS
          type t1 = String | Integer | Bool
          type t2 = String | Integer? | Bool
        RBS
      )).to eq(
        <<~TS
          type t1 = string | number | boolean;

          type t2 = string | (number | null | undefined) | boolean;
        TS
        .chomp
      )
    end
  end

  describe 'Intersection' do
    it 'convert Intersection' do
      expect(TestUtil.to_ts(
        <<~RBS
          type t1 = String & Integer & Bool
          type t2 = String & Integer? & Bool
          type t3 = String & Integer | Bool
          type t4 = String & (Integer | Bool)
          type t5 = String & (Integer | Bool)?
        RBS
      )).to eq(
        <<~TS
          type t1 = string & number & boolean;
          
          type t2 = string & (number | null | undefined) & boolean;
          
          type t3 = string & number | boolean;
          
          type t4 = string & (number | boolean);
          
          type t5 = string & (number | boolean | null | undefined);
        TS
        .chomp
      )
    end
  end

  describe 'ClassInstance' do
    it 'convert String' do
      expect(TestUtil.to_ts(
        <<~RBS
          type t = String
        RBS
      )).to eq(
        <<~TS
          type t = string;
        TS
        .chomp
      )
    end

    it 'convert Integer' do
      expect(TestUtil.to_ts(
        <<~RBS
          type t = Integer
        RBS
      )).to eq(
        <<~TS
          type t = number;
        TS
        .chomp
      )
    end

    it 'convert Bool' do
      expect(TestUtil.to_ts(
        <<~RBS
          type t = Bool
        RBS
      )).to eq(
        <<~TS
          type t = boolean;
        TS
        .chomp
      )
    end

    it 'convert Array' do
      expect(TestUtil.to_ts(
        <<~RBS
          type t1 = Array[String]
          type t2 = Array[Integer]
          type t3 = Array[String | Integer]
          type t4 = Array[String & Integer]
          type t5 = Array[String?]
        RBS
      )).to eq(
        <<~TS
          type t1 = string[];

          type t2 = number[];
          
          type t3 = (string | number)[];

          type t4 = (string & number)[];

          type t5 = (string | null | undefined)[];
        TS
        .chomp
      )
    end
  end

  describe 'Literal' do
    it 'convert Literal' do
      expect(TestUtil.to_ts(
        <<~RBS
          type n = 123
          type s = "hello world"
          type t = true
          type f = false
        RBS
      )).to eq(
        <<~TS
          type n = 123;

          type s = "hello world";

          type t = true;
          
          type f = false;
        TS
        .chomp
      )
    end
  end
end
