Kudoz::App.controllers :team do
  
  get :show, :map => '/teams/:id' do

    @my_user = User.find_by_id( session[:my_user_id] )
    @team = Team.find_by_id( params[:id] )
    
    render 'team/show', :layout => :application
  end
  
  put :invite, :map => '/teams/:id/invite' do
    
    @my_user = User.find_by_id( session[:my_user_id] )
    @team = Team.find_by_id( params[:id] )
    
    invite = Invite.create(params[:invite])
    invite.user = @my_user
    invite.team = @team
    invite.acepted = false
    invite.save!
    
    deliver(:user, :invitation_email, invite, request.host )
    
    render 'team/show', :layout => :application
  end
  
  get :accept_invite, :map => '/teams/:team_id/invites/:invite_uuid/accept' do
    invite_uuid = params[:invite_uuid]
    @invite = Invite.where( "uuid = ?", invite_uuid ).first
    
    if !@invite.nil? && !@invite.acepted
      render 'home/index', :layout => :application
    end
  end

end
