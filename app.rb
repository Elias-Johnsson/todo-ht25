require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'

def db
  return @db if @db
  @db = SQLite3::Database.new("db/todos.db")
  @db.results_as_hash = true
  return @db
end

get('/todos') do
  @items = db.execute("SELECT * FROM todos")
  id = params[:id].to_i
  name = params[:name]
  desc = params[:desc]
  slim(:index)
end

post('/todos') do
  name = params["new_name"]
  desc = params["new_description"]
  db.execute("INSERT INTO todos(name, desc) VALUES(?,?)",[name,desc])
  redirect("/todos")
end

get('/todos/:id/edit') do
  id = params[:id].to_i
  @edited = db.execute("SELECT * FROM todos WHERE id = ?",[id])
  slim(:edit)
end

post('/todos/:id/update') do
  id = params[:id].to_i
  name = params[:name]
  desc = params[:desc]
  db.execute("UPDATE todos SET name= ?, desc=? WHERE id= ?",[name,desc,id])
  redirect('/todos')
end

post('/todos/:id/delete') do
  id = params[:id].to_i
  p id
  db.execute("DELETE FROM todos WHERE id = ?",[id])
  redirect('/todos')
end



