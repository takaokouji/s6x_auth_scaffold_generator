# coding: utf-8
require 'test_helper'

class <%= @user_model_name %>Test < ActiveSupport::TestCase
  fixtures :<%= @users_table_name %>
  
  test "同じログインIDは指定できない" do
    # 新規作成
    assert_raise(ActiveRecord::RecordInvalid) do
      <%= @user_model_name %>.create!(login: "<%= @user_instance_name %>001", password: "password")
    end

    # 更新
    assert_raise(ActiveRecord::RecordInvalid) do
      <%= @user_instance_name %> = <%= @users_table_name %>(:<%= @user_instance_name %>001)
      <%= @user_instance_name %>.login = "admin"
      <%= @user_instance_name %>.save!
    end
  end
  
  test "authenticateを使った認証" do
    assert_equal(true, <%= @users_table_name %>(:admin).authenticate("admin"))
    assert_equal(false, <%= @users_table_name %>(:admin).authenticate("<%= @user_instance_name %>001"))

    assert_equal(true, <%= @users_table_name %>(:<%= @user_instance_name %>001).authenticate("<%= @user_instance_name %>001"))
    assert_equal(false, <%= @users_table_name %>(:<%= @user_instance_name %>001).authenticate("admin"))
  end
end
