-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'lib/push'


--where all the constants are stored
require 'src.constants'


--basic state machine class which allows the transition through states
require 'src.StateMachine'



--the game states
require 'src.states.BaseState'
require 'src.states.StartState'