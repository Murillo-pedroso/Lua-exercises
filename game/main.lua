---@diagnostic disable: lowercase-global, redundant-parameter
WIDTH_SCREEN = 320
HEIGHT_SCREEN = 480;
MAX_METEOROS = 12;
aviao={
    scr = "imagens/nave.png",
    height = 63,
    width = 55,
    x=WIDTH_SCREEN/2 - 60/2,
    y=HEIGHT_SCREEN - 50,
    moveAviao = function()
        if love.keyboard.isDown('w','up') then
            aviao.y = aviao.y - 2;
        end
        if love.keyboard.isDown('s','down')then
            aviao.y = aviao.y + 2;
        end
        if love.keyboard.isDown('a','left') then
            aviao.x = aviao.x - 2;
        end
        if love.keyboard.isDown('d','right') then
            aviao.x = aviao.x + 2;
        end
    end,
    destroiAviao = function ()
        aviao.scr = "imagens/explosao_nave.png"
        aviao.imagem = love.graphics.newImage(aviao.scr)
        aviao.height = 77
        aviao.width = 67
    end
        
    
}
meteoros = {}
criaMeteoro = function ()
    meteoro = {
        x = math.random(WIDTH_SCREEN),
        y = -70,
        width = 50,
        height = 44,
        peso = math.random(3),
        deslocamentoHorizontal = math.random(-1,1);
    }
    table.insert(meteoros , meteoro)
end
moveMeteoro  = function ()
    for k, meteoro in pairs(meteoros) do
        meteoro.y = meteoro.y+ meteoro.peso
        meteoro.x = meteoro.x + meteoro.deslocamentoHorizontal
    end
end
removeMeteoro = function() 
    for i = #meteoros , 1 , -1 do
        if meteoros[i].y > HEIGHT_SCREEN then
            table.remove(meteoros,i)
        end
    end

    
end
temColisao = function (x1,y1,w1,h1,x2,y2,w2,h2)
    return x2 < x1 + w1 and
           x1 < x2 + w2 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end
checaColisao = function ()
    for k, meteoro in pairs(meteoros) do
        if temColisao(meteoro.x,meteoro.y,meteoro.width,meteoro.height,aviao.x,aviao.y,aviao.width,aviao.height)then
            aviao.destroiAviao();
            FIM_JOGO = true;
        end
    end
    
end
function love.load()
    math.randomseed(os.time())
    love.window.setMode(WIDTH_SCREEN,HEIGHT_SCREEN , {resizable = false})
    love.window.setTitle("O Jogo")
    background = love.graphics.newImage("imagens/background.png")
    aviao.imagem = love.graphics.newImage(aviao.scr)
    meteoroImagem = love.graphics.newImage("imagens/meteoro.png")
    x, y, w, h = 20, 20, 60, 20
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
    if not FIM_JOGO then
        if love.keyboard.isDown('w','a','s','d','up','down','left','right') then
            aviao.moveAviao();
        end
        removeMeteoro();
        if #meteoros < MAX_METEOROS then
            criaMeteoro();
        end
        
        moveMeteoro();
        checaColisao();
    end
end

-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(background , 0 , 0)
    
    love.graphics.draw(aviao.imagem , aviao.x , aviao.y )
    for i, meteoro in pairs(meteoros) do
        love.graphics.draw(meteoroImagem , meteoro.x , meteoro.y)
    end

    
end