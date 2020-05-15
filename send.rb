require 'httparty'

class Send

    attr_reader :url, :array_fields

    def initialize(url = 'https://delivery-center-recruitment-ap.herokuapp.com/')
        @url = url
    end


    # verifica todos os campos obrigatorios da API e gera uma lista
    def requestFields
        req  = HTTParty.post(@url, headers: {
            'X-Sent' => "13h36 - 15/05/20"
        },
        body: {"teste": ""}.to_json
        )
        # limpa o retorno da api
        str = req.to_str.sub(/ are required/, '')
        str = str.sub(/\[/, '')
        str = str.sub(/\]/, '')
        str = str.delete(' ')
        @array_fields = str.split(',')
    end


    def post(parser)
        hash_final = {}
        @array_fields.map {|field| hash_final[field] = parser.send(field)}
        # puts hash_final
        req  = HTTParty.post(@url, headers: {
            'X-Sent' => Time.now.strftime("%Hh:%M - %d/%m/%y").to_str
        },
        body: hash_final.to_json
        )
        savePayloadProcess(hash_final)
        return req
    end

    def savePayloadProcess(hash_final)
        File.open("payloads_processed/file_#{Time.now.strftime("%Y%m%d-%H%M%S").to_str}.json", 'w') do |f|
            f.write(hash_final.to_json)
        end
        puts 'Payload processado e salvo!'
    end

end
