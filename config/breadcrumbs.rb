crumb :root do
  link 'トップ', root_path
end

crumb :events do
  link 'イベント一覧', events_path
end

crumb :payments do
  link '支払一覧', payments_path
end

crumb :new_event do |event|
  link 'イベント作成', events_path(event)
  parent :events
end

crumb :show_event do |event|
  link 'イベント詳細', event_path(event)
  parent :events
end

crumb :edit_event do |event|
  link 'イベント編集', edit_event_path(event)
  parent :show_event, event
end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
