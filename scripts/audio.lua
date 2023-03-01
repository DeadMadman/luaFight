local audio = {}
audio.sounds = {}

function audio.load()
    audio.music = love.audio.newSource("audio/platformer_level04_loop.ogg", "stream")
	audio.music:play()
	audio.shootSound = love.audio.newSource("audio/Laser_Shoot.wav", "static")
	audio.shootSound:setVolume(0.3)
	audio.hitSound = love.audio.newSource("audio/Explosion.wav", "static")
	audio.hitSound:setVolume(0.3)
	audio.hitSound:setPitch(1.5)
end

function audio.update()
	if not audio.music:isPlaying() then
		love.audio.play(audio.music)
	end
end

function audio.playShootSound()
	love.audio.stop(audio.shootSound)
	audio.shootSound:play()
end

function audio.playHitSound()
	love.audio.stop(audio.hitSound)
	audio.hitSound:play()
end
return audio