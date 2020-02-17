Gem::Specification.new do |gem|
  gem.name        = 'no-regrets'
  gem.version     = '0.0.1'
  gem.licenses    = ['MIT']
  gem.summary     = "Visual regression testing for Capybara specs"
  gem.description = ""
  gem.authors     = ["Victor Mours"]
  gem.email       = 'victor@ahaoho.io'
  gem.files       = Dir["lib/**/*.rb"]
  gem.executables = []

  gem.add_runtime_dependency "capybara"
  gem.add_runtime_dependency "launchy"
  gem.add_runtime_dependency "chunky_png"
end

