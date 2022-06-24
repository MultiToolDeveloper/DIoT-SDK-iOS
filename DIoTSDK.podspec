Pod::Spec.new do |spec|

  spec.name         = "DIoTSDK"
  spec.version      = "1.0.1"
  spec.summary      = "DIoT Platform library"

  spec.description  = <<-DESC
Library for implementation connection flow between phone and DIoT Platform device.
                   DESC

  spec.homepage     = "https://github.com/MultiToolDeveloper/DIoT-SDK-iOS"
  spec.license      = { :type => "Apache-2.0", :file => "LICENSE" }
  spec.author       = { "andrey" => "andreym@daatrics.com" }

  spec.ios.deployment_target = "13.0"
  spec.swift_version = "5.0"

  spec.source        = { :git => "git@github.com:MultiToolDeveloper/DIoT-SDK-iOS.git", :tag => "#{spec.version}" }
  spec.source_files  = "DIoTSDK/**/*.{h,m,swift}"

end