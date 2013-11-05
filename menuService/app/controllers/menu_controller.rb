class MenuController < ApplicationController

  def show
  	#  params[:id] expected to be building code:  e.g., "SHAN"
    @menu = Menu.find(params[:id])

  end
end
