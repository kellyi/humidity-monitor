class HomeController < ApplicationController
  def show
    render html: '<p>hello world</p>'.html_safe
  end
end
