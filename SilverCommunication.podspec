Pod::Spec.new do |s|
  s.name = 'SilverCommunication'
  s.version = '0.15.2'
  s.summary = 'A lightweight Swift library used to perform simple HTTP requests.'
  s.license = 'MIT'
  s.homepage = 'https://github.com/kjeldGr/SilverCommunication'
  s.author = 'KPGroot'
  s.source = { :git => 'https://github.com/kjeldGr/SilverCommunication.git', :tag => s.version.to_s }
  s.documentation_url = 'https://github.com/kjeldGr/SilverCommunication'

  s.ios.deployment_target = '12.0'
  s.osx.deployment_target  = '10.13'
  s.tvos.deployment_target = '12.0'
  s.visionos.deployment_target = '1.0'
  s.watchos.deployment_target = '4.0'

  s.swift_versions = ['5.9']
  s.source_files = 'Sources/SilverCommunication/**/*.swift'

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/SilverCommunicationTests/**/*.swift'
    test_spec.resources = 'Tests/SilverCommunicationTests/Resources/*'
  end
end
