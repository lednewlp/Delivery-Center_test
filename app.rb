require_relative "parsing"
require_relative "send"

# Instancia o objeto Parser e carrega o arquivo
p = Parser.new
p.loadPayload()

send = Send.new
send.requestFields
# puts send.array_fields # imprime os campos obrigatorios da API
puts send.post(p) # envia os dados para o endpoint
