Pod::Spec.new do |s|

  s.name                  = "TensorBoxify"
  s.version               = "0.0.1"
  s.summary               = "Image Annotation Transmogrifier for TensorFlow Processing."
  s.homepage              = "https://github.com/dhushon/TensorBoxify"
  s.license               = { :type => 'Copyright', :file => 'LICENSE' }
  s.author                = { "Dan Hushon" => "hushon@gmail.com" }
  s.platform = :osx
  s.osx.deployment_target = "10.13"
  s.source                = { :git => "https://github.com/dhushon/TensorBoxify.git", :tag => "0.0.1" }
  s.source_files          = 'Sources/TensorBoxify/*.{h,m,swift}'
  s.dependency 'Swifter','~> 1.3.3'

end
