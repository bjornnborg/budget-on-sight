json.array!(@categories) do |category|
  json.extract! category, :id, :type, :description, :group, :value, :frequency, :active
  json.url category_url(category, format: :json)
end
