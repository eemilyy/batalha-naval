require "ruby2d"

class Grid
  attr_accessor :message, :message2

  def initialize
    @player1 = [] #array de objetos - quadrados
    @player1Navios = [] #array onde estará mapeado os navios
    @@tipos_navios = { 1 => "submarino", 3 => "navio_encouracado", 4 => "navio_de_guerra", 6 => "porta_avioes" }
    #Tabela de posicoes dos quadrados do tabuleiro, cada quadrado possui 50x50 ------------
    @positions = [[0, 0], [50, 0], [100, 0], [150, 0], [200, 0], [250, 0], [300, 0], [350, 0], [400, 0], [450, 0],
                  [0, 50], [50, 50], [100, 50], [150, 50], [200, 50], [250, 50], [300, 50], [350, 50], [400, 50], [450, 50],
                  [0, 100], [50, 100], [100, 100], [150, 100], [200, 100], [250, 100], [300, 100], [350, 100], [400, 100], [450, 100],
                  [0, 150], [50, 150], [100, 150], [150, 150], [200, 150], [250, 150], [300, 150], [350, 150], [400, 150], [450, 150],
                  [0, 200], [50, 200], [100, 200], [150, 200], [200, 200], [250, 200], [300, 200], [350, 200], [400, 200], [450, 200],
                  [0, 250], [50, 250], [100, 250], [150, 250], [200, 250], [250, 250], [300, 250], [350, 250], [400, 250], [450, 250],
                  [0, 300], [50, 300], [100, 300], [150, 300], [200, 300], [250, 300], [300, 300], [350, 300], [400, 300], [450, 300],
                  [0, 350], [50, 350], [100, 350], [150, 350], [200, 350], [250, 350], [300, 350], [350, 350], [400, 350], [450, 350],
                  [0, 400], [50, 400], [100, 400], [150, 400], [200, 400], [250, 400], [300, 400], [350, 400], [400, 400], [450, 400],
                  [0, 450], [50, 450], [100, 450], [150, 450], [200, 450], [250, 450], [300, 450], [350, 450], [400, 450], [450, 450]]

    @positions.each do |position| #preenchendo a player1 com com os quadrados (objetos)
      @player1.push(Square.new(x: position[0], y: position[1], z: 0, size: 49, color: "blue"))
    end

    @message = Text.new("ESCOLHA AS POSIÇÕES PARA OS BARCOS", size: 25, x: 520)
    @message2 = Text.new("Pressione qualquer tecla quando terminar de escolher as casas", size: 20, x: 520, y: 50)
  end

  def contains(x, y) #funcão que verifica se o click pertence a algum quadrado
    # p @player1
    @player1.each do |player1|
      if player1.contains?(x, y)
        player1.color = "red"
        return true
      end
    end
    return false
  end

  def getPosition(x, y) # função que retorna a o indice do quadrado clicado no array de quadrados
    @player1.each do |player1|
      if player1.contains?(x, y)
        return @player1.find_index(player1)
      end
    end
  end

  # mudar o nome dessas funções

  def shipFits?(i, ship_size)
    #compara o primeiro algarismo da posição onde começa o barco com o primeiro algarismo da posição onde ele termina.
    #se o segundo desses for maiosr, o barco termina em outra linha.
    # possui um caso especial para a primeira linha: se o fim do barco ficar em uma posição maior que 9, já vai estar em outra linha
    # verifica também se o fim do barco ultrapassaria a última posição
    fits_line_size = !(((0..9) === i && i + (ship_size - 1) > 9) ||
                       (!((0..9) === i) && (i + (ship_size - 1)).to_s[0].to_i > (i).to_s[0].to_i) ||
                       i + (ship_size - 1) > 99)

    is_range_free = true

    # verifica se todos os quadrados, do começo ao fim do barco, estão desocupados
    for j in i..i + ship_size - 1
      if containsShip?(j)
        is_range_free = false
        break
      end
    end

    # se ambas as condições forem atendidas, o quadradinho escolhido pode abrigar o barco
    fits_line_size && is_range_free
  end

  # recebe a posição que se pretende colocar o barco e o tamanho do barco
  # com base no tamanho do barco, ele já sabe quais imagens renderizar (array tipos_navios)
  def mapShip(i, ship_size)
    # verifica se o quadrado clicado e seus sucessores podem abrigar o barco
    if shipFits?(i, ship_size)
      # renderização das imagens nos quadradinhos
      # o 'j' serve para gerenciar qual parte do barco (imagem) será renderizada naquele determinado quadrado
      for j in 1..ship_size
        @player1Navios[i] = Image.new(
          "images/#{@@tipos_navios[ship_size]}_#{j}.png",
          x: @player1[i].x,
          y: @player1[i].y,
          width: 45, height: 45,
          opacity: 100,
        )

        @player1[i].color = "#87CEEB" # teste apenas; p/ destacar as casas escolhidas até o momento
        i = i + 1 # passa para o próximo quadradinho
      end
    end
  end

  def hideShips
    @player1.each do |player1|
      player1.color = "blue"
      if containsShip?(@player1.find_index(player1))
        @player1Navios[@player1.find_index(player1)].opacity = 0
      end
    end
  end

  def containsShip?(i)
    !@player1Navios[i].nil?
  end

  def revealShip(i)
    @player1Navios[i].opacity = 100
  end
end
