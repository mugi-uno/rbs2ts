RSpec.describe Rbs2ts::Converter::Declarations::Declarations do
  describe 'Class' do
    it 'convert Class' do
      expect(TestUtil.to_ts(
        <<~RBS
          class Foo
            @val: String

            attr_reader reader: String
            attr_accessor accesor: String
            attr_writer writer: String
            attr_reader record: {
              a: String,
              b: Integer
            }

            def required_positional: (String) -> void
            def required_positional_name: (String str) -> void
            def optional_positional: (?String) -> void
            def optional_positional_name: (?String? str) -> void
            def rest_positional: (*String, Integer) -> void
            def rest_positional_name: (*String str, Integer trailing) -> void
            def rest_positional_only: (*String) -> void
            def required_keyword: (str: String) -> void
            def optional_keyword: (?str: String?) -> void
            def rest_keywords: (**String) -> void
            def rest_keywords_name: (**String rest) -> void
          end
        RBS
      )).to eq(
        <<~TS
          export declare class Foo {
            val: string;
            readonly reader: string;
            accesor: string;
            writer: string;
            readonly record: {
              a: string;
              b: number;
            };
            requiredPositional(arg1: string): void;
            requiredPositionalName(str: string): void;
            optionalPositional(arg1?: string): void;
            optionalPositionalName(str?: string | null | undefined): void;
            restPositional(arg1: string[], arg2: number): void;
            restPositionalName(str: string[], trailing: number): void;
            restPositionalOnly(...arg1: string[]): void;
            requiredKeyword(arg1: { str: string }): void;
            optionalKeyword(arg1: { str?: string | null | undefined }): void;
            restKeywords(arg1: { [key: string]: unknown; }): void;
            restKeywordsName(arg1: { [key: string]: unknown; }): void;
          };
        TS
        .chomp
      )
    end
  end

  describe 'Module' do
    it 'convert Module' do
      expect(TestUtil.to_ts(
        <<~RBS
          module Foo
            @val: String
            def required_positional: (String) -> void
            def required_positional_name: (String str) -> void
            def optional_positional: (?String) -> void
            def optional_positional_name: (?String? str) -> void
            def rest_positional: (*String, Integer) -> void
            def rest_positional_name: (*String str, Integer trailing) -> void
            def rest_positional_only: (*String) -> void
            def required_keyword: (str: String) -> void
            def optional_keyword: (?str: String?) -> void
            def rest_keywords: (**String) -> void
            def rest_keywords_name: (**String rest) -> void

            type AliasType = String

            class Bar
              attr_reader reader: AliasType
            end

            module NestedModule
              @nested_module_val: String

              class Baz
                @nested_class_val: String

                attr_reader writer: AliasType
              end
            end
          end
        RBS
      )).to eq(
        <<~TS
          export namespace Foo {
            export declare let val: string;
            export declare function requiredPositional(arg1: string): void;
            export declare function requiredPositionalName(str: string): void;
            export declare function optionalPositional(arg1?: string): void;
            export declare function optionalPositionalName(str?: string | null | undefined): void;
            export declare function restPositional(arg1: string[], arg2: number): void;
            export declare function restPositionalName(str: string[], trailing: number): void;
            export declare function restPositionalOnly(...arg1: string[]): void;
            export declare function requiredKeyword(arg1: { str: string }): void;
            export declare function optionalKeyword(arg1: { str?: string | null | undefined }): void;
            export declare function restKeywords(arg1: { [key: string]: unknown; }): void;
            export declare function restKeywordsName(arg1: { [key: string]: unknown; }): void;
            export type AliasType = string;
            export declare class Bar {
              readonly reader: AliasType;
            };
            export namespace NestedModule {
              export declare let nestedModuleVal: string;
              export declare class Baz {
                nestedClassVal: string;
                readonly writer: AliasType;
              };
            };
          };
        TS
        .chomp
      )
    end
  end

  describe 'Interface' do
    it 'convert Interface' do
      expect(TestUtil.to_ts(
        <<~RBS
          interface _Foo
            def required_positional: (String) -> void
            def required_positional_name: (String str) -> void
            def optional_positional: (?String) -> void
            def optional_positional_name: (?String? str) -> void
            def rest_positional: (*String, Integer) -> void
            def rest_positional_name: (*String str, Integer trailing) -> void
            def rest_positional_only: (*String) -> void
            def required_keyword: (str: String) -> void
            def optional_keyword: (?str: String?) -> void
            def rest_keywords: (**String) -> void
            def rest_keywords_name: (**String rest) -> void
          end
        RBS
      )).to eq(
        <<~TS
          export interface Foo {
            requiredPositional(arg1: string): void;
            requiredPositionalName(str: string): void;
            optionalPositional(arg1?: string): void;
            optionalPositionalName(str?: string | null | undefined): void;
            restPositional(arg1: string[], arg2: number): void;
            restPositionalName(str: string[], trailing: number): void;
            restPositionalOnly(...arg1: string[]): void;
            requiredKeyword(arg1: { str: string }): void;
            optionalKeyword(arg1: { str?: string | null | undefined }): void;
            restKeywords(arg1: { [key: string]: unknown; }): void;
            restKeywordsName(arg1: { [key: string]: unknown; }): void;
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
