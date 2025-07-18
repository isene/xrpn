Gem::Specification.new do |s|
  s.name        = 'xrpn'
  s.version     = '2.5'
  s.licenses    = ['Unlicense']
  s.summary     = "XRPN - The eXtended RPN (Reverse Polish Notation) programming language"
  s.description = "A full programming language and environment extending the features of the venerable HP calculator programmable calculators. With XRPN you can accomplish a wide range of modern programming tasks as well as running existing HP-41 FOCAL programs directly. XRPN gives modern life to tens of thousands of old HP calculator programs and opens the possibilities to many, many more. New in 2.5: Critical bug fixes and performance enhancements - fixed division by zero crashes, nil reference errors, memory leaks, and optimized file system operations."

  s.authors     = ["Geir Isene"]
  s.email       = 'g@isene.com'
  s.homepage    = 'https://github.com/isene/XRPN'

  s.add_runtime_dependency 'tty-prompt', '~> 0.23'
  
  s.files       = ["bin/xrpn", "conf", "theme_example", "README.md", "xrpn.gemspec"] + Dir.glob("xcmd/*") + Dir.glob("xlib/*") + Dir.glob("tests/*")
  s.executables << 'xrpn'
end
