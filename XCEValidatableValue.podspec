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
  s.version                   = '3.6.0'
  s.homepage                  = companyGitHubPage + '/' + projName

  s.source                    = { :git => companyGitHubAccount + '/' + projName + '.git', :tag => s.version }

  s.requires_arc              = true

  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }

  s.swift_version             = '4.1'

  # === All platforms

  #

  # === iOS

  s.ios.deployment_target     = '8.0'

  s.ios.source_files          = 'Sources/**/*.swift'

end
