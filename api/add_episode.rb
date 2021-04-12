require_relative '../lib/app'

def handler
  start_time = Time.now.to_f

  name = params['name'] || 'Big Bang Theory'

  show = Show.find_or_create_by!(name: name)

  Episode.create!(show: show, name: "ep:#{rand(1..1000)}")

  json = { show: show, episodes: show.episodes.to_a }

  delta = Time.now.to_f - start_time
  response.headers['X-Timing-Ms'] = delta.to_s

  render json: json
end

init_handler
