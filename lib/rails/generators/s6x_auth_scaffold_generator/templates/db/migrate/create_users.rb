# coding: utf-8
# <%= @users_table_name %>テーブルを作成する。
# loginカラムはログインに使用するIDを格納する。
# password_digestカラムはパスワードとsaltカラムを元に生成したハッシュ値を格納する。
# saltカラムはパスワードからハッシュ値を求めるときに使うランダムな値を格納する。
class Create<%= @users_table_name.camelize %> < ActiveRecord::Migration
  def self.up
    create_table :<%= @users_table_name %> do |t|
      t.string :login, limit: 40
      t.string :password_digest
      t.string :salt

      # ここに名前(name)、ふりがな(furigana)、メールアドレス(email)などを追加します。

      t.timestamps
    end
  end

  def self.down
    drop_table :<%= @users_table_name %>
  end
end
