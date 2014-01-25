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
  
  get :show, :map => '/accounts/:id/show' do
    @my_user = User.find_by_id( session[:my_user_id] )
    
    @account = Account.find_by_id( params[:id] )
    
    render 'accounts/show'
  end

  put :deposit, :map => '/accounts/:id/deposit' do
    
    @my_user = User.find_by_id( session[:my_user] )
    
    @account = Account.find_by_id( params[:id] )
    
    if !@account.nil?
    
      @transfer = Transfer.new(params[:transfer])
      @transfer.origin = @my_account
      @transfer.destination = @account
      @transfer.save!
      
      @transfer.execute!
      
      email(
        :from => "koinz@kleer.la", 
        :to => @transfer.destination.email, 
        :subject => "Koinz deposit from #{@transfer.origin.name}!", 
        :body=>"You've received #{@transfer.ammount} Koinz from #{@transfer.origin.name}: '#{@transfer.message}'"
      )
    
    end
    
    render 'accounts/show'
  end
end
