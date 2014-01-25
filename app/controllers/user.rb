Kudoz::App.controllers :user do
  
  get :callback, :map => '/auth/:provider/callback' do
     
     provider = params[:provider]
     auth = request.env['omniauth.auth']
     
     user = User.find_for_omniouth( provider, auth )
     
     if !user.nil?
       session[:my_user_id] = user.id
     end
     
     redirect_to "/"

   end

   get :failure, :map => '/auth/failure' do
     content_type 'text/plain'
     request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
   end
   
   get :logout, :map => '/auth/log_out' do
     session[:my_user_id] = nil
     redirect_to "/"
   end
  

end
