# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'

Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'youpropapp'
  app.provisioning_profile = '/Users/paolotax/Library/MobileDevice/Provisioning Profiles/EA8F07F2-DB5C-43D5-A722-BEF7C43408FB.mobileprovision' 
  app.codesign_certificate = 'iPhone Developer: Paolo Tassinari (9L6JUZD52Q)' 
  
  app.frameworks += ['QuartzCore', 'Security']

  app.pods do
    pod 'AFNetworking'
    pod "RDActionSheet"
    pod 'SSKeychain'
    pod "PDKeychainBindingsController"
  end
end