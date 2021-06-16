require 'socksify/http'
http = Net::HTTP::SOCKSProxy('127.0.0.1', 9050)
url = 'https://ident.me'
puts http.get(URI(url))
sleep 10
puts http.get(URI(url))
sleep 10
puts http.get(URI(url))