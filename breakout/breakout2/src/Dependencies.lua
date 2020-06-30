-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'lib/push'


--where all the constants are stored
require 'src.constants'


--the rectangular entity the player controls
require 'src.Paddle'

require 'src.Ball'


--basic state machine class which allows the transition through states
require 'src.StateMachine'


-- utility functions, mainly for splitting our sprite sheet into various Quads
-- of differing sizes for paddles, balls, bricks, etc.
util = require 'src.util'



--the game states
require 'src.states.BaseState'
require 'src.states.StartState'
require 'src.states.PlayState'