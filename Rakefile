require "bundler/gem_tasks"
require "rake/testtask"

task :parser do
  sh "racc -o lib/plate/parser.rb lib/plate/grammar.y"
end

task :examples do
  require 'plate'
  require 'screencap'
  FileUtils.rm_rf('./examples')
  Dir.glob('./test/fixtures/src/*').each do |ex|
    name = File.basename(ex, '.*')

    output = "./examples/#{name}"
    Plate::CLI.new.invoke(:compile, [ex], o: output)

    path = File.expand_path("./examples/#{name}/index.html")
    f = Screencap::Fetcher.new("file://#{path}")
    screenshot = f.fetch(
      output: "./examples/#{name}.png",
      width: 640,
      height: 480,
      debug: true
    )
  end
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
  Rake::Task['parser'].invoke
end

task default: :test
