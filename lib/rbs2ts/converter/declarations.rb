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
            when ::RBS::AST::Declarations::Module then
              Converter::Declarations::Module.new(d).to_ts
            when ::RBS::AST::Declarations::Interface then
              Converter::Declarations::Interface.new(d).to_ts
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
          declaration.name.name.to_s.gsub(/:/, '')
        end
    
        private
    
        attr_reader :declaration
      end

      class Class < Base
        def to_ts
          members_ts = declaration.members.map {|member|
            member_to_ts(member)
          }.reject(&:empty?).join("\n")

          <<~TS
            export declare class #{name} {
            #{Helper.indent(members_ts)}
            };
          TS
          .chomp
        end

        def member_to_ts(member)
          case member
          when ::RBS::AST::Members::InstanceVariable then
            Converter::Members::InstanceVariable.new(member).to_ts
          when ::RBS::AST::Members::AttrReader then
            Converter::Members::AttrReader.new(member).to_ts
          when ::RBS::AST::Members::AttrWriter then
            Converter::Members::AttrWriter.new(member).to_ts
          when ::RBS::AST::Members::AttrAccessor then
            Converter::Members::AttrAccessor.new(member).to_ts
          when ::RBS::AST::Members::MethodDefinition
            Converter::Members::MethodDefinition.new(member).to_ts
          else
            ''
          end
        end
      end
  
      class Module < Base
        def to_ts
          members_ts = declaration.members.map {|member|
            member_to_ts(member)
          }.reject(&:empty?).join("\n")

          <<~TS
            export namespace #{name} {
            #{Helper.indent(members_ts)}
            };
          TS
          .chomp
        end

        def member_to_ts(member)
          case member
          when ::RBS::AST::Declarations::Class then
            Converter::Declarations::Class.new(member).to_ts
          when ::RBS::AST::Declarations::Module then
            Converter::Declarations::Module.new(member).to_ts
          when ::RBS::AST::Declarations::Interface then
            Converter::Declarations::Interface.new(member).to_ts
          when ::RBS::AST::Declarations::Alias then
            Converter::Declarations::Alias.new(member).to_ts
          when ::RBS::AST::Members::InstanceVariable
            ts = Converter::Members::InstanceVariable.new(member).to_ts
            "export declare let #{ts}"
          when ::RBS::AST::Members::MethodDefinition
            ts = Converter::Members::MethodDefinition.new(member).to_ts
            "export declare function #{ts}"
          else
            ''
          end
        end
      end
  
      class Interface < Base
        def to_ts
          members_ts = declaration.members.map {|member|
            member_to_ts(member)
          }.reject(&:empty?).join("\n")

          <<~TS
            export interface #{name.gsub(/_/, '')} {
            #{Helper.indent(members_ts)}
            };
          TS
          .chomp
        end

        def member_to_ts(member)
          case member
          when ::RBS::AST::Members::MethodDefinition
            Converter::Members::MethodDefinition.new(member).to_ts
          else
            ''
          end
        end
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
