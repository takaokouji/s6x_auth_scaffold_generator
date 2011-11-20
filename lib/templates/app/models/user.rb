# coding: utf-8
require 'securerandom'
require 'digest/sha1'

# ユーザを表現する。
class <%= @user_model_name %> < ActiveRecord::Base
  attr_accessor :password

  attr_accessible :login, :password
  
  validates_presence_of :login
  validates_uniqueness_of :login
  # validates_length_of :login, within: 3..40

  validates_presence_of :password, on: :create
  # validates_length_of :password, within: 5..40
  
  # パスワードの確認を行う場合は以下のコメントをはずす。
  # attr_accessor :password_confirmation
  # validates_confirmation_of :password
  # validates_presence_of :password_confirmation, on: :create

  before_save do
    if @password
      if !self.salt?
        self.salt = random_string(10)
      end
      self.password_digest = digest(@password, self.salt)
    end
  end
  
  # パスワード+password+で認証する。認証に成功した場合trueを返す。失敗した場合はfalseを返す。
  # 使用例)
  #   <%= @user_instance_name %> = <%= @user_model_name %>.find_by_login(params[:login])
  #   if <%= @user_instance_name %>.authenticate(params[:password])
  #     # 認証に成功した場合の処理。
  #   else
  #     # 認証に失敗した場合の処理。
  #   end
  def authenticate(password)
    return digest(password, salt) == password_digest
  end

  private
  
  # ランダムな文字列を生成します。
  # Deviseライブラリのdevise/lib/devise.rbのDevise.friendly_tokenメソッドの実装を使っています。
  # http://blog.plataformatec.com.br/tag/devise/
  def random_string(length)
    return SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')[0, length]
  end
  
  # パスワード+password+とランダムな文字列+salt+から、パスワード認証のためのハッシュ値を求める。
  def digest(password, salt)
    return Digest::SHA1.hexdigest(password + salt)
  end
end
