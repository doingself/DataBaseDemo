# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def commonPods
  # WCDB是腾讯开发的，微信中使用的DB开源框架 https://github.com/Tencent/wcdb
  pod 'WCDB.swift'
  pod 'SnapKit'
end

target 'DataBaseDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DataBaseDemo
  commonPods
  
  target 'DataBaseDemoTests' do
    inherit! :search_paths
    # Pods for testing
    commonPods
  end

  target 'DataBaseDemoUITests' do
    # Pods for testing
    commonPods
  end

end

# 保证 M1 模拟器可以正常运行
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "$(inherited) arm64"
    end
  end
end
