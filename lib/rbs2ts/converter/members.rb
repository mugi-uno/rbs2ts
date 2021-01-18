module Rbs2ts
  module Converter
    module Members
      class Base
        def initialize(member)
          @member = member
        end
    
        def to_ts
          ''
        end

        def name
          CaseTransform.camel_lower(member.name.to_s.gsub(/:/, ''))
        end
    
        private
    
        attr_reader :member
      end

      class AttrReader < Base
        def to_ts
          "readonly #{name}: #{Converter::Types::Resolver.to_ts(member.type)};"
        end
      end

      class AttrWriter < Base
        def to_ts
          "#{name}: #{Converter::Types::Resolver.to_ts(member.type)};"
        end
      end

      class AttrAccessor < Base
        def to_ts
          "#{name}: #{Converter::Types::Resolver.to_ts(member.type)};"
        end
      end

      class MethodDefinition < Base
        def initialize(member)
          super
          @args_count = 0
        end

        def to_ts
          "#{name}(#{args_to_ts}): #{return_type_to_ts};"
        end

        def args_to_ts
          [
            *required_positional_to_ts,
            *optional_positional_to_ts,
            *rest_positionals_to_ts,
            *trailing_positionals_to_ts,
            *keyword_args_to_ts
          ].join(", ")
        end

        def arg_name(arg)
          name = arg.name.nil? ? next_default_arg_name : arg.name.to_s
          CaseTransform.camel_lower(name)
        end

        def next_default_arg_name
          @args_count = @args_count + 1
          "arg#{@args_count.to_s}"
        end

        def required_positional_to_ts
          method_type.required_positionals.map {|arg|
            "#{arg_name(arg)}: #{Converter::Types::Resolver.to_ts(arg.type)}"
          }
        end

        def optional_positional_to_ts
          method_type.optional_positionals.map {|arg|
            "#{arg_name(arg)}?: #{Converter::Types::Resolver.to_ts(arg.type)}"
          }
        end

        def rest_positionals_to_ts
          arg = method_type.rest_positionals
          
          return [] if arg.nil?

          has_rest_after_arguments ?
            ["#{arg_name(arg)}#{optional_ts_code}: #{Converter::Types::Resolver.to_ts(arg.type)}[]"] :
            ["...#{arg_name(arg)}#{optional_ts_code}: #{Converter::Types::Resolver.to_ts(arg.type)}[]"]
        end

        def trailing_positionals_to_ts
          method_type.trailing_positionals.map {|arg|
            "#{arg_name(arg)}#{optional_ts_code}: #{Converter::Types::Resolver.to_ts(arg.type)}"
          }
        end

        def keyword_args_to_ts
          required_keywords_ts = method_type.required_keywords.map {|key, value|
            "#{CaseTransform.camel_lower(key.to_s)}: #{Converter::Types::Resolver.to_ts(value.type)}"
          }
          optional_keywords_ts = method_type.optional_keywords.map {|key, value|
            "#{CaseTransform.camel_lower(key.to_s)}?: #{Converter::Types::Resolver.to_ts(value.type)}"
          }
          rest_keywords_ts = method_type.rest_keywords.nil? ? [] : ["[key: string]: unknown;"]

          ts_array = [
            *required_keywords_ts,
            *optional_keywords_ts,
            *rest_keywords_ts
          ]

          return [] if ts_array.empty?

          ts = ts_array.join(', ')

          ["#{next_default_arg_name}#{optional_ts_code}: { #{ts} }"]
        end

        def method_type
          member.types.first.type
        end

        def return_type_to_ts
          Converter::Types::Resolver.to_ts(method_type.return_type)
        end

        def optional_ts_code
          method_type.optional_positionals.present? ? '?' : ''
        end

        def has_rest_after_arguments
          method_type.trailing_positionals.present? || 
          method_type.required_keywords.present? ||
          method_type.optional_keywords.present?
        end
      end
    end
  end
end
