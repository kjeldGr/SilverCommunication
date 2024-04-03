Pod::Spec.new do |s|
  s.name             = 'SilverCommunication'
  s.version          = '0.13.0'
  s.summary          = 'Provides convenience for server communication.'

  s.description      = <<-DESC
  Provides convenience for server communication.
                       DESC

  s.license          = 'MIT'
  s.homepage         = 'https://github.com/kjeldGr/SilverCommunication'
  s.author           = 'Kjeld Groot'
  s.source           = { :git => 'git@github.com/kjeldGr/SilverCommunication.git',
                         :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'Sources/SilverCommunication/**/*.swift'

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/SilverCommunicationTests/*.swift'
    test_spec.resources = 'Tests/SilverCommunicationTests/Resources/*'
  end
end
