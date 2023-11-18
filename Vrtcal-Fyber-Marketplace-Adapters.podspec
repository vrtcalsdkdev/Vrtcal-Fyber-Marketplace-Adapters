Pod::Spec.new do |s|
    s.name         = "Vrtcal-Fyber-Marketplace-Adapters"
    s.version      = "1.0.2"
    s.summary      = "Allows mediation with Vrtcal as either the primary or secondary SDK"
    s.homepage     = "http://vrtcal.com"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2020 Vrtcal Markets, Inc.
                  LICENSE
                }
    s.author       = { "Scott McCoy" => "scott.mccoy@vrtcal.com" }
    
    s.source       = { :git => "https://github.com/vrtcalsdkdev/Vrtcal-Fyber-Marketplace-Adapters.git", :tag => "#{s.version}" }
    s.source_files = "Source/**/*.swift"

    s.platform = :ios
    s.ios.deployment_target = '11.0'

    s.dependency 'Fyber_Marketplace_SDK'
    s.dependency 'VrtcalSDK'

    s.static_framework = true
end
