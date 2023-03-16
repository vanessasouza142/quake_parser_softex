class Player

	attr_accessor :name, :score

	def initialize(name)
		@name = name
		@score = 0
	end

	def adicionar_score
		@score += 1
	end

	def subtrair_score
		@score -= 1
	end


	def to_s
		"Player: #{@name}  #{@score} Kills"
	end

end