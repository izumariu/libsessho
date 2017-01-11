# META_VERSION 1.5

=begin
class Version
	def initialize(_1,_2=0,_3=0,_4=0)
		@verstr = [_1,_2,_3,_4].map(&:to_s)
	end
end
=end

def upd_check
	require 'net/http'
	require 'timeout'
	onln_content = nil
	begin
		Timeout.timeout(2) { onln_content = Net::HTTP.get(URI("https://raw.githubusercontent.com/sesshomariu/libsessho/master/libsessho.rb")) }
	rescue
		return [false,""]
	else
		onln_version = onln_content.match(/META_VERSION \d+\.\d+/).to_s.split[-1].to_f
		this_version = File.read(__FILE__).match(/META_VERSION \d+\.\d+/).to_s.split[-1].to_f
		upd_av = (onln_version>this_version)
		return [upd_av, (upd_av ? onln_content : "")]
	end
end

$0==__FILE__&&( # not imported
	upd_av, onln_cont = upd_check
	upd_av ? puts("Update available. Updating...") : puts("No update available(or could not check repository).")
	upd_av&&File.write(__FILE__,onln_cont)
	exit
)

_UPD_upd_av, _UPD_onln_cont = upd_check
at_exit{_UPD_upd_av&&File.write(__FILE__,_UPD_onl_cont)}
Signal.trap("INT"){exit} # ensure proper exit


module Libsessho # error module / api module / dunno
	class StringNotDivideableError<StandardError;end
end

def warning_msg(msg)
	puts "\e[31m#{msg}\e[39m"
end

class String
	def splitAt(pos)
		raise ArgumentError,"Index out of range" if pos>=self.length
		p2 = self.split("")
		p1 = p2.shift(pos)
		[p1,p2].map(&:join)
	end
	def substr(pos)
		raise ArgumentError,"Index out of range" if pos>=self.length
		self[pos,self.length]
	end
	def supstr(pos)
		raise ArgumentError,"Index out of range" if pos>=self.length
		self[0,pos]
	end
	def divide(by,supprErr=false)
		supprErr||(self.length%by==0||raise(Libsessho::StringNotDivideableError,"Length of string is not divideable by #{by}"))
		retarr = Array.new
		s = self.split("")
		until s.empty?
			retarr.push s.shift(by)
		end
		return retarr.map(&:join)
	end
	def dropFileEnding
		self.split(".").reverse[1,self.length].reverse.join(".")
	end
	def matches(s)
		matcharr = Array.new
		self.split("").each_with_index{|c,i|c==s&&matcharr<<i}
		return matcharr
	end
end

class Array
	def intersect(sa);self.select{|i|sa.include?(i)};end
	def subarr(pos)
		raise ArgumentError,"Index out of range" if pos>=self.length
		self[pos,self.length]
	end
	def suparr(pos)
		raise ArgumentError,"Index out of range" if pos>=self.length
		self[0,pos]
	end
	def matches(s)
		matcharr = Array.new
		self.each_with_index{|c,i|c==s&&matcharr<<i}
		return matcharr
	end
end

def publicIP
	require 'net/http'
	return Net::HTTP.get(URI('https://api.ipify.org'))
end

def publicIPv6
	require 'net/http'
	Net::HTTP.get(URI("http://whatismyip.org")).match(/\h{,4}:\h{,4}:\h{,4}:\h{,4}:\h{,4}:\h{,4}:\h{,4}:\h{,4}/).to_s
end

def backtrack_call
	raise NotImplementedError
end

def localIP
	require 'socket'
	Socket.ip_address_list.map{|i|i.inspect.split(" ")[-1].split(">")[0]}.select{|i|i.match(/^\d{,3}\.\d{,3}\.\d{,3}.\d{,3}$/)}.select{|i|i!="127.0.0.1"}[0]
end
