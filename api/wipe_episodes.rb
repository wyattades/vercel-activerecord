require_relative '../lib/app'

Handler =
  Proc.new do |req, res|
    name = req.query['name'] || 'Big Bang Theory'

    show = Show.find_or_create_by!(name: name)

    show.episodes.destroy_all

    json = { show: show, episodes: show.episodes.to_a }

    res.status = 200
    res['Content-Type'] = 'application/json; charset=utf-8'
    res.body = json.to_json
  end
