while :
do
    curl -H "Host: adminer.local" -Is localhost | head -n 1
    echo "-----------"
	sleep 1
done