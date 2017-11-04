platform :ios, '9.0'

use_frameworks!

def all_pods
  pod 'Locksmith'
  pod 'SkyFloatingLabelTextField'
  pod 'IQKeyboardManagerSwift'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'MBProgressHUD'
  pod 'RKDropdownAlert'
  pod "JWTDecode"
  pod 'Hero', '1.0.0'
  pod 'SwiftyUserDefaults'
  pod 'NibDesignable', :git => 'https://github.com/dzzh/NibDesignable.git', :branch => 'great-swift4'
  pod 'SwiftDate'
  pod 'AlamofireImage'
  pod 'SlideMenuControllerSwift'
  pod 'DZNEmptyDataSet'
  pod 'ImagePicker'
  pod 'XLPagerTabStrip'
  pod 'SwiftIcons', :git => 'https://github.com/laeroah/SwiftIcons.git', :branch => 'swift4_0'
  pod 'RSKImageCropper'
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