---@diagnostic disable: lowercase-global, redundant-parameter, undefined-global
WIDTH_SCREEN = 320
HEIGHT_SCREEN = 480;
MAX_METEOROS = 12;
pontuacao = 0
timer = 0
aviao={
    scr = "imagens/nave.png",
    height = 63,
    width = 55,
    tiros={},
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
        love.timer.step(5)
        somDestruicao:play()
        aviao.height = 77
        aviao.width = 67
    end
    
        
    
}
atirar = function()
    somTiro:play()
    local tiro = {
        x = aviao.x + aviao.width/2 -2,
        y = aviao.y,
        width = 16,
        height = 16
    }
    table.insert(aviao.tiros,tiro)
    
end
moveTiro = function()
    for i = #aviao.tiros, 1, -1 do
        if aviao.tiros[i].y>0 then
            aviao.tiros[i].y = aviao.tiros[i].y - 4
        else
            table.remove(aviao.tiros,i)
        end
    end
end
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
trocaMusica = function ()
    somAmbiente:stop()
    somGameOver:play()
end
temColisao = function (x1,y1,w1,h1,x2,y2,w2,h2)
    return x2 < x1 + w1 and
           x1 < x2 + w2 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end
checaColisaoAviao = function ()
    for k, meteoro in pairs(meteoros) do
        if temColisao(meteoro.x,meteoro.y,meteoro.width,meteoro.height,aviao.x,aviao.y,aviao.width,aviao.height)then
            aviao.destroiAviao();
            trocaMusica()
            FIM_JOGO = true;
        end
    end
end
checaColisaoTiro = function()
    for i = #aviao.tiros,1,-1 do
        for j=#meteoros,1,-1 do
            if temColisao(meteoros[j].x,meteoros[j].y,meteoros[j].width,meteoros[j].height,aviao.tiros[i].x,aviao.tiros[i].y,aviao.tiros[i].width,aviao.tiros[i].height)then
                table.remove(aviao.tiros,i)
                table.remove(meteoros,j)
                pontuacao = pontuacao+1
                break
            end
            
        end
    end
end
checaColisao = function ()
    checaColisaoAviao()
    checaColisaoTiro()
    
end
checaObjetivo = function ()
    if pontuacao == 10 then
        VENCEDOR=true
        somVencedor:play();
        somAmbiente:stop();
    end
    
end
restart = function()
    pontuacao = 0
    timer=0
    somAmbiente:stop()
    somDestruicao:stop()
    somGameOver:stop()
    somTiro:stop()
    somVencedor:stop()
    somAmbiente:play()
    for i=#meteoros,1,-1 do
        table.remove(meteoros,i)
    end
    for i=#aviao.tiros,1,-1 do
        table.remove(aviao.tiros,i)
    end
    
    aviao.x=WIDTH_SCREEN/2 - 60/2
    aviao.y=HEIGHT_SCREEN - 50
    VENCEDOR = false
    FIM_JOGO = false
    aviao.scr = "imagens/nave.png"
    aviao.imagem = love.graphics.newImage(aviao.scr)
    aviao.height = 63
    aviao.width = 55
end
function love.load()
    --configs gerais
    math.randomseed(os.time())
    love.window.setMode(WIDTH_SCREEN,HEIGHT_SCREEN , {resizable = false})
    love.window.setTitle("O Jogo")
    --imagens
    background = love.graphics.newImage("imagens/background.png")
    aviao.imagem = love.graphics.newImage(aviao.scr)
    meteoroImagem = love.graphics.newImage("imagens/meteoro.png")
    tiroImagem = love.graphics.newImage("imagens/tiro.png")
    gameOverImagem = love.graphics.newImage("imagens/gameover.png")
    vencedorImagem = love.graphics.newImage("imagens/vencedor.png")
    
    --sons
    somAmbiente = love.audio.newSource("audios/ambiente.wav","static")
    somGameOver = love.audio.newSource("audios/game_over.wav","static")
    somDestruicao = love.audio.newSource("audios/destruicao.wav","static")
    somTiro = love.audio.newSource("audios/disparo.wav","static")
    somVencedor = love.audio.newSource("audios/winner.wav","static")


    somAmbiente:setLooping(true)
    somAmbiente:play()

end

-- Increase the size of the rectangle every frame.
function love.update(dt)
    if not FIM_JOGO and not VENCEDOR then
        if love.keyboard.isDown('w','a','s','d','up','down','left','right') then
            aviao.moveAviao();
        end
        removeMeteoro();
        if #meteoros < MAX_METEOROS then
            criaMeteoro();
        end
        timer = timer+1;
        moveTiro();
        moveMeteoro();
        checaColisao();
        checaObjetivo();
    end
end
function love.keypressed(tecla)             

    if tecla == "escape" then
        love.event.quit()
    end
    if tecla == "space" then
        if #aviao.tiros <1 then
         atirar()
         timer=0
        else    
              if timer>=25 then
                  atirar()
                  timer=0
              end
        end
        
        
    end
    if tecla == "r"then
        restart()
        
    end
end
-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(background , 0 , 0)
    
    love.graphics.draw(aviao.imagem , aviao.x , aviao.y )
    love.graphics.print("Pontuação: "..pontuacao,0,0)
    love.graphics.print("Esc - SAIR ",236,0)
    love.graphics.print("R - REINICIAR ",236,13)
    

    for i, meteoro in pairs(meteoros) do
        love.graphics.draw(meteoroImagem , meteoro.x , meteoro.y)
    end
    for i, tiro in pairs(aviao.tiros) do
        love.graphics.draw(tiroImagem , tiro.x , tiro.y)
    end
    if FIM_JOGO then
        love.graphics.draw(gameOverImagem, WIDTH_SCREEN/2 - gameOverImagem:getWidth()/2, HEIGHT_SCREEN/2-gameOverImagem:getHeight()/2)
        
    end
    if VENCEDOR then
        love.graphics.draw(vencedorImagem, WIDTH_SCREEN/2 - vencedorImagem:getWidth()/2, HEIGHT_SCREEN/2-vencedorImagem:getHeight()/2)
    end
    
end