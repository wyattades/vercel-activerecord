require_relative '../lib/app'

def handler
  name = params['name'] || 'Big Bang Theory'

  show = Show.find_or_create_by!(name: name)

  show.episodes.destroy_all

  render json: { show: show, episodes: show.episodes.to_a }
end

init_handler
