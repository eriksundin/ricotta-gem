require "bundler"
Bundler.setup

gemspec = eval(File.read("ricotta.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["ricotta.gemspec"] do
  system "gem build ricotta.gemspec"
end
