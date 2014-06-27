# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'correios/frete/version'

Gem::Specification.new do |gem|
  gem.name        = "correios-frete"
  gem.version     = Correios::Frete::VERSION
  gem.authors     = ["Prodis a.k.a. Fernando Hamasaki de Amorim"]
  gem.email       = ["prodis@gmail.com"]
  gem.summary     = "Calculo de frete dos Correios."
  gem.description = "Calculo de frete utilizando o Web Service dos Correios (http://www.correios.com.br/webservices).\nOs servicos de frete suportados sao PAC, SEDEX, SEDEX a Cobrar, SEDEX 10, SEDEX Hoje e e-SEDEX."
  gem.homepage    = "http://prodis.blog.br/correios-frete-gem-para-calculo-de-frete-dos-correios"
  gem.licenses    = ["MIT"]

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.platform              = Gem::Platform::RUBY
  gem.required_ruby_version = Gem::Requirement.new(">= 1.8.7")

  gem.add_dependency "log-me",      "~> 0.0.7"
  gem.add_dependency "nokogiri",    "~> 1.6.2"
  gem.add_dependency "sax-machine", "~> 0.2.1"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec",   "~> 3.0.0"
  gem.add_development_dependency "webmock", "~> 1.18.0"
end
