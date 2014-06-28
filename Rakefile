require "bundler/setup"
require "./credentials"

require "stringex"
require "date"
require "yaml"
require "fileutils"


CONFIG = YAML.load_file("_config.yml")
DATE_FORMAT = "%Y-%m-%d"
NOW = Time.now.strftime(DATE_FORMAT)
POSTS = "_posts"
DRAFTS = "_drafts"

task :default => :watch

desc "Build the site"
task :build do
  system "jekyll build"
end

desc "Deploy to webBox.io"
task :deploy do
  Rake::Task[:build].invoke
  system "rsync -av _site/ #{DEPLOY_DESTINATION}"
  puts "Transfer completed..."
end

# rake watch
# rake watch[number]
# rake watch["drafts"]
desc "Serve and watch the site (with post limit or drafts)"
task :watch, :option do |t, args|
  option = args[:option]
  if option.nil? or option.empty?
    system "jekyll serve --watch"
  else
    if option == "drafts"
      system "jekyll serve --watch --drafts"
    else
      system "jekyll serve --watch --limit_posts #{option}"
    end
  end
end

# rake post["Title"]
# rake post["Title", "Date"]
desc "Create a new blog post"
task :post, :title, :post_date do |t, args|
  title = args[:title] ? args[:title] : "My Blog Post"
  post_date = args[:post_date] ? Date.parse(args[:post_date]).strftime(DATE_FORMAT) : NOW
  preps = prep_file post_date, title
  filename = preps[:filename]
  content = preps[:content]
  filename_path = "#{POSTS}/#{filename}"
  raise "The file: #{filename} already exists." if File.exists? filename_path
  File.write filename_path, content
  puts "Blog post created: #{filename}"
end

desc "Create a draft blog post"
task :draft, :title, :post_date do |t, args|
  FileUtils.mkdir_p "#{DRAFTS}" unless File.exists? "#{DRAFTS}/"
  title = args[:title] ? args[:title] : "My Blog Post"
  post_date = args[:post_date] ? Date.parse(args[:post_date]).strftime(DATE_FORMAT) : NOW
  preps = prep_file post_date, title
  filename = preps[:filename]
  content = preps[:content]
  filename_path = "#{DRAFTS}/#{filename}"
  raise "The file: #{filename} already exists." if File.exists? filename_path
  File.write filename_path, content
  puts "Draft blog post created: #{filename}"
end

def prep_file(post_date, title)
  extension = CONFIG["post"]["extension"]
  output = ["---"]
  output << "title: #{title}"
  output << "layout: post"
  output << "published: true"
  output << "abstract: |"
  output << "  Abstract goes here..."
  output << "writer:"
  output << "  name: YOUR_NAME"
  output << "  url: YOUR_HOME_URL"
  output << "---"
  return {
    filename: "#{post_date}-#{title.to_url}.#{extension}",
    content: output.join("\n")
  }
end




