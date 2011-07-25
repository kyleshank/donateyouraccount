# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mysql2}
  s.version = "0.2.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Lopez"]
  s.date = %q{2011-06-17}
  s.email = %q{seniorlopez@gmail.com}
  s.extensions = ["ext/mysql2/extconf.rb"]
  s.files = [".gitignore", ".rspec", ".rvmrc", "CHANGELOG.md", "Gemfile", "MIT-LICENSE", "README.md", "Rakefile", "benchmark/active_record.rb", "benchmark/active_record_threaded.rb", "benchmark/allocations.rb", "benchmark/escape.rb", "benchmark/query_with_mysql_casting.rb", "benchmark/query_without_mysql_casting.rb", "benchmark/sequel.rb", "benchmark/setup_db.rb", "benchmark/threaded.rb", "examples/eventmachine.rb", "examples/threaded.rb", "ext/mysql2/client.c", "ext/mysql2/client.h", "ext/mysql2/extconf.rb", "ext/mysql2/mysql2_ext.c", "ext/mysql2/mysql2_ext.h", "ext/mysql2/result.c", "ext/mysql2/result.h", "lib/active_record/connection_adapters/em_mysql2_adapter.rb", "lib/active_record/connection_adapters/mysql2_adapter.rb", "lib/active_record/fiber_patches.rb", "lib/arel/engines/sql/compilers/mysql2_compiler.rb", "lib/mysql2.rb", "lib/mysql2/client.rb", "lib/mysql2/em.rb", "lib/mysql2/em_fiber.rb", "lib/mysql2/error.rb", "lib/mysql2/result.rb", "lib/mysql2/version.rb", "mysql2.gemspec", "spec/em/em_fiber_spec.rb", "spec/em/em_spec.rb", "spec/mysql2/client_spec.rb", "spec/mysql2/error_spec.rb", "spec/mysql2/result_spec.rb", "spec/rcov.opts", "spec/spec_helper.rb", "tasks/benchmarks.rake", "tasks/compile.rake", "tasks/rspec.rake", "tasks/vendor_mysql.rake"]
  s.homepage = %q{http://github.com/brianmario/mysql2}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib", "ext"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A simple, fast Mysql library for Ruby, binding to libmysql}
  s.test_files = ["examples/eventmachine.rb", "examples/threaded.rb", "spec/em/em_fiber_spec.rb", "spec/em/em_spec.rb", "spec/mysql2/client_spec.rb", "spec/mysql2/error_spec.rb", "spec/mysql2/result_spec.rb", "spec/rcov.opts", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<eventmachine>, [">= 0"])
      s.add_development_dependency(%q<rake-compiler>, ["~> 0.7.7"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<activerecord>, [">= 0"])
      s.add_development_dependency(%q<mysql>, [">= 0"])
      s.add_development_dependency(%q<do_mysql>, [">= 0"])
      s.add_development_dependency(%q<sequel>, [">= 0"])
      s.add_development_dependency(%q<faker>, [">= 0"])
    else
      s.add_dependency(%q<eventmachine>, [">= 0"])
      s.add_dependency(%q<rake-compiler>, ["~> 0.7.7"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<mysql>, [">= 0"])
      s.add_dependency(%q<do_mysql>, [">= 0"])
      s.add_dependency(%q<sequel>, [">= 0"])
      s.add_dependency(%q<faker>, [">= 0"])
    end
  else
    s.add_dependency(%q<eventmachine>, [">= 0"])
    s.add_dependency(%q<rake-compiler>, ["~> 0.7.7"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<mysql>, [">= 0"])
    s.add_dependency(%q<do_mysql>, [">= 0"])
    s.add_dependency(%q<sequel>, [">= 0"])
    s.add_dependency(%q<faker>, [">= 0"])
  end
end
