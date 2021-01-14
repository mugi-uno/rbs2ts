module Rbs2ts
  module Converter
    module Types
      class ConverterBase
        def initialize(type)
          @type = type
        end
    
        def to_ts
          raise 'not implemented'
        end
    
        private
    
        attr_reader :type
      end

      class Fallback < ConverterBase
        def to_ts
          'unknown'
        end
      end

      class BasesBool < ConverterBase
        def to_ts
          'boolean'
        end
      end

      class BasesVoid < ConverterBase
        def to_ts
          'void'
        end
      end

      class BasesAny < ConverterBase
        def to_ts
          'any'
        end
      end

      class BasesNil < ConverterBase
        def to_ts
          'null'
        end
      end

      class Record < ConverterBase
        INDENT = '  '
        @@nest = 0

        def to_ts
          @@nest = @@nest + 1

          indent = INDENT * @@nest
          field_lines = type.fields.map { |name, type|
            "#{indent}#{CaseTransform.camel_lower(name.to_s)}: #{Types::Resolver.to_ts(type)};"
          }

          @@nest = @@nest - 1

          return '{}' if field_lines.empty?

          field_ts = field_lines.join("\n")

          ts = <<~CODE
          {
          #{field_ts}
          #{INDENT * @@nest}}
          CODE
    
          ts.chomp
        end
      end

      class Literal < ConverterBase
        def to_ts
          case type.literal
          when ::String then
            "\"#{type.literal}\""
          when ::Integer, ::TrueClass, ::FalseClass then
            "#{type.literal}"
          else
            'unknown'
          end
        end
      end

      class Optional < ConverterBase
        def to_ts
          "#{Types::Resolver.to_ts(type.type)} | null | undefined"
        end
      end

      class Union < ConverterBase
        def to_ts
          types_ts = type.types.map { |type|
            ts = Types::Resolver.to_ts(type)
            type.is_a?(::RBS::Types::Optional) ? "(#{ts})" : ts
          }

          types_ts.join(' | ')
        end
      end

      class Intersection < ConverterBase
        def to_ts
          types_ts = type.types.map { |type|
            ts = Types::Resolver.to_ts(type)
            type.is_a?(::RBS::Types::Union) || type.is_a?(::RBS::Types::Optional) ? "(#{ts})" : ts
          }

          types_ts.join(' & ')
        end
      end

      class ClassInstance < ConverterBase
        def to_ts
          case type.name.to_s
          when 'Array' then
            Types::Array.new(type).to_ts
          when 'String' then
            Types::String.new(type).to_ts
          when 'Integer' then
            Types::Integer.new(type).to_ts
          when 'Bool' then
            Types::Bool.new(type).to_ts
          else
            type.name.to_s.gsub(/:/, '')
          end
        end
      end

      class Array < ConverterBase
        def to_ts
          array_type = type.args.first
          array_type_ts = Types::Resolver.to_ts(array_type)

          if array_type.is_a?(::RBS::Types::Union) ||
            array_type.is_a?(::RBS::Types::Intersection) ||
            array_type.is_a?(::RBS::Types::Optional)
            "(#{array_type_ts})[]"
          else
            "#{array_type_ts}[]"
          end

        end
      end  

      class String < ConverterBase
        def to_ts
          'string'
        end
      end  

      class Integer < ConverterBase
        def to_ts
          'number'
        end
      end

      class Bool < ConverterBase
        def to_ts
          'boolean'
        end
      end

      class Resolver
        def self.to_ts(type)
          Resolver.resolve(type).new(type).to_ts
        end

        def self.resolve(type)
          case type
          when ::RBS::Types::Bases::Bool then
            Types::BasesBool
          when ::RBS::Types::Bases::Void then
            Types::BasesVoid
          when ::RBS::Types::Bases::Any then
            Types::BasesAny
          when ::RBS::Types::Bases::Nil then
            Types::BasesNil
          when ::RBS::Types::ClassInstance then
            Types::ClassInstance
          when ::RBS::Types::Literal then
            Types::Literal
          when ::RBS::Types::Optional then
            Types::Optional
          when ::RBS::Types::Union then
            Types::Union
          when ::RBS::Types::Intersection then
            Types::Intersection
          when ::RBS::Types::Record then
            Types::Record
          else
            Types::Fallback
          end
        end
      end
    end
  end
end
