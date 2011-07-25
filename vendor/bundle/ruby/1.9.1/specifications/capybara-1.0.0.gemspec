# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{capybara}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonas Nicklas"]
  s.date = %q{2011-06-13}
  s.description = %q{Capybara is an integration testing tool for rack based web applications. It simulates how a user would interact with a website}
  s.email = ["jonas.nicklas@gmail.com"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["lib/capybara/cucumber.rb", "lib/capybara/driver/base.rb", "lib/capybara/driver/node.rb", "lib/capybara/dsl.rb", "lib/capybara/node/actions.rb", "lib/capybara/node/base.rb", "lib/capybara/node/document.rb", "lib/capybara/node/element.rb", "lib/capybara/node/finders.rb", "lib/capybara/node/matchers.rb", "lib/capybara/node/simple.rb", "lib/capybara/rack_test/browser.rb", "lib/capybara/rack_test/driver.rb", "lib/capybara/rack_test/form.rb", "lib/capybara/rack_test/node.rb", "lib/capybara/rails.rb", "lib/capybara/rspec/features.rb", "lib/capybara/rspec/matchers.rb", "lib/capybara/rspec.rb", "lib/capybara/selector.rb", "lib/capybara/selenium/driver.rb", "lib/capybara/selenium/node.rb", "lib/capybara/server.rb", "lib/capybara/session.rb", "lib/capybara/spec/driver.rb", "lib/capybara/spec/fixtures/capybara.jpg", "lib/capybara/spec/fixtures/test_file.txt", "lib/capybara/spec/public/jquery-ui.js", "lib/capybara/spec/public/jquery.js", "lib/capybara/spec/public/test.js", "lib/capybara/spec/session/all_spec.rb", "lib/capybara/spec/session/attach_file_spec.rb", "lib/capybara/spec/session/check_spec.rb", "lib/capybara/spec/session/choose_spec.rb", "lib/capybara/spec/session/click_button_spec.rb", "lib/capybara/spec/session/click_link_or_button_spec.rb", "lib/capybara/spec/session/click_link_spec.rb", "lib/capybara/spec/session/current_host_spec.rb", "lib/capybara/spec/session/current_url_spec.rb", "lib/capybara/spec/session/fill_in_spec.rb", "lib/capybara/spec/session/find_button_spec.rb", "lib/capybara/spec/session/find_by_id_spec.rb", "lib/capybara/spec/session/find_field_spec.rb", "lib/capybara/spec/session/find_link_spec.rb", "lib/capybara/spec/session/find_spec.rb", "lib/capybara/spec/session/first_spec.rb", "lib/capybara/spec/session/has_button_spec.rb", "lib/capybara/spec/session/has_content_spec.rb", "lib/capybara/spec/session/has_css_spec.rb", "lib/capybara/spec/session/has_field_spec.rb", "lib/capybara/spec/session/has_link_spec.rb", "lib/capybara/spec/session/has_select_spec.rb", "lib/capybara/spec/session/has_selector_spec.rb", "lib/capybara/spec/session/has_table_spec.rb", "lib/capybara/spec/session/has_xpath_spec.rb", "lib/capybara/spec/session/headers.rb", "lib/capybara/spec/session/javascript.rb", "lib/capybara/spec/session/response_code.rb", "lib/capybara/spec/session/select_spec.rb", "lib/capybara/spec/session/text_spec.rb", "lib/capybara/spec/session/uncheck_spec.rb", "lib/capybara/spec/session/unselect_spec.rb", "lib/capybara/spec/session/within_spec.rb", "lib/capybara/spec/session.rb", "lib/capybara/spec/test_app.rb", "lib/capybara/spec/views/buttons.erb", "lib/capybara/spec/views/fieldsets.erb", "lib/capybara/spec/views/form.erb", "lib/capybara/spec/views/frame_one.erb", "lib/capybara/spec/views/frame_two.erb", "lib/capybara/spec/views/header_links.erb", "lib/capybara/spec/views/host_links.erb", "lib/capybara/spec/views/popup_one.erb", "lib/capybara/spec/views/popup_two.erb", "lib/capybara/spec/views/postback.erb", "lib/capybara/spec/views/tables.erb", "lib/capybara/spec/views/with_html.erb", "lib/capybara/spec/views/with_html_entities.erb", "lib/capybara/spec/views/with_js.erb", "lib/capybara/spec/views/with_scope.erb", "lib/capybara/spec/views/with_simple_html.erb", "lib/capybara/spec/views/within_frames.erb", "lib/capybara/spec/views/within_popups.erb", "lib/capybara/util/save_and_open_page.rb", "lib/capybara/util/timeout.rb", "lib/capybara/version.rb", "lib/capybara.rb", "spec/basic_node_spec.rb", "spec/capybara_spec.rb", "spec/driver/rack_test_driver_spec.rb", "spec/driver/selenium_driver_spec.rb", "spec/dsl_spec.rb", "spec/rspec/features_spec.rb", "spec/rspec/matchers_spec.rb", "spec/rspec_spec.rb", "spec/save_and_open_page_spec.rb", "spec/server_spec.rb", "spec/session/rack_test_session_spec.rb", "spec/session/selenium_session_spec.rb", "spec/spec_helper.rb", "spec/string_spec.rb", "spec/timeout_spec.rb", "README.rdoc", "History.txt"]
  s.homepage = %q{http://github.com/jnicklas/capybara}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{capybara}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Capybara aims to simplify the process of integration testing Rack applications, such as Rails, Sinatra or Merb}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.3.3"])
      s.add_runtime_dependency(%q<mime-types>, [">= 1.16"])
      s.add_runtime_dependency(%q<selenium-webdriver>, ["~> 0.2.0"])
      s.add_runtime_dependency(%q<rack>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<rack-test>, [">= 0.5.4"])
      s.add_runtime_dependency(%q<xpath>, ["~> 0.1.4"])
      s.add_development_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_development_dependency(%q<launchy>, [">= 0.3.5"])
      s.add_development_dependency(%q<yard>, [">= 0.5.8"])
      s.add_development_dependency(%q<fuubar>, [">= 0.0.1"])
      s.add_development_dependency(%q<cucumber>, [">= 0.10"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.3.3"])
      s.add_dependency(%q<mime-types>, [">= 1.16"])
      s.add_dependency(%q<selenium-webdriver>, ["~> 0.2.0"])
      s.add_dependency(%q<rack>, [">= 1.0.0"])
      s.add_dependency(%q<rack-test>, [">= 0.5.4"])
      s.add_dependency(%q<xpath>, ["~> 0.1.4"])
      s.add_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_dependency(%q<launchy>, [">= 0.3.5"])
      s.add_dependency(%q<yard>, [">= 0.5.8"])
      s.add_dependency(%q<fuubar>, [">= 0.0.1"])
      s.add_dependency(%q<cucumber>, [">= 0.10"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.3.3"])
    s.add_dependency(%q<mime-types>, [">= 1.16"])
    s.add_dependency(%q<selenium-webdriver>, ["~> 0.2.0"])
    s.add_dependency(%q<rack>, [">= 1.0.0"])
    s.add_dependency(%q<rack-test>, [">= 0.5.4"])
    s.add_dependency(%q<xpath>, ["~> 0.1.4"])
    s.add_dependency(%q<sinatra>, [">= 0.9.4"])
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
    s.add_dependency(%q<launchy>, [">= 0.3.5"])
    s.add_dependency(%q<yard>, [">= 0.5.8"])
    s.add_dependency(%q<fuubar>, [">= 0.0.1"])
    s.add_dependency(%q<cucumber>, [">= 0.10"])
  end
end
