Pod::Spec.new do |s|

  s.name                      = 'XCEValidatableValue'
  s.summary                   = 'Generic value wrapper with built-in validation.'
  s.version                   = '3.11.3'
  s.homepage                  = 'https://XCEssentials.github.io/ValidatableValue'

  s.source                    = { :git => 'https://github.com/XCEssentials/ValidatableValue.git', :tag => s.version }

  s.requires_arc              = true

  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }

  s.swift_version             = '4.1'

  s.ios.deployment_target     = '8.0'

  s.source_files              = 'Sources/ValidatableValue/**/*.swift'

end
