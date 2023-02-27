function createShooting(name, fireRate)
    local shooting = {}
    shooting.canShoot = true
    shooting.inShoot = false
    shooting.shootTimer = 0
    shooting.fireRate = fireRate
    require("scripts/bullet")
    shooting.bullets = createBullets(name)

    function shooting.shoot(player)
        local bulletSize = shooting.bullets.size
        shooting.bullets.createBullet(
            player.collider.x + player.collider.w / 2 + player.collider.w / 2 * player.lookDir - bulletSize.x, 
            player.collider.y + player.collider.h / 2 - bulletSize.y - 4, createVec(player.lookDir, 0))
        shooting.canShoot = false
        shooting.inShoot = true
    end
    
    function shooting.shootCooldown(dt)
        shooting.shootTimer = shooting.shootTimer + dt
        if shooting.shootTimer >= shooting.fireRate then
            shooting.canShoot = true
            shooting.inShoot = false
            shooting.shootTimer = 0
        end
    end

    function shooting.update(dt)
        if shooting.inShoot then
            shooting.shootCooldown(dt)
        end
        shooting.bullets.update(dt)
    end

    function shooting.draw()
        shooting.bullets.draw()
    end

    return shooting
end