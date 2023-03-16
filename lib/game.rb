class Game
	attr_accessor :total_kills, :players, :causas_das_mortes
	attr_reader :id

	@@id_jogo = 0

	def initialize()
		@id = @@id_jogo += 1

		@total_kills = 0
		
		@players = Hash.new

		@causas_das_mortes =  Hash.new(0)

	end

	def adicionar_kill
		@total_kills += 1
	end

	def to_s
		"Game_#{@id} : {\n Total_kills: #{@total_kills},\n "+
		  "Players : #{@players.keys }\n Kills: {\n" +
		   @players.map { |key,value| "  #{key} : #{value.score}\n " }.join("")+"\n }\n}"
	end

end