# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'NewsCheck' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NewsCheck

pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'GoogleSignIn', '~> 6.0.2'
pod 'KakaoSDKCommon'
pod 'KakaoSDKAuth'
pod 'KakaoSDKUser'


post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      end
    end
  end

end
