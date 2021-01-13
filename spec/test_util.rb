module TestUtil
  def self.to_ts(rbs)
    file = Tempfile.create('rbs')
    file.write(rbs)
    file.rewind

    loader = ::RBS::EnvironmentLoader.new(core_root: nil)
    loader.add(path: Pathname(file.path))

    env = ::RBS::Environment.from_loader(loader).resolve_type_names

    Rbs2ts::Converter::Declarations::Declarations.new(env.declarations).to_ts
  end
end
