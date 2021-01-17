module Rbs2ts
  module Converter
    module Declarations
      class Declarations
        def initialize(decls)
          @decls = decls
        end
    
        def to_ts
          decls_ts = @decls.map do |d|
            case d
            when ::RBS::AST::Declarations::Class then
              Converter::Declarations::Class.new(d).to_ts
            when ::RBS::AST::Declarations::Alias then
              Converter::Declarations::Alias.new(d).to_ts
            end
          end

          decls_ts.join("\n\n")
        end
      end
  
      # reference: RBS::AST::Declarations
      class Base
        def initialize(declaration)
          @declaration = declaration
        end
    
        def to_ts
          ''
        end

        def name
          declaration.name.to_s.gsub(/:/, '')
        end
    
        private
    
        attr_reader :declaration
      end
  
      class Class < Base
        INDENT = '  '
        @@nest = 0

        def to_ts
          @@nest = @@nest + 1

          members_ts = declaration.members.map {|member|
            ts = member_to_ts(member)
            ts
              .split("\n")
              .map {|t| "#{INDENT * @@nest}#{t}" }
              .join("\n")
          }.join("\n")

          @@nest = @@nest - 1

          <<~TS
            export namespace #{name} {
            #{members_ts}
            };
          TS
          .chomp
        end

        def member_to_ts(member)
          case member
          when ::RBS::AST::Members::AttrReader, ::RBS::AST::Members::AttrAccessor then
            "export type #{member.name} = #{Converter::Types::Resolver.to_ts(member.type)};"
          else
            ''
          end
        end
      end
  
      class Module < Base
      end
  
      class Interface < Base
      end
  
      class Alias < Base
        def to_ts
          "export type #{name} = #{Converter::Types::Resolver.to_ts(declaration.type)};"
        end
      end
  
      class Constant < Base
      end
  
      class Global < Base
      end
    end
  end
end
