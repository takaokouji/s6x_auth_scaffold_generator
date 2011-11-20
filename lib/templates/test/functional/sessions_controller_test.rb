# coding: utf-8
require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  fixtures :<%= @users_table_name %>

  def setup
    @request.session = ActionController::TestSession.new      
  end
  
  test "ログイン画面を表示" do
    get :login
    assert_response :success
  end
  
  test "ログイン中にログイン画面を表示しようとするとWelcome画面にリダイレクト" do
    @request.session[:<%= @user_instance_name %>_id] = <%= @users_table_name %>(:admin).id
    get :login
    assert_redirected_to root_url
  end

  test "ログインに成功するとWelcome画面にリダイレクト" do
    post :login, login: "admin", password: "admin"
    assert_redirected_to root_url
  end

  test "ログインに失敗するとログイン画面を表示" do
    post :login, login: "admin", password: "<%= @user_instance_name %>001"
    assert_response :success
  end

  test "ログアウト後はログイン画面にリダイレクト" do
    @request.session[:<%= @user_instance_name %>_id] = <%= @users_table_name %>(:admin).id
    get :logout
    assert_redirected_to login_url
    assert_equal({}, @request.session)
  end
end
