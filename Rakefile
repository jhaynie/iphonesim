desc "Create a Release build"
task :build do
  sh "xcodebuild -project ios-sim.xcodeproj -configuration Release SYMROOT=build"
end

desc "Install a Release build"
task :install => :build do
  if (prefix = ENV['prefix']) && File.directory?(prefix)
    cp 'build/Release/ios-sim', prefix
  else
    puts "[!] Specify a directory as the install prefix with the `prefix' env variable"
    exit 1
  end
end

desc "Update README.md from README.template.md"
task :readme do
  version  = File.read('Source/version.h').match(/IOS_SIM_VERSION "([\d\.]+)"/)[1]
  template = File.read('README.template.md')
  rendered = template.gsub('{{VERSION}}', version)
  File.open('README.md', 'w') { |f| f << rendered }
end
