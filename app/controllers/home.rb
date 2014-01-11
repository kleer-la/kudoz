Kudoz::App.controllers :home do
  
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
  
  get :index, :map => '/' do
    @transactions = Transfer.order("created_at DESC")
    @my_account = Account.find_by_id( session[:my_account_id] )
    
    if !@my_account.nil?
      @accounts = Account.order("balance DESC")
    end
    
    render 'home/index', :layout => :application
  end

end
