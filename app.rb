require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'



# Routen /
get '/todos' do
  @db = SQLite3::Database.new("db/todos.db")
  @db.results_as_hash = true
  @todos = @db.execute("SELECT * FROM todos")
  id = params[:id].to_i
  name = params[:name]
  desc = params[:desc]
  slim(:index)
end

post("/todos") do
  @db = SQLite3::Database.new("db/todos.db")
  @db.results_as_hash = true
  @todos = @db.execute("SELECT * FROM todos")
  name = params["new_name"]
  desc = params["new_description"]
  @db.execute("INSERT INTO todos(name, desc) VALUES(?,?)",[name,desc])
  redirect("/todos")
end

post("/todos/delete") do
  @db = SQLite3::Database.new("db/todos.db")
  @db.results_as_hash = true
  to_delete = params["name"].to_i
  @db.execute("DELETE FROM todos WHERE id = ?",to_delete)
  redirect("/todos")
end



