Gem::Specification.new do |s|
  s.name        = "s6x_auth_scaffold_generator"
  s.version     = "0.0.2"
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.2'
  s.summary     = "Really simple authentication scaffold generator for Rails"
  s.email       = "kouji.takao@gmail.com"
  s.homepage    = "http://github.com/takaokouji/s6x_auth_scaffold_generator"
  s.description = "Really simple authentication scaffold generator for Rails"
  s.authors     = ["Kouji Takao (Kody)"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_dependency("rails", "~> 3.0.0")
end
