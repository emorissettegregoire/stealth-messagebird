$LOAD_PATH.push File.expand_path('../lib', __FILE__)

version = File.read(File.join(File.dirname(__FILE__), 'VERSION')).strip

Gem::Specification.new do |s|
  s.name = 'stealth-messagebird'
  s.summary = 'Stealth MessageBird Whatsapp driver'
  s.description = 'MessageBird Whatsapp driver for Stealth.'
  s.homepage = 'https://github.com/emorissettegregoire/stealth-messagebird'
  s.licenses = ['MIT']
  s.version = version
  s.author = 'Emilie Morissette'
  s.email = 'emorissettegregoire@gmail.com'

  s.add_dependency 'stealth', '>= 2.0.0.beta'
  s.add_dependency 'messagebird-rest', '1.4.2'

  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'rspec_junit_formatter', '~> 0.3'
  s.add_development_dependency 'rack-test', '~> 1.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
