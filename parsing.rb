require 'json'

class Parser

    attr_reader :data

    # Carrega o modelo completo do payload e adiciona a @data
    def loadPayload(path = 'payload.json')
        file  = File.open(path)
        @data = JSON.load file
    end

    # metodos que quando solicitados buscam a informação correta no arquivo completo
    

    def externalCode
        return @data['id']
    end

    def storeId
        return @data['store_id']
    end

    def subTotal
        return @data['total_amount']
    end

    def deliveryFee
        return @data['total_shipping']
    end

    def total
        return @data['paid_amount']
    end

    def total_shipping
        return @data['total_shipping']
    end

    def country
        return @data['shipping']['receiver_address']['country']['id']
    end

    def state
        return @data['shipping']['receiver_address']['state']['name']
    end

    def city
        return @data['shipping']['receiver_address']['city']['name']
    end

    def district
        return @data['shipping']['receiver_address']['neighborhood']['name']
    end

    def street
        return @data['shipping']['receiver_address']['street_name']
    end

    def complement
        return @data['shipping']['receiver_address']['comment']
    end

    def latitude
        return @data['shipping']['receiver_address']['latitude']
    end

    def longitude
        return @data['shipping']['receiver_address']['longitude']
    end

    def dtOrderCreate
        return @data['shipping']['date_created']
    end

    def postalCode
        return @data['shipping']['receiver_address']['zip_code']
    end

    def number
        return @data['shipping']['receiver_address']['street_number']
    end

    def customer
        return {
            'externalCode' => @data['buyer']['id'],
            'name'         => "#{@data['buyer']['first_name']} #{@data['buyer']['last_name']}",
            'email'        => @data['buyer']['email'],
            'contact'      => "#{@data['buyer']['phone']['area_code']}#{@data['buyer']['phone']['number']}"
        }
    end

    def items
        array_items = []
        @data['order_items'].map { |item|
            hash_item = {};
            hash_item['externalCode']   = item['item']['id']
            hash_item['name']           = item['item']['title']
            hash_item['price']          = item['unit_price']
            hash_item['quantity']       = item['quantity']
            hash_item['total']          = item['unit_price'] * item['quantity']
            hash_item['subItems']       = []
            array_items << hash_item
        }
        return array_items
    end

    def payments
        array_pay = []
        @data['payments'].map { |payment|
            hash_pay = {}
            payment.map { |key, value|
                case key
                    when 'payment_type'
                        hash_pay['type'] = value
                    when 'total_paid_amount'
                        hash_pay['value'] = value
                end
            }
            array_pay << hash_pay
        }
        return array_pay
    end

end
