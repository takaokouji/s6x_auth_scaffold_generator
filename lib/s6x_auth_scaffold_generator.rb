# coding: utf-8
# 認証まわりのソースコードを自動生成するscaffoldの+s6x_auth_scaffold+。
# 現状、Rubyは1.9.2-p290、Railsは3.0.10を対象とする。
# また、メインのplatformはWindows。

require 'rails/generators'
require 'rails/generators/named_base'
require 'rails/generators/active_record/migration'

class S6xAuthScaffoldGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration
  extend ActiveRecord::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  class_option :root_to, default: "welcome#index", desc: "「root :to =>」に指定する文字列", aliases: "r"

  def parse_options
    @user_model_name = file_name.camelize
    @user_model_file_name = file_name.underscore
    @user_instance_name = file_name.underscore
    @users_table_name = file_name.underscore.pluralize
  end

  def create_users_migration
    migration_template "db/migrate/create_users.rb", "db/migrate/create_#{@users_table_name}.rb"
  rescue Rails::Generators::Error => e
    if options[:skip]
      puts e.message
    else
      raise
    end
  end
  
  def create_user_model
    template "app/models/user.rb", "app/models/#{@user_model_file_name}.rb"
    template "test/unit/user_test.rb", "test/unit/#{@user_model_file_name}_test.rb"
    template "test/fixtures/users.yml", "test/fixtures/#{@users_table_name}.yml"
  end

  def create_sessions_controller
    template "app/controllers/sessions_controller.rb"
    template "test/functional/sessions_controller_test.rb"
    copy_file "app/views/sessions/login.html.erb"
    template "app/helpers/sessions_helper.rb"
  end

  def add_routes
    route('match "login" => "sessions#login"')
    route('match "logout" => "sessions#logout"')
    route(%Q'root :to => "#{options[:root_to]}"')
  end

  def edit_application_controller
    method_name = "current_#{@user_instance_name}"
    dest_path = "app/controllers/application_controller.rb"
    if ApplicationController.public_method_defined?(method_name.to_sym)
      msg = "ApplicationController is already defined #{method_name} method: #{dest_path}"
      if options[:skip]
        puts msg
      else
        raise Rails::Generators::Error, msg
      end
    else
      inject_into_class(dest_path, ApplicationController, "
  # ログイン中のユーザを返す。
  def #{method_name}
    if session[:#{@user_instance_name}_id]
      @current_#{@user_instance_name} ||= #{@user_model_name}.find(session[:#{@user_instance_name}_id])
    end
    return @current_#{@user_instance_name}
  end
    
  helper_method :current_#{@user_instance_name}

".force_encoding("ASCII-8BIT")) # NOTE: force_encoding("ASCII-8BIT")はThorのバグを回避するため。
    end
  end
end
