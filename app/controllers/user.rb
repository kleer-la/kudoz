Kudoz::App.controllers :user do
  
  get :callback, :map => '/auth/:provider/callback' do
     
     provider = params[:provider]
     auth = request.env['omniauth.auth']
     
     user = User.find_for_omniouth( provider, auth )
     
     if !user.nil?
       session[:my_user_id] = user.id
       
       if user.needs_initialization
         redirect_to "/user/initialize"
       else
         redirect_to "/"
       end
       
     else
     end

   end

   get :failure, :map => '/auth/failure' do
     content_type 'text/plain'
     request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
   end
   
   get :logout, :map => '/auth/log_out' do
     session[:my_user_id] = nil
     redirect_to "/"
   end
   
   get :initialize, :map => '/user/initialize' do
     @my_user = User.find_by_id( session[:my_user_id] )

     if !@my_user.nil?
       render 'user/initialize', :layout => :initialize
     end
   end
   
   put :initial_update do
     @my_user = User.find_by_id( session[:my_user_id] )

     team = Team.find_by_id( params[:team_id] )

     if !team.nil?
       if @my_user.teams.include?( team )
         team.update_attributes!( params[:team] )
         @my_user.update_attributes!( :needs_initialization => false )
         redirect_to "/"
       end
     end

   end

end
