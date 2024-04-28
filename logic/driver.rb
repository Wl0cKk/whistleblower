require 'yaml'
require 'json'

def load(data); IO.write(CONFIG, data.to_yaml) end

def read_conf(conf = CONFIG) 
    data = YAML.load(IO.read(conf))
    return data
end

def write_conf(key, value, pos = false, conf = CONFIG)
    data = read_conf(conf) # YAML -> Hash
    if pos
        data[key][pos] = value
    else
        data[key] = value
    end
    load(data)

end

def read_coins()
    file_path = File.join(__dir__, '../', 'cryptocurrency.json')
    data = File.exist?(file_path) ? JSON.parse(File.read(file_path)) : {}
    return {path: file_path, data: data}
end

def update_checked_value(crypto_symbol, new_value)
  parser = read_coins
  
  if parser[:data].key?(crypto_symbol)
        parser[:data][crypto_symbol][1] = new_value
  else
    puts "Crypto #{crypto_symbol} not found"
    return
  end

  File.write(parser[:path], JSON.pretty_generate(parser[:data]))
  puts "#{crypto_symbol} -> #{new_value}."
end

CONFIG = './config.yml'

data_conf = File.exist?(CONFIG) ? read_conf(CONFIG) : { \
  'host'      => 'smtp.example.com', # url to service
  'port'      => 1111,               # smtp service port
  'domain'    => 'example.com',
  'emailhost' => 'example@examp.le', # sender email
  'dtime'     => [0, 0, 0, 0],       # days, hours, minutes, seconds
  'times'     => 2,                  # times of movement
  'movement'  => 2,                  # Direction: 0 - up, 1 - down, 2 - bidirectional, 3 - any
  'recipient' => 'your@mail.example' # whos gonna get the notification
}

load(data_conf)