Kudoz::App.controllers :user do

   get :callback, :map => '/auth/:provider/callback' do

     provider = params[:provider]
     auth = request.env['omniauth.auth']

#     puts auth.to_hash.inspect

#     if provider == "google_oauth2" || provider == "twitter"
       auth = request.env['omniauth.auth']
       invite_uuid = request.env['omniauth.params']['invite']
       fwd = request.env['omniauth.params']['fwd']

       invite = invite_uuid.nil? ? nil : Invite.where("uuid = ?", invite_uuid).first

       user = OmniAuthService.find_for_omniauth( provider, auth, invite )

       if !user.nil?
         session[:my_user_id] = user.id

         if !invite.nil?
           new_account = user.accounts.select { |account| account.team = invite.team }.first

            invite.team.accounts.each do |account|
              if !account.user.email.nil? && account.user.email != ""
                NotificationHelper.notify_new_joiner(new_account, account, request.host_with_port) unless new_account.user.id == account.user.id
              end
            end
         end

         if user.needs_initialization
           redirect_to "/user/initialize"
         elsif !invite.nil?
           redirect_to "/teams/#{invite.team.id}"
         elsif !fwd.nil? && fwd != "/"
           redirect_to fwd
         elsif user.accounts.size == 1
           redirect_to "/teams/#{user.accounts.first.team.id}"
         else
           redirect_to "/"
         end

       end

#    end

   end

   get :failure, :map => '/auth/failure' do
     content_type 'text/plain'
     request.env['omniauth.auth'].to_hash.inspect rescue "No Data: #{request.env['omniauth.auth'].to_hash.inspect}"
   end

   get :logout, :map => '/auth/log_out' do
     session[:my_user_id] = nil
     redirect_to "/"
   end

   get :initialize, :map => '/user/initialize' do
     @my_user = User.find_by_id( session[:my_user_id] )

     if !@my_user.nil?

       if @my_user.email == ""
         render 'user/initialize_email', :layout => :initialize
       else
         render 'user/initialize_team', :layout => :initialize
       end

     end
   end

   put :initial_team_update do
     @my_user = User.find_by_id( session[:my_user_id] )

     team = Team.find_by_id( params[:team_id] )

     if !team.nil?
       if @my_user.teams.include?( team )
         team.update_attributes!( params[:team] )
         @my_user.update_attributes!( :needs_initialization => false )
         if @my_user.accounts.size == 1
            redirect_to "/teams/#{@my_user.accounts.first.team.id}"
         else
           redirect_to "/"
         end
       end
     end

   end

   put :initial_email_update do
      @my_user = User.find_by_id( session[:my_user_id] )

      if !@my_user.nil?
        @my_user.update_attributes!( params[:user] )
        if @my_user.teams.first.name != "My Initial Team"
          @my_user.update_attributes!( :needs_initialization => false )
          if @my_user.accounts.size == 1
              redirect_to "/teams/#{@my_user.accounts.first.team.id}"
           else
             redirect_to "/"
           end
        else
          redirect_to "/user/initialize"
        end
      end

    end

    get :mood_happy, :provides => :js, :map => "/user/mood/happy.js" do
      @my_user = User.find_by_id( session[:my_user_id] )

      if !@my_user.nil?
        @my_user.update_attributes!( :mood => "happy" )
        "$( '#moodlink' ).attr('style', 'background-color: rgb(135, 184, 127);');" +
        "$( '#moodicon' ).removeClass('icon-meh');" +
        "$( '#moodicon' ).removeClass('icon-frown');" +
        "$( '#moodicon' ).addClass('icon-smile');"
      end
    end

    get :mood_meh, :provides => :js, :map => "/user/mood/meh.js" do
      @my_user = User.find_by_id( session[:my_user_id] )

      if !@my_user.nil?
        @my_user.update_attributes!( :mood => "meh" )
        "$( '#moodlink' ).attr('style', 'background-color: rgb(255, 183, 82);');" +
        "$( '#moodicon' ).removeClass('icon-smile');" +
        "$( '#moodicon' ).removeClass('icon-frown');" +
        "$( '#moodicon' ).addClass('icon-meh');"
      end
    end

    get :mood_annoyed, :provides => :js, :map => "/user/mood/annoyed.js" do
      @my_user = User.find_by_id( session[:my_user_id] )

      if !@my_user.nil?
        @my_user.update_attributes!( :mood => "annoyed" )
        "$( '#moodlink' ).attr('style', 'background-color: rgb(209, 91, 71);');" +
        "$( '#moodicon' ).removeClass('icon-meh');" +
        "$( '#moodicon' ).removeClass('icon-smile');" +
        "$( '#moodicon' ).addClass('icon-frown');"
      end
    end
end
