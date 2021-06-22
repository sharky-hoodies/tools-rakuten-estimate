#!/bin/sh

while read line; do
    # csvデータ取得
    filen=`echo -n ${line} | cut -d ',' -f 1`
    sizewmax=`echo -n ${line} | cut -d ',' -f 2`
    sizewmin=`echo -n ${line} | cut -d ',' -f 3`
    sizevmax=`echo -n ${line} | cut -d ',' -f 4`
    sizevmin=`echo -n ${line} | cut -d ',' -f 5`
    price=`echo -n ${line} | cut -d ',' -f 6`
    thick=`echo -n ${line} | cut -d ',' -f 7`
    echo "${filen}, ${sizewmax}, ${sizewmin}, ${sizevmax}, ${sizevmin}, ${price}, ${thick}"
    sed \
    -e "s/TARGET_TEMPLATE_SIZE_W_MAX/${sizewmax}/g" \
    -e "s/TARGET_TEMPLATE_SIZE_W_MIN/${sizewmin}/g" \
    -e "s/TARGET_TEMPLATE_SIZE_V_MAX/${sizevmax}/g" \
    -e "s/TARGET_TEMPLATE_SIZE_V_MIN/${sizevmin}/g" \
    -e "s/TARGET_TEMPLATE_PRICE/${price}/g" \
    -e "s/TARGET_TEMPLATE_THICKNESS/${thick}/g" \
    ./target/template.html > ./result/${filen}.html
    echo "Success!! : ${filen}.html"
done < ./target/target-items.csv
