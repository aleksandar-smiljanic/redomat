class StoreController < ApplicationController
  @visit_counter_msg = nil
  def index
    @products = Product.order(:title)

    # Add a new variable to the session to record how many times the user has accessed the index action.
    if session[:counter].nil?
      session[:counter]=0
    else
      session[:counter] += 1
    end

    # Display counter only if accessed more than 5 times
    if session[:counter] > 5
      @visit_counter_msg = "Visited #{session[:counter]} times"
    else
      @visit_counter_msg = nil
    end
  end
end
