class TweetsController < ApplicationController
  
  get '/tweets' do
    if Helpers.is_logged_in?(session)
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else
      redirect to '/login'
    end
  end
  
  get '/tweets/new' do
    if Helpers.is_logged_in?(session)
      erb :'tweets/new'
    else
      redirect to '/login'
    end
  end
  
  get '/tweets/:id' do
    if Helpers.is_logged_in?(session)
      @tweet = Tweet.find_by_id(params[:id])
    else
      redirect to '/login'
    end
    erb :'tweets/show_tweet'
  end
  
  post '/tweets' do
    @user = Helpers.current_user(session)
    if (params.has_value?(""))
      redirect to '/tweets/new'
    elsif !params.empty?
      @tweet = Tweet.create(:content => params["content"])
      @user = User.find_by(params[:id])
      @tweet.user_id = @user.id
      @tweet.save
      @user.tweets << @tweet
    end
    redirect to "/tweets/#{@tweet.id}"
  end
  
  delete '/tweets/:id/delete' do
    @tweet = Tweet.find_by_id(params[:id])
    if @tweet.user != Helpers.current_user(session)
      redirect to '/tweets'
    end
    if Helpers.is_logged_in?(session)
      if @tweet.user_id == Helpers.current_user.id
        @tweet.destroy
        redirect to '/tweets'
      end
    else
    redirect to '/login'
    end
  end
  
  get '/tweets/:id/edit' do
    if Helpers.is_logged_in?(session)
      @tweet = Tweet.find_by_id(params[:id])
    else
      redirect to '/login'
    end
    erb :'tweets/edit_tweet'
  end
  
  patch '/tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])
    if @tweet.user != Helpers.current_user(session)
      redirect to '/tweets'
    end
    if !(params.has_value?(""))
      @tweet.update(content: params["content"])
      @tweet.save
     else
      redirect to "/tweets/#{@tweet.id}/edit"
    end
    redirect to "/tweets/#{@tweet.id}"
  end

end
