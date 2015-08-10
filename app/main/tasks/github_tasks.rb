require 'httparty'
class GithubTasks < Volt::Task
  def get_commits
    #TODO: cover connection problems
    response = HTTParty.get('https://api.github.com/repos/fry1026/volt_twitter_clone/commits',:verify => false)
    commits = response.map do |item|
     [item['commit']['message'],item['html_url'], item['commit']['author']['name'],item['commit']['author']['date']]
    end
    commits
  end
end