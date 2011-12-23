# encoding: UTF-8
require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require './lib/correios/frete/version'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "correios-frete"
  gem.homepage = "http://prodis.blog.br/2011/07/03/gem-para-calculo-de-frete-dos-correios"
  gem.license = "MIT"
  gem.summary = %Q{Cálculo de frete dos Correios.}
  gem.description = %Q{Calculo de frete utilizando o Web Service dos Correios (http://www.correios.com.br/webservices). Servicos de frete suportados sao PAC, SEDEX, SEDEX 10, SEDEX Hoje e e-SEDEX (necessario informar codigo de empresa e senha).}
  gem.email = "prodis@gmail.com"
  gem.authors = ["Prodis a.k.a. Fernando Hamasaki"]
  gem.version = Correios::Frete::Version::VERSION
  gem.required_ruby_version = ">= 1.8.7"
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "correios-frete #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('CHANGELOG*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
