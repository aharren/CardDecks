link_with ['CardDecks', 'Tests']

platform :ios, 7

pod 'LibComponentLogging-Core'
pod 'LibComponentLogging-qlog'

pod 'LibComponentLogging-pods'

post_install do |installer|
  # run lcl_configure
  puts 'Running lcl_configure'
  system 'Pods/LibComponentLogging-pods/configure/lcl_configure pod'
end
