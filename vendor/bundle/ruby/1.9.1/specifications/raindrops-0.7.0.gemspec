# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{raindrops}
  s.version = "0.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["raindrops hackers"]
  s.date = %q{2011-06-27}
  s.description = %q{Raindrops is a real-time stats toolkit to show statistics for Rack HTTP
servers.  It is designed for preforking servers such as Rainbows! and
Unicorn, but should support any Rack HTTP server under Ruby 1.9, 1.8 and
Rubinius on platforms supporting POSIX shared memory.  It may also be
used as a generic scoreboard for sharing atomic counters across multiple
processes.}
  s.email = %q{raindrops@librelist.org}
  s.extensions = ["ext/raindrops/extconf.rb"]
  s.extra_rdoc_files = ["README", "LICENSE", "NEWS", "ChangeLog", "lib/raindrops.rb", "lib/raindrops/aggregate.rb", "lib/raindrops/aggregate/last_data_recv.rb", "lib/raindrops/aggregate/pmq.rb", "lib/raindrops/last_data_recv.rb", "lib/raindrops/linux.rb", "lib/raindrops/middleware.rb", "lib/raindrops/middleware/proxy.rb", "lib/raindrops/struct.rb", "lib/raindrops/watcher.rb", "ext/raindrops/raindrops.c", "ext/raindrops/linux_inet_diag.c", "ext/raindrops/linux_tcp_info.c"]
  s.files = [".document", ".gitignore", ".manifest", ".wrongdoc.yml", "COPYING", "ChangeLog", "GIT-VERSION-FILE", "GIT-VERSION-GEN", "GNUmakefile", "Gemfile", "LATEST", "LICENSE", "NEWS", "README", "Rakefile", "TODO", "examples/linux-listener-stats.rb", "examples/middleware.ru", "examples/watcher.ru", "examples/watcher_demo.ru", "examples/zbatery.conf.rb", "ext/raindrops/extconf.rb", "ext/raindrops/linux_inet_diag.c", "ext/raindrops/linux_tcp_info.c", "ext/raindrops/my_fileno.h", "ext/raindrops/raindrops.c", "ext/raindrops/raindrops_atomic.h", "lib/raindrops.rb", "lib/raindrops/aggregate.rb", "lib/raindrops/aggregate/last_data_recv.rb", "lib/raindrops/aggregate/pmq.rb", "lib/raindrops/last_data_recv.rb", "lib/raindrops/linux.rb", "lib/raindrops/middleware.rb", "lib/raindrops/middleware/proxy.rb", "lib/raindrops/struct.rb", "lib/raindrops/watcher.rb", "pkg.mk", "raindrops.gemspec", "setup.rb", "test/ipv6_enabled.rb", "test/rack_unicorn.rb", "test/test_aggregate_pmq.rb", "test/test_inet_diag_socket.rb", "test/test_last_data_recv_unicorn.rb", "test/test_linux.rb", "test/test_linux_all_tcp_listen_stats.rb", "test/test_linux_all_tcp_listen_stats_leak.rb", "test/test_linux_ipv6.rb", "test/test_linux_middleware.rb", "test/test_linux_tcp_info.rb", "test/test_middleware.rb", "test/test_middleware_unicorn.rb", "test/test_middleware_unicorn_ipv6.rb", "test/test_raindrops.rb", "test/test_raindrops_gc.rb", "test/test_struct.rb", "test/test_watcher.rb"]
  s.homepage = %q{http://raindrops.bogomips.org/}
  s.rdoc_options = ["-t", "raindrops - real-time stats for preforking Rack servers", "-W", "http://bogomips.org/raindrops.git/tree/%s"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rainbows}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{real-time stats for preforking Rack servers}
  s.test_files = ["test/test_aggregate_pmq.rb", "test/test_inet_diag_socket.rb", "test/test_last_data_recv_unicorn.rb", "test/test_linux.rb", "test/test_linux_all_tcp_listen_stats.rb", "test/test_linux_all_tcp_listen_stats_leak.rb", "test/test_linux_ipv6.rb", "test/test_linux_middleware.rb", "test/test_linux_tcp_info.rb", "test/test_middleware.rb", "test/test_middleware_unicorn.rb", "test/test_middleware_unicorn_ipv6.rb", "test/test_raindrops.rb", "test/test_raindrops_gc.rb", "test/test_struct.rb", "test/test_watcher.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.0.10"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.0.10"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.0.10"])
  end
end
