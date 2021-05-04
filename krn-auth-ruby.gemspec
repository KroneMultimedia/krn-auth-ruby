require_relative 'lib/krn/auth/version'

Gem::Specification.new do |spec|
  spec.name          = "krn-auth-ruby"
  spec.version       = Krn::VERSION
  spec.authors       = ["Helmut Januschka"]
  spec.email         = ["helmut@januschka.com"]

  spec.summary       = %q{Validate KRN JWT Tokens}
  spec.description   = %q{Validate KRN JWT Tokens}
  spec.homepage      = "https://www.krone.at"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/KroneMultimedia/krn-auth-ruby"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_dependency 'jwt'
  spec.add_dependency 'openssl'
  spec.add_dependency 'http_signatures'
  spec.add_development_dependency 'rubocop'


end
