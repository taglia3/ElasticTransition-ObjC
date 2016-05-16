Pod::Spec.new do |s|
  s.name             = "ElasticTransitionObjC"
  s.version          = "0.1"
  s.summary          = "A UIKit custom transition that simulates an elastic drag."
  s.description      = <<-DESC
This is the Objective-C Version of Elastic Transition written in Swift by lkzhao.
                       DESC

  s.homepage         = "https://github.com/taglia3/ElasticTransition-ObjC"
  s.license          = 'MIT'
  s.author           = { "taglia3" => "the.taglia3@gmail.com" }
  s.source           = { :git => "https://github.com/taglia3/ElasticTransition-ObjC.git", :tag => "0.1" }
  s.social_media_url = 'https://twitter.com/taglia3'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ElasticTransition/**/*'
   s.frameworks = 'UIKit'
end
