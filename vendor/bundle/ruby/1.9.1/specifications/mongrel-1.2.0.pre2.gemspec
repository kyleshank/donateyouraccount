# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mongrel}
  s.version = "1.2.0.pre2"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Zed A. Shaw"]
  s.date = %q{2010-03-17}
  s.default_executable = %q{mongrel_rails}
  s.description = %q{Mongrel is a small library that provides a very fast HTTP 1.1 server for Ruby web applications.  It is not particular to any framework, and is intended to be just enough to get a web application running behind a more complete and robust web server.

What makes Mongrel so fast is the careful use of an Ragel extension to provide fast, accurate HTTP 1.1 protocol parsing. This makes the server scream without too many portability issues.

See http://mongrel.rubyforge.org for more information.}
  s.email = ["mongrel-users@rubyforge.org"]
  s.executables = ["mongrel_rails"]
  s.extensions = ["ext/http11/extconf.rb"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt", "LICENSE"]
  s.files = ["COPYING", "History.txt", "LICENSE", "Manifest.txt", "README.txt", "Rakefile", "TODO", "bin/mongrel_rails", "examples/builder.rb", "examples/camping/README", "examples/camping/blog.rb", "examples/camping/tepee.rb", "examples/httpd.conf", "examples/mime.yaml", "examples/mongrel.conf", "examples/monitrc", "examples/random_thrash.rb", "examples/simpletest.rb", "examples/webrick_compare.rb", "ext/http11/ext_help.h", "ext/http11/extconf.rb", "ext/http11/http11.c", "ext/http11/http11_parser.c", "ext/http11/http11_parser.h", "ext/http11/http11_parser.java.rl", "ext/http11/http11_parser.rl", "ext/http11/http11_parser_common.rl", "ext/http11/Http11Service.java", "ext/http11/org/jruby/mongrel/Http11.java", "ext/http11/org/jruby/mongrel/Http11Parser.java", "lib/mongrel.rb", "lib/mongrel/camping.rb", "lib/mongrel/cgi.rb", "lib/mongrel/command.rb", "lib/mongrel/configurator.rb", "lib/mongrel/const.rb", "lib/mongrel/debug.rb", "lib/mongrel/gems.rb", "lib/mongrel/handlers.rb", "lib/mongrel/header_out.rb", "lib/mongrel/http_request.rb", "lib/mongrel/http_response.rb", "lib/mongrel/init.rb", "lib/mongrel/mime_types.yml", "lib/mongrel/rails.rb", "lib/mongrel/stats.rb", "lib/mongrel/tcphack.rb", "lib/mongrel/uri_classifier.rb", "setup.rb", "tasks/gem.rake", "tasks/native.rake", "tasks/ragel.rake", "test/mime.yaml", "test/mongrel.conf", "test/test_cgi_wrapper.rb", "test/test_command.rb", "test/test_conditional.rb", "test/test_configurator.rb", "test/test_debug.rb", "test/test_handlers.rb", "test/test_http11.rb", "test/test_redirect_handler.rb", "test/test_request_progress.rb", "test/test_response.rb", "test/test_stats.rb", "test/test_uriclassifier.rb", "test/test_ws.rb", "test/testhelp.rb", "tools/trickletest.rb"]
  s.homepage = %q{http://mongrel.rubyforge.org/}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib", "ext"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = %q{mongrel}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Mongrel is a small library that provides a very fast HTTP 1.1 server for Ruby web applications}
  s.test_files = ["test/test_http11.rb", "test/test_uriclassifier.rb", "test/test_response.rb", "test/test_configurator.rb", "test/test_conditional.rb", "test/test_handlers.rb", "test/test_redirect_handler.rb", "test/test_debug.rb", "test/test_request_progress.rb", "test/test_stats.rb", "test/test_command.rb", "test/test_ws.rb", "test/test_cgi_wrapper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<gem_plugin>, ["~> 0.2.3"])
      s.add_runtime_dependency(%q<daemons>, ["~> 1.0.10"])
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.3"])
      s.add_development_dependency(%q<gemcutter>, [">= 0.3.0"])
      s.add_development_dependency(%q<rake-compiler>, ["~> 0.7.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.5.0"])
    else
      s.add_dependency(%q<gem_plugin>, ["~> 0.2.3"])
      s.add_dependency(%q<daemons>, ["~> 1.0.10"])
      s.add_dependency(%q<rubyforge>, [">= 2.0.3"])
      s.add_dependency(%q<gemcutter>, [">= 0.3.0"])
      s.add_dependency(%q<rake-compiler>, ["~> 0.7.0"])
      s.add_dependency(%q<hoe>, [">= 2.5.0"])
    end
  else
    s.add_dependency(%q<gem_plugin>, ["~> 0.2.3"])
    s.add_dependency(%q<daemons>, ["~> 1.0.10"])
    s.add_dependency(%q<rubyforge>, [">= 2.0.3"])
    s.add_dependency(%q<gemcutter>, [">= 0.3.0"])
    s.add_dependency(%q<rake-compiler>, ["~> 0.7.0"])
    s.add_dependency(%q<hoe>, [">= 2.5.0"])
  end
end
