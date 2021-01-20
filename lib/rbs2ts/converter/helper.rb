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
      end
    end
  end
end