Gem::Specification.new do |s|
  s.name        = 'xrpn'
  s.version     = '2.6'
  s.licenses    = ['Unlicense']
  s.summary     = "XRPN - The eXtended RPN (Reverse Polish Notation) programming language"
  s.description = "A full programming language and environment extending the features of the venerable HP calculator programmable calculators. With XRPN you can accomplish a wide range of modern programming tasks as well as running existing HP-41 FOCAL programs directly. XRPN gives modern life to tens of thousands of old HP calculator programs and opens the possibilities to many, many more. New in 2.6: Comprehensive regression test framework with 58 automated tests and HP-41 RAW file viewer for inspecting thousands of legacy HP-41 programs."

  s.authors     = ["Geir Isene"]
  s.email       = 'g@isene.com'
  s.homepage    = 'https://github.com/isene/XRPN'

  s.add_runtime_dependency 'tty-prompt', '~> 0.23'
  
  s.files       = ["bin/xrpn", "conf", "theme_example", "README.md", "xrpn.gemspec"] + Dir.glob("xcmd/*") + Dir.glob("xlib/*") + Dir.glob("tests/*")
  s.executables << 'xrpn'
end
