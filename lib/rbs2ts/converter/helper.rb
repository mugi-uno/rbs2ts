module Rbs2ts
  module Converter
    module Helper
      class << self
        INDENT = '  '

        def indent(text, level = 1)
          text
            .split("\n")
            .map {|t| "#{INDENT * level}#{t}" }
            .join("\n")
        end

        TS_RESERVED_WORDS = %w(
          any as boolean break case catch class const constructor continue debugger declare
          default delete do else enum export extends false finally for from function get if
          implements import in instanceof interface let module new null number of package
          private protected public require return set static string super switch symbol
          this throw true try type typeof var void while with yield
        )

        def convert_name(org_name)
          name = org_name.to_s.gsub(/[:@]/, '')

          unless name =~ /^[A-Z]/
            name = CaseTransform.camel_lower(name)
          end

          if TS_RESERVED_WORDS.include?(name)
            "#{name}Type"
          else
            name
          end
        end
      end
    end
  end
end