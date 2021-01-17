# Rbs2ts

Convert RBS to TypeScript type definition.

## Installation

```ruby
gem install rbs2ts
```

## Usage

```
rbs2ts convert type.rbs
```

## Example

from RBS

```
type TypeofInteger = Integer
type TypeofFloat = Float
type TypeofNumeric = Numeric
type TypeofString = String
type TypeofBool = Bool
type TypeofVoid = void
type TypeofUntyped = untyped
type TypeofNil = nil

type IntegerLiteral = 123
type StringLiteral = 'abc'
type TrueLiteral = true
type FalseLiteral = false

type UnionType = String & Integer & Bool
type IntersectionType = String | Integer | Bool

type ArrayType = Array[String]

type TupleType = [ ]
type TupleEmptyType = [String, Integer]

type OptionalType = String?

type RecordType = {
  s: String,
  next: {
    i: Integer,
    f: Float
  }?
}

class Klass
  attr_accessor a: String
  attr_reader b: Integer
  attr_writer c: Bool

  attr_reader r: {
    d: String,
    e: {
      f: String,
      g: String?
    }?
  }

  def to_s: () -> String
  def tuple: () -> [{ s: String, f: Float }?]
end
```

to TypeScript

```typescript
export type TypeofInteger = number;

export type TypeofFloat = number;

export type TypeofNumeric = number;

export type TypeofString = string;

export type TypeofBool = boolean;

export type TypeofVoid = void;

export type TypeofUntyped = any;

export type TypeofNil = null;

export type IntegerLiteral = 123;

export type StringLiteral = "abc";

export type TrueLiteral = true;

export type FalseLiteral = false;

export type IntersectionType = string & number & boolean;

export type UnionType = string | number | boolean;

export type ArrayType = string[];

export type TupleType = [];

export type TupleEmptyType = [string, number];

export type OptionalType = string | null | undefined;

export type RecordType = {
  s: string;
  next: {
    i: number;
    f: number;
  } | null | undefined;
};

export namespace Klass {
  export type a = string;
  export type b = number;
  export type r = {
    d: string;
    e: {
      f: string;
      g: string | null | undefined;
    } | null | undefined;
  };
  export type toSReturnType = string;
  export type tupleReturnType = [({
    s: string;
    f: number;
  } | null | undefined)];
};
```

---

## ToDo

- [x] Literal type
- [ ] Interface type
- [x] Literal type
- [x] Tuple Type
- [x] Base Types
- [x] Method Type (Argument Types and Return Types)
- [x] Class declaration
- [ ] Module declaration
- [ ] Interface declaration
