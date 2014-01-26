Kudoz::App.controllers :team do
  
  get :show, :map => '/teams/:id' do

    @my_user = User.find_by_id( session[:my_user_id] )
    @team = Team.find_by_id( params[:id] )
    
    render 'team/show', :layout => :application
  end

end
