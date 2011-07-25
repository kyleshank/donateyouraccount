# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{kgio}
  s.version = "2.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["kgio hackers"]
  s.date = %q{2011-07-15}
  s.description = %q{kgio provides non-blocking I/O methods for Ruby without raising
exceptions on EAGAIN and EINPROGRESS.  It is intended for use with the
Unicorn and Rainbows! Rack servers, but may be used by other
applications (that run on Unix-like platforms).}
  s.email = %q{kgio@librelist.org}
  s.extensions = ["ext/kgio/extconf.rb"]
  s.extra_rdoc_files = ["LICENSE", "README", "TODO", "NEWS", "LATEST", "ChangeLog", "ISSUES", "HACKING", "lib/kgio.rb", "ext/kgio/accept.c", "ext/kgio/autopush.c", "ext/kgio/connect.c", "ext/kgio/kgio_ext.c", "ext/kgio/poll.c", "ext/kgio/read_write.c", "ext/kgio/wait.c", "ext/kgio/tryopen.c"]
  s.files = [".document", ".gitignore", ".manifest", ".wrongdoc.yml", "COPYING", "ChangeLog", "GIT-VERSION-FILE", "GIT-VERSION-GEN", "GNUmakefile", "HACKING", "ISSUES", "LATEST", "LICENSE", "NEWS", "README", "Rakefile", "TODO", "ext/kgio/accept.c", "ext/kgio/ancient_ruby.h", "ext/kgio/autopush.c", "ext/kgio/blocking_io_region.h", "ext/kgio/broken_system_compat.h", "ext/kgio/connect.c", "ext/kgio/extconf.rb", "ext/kgio/kgio.h", "ext/kgio/kgio_ext.c", "ext/kgio/missing_accept4.h", "ext/kgio/my_fileno.h", "ext/kgio/nonblock.h", "ext/kgio/poll.c", "ext/kgio/read_write.c", "ext/kgio/set_file_path.h", "ext/kgio/sock_for_fd.h", "ext/kgio/tryopen.c", "ext/kgio/wait.c", "kgio.gemspec", "lib/kgio.rb", "pkg.mk", "setup.rb", "test/lib_read_write.rb", "test/lib_server_accept.rb", "test/test_accept_class.rb", "test/test_accept_flags.rb", "test/test_autopush.rb", "test/test_connect_fd_leak.rb", "test/test_cross_thread_close.rb", "test/test_default_wait.rb", "test/test_kgio_addr.rb", "test/test_no_dns_on_tcp_connect.rb", "test/test_peek.rb", "test/test_pipe_popen.rb", "test/test_pipe_read_write.rb", "test/test_poll.rb", "test/test_singleton_read_write.rb", "test/test_socketpair_read_write.rb", "test/test_tcp6_client_read_server_write.rb", "test/test_tcp_client_read_server_write.rb", "test/test_tcp_connect.rb", "test/test_tcp_server.rb", "test/test_tcp_server_read_client_write.rb", "test/test_tryopen.rb", "test/test_unix_client_read_server_write.rb", "test/test_unix_connect.rb", "test/test_unix_server.rb", "test/test_unix_server_read_client_write.rb"]
  s.homepage = %q{http://bogomips.org/kgio/}
  s.rdoc_options = ["-t", "kgio - kinder, gentler I/O for Ruby", "-W", "http://bogomips.org/kgio.git/tree/%s"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rainbows}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{kinder, gentler I/O for Ruby}
  s.test_files = ["test/test_poll.rb", "test/test_peek.rb", "test/test_default_wait.rb", "test/test_no_dns_on_tcp_connect.rb", "test/test_unix_connect.rb", "test/test_pipe_read_write.rb", "test/test_unix_server.rb", "test/test_accept_flags.rb", "test/test_socketpair_read_write.rb", "test/test_tcp_server.rb", "test/test_unix_server_read_client_write.rb", "test/test_cross_thread_close.rb", "test/test_tcp_connect.rb", "test/test_autopush.rb", "test/test_connect_fd_leak.rb", "test/test_singleton_read_write.rb", "test/test_kgio_addr.rb", "test/test_tryopen.rb", "test/test_tcp6_client_read_server_write.rb", "test/test_tcp_server_read_client_write.rb", "test/test_unix_client_read_server_write.rb", "test/test_tcp_client_read_server_write.rb", "test/test_pipe_popen.rb", "test/test_accept_class.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<wrongdoc>, ["~> 1.5"])
      s.add_development_dependency(%q<strace_me>, ["~> 1.0"])
    else
      s.add_dependency(%q<wrongdoc>, ["~> 1.5"])
      s.add_dependency(%q<strace_me>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<wrongdoc>, ["~> 1.5"])
    s.add_dependency(%q<strace_me>, ["~> 1.0"])
  end
end
