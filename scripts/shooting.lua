function createShooting(name, fireRate)
    local shooting = {}
    shooting.canShoot = true
    shooting.inShoot = false
    shooting.shootTimer = 0
    shooting.fireRate = fireRate
    require("scripts/bullet")
    shooting.bullets = createBullets(name)

    function shooting.shoot(obj, style, yOffset)

        if style == 3 then
            shooting.shoot3(obj, yOffset)
        elseif style == 2 then
            shooting.shoot2(obj, yOffset)
        else
            shooting.shoot1(obj, yOffset)
        end
    end

    function shooting.shoot1(obj, y)
        local bulletSize = shooting.bullets.size
        shooting.bullets.createBullet(
            obj.collider.x + obj.collider.w / 2 + obj.collider.w / 2 * obj.lookDir - bulletSize.x, 
            obj.collider.y + obj.collider.h / 2 + bulletSize.y / 2 - y, createVec(obj.lookDir, 0))
        shooting.canShoot = false
        shooting.inShoot = true
    end

    function shooting.shoot2(obj, y)
        local bulletSize = shooting.bullets.size
        shooting.bullets.createBullet(
            obj.collider.x + obj.collider.w / 2 + obj.collider.w / 2 * obj.lookDir - bulletSize.x, 
            obj.collider.y + obj.collider.h / 2 - bulletSize.y / 2 - y, createVec(obj.lookDir, 0))

            shooting.bullets.createBullet(
            obj.collider.x + obj.collider.w / 2 + obj.collider.w / 2 * obj.lookDir - bulletSize.x, 
            obj.collider.y + obj.collider.h / 2 + bulletSize.y * 1.5, createVec(obj.lookDir, 0))
        shooting.canShoot = false
        shooting.inShoot = true
    end

    function shooting.shoot3(obj, y)
        local bulletSize = shooting.bullets.size
        shooting.bullets.createBullet(
            obj.collider.x + obj.collider.w / 2 + obj.collider.w / 2 * obj.lookDir - bulletSize.x, 
            obj.collider.y + obj.collider.h / 2 - bulletSize.y * 1.5 - y, createVec(obj.lookDir, 0))

            shooting.bullets.createBullet(
            obj.collider.x + obj.collider.w / 2 + obj.collider.w / 2 * obj.lookDir - bulletSize.x, 
            obj.collider.y + obj.collider.h / 2 + bulletSize.y / 2 - y, createVec(obj.lookDir, 0))
            
            shooting.bullets.createBullet(
                obj.collider.x + obj.collider.w / 2 + obj.collider.w / 2 * obj.lookDir - bulletSize.x, 
                obj.collider.y + obj.collider.h / 2 + bulletSize.y * 2.5, createVec(obj.lookDir, 0))
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