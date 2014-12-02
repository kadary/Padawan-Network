class NavigationController < ApplicationController
	before_filter :update_statusstreams, :only => [:accueil, :refreshstatus]
  def accueil
  end
  
  def votedup
		@status = Status.find(params[:id])
		@status.ups=@status.ups+1
		@status.save
		render :text => "<div class='up'></div>"+@status.ups.to_s+" j'aime"
  end
  def voteddown
		@status = Status.find(params[:id])
		@status.downs=@status.downs+1
		@status.save
		render :text => "<div class='down'></div>"+@status.downs.to_s+" j'aime pas"
  end
	
  def refreshstatus
		render :partial => 'statuses.html.erb', :locals => { :statuses_streams => @statuses_streams }
  end

  protected
  def update_statusstreams
	@statuses_streams = Status.order('created_at DESC').all
  end
end
