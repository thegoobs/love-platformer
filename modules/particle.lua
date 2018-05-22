local particle = {}
particle.smoke = {}
particle.smoke.img = love.graphics.newImage("smoke_particle.png")
particle.smoke.system = love.graphics.newParticleSystem(particle.smoke.img, 8)
particle.smoke.system:setParticleLifetime(0.25,1)
particle.smoke.system:setEmissionRate(5)
particle.smoke.system:setSizeVariation(0)
particle.smoke.system:setLinearAcceleration(-150, -150, 150, 0) -- Random movement in all directions.
particle.smoke.system:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.

return particle