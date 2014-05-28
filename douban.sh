#!/bin/bash
#Author: Newborn John
#Usage: me.sh [album-link] [photo|large] [parallel-n]

[ -e run.log ] && rm -rf run.log
ALBUM=$1

for (( N1 = 0; ; N1+=18 )) ; do 
next=$(curl -s "$ALBUM"?start="$N1" | tee -a run.log | grep rel=\"next\" | cut -d\" -f4)
echo $N1
	if [ -n "$next" ] ; then
		continue
	else
		break
	fi
done

[ -e douban_album ] || mkdir douban_album
cd douban_album

count=0
for plink in `cat ../run.log | grep img.*photo\/thum.*\.jpg  | cut -d\" -f 2 | sed "s/thumb/$2/g"` ; do
curl -sL -w "%{http_code} %{url_effective} \\n" -O $plink &
let count+=1
[[ $((count%$3)) -eq 0 ]] && wait
done
