Kudoz::App.controllers :accounts do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  
  get :show, :map => '/teams/:team_id/accounts/:id/show' do
    @my_user = User.find_by_id( session[:my_user_id] )
    @team = Team.find_by_id( params[:team_id] )
    @account = Account.find_by_id( params[:id] )
    
    render 'accounts/show'
  end

  put :deposit, :map => '/teams/:team_id/accounts/:id/deposit' do
    
    @my_user = User.find_by_id( session[:my_user_id] )
    @team = Team.find_by_id( params[:team_id] )
    @account = Account.find_by_id( params[:id] )
    @my_account = @my_user.accounts.select { |account| account.team.id == @team.id }.first
    
    if !@account.nil? && !@my_account.nil?
    
      @transfer = Transfer.new(params[:transfer])
      @transfer.origin = @my_account
      @transfer.destination = @account
      @transfer.save!
      
      begin
        @transfer.execute!
      
        email(
          :from => "koinz@kleer.la", 
          :to => @transfer.destination.user.email, 
          :subject => "Koinz deposit from #{@transfer.origin.user.name}!", 
          :body=>"You've received #{@transfer.ammount} Koinz from #{@transfer.origin.user.name}: '#{@transfer.message}'"
        )
        
      rescue Exception => e
          puts e.message
      end
    
    end
    
    render 'accounts/show'
  end
end
