Pod::Spec.new do |s|

  s.name                      = 'MKHValidatableValue'
  s.version                   = '2.2.0'
  s.summary                   = 'Generic value wrapper with built-in validation.'
  s.homepage                  = 'https://github.com/maximkhatskevich/#{s.name}'
  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }
  s.ios.deployment_target     = '8.0'
  s.source                    = { :git => '#{s.homepage}.git', :tag => '#{s.version}' }
  s.source_files              = 'Src/**/*.swift'
  s.requires_arc              = true
  s.social_media_url          = 'http://www.linkedin.com/in/maximkhatskevich'

  s.dependency                'MKHRequirement', '~> 1.0.0'

end
