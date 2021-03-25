#!/bin/sh
while read line; do
    # csvデータ取得
    filen=`echo -n ${line} | cut -d ',' -f 1`
    itemc=`echo -n ${line} | cut -d ',' -f 2`
    price=`echo -n ${line} | cut -d ',' -f 3`
    thick=`echo -n ${line} | cut -d ',' -f 4`
    # echo "${filen}, ${itemc}, ${price}, ${thick}"
    sed -e "s/TARGET_TEMPLATE_PRICE/${price}/g" -e"s/TARGET_TEMPLATE_THICKNESS/${thick}/g" ./target/template.html > ./result/${filen}.html
    echo "Success!! : ${filen}.html"
done < ./target/target-items.csv
