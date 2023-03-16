load 'lib/parser.rb'

	parser = Parser.new

	puts "================== PARSER LOG ==================="

	def exibe_informacao?
		puts "Deseja ver mais alguma informação? (S/N)"
		decisao = gets.strip
		exibir = decisao.upcase == "N"
	end

loop do

	puts "O que você deseja ver?"
	puts "\n\n"
	puts "Digite 1 para exibir as informações de determinado jogo."
	puts "Digite 2 para exibir o relatorio de kills e causas dos abates por jogo."
	puts "Digite 3 para exibir o ranking geral de kills dos players."
	puts "Digite 4 para gerar o arquivo de relatorio dos jogos (ver na pasta log)."
	puts "Digite 0 para finalizar a aplicação."


	opcao = gets
			
	puts `clear`
		
	case opcao.to_i

		when 1
			puts "Houve no total #{parser.jogos.length} jogos, você deseja ver as informações de qual jogo?"
			puts "Escolha um numero entre 1 e #{parser.jogos.length}?"
			jogo = gets

			puts `clear`

			puts "Informações sobre o jogo #{jogo.to_i}"
			parser.informacao_do_jogo(jogo.to_i)
			break if exibe_informacao?

		when 2
			parser.relatorio_dos_jogos
			break if exibe_informacao?

		when 3
			parser.ranking_geral_de_abates
			break if exibe_informacao?

		when 4
			parser.relatorio_geral
			break if exibe_informacao?
		when 0
			puts "Até mais."
			break
		else

		puts "Opção invalida!\n"
	end
end