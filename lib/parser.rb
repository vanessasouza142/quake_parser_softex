load 'lib/game.rb'
load 'lib/player.rb'

class Parser

	attr_reader :jogos, :file
	
	def initialize

		@file = File.open("log/games.log", "r")

		@jogos = []

		@file.each do |f|

			if linha_novo_jogo?(f)
				@jogos << Game.new
				next


			elsif linha_usuario?(f)
				player = Player.new obter_usuario(f)
				@jogos.last.players[player.name] = player
				next

			elsif linha_kill?(f)
				assasino = obter_assasino(f) 
				vitima = obter_vitima(f)
				motivo = causa_da_morte(f)

				@jogos.last.adicionar_kill
				@jogos.last.causas_das_mortes[motivo] += 1

				if assasino != "<world>"
					@jogos.last.players[assasino].adicionar_score
				else 
					@jogos.last.players[vitima].subtrair_score 
				end
			end			
		end
	end


	def informacao_do_jogo(id)

		case id
		when 1..@jogos.length
			jogo = @jogos[id-1]
		else
			puts "Não existe informações para este jogo"
			return 
		end

		puts jogo
	end


	def relatorio_dos_jogos
		@jogos.each do |jogo|
			puts "Game #{jogo.id}:\n" + jogo.players.map { |key,value| "PLAYER: #{key} #{value.score} KILLS\n" }.join("") + "\n"
		 	puts "Causas dos Abates:\n" + jogo.causas_das_mortes.map { |key, value|  "Motivo: #{key} #{value} vezes\n" }.join("") + "\n"		
		end
	end

	def ranking_geral_de_abates
		ranking = Hash.new(0)
		@jogos.each do |jogo|
			jogo.players.map { |key,value| ranking[key] += value.score  }
		end

		ranking = ordenar_valores(ranking)

		puts "RANKING:\n" + ranking.map { |key, value| "PLAYER: #{key} #{value} KILLS\n" }.join("") + "\n"
		
	end


	def relatorio_geral
		open('log/resultado.log', 'w') do |f|
		
			ranking = Hash.new(0)
			@jogos.each do |jogo|
				jogo.players.map { |key,value| ranking[key] += value.score  }
			end

			ranking = ordenar_valores(ranking)

			f.puts "RANKING:\n" + ranking.map { |key, value| "PLAYER: #{key} #{value} KILLS\n" }.join("") + "\n"

			@jogos.each do |jogo|
				f.puts "Game #{jogo.id}:\n" + jogo.players.map { |key,value| "PLAYER: #{key} #{value.score} KILLS\n" }.join("") + "\n"
			 	f.puts "Causas dos Abates:\n" + jogo.causas_das_mortes.map { |key, value|  "Motivo: #{key} #{value} vezes\n" }.join("") + "\n"		
			end
		end

		puts "O arquivo 'resultado.log' contendo o relatorio foi criado no diretorio 'log'" 
	end


	def ordenar_valores(hash)
		hash.sort_by { |key, value| value }.reverse
	end

	private
		def obter_usuario(linha)
			linha.match(/((?<=n\\).*?(?=\\t))/)[0]
		end

		def obter_assasino(linha)
			linha.match(/([^:]+).(?=\skilled)/)[0].strip
		end


		def obter_vitima(linha)
			linha.match(/((?<=killed\s).*(?=\sby))/)[0]
		end

		def causa_da_morte(linha)
			linha.match(/((?<=by\s).*)/)[0]
		end

		def linha_novo_jogo?(linha)
			linha.match(/(?:^|\W)InitGame(?:$|\W)/) ? true : false
		end


		def linha_usuario?(linha)
			linha.match(/(?:^|\W)ClientUserinfoChanged(?:$|\W)/) ? true : false
		end


		def linha_fim_jogo?(linha)
			linha.match(/(?:^|\W)ShutdownGame(?:$|\W)/) ? true : false
		end


		def linha_kill?(linha)
			linha.match(/(?:^|\W)Kill(?:$|\W)/) ? true : false
		end

end
