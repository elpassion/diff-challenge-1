repo_url, *the_rest = ARGV
timeout = ENV.fetch('TIMEOUT', 60)
timeout = timeout.to_i
branch = ENV.fetch('BRANCH', 'master')
solutions_dir = "solutions"
puts "timeout: #{timeout}"
puts "repo_url: #{repo_url}"

def execute(command)
  puts command
  system command
end

raise 'repo url must start with "git@"' unless repo_url.start_with?('git@')
dir_name = repo_url.split(':').last
repo_name = dir_name.split('/').last
repo_name = repo_name.gsub('.git', '')
dir_name = dir_name.gsub('/', '-')
repo_dir = "./#{solutions_dir}/#{dir_name}/#{repo_name}"
puts "repo_dir: #{repo_dir}"

commands = [
  "cd #{solutions_dir}",
  "rm -rf ./#{dir_name}",
  "mkdir #{dir_name}",
  "cd #{dir_name}",
  #"git clone #{repo_url} --depth=1",
  "git clone #{repo_url}",
  "cd #{repo_name}",
  "git fetch && git checkout #{branch}",
  ]
execute(commands.join(' && '))

commands = [
  "cp #{repo_dir}/spec/endpoints.rb spec/endpoints.rb",
  "cd #{repo_dir}/my_app",
  'chmod +x ./start.sh',
  './start.sh &',
]
execute(commands.join(' && '))

puts 'Waiting for server to start...'
timeout.downto(1).each do |n|
  puts "Tests will start in #{n}... "
  sleep 1
end

commands = [
  "cd #{repo_dir} && DC_SHA=$(git log -1 --format=format:%H) && cd #{File.expand_path File.dirname(__FILE__)}",
  "rspec spec --format html --out #{solutions_dir}/#{dir_name}/results_$DC_SHA.html"
]
execute(commands.join(' && '))

commands = [
  'git checkout spec/endpoints.rb'
]
execute(commands.join(' && '))
