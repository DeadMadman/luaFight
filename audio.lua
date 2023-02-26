local audio = {}
audio.sounds = {}

function audio.load()
    audio.music = love.audio.newSource("platformer_level04_loop.ogg", "stream")
	audio.music:play()
	audio.shootSound = love.audio.newSource("Laser_Shoot.wav", "static")
	audio.shootSound:setVolume(0.3)
end

function audio.update()
	if not audio.music:isPlaying( ) then
		love.audio.play( audio.music )
	end
end

function audio.playShootSound()
	love.audio.stop(audio.shootSound)
	audio.shootSound:play()
end
return audio