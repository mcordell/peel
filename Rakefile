require "bundler/gem_tasks"


namespace :bump do
  def modify_version_file(&block)
    version_file_path = File.expand_path("../lib/peel/version.rb", __FILE__)
    lines = File.readlines(version_file_path).map do |line|
      if line.match(/VERSION/)
        version_pattern = /(\d+)\.(\d+)\.(\d+)/
        result = block.call(line.match(version_pattern).captures)
        line.gsub(version_pattern, result)
      else
        line
      end
    end
    File.open(version_file_path, "w") { |file| file.puts lines }
  end

  desc 'Bump the gem version to the next patch X.X.+1'
  task :patch do
    modify_version_file do |major, minor, patch|
      [major, minor, (patch.to_i + 1)].join('.')
    end
  end

  desc 'Bump the gem version to the next minor X.+1.0'
  task :minor do
    modify_version_file do |major, minor, _|
      [major, (minor.to_i + 1), 0].join('.')
    end
  end

  desc 'Bump the gem version to the next major +1.0.0'
  task :major do
    modify_version_file do |major, _, _|
      [(major.to_i + 1), 0, 0].join('.')
    end
  end
end
