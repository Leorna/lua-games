local sounds = {}

sounds.paddle_hit = love.audio.newSource('sounds/paddle_hit.wav', 'static')
sounds.score = love.audio.newSource('sounds/score.wav', 'static')
sounds.wall_hit = love.audio.newSource('sounds/wall_hit.wav', 'static')

return sounds