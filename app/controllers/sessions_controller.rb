class SessionsController < ApplicationController

  def new
    redirect_to '/auth/github'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth['provider'],
                      :uid => auth['uid'].to_s).first || User.create_with_omniauth(auth)
    user.fill_missing_omniauth(auth)
    reset_session
    session[:user_id] = user.id

    page = request.env['omniauth.origin'] || root_url
    redirect_to page, :notice => '已登录！'
  end

  def destroy
    reset_session
    if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back, :notice => '已注销！'
    else
      redirect_to root_url, :notice => '已注销！'
    end
  end

  def failure
    redirect_to root_url, :alert => "认证失败：#{params[:message].humanize}"
  end

end
