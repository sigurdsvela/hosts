Gem::Specification.new do |s|
  s.name        = 'hosts-cli'
  s.version     = "0.1.0"
  s.executables << 'hosts'
  s.licenses    = ['licenses']
  s.summary     = "Edit host file on unix system"
  s.description = "An easy CLI to edit the hosts file on unix systems"
  s.authors     = ["Sigurd Berg Svela"]
  s.email       = 'sigurdbergsvela@gmail.com'
  s.files       = `git ls-files -- lib/*`.split("\n")
  s.homepage    = 'https://github.com/sigurdsvela/hosts'
  s.required_ruby_version = '>= 2.0.0'
end