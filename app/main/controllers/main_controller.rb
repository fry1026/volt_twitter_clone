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
        .then{page._headline_body = ''}
        .fail{|err| add_error(err)}
    end

    def add_error(err)
      err.each{|k,v| flash._errors.create "#{k}: #{v.join('.')}"}
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
