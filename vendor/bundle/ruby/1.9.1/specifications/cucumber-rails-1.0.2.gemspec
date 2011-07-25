# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cucumber-rails}
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aslak Hellesøy", "Dennis Blöte", "Rob Holland"]
  s.date = %q{2011-06-26}
  s.description = %q{Cucumber Generators and Runtime for Rails}
  s.email = %q{cukes@googlegroups.com}
  s.files = [".gitignore", ".rspec", ".rvmrc", "Gemfile", "Gemfile.lock", "History.md", "LICENSE", "README.md", "Rakefile", "config/.gitignore", "config/cucumber.yml", "cucumber-rails.gemspec", "dev_tasks/cucumber.rake", "dev_tasks/rspec.rake", "dev_tasks/yard.rake", "dev_tasks/yard/default/layout/html/bubble_32x32.png", "dev_tasks/yard/default/layout/html/footer.erb", "dev_tasks/yard/default/layout/html/index.erb", "dev_tasks/yard/default/layout/html/layout.erb", "dev_tasks/yard/default/layout/html/logo.erb", "dev_tasks/yard/default/layout/html/setup.rb", "features/allow_rescue.feature", "features/capybara_javascript_drivers.feature", "features/database_cleaner.feature", "features/emulate_javascript.feature", "features/inspect_query_string.feature", "features/install_cucumber_rails.feature", "features/mongoid.feature", "features/multiple_databases.feature", "features/named_selectors.feature", "features/no_database.feature", "features/pseduo_class_selectors.feature", "features/rerun_profile.feature", "features/rest_api.feature", "features/routing.feature", "features/select_dates.feature", "features/step_definitions/cucumber_rails_steps.rb", "features/support/env.rb", "features/test_unit.feature", "lib/cucumber/rails.rb", "lib/cucumber/rails/action_controller.rb", "lib/cucumber/rails/application.rb", "lib/cucumber/rails/capybara.rb", "lib/cucumber/rails/capybara/javascript_emulation.rb", "lib/cucumber/rails/capybara/select_dates_and_times.rb", "lib/cucumber/rails/hooks.rb", "lib/cucumber/rails/hooks/active_record.rb", "lib/cucumber/rails/hooks/allow_rescue.rb", "lib/cucumber/rails/hooks/database_cleaner.rb", "lib/cucumber/rails/hooks/mail.rb", "lib/cucumber/rails/rspec.rb", "lib/cucumber/rails/world.rb", "lib/cucumber/web/tableish.rb", "lib/generators/cucumber/feature/USAGE", "lib/generators/cucumber/feature/feature_generator.rb", "lib/generators/cucumber/feature/named_arg.rb", "lib/generators/cucumber/feature/templates/feature.erb", "lib/generators/cucumber/feature/templates/steps.erb", "lib/generators/cucumber/install/USAGE", "lib/generators/cucumber/install/install_generator.rb", "lib/generators/cucumber/install/templates/config/cucumber.yml.erb", "lib/generators/cucumber/install/templates/script/cucumber", "lib/generators/cucumber/install/templates/step_definitions/web_steps.rb.erb", "lib/generators/cucumber/install/templates/step_definitions/web_steps_cs.rb.erb", "lib/generators/cucumber/install/templates/step_definitions/web_steps_da.rb.erb", "lib/generators/cucumber/install/templates/step_definitions/web_steps_de.rb.erb", "lib/generators/cucumber/install/templates/step_definitions/web_steps_es.rb.erb", "lib/generators/cucumber/install/templates/step_definitions/web_steps_ja.rb.erb", "lib/generators/cucumber/install/templates/step_definitions/web_steps_ko.rb.erb", "lib/generators/cucumber/install/templates/step_definitions/web_steps_no.rb.erb", "lib/generators/cucumber/install/templates/step_definitions/web_steps_pt-BR.rb.erb", "lib/generators/cucumber/install/templates/support/_rails_each_run.rb.erb", "lib/generators/cucumber/install/templates/support/_rails_prefork.rb.erb", "lib/generators/cucumber/install/templates/support/capybara.rb", "lib/generators/cucumber/install/templates/support/edit_warning.txt", "lib/generators/cucumber/install/templates/support/paths.rb", "lib/generators/cucumber/install/templates/support/rails.rb.erb", "lib/generators/cucumber/install/templates/support/rails_spork.rb.erb", "lib/generators/cucumber/install/templates/support/selectors.rb", "lib/generators/cucumber/install/templates/support/web_steps_warning.txt", "lib/generators/cucumber/install/templates/tasks/cucumber.rake.erb", "spec/cucumber/web/tableish_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://cukes.info}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{cucumber-rails-1.0.2}
  s.test_files = ["features/allow_rescue.feature", "features/capybara_javascript_drivers.feature", "features/database_cleaner.feature", "features/emulate_javascript.feature", "features/inspect_query_string.feature", "features/install_cucumber_rails.feature", "features/mongoid.feature", "features/multiple_databases.feature", "features/named_selectors.feature", "features/no_database.feature", "features/pseduo_class_selectors.feature", "features/rerun_profile.feature", "features/rest_api.feature", "features/routing.feature", "features/select_dates.feature", "features/step_definitions/cucumber_rails_steps.rb", "features/support/env.rb", "features/test_unit.feature", "spec/cucumber/web/tableish_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cucumber>, ["~> 1.0.0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.6"])
      s.add_runtime_dependency(%q<capybara>, [">= 1.0.0"])
      s.add_development_dependency(%q<rails>, [">= 3.1.0.rc4"])
      s.add_development_dependency(%q<rake>, [">= 0.9.2"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.15"])
      s.add_development_dependency(%q<aruba>, [">= 0.4.3"])
      s.add_development_dependency(%q<sqlite3-ruby>, [">= 1.3.3"])
      s.add_development_dependency(%q<rspec>, [">= 2.6.0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 2.6.1"])
      s.add_development_dependency(%q<factory_girl>, [">= 2.0.0.beta2"])
      s.add_development_dependency(%q<database_cleaner>, [">= 0.6.7"])
      s.add_development_dependency(%q<mongoid>, [">= 2.0.2"])
      s.add_development_dependency(%q<bson_ext>, [">= 1.3.1"])
      s.add_development_dependency(%q<turn>, [">= 0.8.2"])
      s.add_development_dependency(%q<sass>, [">= 3.1.3"])
      s.add_development_dependency(%q<coffee-script>, [">= 2.2.0"])
      s.add_development_dependency(%q<uglifier>, [">= 1.0.0"])
      s.add_development_dependency(%q<jquery-rails>, [">= 1.0.12"])
      s.add_development_dependency(%q<yard>, ["= 0.7.1"])
      s.add_development_dependency(%q<rdiscount>, ["= 1.6.8"])
      s.add_development_dependency(%q<bcat>, ["= 0.6.1"])
    else
      s.add_dependency(%q<cucumber>, ["~> 1.0.0"])
      s.add_dependency(%q<nokogiri>, [">= 1.4.6"])
      s.add_dependency(%q<capybara>, [">= 1.0.0"])
      s.add_dependency(%q<rails>, [">= 3.1.0.rc4"])
      s.add_dependency(%q<rake>, [">= 0.9.2"])
      s.add_dependency(%q<bundler>, [">= 1.0.15"])
      s.add_dependency(%q<aruba>, [">= 0.4.3"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 1.3.3"])
      s.add_dependency(%q<rspec>, [">= 2.6.0"])
      s.add_dependency(%q<rspec-rails>, [">= 2.6.1"])
      s.add_dependency(%q<factory_girl>, [">= 2.0.0.beta2"])
      s.add_dependency(%q<database_cleaner>, [">= 0.6.7"])
      s.add_dependency(%q<mongoid>, [">= 2.0.2"])
      s.add_dependency(%q<bson_ext>, [">= 1.3.1"])
      s.add_dependency(%q<turn>, [">= 0.8.2"])
      s.add_dependency(%q<sass>, [">= 3.1.3"])
      s.add_dependency(%q<coffee-script>, [">= 2.2.0"])
      s.add_dependency(%q<uglifier>, [">= 1.0.0"])
      s.add_dependency(%q<jquery-rails>, [">= 1.0.12"])
      s.add_dependency(%q<yard>, ["= 0.7.1"])
      s.add_dependency(%q<rdiscount>, ["= 1.6.8"])
      s.add_dependency(%q<bcat>, ["= 0.6.1"])
    end
  else
    s.add_dependency(%q<cucumber>, ["~> 1.0.0"])
    s.add_dependency(%q<nokogiri>, [">= 1.4.6"])
    s.add_dependency(%q<capybara>, [">= 1.0.0"])
    s.add_dependency(%q<rails>, [">= 3.1.0.rc4"])
    s.add_dependency(%q<rake>, [">= 0.9.2"])
    s.add_dependency(%q<bundler>, [">= 1.0.15"])
    s.add_dependency(%q<aruba>, [">= 0.4.3"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 1.3.3"])
    s.add_dependency(%q<rspec>, [">= 2.6.0"])
    s.add_dependency(%q<rspec-rails>, [">= 2.6.1"])
    s.add_dependency(%q<factory_girl>, [">= 2.0.0.beta2"])
    s.add_dependency(%q<database_cleaner>, [">= 0.6.7"])
    s.add_dependency(%q<mongoid>, [">= 2.0.2"])
    s.add_dependency(%q<bson_ext>, [">= 1.3.1"])
    s.add_dependency(%q<turn>, [">= 0.8.2"])
    s.add_dependency(%q<sass>, [">= 3.1.3"])
    s.add_dependency(%q<coffee-script>, [">= 2.2.0"])
    s.add_dependency(%q<uglifier>, [">= 1.0.0"])
    s.add_dependency(%q<jquery-rails>, [">= 1.0.12"])
    s.add_dependency(%q<yard>, ["= 0.7.1"])
    s.add_dependency(%q<rdiscount>, ["= 1.6.8"])
    s.add_dependency(%q<bcat>, ["= 0.6.1"])
  end
end
