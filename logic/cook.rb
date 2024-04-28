require_relative 'smtp.rb'
require 'httparty'
require 'erb'

def get_price
	JSON.parse(
		HTTParty.get("https://api.coingecko.com/api/v3/simple/price?ids=\
		#{read_coins[:data].map { |k, v| v[0][1] if v[1] }.compact!.join(',')}\
		&vs_currencies=usd")
		.body
	)
end

def direction(original, obtained)
	status = Array.new
	original.each { |k, v|
		if original[k]['usd'] < obtained[k]['usd']
			status << true
		elsif original[k]['usd'] > obtained[k]['usd']
			status << false
		end
	}
	return status.count(true) > status.count(false) ? true : false
end # true - UP, false - DOWN

def prepare(amounts1, amounts2)

coin = ->(find) { read_coins[:data].each { |kk, vv| if find == vv[0][1]; return vv[0][0] end} }
opt = read_conf
eof = amounts1.map do |k, v|
<<EOF
<tr>
    <td>#{coin.(k)}</td>
    <td>$#{amounts2[k]['usd']}</td>
    <td >$#{amounts1[k]['usd']}</td>
</tr>
EOF
end 
option = ['UP', 'DOWN', 'BIDIRECTION', 'ANY'][opt['movement']]
times  = opt['times']
message = 
<<MESSAGE
From: <#{opt['emailhost']}>
To: <#{opt['recipient']}>
Subject: Notice: Market volume changed direction #{opt['times']} times.
MIME-Version: 1.0
Content-type: text/html

#{ERB.new(IO.read(File.join(__dir__, '../mail', 'template.erb'))).result(binding)}
MESSAGE

end

def analyze
	ready = false
	value = read_conf
	trigger_amounts = Hash.new
	attempts = value['times']
	until ready do
		initial_amounts = get_price()
		comparable_amounts = initial_amounts
		puts "#{Time.now}: #{initial_amounts}"
		hook = 0
		_up   = false
		_down = false
		
		attempts.times {
			time = value['dtime']
			sec = 
			(time[0]*24*60*60) +
			(time[0]*60*60) +
			(time[2]*60) +
			time[3]
			sleep(sec)

			comparable_amounts = get_price
			market = direction(initial_amounts, comparable_amounts)
			case value['movement']

			 when 0 # UP
			 	hook += 1 if market
			 when 1 # DOWN
				hook += 1 unless market
			 when 2 # BIDI
			 	if market && !_down
			 		hook += 1
			 		_up = true
			 	end	
			 	if !market &&  !_up
			 		hook += 1
			 		_down = true
			 	end
			 else   # ANY
			 	hook += 1
			end
		}
		if hook == attempts
			ready = true 
			trigger_amounts = comparable_amounts
		end
	end
	# cook here
	return {:val1 => initial_amounts, :val2 => trigger_amounts}
end

def result(key)
	market = analyze
	html = prepare(market[:val1], market[:val2])
	configuration = read_conf()
	password = decrypt(IO.read($VAULT), key)
	mailer = MailService.new(configuration)
	mailer.send_mail(configuration['emailhost'], configuration['recipient'], html, password)
	puts "#{Time.new}: Email sent!"
end





































