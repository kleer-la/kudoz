Kudoz::App.controllers :team do
  
  get :show, :map => '/teams/:id' do

    @my_user = User.find_by_id( session[:my_user_id] )
    @team = Team.find_by_id( params[:id] )
    
    team_member_count = @team.accounts.count
    team_member_happy_count = @team.accounts.select { |account| account.user.mood == "happy" }.count
    team_member_meh_count = @team.accounts.select { |account| account.user.mood == "meh" }.count
    team_member_annoyed_count = @team.accounts.select { |account| account.user.mood == "annoyed" }.count
    
    @team_member_happy_percentage = (team_member_happy_count.to_f / team_member_count.to_f)*100
    @team_member_meh_percentage = (team_member_meh_count.to_f / team_member_count.to_f)*100
    @team_member_annoyed_percentage = (team_member_annoyed_count.to_f / team_member_count.to_f)*100
    
    render 'team/show', :layout => :application
  end
  
  put :invite, :map => '/teams/:id/invite' do
    
    @my_user = User.find_by_id( session[:my_user_id] )
    @team = Team.find_by_id( params[:id] )
    
    invite = Invite.create(params[:invite])
    invite.user = @my_user
    invite.team = @team
    invite.acepted = false
    
    begin
      invite.save!
      deliver(:user, :invitation_email, invite, request.host_with_port )
      flash[:success] = "Invitation sent successfuly!"
    rescue Exception => e
      flash[:error] = e.message
    end
    
    redirect_to "/teams/#{@team.id}"
  end
  
  put :create, :map => '/teams/create' do
    @my_user = User.find_by_id( session[:my_user_id] )
    @team = Team.create( params[:team] )
    @my_user.accounts << Account.create( balance: 100, team: @team )
    redirect_to "/teams/#{@team.id}"
  end
  
  get :accept_invite, :map => '/teams/:team_id/invites/:invite_uuid/accept' do
    invite_uuid = params[:invite_uuid]
    @invite = Invite.where( "uuid = ?", invite_uuid ).first
    
    if !@invite.nil? && !@invite.acepted
      render 'home/index', :layout => :application
    end
  end

end
