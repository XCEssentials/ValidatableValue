projName = 'ValidatableValue'
projSummary = 'Generic value wrapper with built-in validation.'
companyPrefix = 'XCE'
companyName = 'XCEssentials'
companyGitHubAccount = 'https://github.com/' + companyName
companyGitHubPage = 'https://' + companyName + '.github.io'

#===

Pod::Spec.new do |s|

  s.name                      = companyPrefix + projName
  s.summary                   = projSummary
  s.version                   = '2.2.0'
  s.homepage                  = companyGitHubPage + '/' + projName

  s.source                    = { :git => companyGitHubAccount + '/' + projName + '.git', :tag => s.version }
  s.source_files              = 'Src/**/*.swift'
  
  s.ios.deployment_target     = '8.0'
  s.requires_arc              = true
  
  s.dependency                  'XCERequirement', '~> 1.4'

  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }
  
end
