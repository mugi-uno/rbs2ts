
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rbs2ts/version"

Gem::Specification.new do |spec|
  spec.name          = "rbs2ts"
  spec.version       = Rbs2ts::VERSION
  spec.authors       = ["mugi-uno"]
  spec.email         = ["mugi.uno@gmail.com"]

  spec.summary       = "Convert rbs to typescript"
  spec.homepage      = "https://github.com/mugi-uno/rbs2ts"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rbs", "~> 1.0.0"
  spec.add_dependency "thor"
  spec.add_dependency "case_transform"

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
