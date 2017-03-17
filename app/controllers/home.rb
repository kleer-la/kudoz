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

    @my_user = User.find_by_id( session[:my_user_id] ) unless session[:my_user_id].nil?

    if @my_user.nil?
      session[:invite_uid] = params[:my_user_id]
    else
      @teams = @my_user.teams
      @visible_transactions = @my_user.visible_transactions
    end

    render 'home/index', :layout => :application
  end

end
