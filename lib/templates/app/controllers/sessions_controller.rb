# coding: utf-8
# セッションを管理するコントローラ。
class SessionsController < ApplicationController
  skip_before_filter :login_required, only: :login

  # ログイン。
  def login
    if session[:<%= @user_instance_name %>_id]
      redirect_to(root_url, notice: "すでにログインしています。")
    end
    if params[:login] && params[:password]
      <%= @user_instance_name %> = <%= @user_model_name %>.find_by_login(params[:login])
      if <%= @user_instance_name %> && <%= @user_instance_name %>.authenticate(params[:password])
        session[:<%= @user_instance_name %>_id] = <%= @user_instance_name %>.id  
        redirect_to(root_url, notice: "ログインしました。")
      else  
        flash.now.alert = "ログインID、パスワードが間違っています。"
      end
    end
  end
  
  # ログアウト。
  def logout
    reset_session
    redirect_to(login_path, notice: "ログアウトしました。")
  end
end
