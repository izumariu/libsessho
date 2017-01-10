# META_VERSION 1.1
$0==__FILE__&&( # not imported
	require 'net/http'
	onln_version = Net::HTTP.get(URI("https://gist.githubusercontent.com/sesshomariu/bea3f4403f0d4c671da0e7fed2f6a0dd/raw/005929716023ea119afab0fc8863a5fcb1ddefc6/libsessho.rb")).match(/META_VERSION \d+\.\d+/).to_s.split[-1]
	onln_version = Net::HTTP.get(URI("https://gist.githubusercontent.com/sesshomariu/bea3f4403f0d4c671da0e7fed2f6a0dd/raw/69ac9704fc153aaf8d6b0a80fa0f328066b03270/libsessho.rb")).match(/META_VERSION \d+\.\d+/).to_s.split[-1]
	p onln_version
	this_version = File.read(__FILE__).match(/META_VERSION \d+\.\d+/).to_s.split[-1]
	onln_version!=this_version ? puts("Update available.") : puts("No update available.")

	exit
)

module Libsessho # error module / api module / dunno
	class StringNotDivideableError<StandardError;end
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
