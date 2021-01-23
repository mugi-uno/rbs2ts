# Rbs2ts

A RubyGem that converts Ruby RBS to TypeScript definitions.

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

type IntersectionType = String & Integer & Bool
type UnionType = String | Integer | Bool

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
  @val: String
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

  def to_tuple: () -> [{ s: String, f: Float }?]
  def required_positional: (String) -> void
  def required_positional_name: (String str) -> void
  def optional_positional: (?String) -> void
  def optional_positional_name: (?String? str) -> void
  def rest_positional: (*String) -> void
  def rest_positional_name: (*String str) -> void
  def rest_positional_with_trailing: (*String, Integer) -> void
  def rest_positional_name_with_trailing: (*String str, Integer trailing) -> void
  def required_keyword: (str: String) -> void
  def optional_keyword: (?str: String?) -> void
  def rest_keywords: (**String) -> void
  def rest_keywords_name: (**String rest) -> void

  def all_arguments: (
    String required_positional,
    ?Integer? optional_positional,
    *String rest_positionals_s,
    Integer trailing_positional_s,
    required_keyword: String,
    ?optional_keyword: Integer?,
    **String rest_keywords
  ) -> [{ s: String, f: Float }?]
end

module Module
  @val: String
  type AliasType = String

  def func: (String, Integer) -> { str: String, int: Integer }

  class NestedClass
    attr_accessor a: AliasType
  end
end

interface _Interface
  def func: (String, Integer) -> { str: String, int: Integer }
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

export declare class Klass {
  val: string;
  a: string;
  readonly b: number;
  c: boolean;
  readonly r: {
    d: string;
    e: {
      f: string;
      g: string | null | undefined;
    } | null | undefined;
  };
  toTuple(): [({
    s: string;
    f: number;
  } | null | undefined)];
  requiredPositional(arg1: string): void;
  requiredPositionalName(str: string): void;
  optionalPositional(arg1?: string): void;
  optionalPositionalName(str?: string | null | undefined): void;
  restPositional(...arg1: string[]): void;
  restPositionalName(...str: string[]): void;
  restPositionalWithTrailing(arg1: string[], arg2: number): void;
  restPositionalNameWithTrailing(str: string[], trailing: number): void;
  requiredKeyword(arg1: { str: string }): void;
  optionalKeyword(arg1: { str?: string | null | undefined }): void;
  restKeywords(arg1: { [key: string]: unknown; }): void;
  restKeywordsName(arg1: { [key: string]: unknown; }): void;
  allArguments(requiredPositional: string, optionalPositional?: number | null | undefined, restPositionalsS?: string[], trailingPositionalS?: number, arg1?: { requiredKeyword: string, optionalKeyword?: number | null | undefined, [key: string]: unknown; }): [({
    s: string;
    f: number;
  } | null | undefined)];
};

export namespace Module {
  export declare let val: string;
  export type AliasType = string;
  export declare function func(arg1: string, arg2: number): {
    str: string;
    int: number;
  };
  export declare class NestedClass {
    a: AliasType;
  };
};

export interface Interface {
  func(arg1: string, arg2: number): {
    str: string;
    int: number;
  };
};
```
