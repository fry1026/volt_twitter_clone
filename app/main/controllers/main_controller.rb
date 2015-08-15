# By default Volt generates this controller for your Main component
module Main
  class MainController < Volt::ModelController
    # model :store
    def index
      # Add code for when the index view is loaded

    end

    def about
      # 
    end

    def show_commits
      GithubTasks.get_commits
      .then do |commits|
        page._list_commits = commits
      end.fail do |error|
        page._list_commits = error
      end
    end

    def show_headline_details(index)
      page._headline_details_visible = true
      params._index = index
    end

    def hide_headline_details
      page._headline_details_visible = false
    end

    def current_headline
      store._headlines[(params._index || 0).to_i]
    end

    def headlines2
      if page._headline_filter

          user_to_find = page._headline_filter.scan(/@\S*/).map { |r| r[1..-1] }.first
          if user_to_find && user_to_find.length > 0
            headlines = store.headlines.all.value.select{|h| h.user.value.name.include?(user_to_find)}.map{|i| i}
          else
            query = {'$regex' => page._headline_filter || '', '$options' => 'i'}
            headlines = store.headlines.where({'$or' => [{body: query}]})
          end

        else
          headlines = store.headlines.all
        end
      headlines
    end

    def headlines
      query = {'$regex' => page._headline_filter || '', '$options' => 'i'}
      headlines = store.headlines.where({'$or' => [{body: query}]})
      # "sdfsdf @fab1 @sdf asdfasdf".scan( /@\S*/).map{|r| r[1..-1]}
      if page._headline_filter && page._headline_filter.include?('@') && page._headline_filter.length > 1
        puts page._headline_filter.length
        user_to_find = page._headline_filter.scan(/@\S*/).map { |r| r[1..-1] }.first
        headlines = headlines.all.value.map { |h| h if h.user.value.name.include?(user_to_find) }
        #headlines.all.value.each{|h| puts "headline filter "+ h.user.value.name}  # if h.user.value.name.include?users_to_find}
      end
      headlines
    end

    def all_users
      store.users.all.map { |u| u.name }.value
    end

    def age(hl)
      age = ((Time.now - Time.parse(hl.created_at))/60).floor
      if age == 0
        "just now"
      elsif age ==1
        "1 minute ago"
      elsif age < 60
        "#{age} minutes ago"
      elsif (age/60).floor ==1
        "1 hour ago"
      elsif (age/60).floor > 1
        "#{(age/60).floor} hours ago"
      end
    end

    def submit_headline
      store._headlines
      .create(body: page._headline_body)
      .then { page._headline_body = '' }
      .fail { |err| add_error(err) }
    end

    def add_error(err)
      err.each { |k, v| flash._errors.create "#{k}: #{v.join('.')}" }
    end

    private

    # The main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._component, params._controller, and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

    # Determine if the current nav component is the active one by looking
    # at the first part of the url against the href attribute.
    def active_tab?
      url.path.split('/')[1] == attrs.href.split('/')[1]
    end
  end
end
