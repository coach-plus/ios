platform :ios, '10.0'

use_frameworks!

def all_pods
  pod 'Locksmith'
  pod 'SkyFloatingLabelTextField'
  pod 'IQKeyboardManagerSwift'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'MBProgressHUD'
  pod 'NotificationBannerSwift'
  pod "JWTDecode"
  pod 'Hero'
  pod 'SwiftyUserDefaults'
  pod 'NibDesignable', :git => 'https://github.com/dzzh/NibDesignable.git', :branch => 'great-swift4'
  pod 'SwiftDate'
  pod 'DZNEmptyDataSet'
  pod 'ImagePicker'
  pod 'XLPagerTabStrip'
  pod 'SwiftIcons'
  pod 'RSKImageCropper'
  pod 'TextFieldEffects'
  pod 'MMDrawerController'
  pod "PromiseKit"
  pod 'Kingfisher', '~> 5.0'
  pod 'RxSwift',    '~> 4.0'
  pod 'RxCocoa',    '~> 4.0'
end

target 'CoachPlus' do
  all_pods

  target 'CoachPlusTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CoachPlusUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'CoachPlusDev' do
  all_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['SwiftIcons', 'NibDesignable', 'ImagePicker'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
