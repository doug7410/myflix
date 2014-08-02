Fabricator(:queue_item) do
  list_order {user.queue_items.size + 1}
  user
  video
end