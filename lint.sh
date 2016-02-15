#!/bin/bash
if `docker-compose run web rake cane`; then
    echo "[+] CANE - Success";
else
    echo ""
fi
if `docker-compose run web rake tailor > /tmp/tailor.tmp.log`; then
    echo "[+] TAILOR - Success";
else
    cat /tmp/tailor.tmp.log;
fi
if `docker-compose run frontend npm run-script build > /tmp/frontend-lint.tmp.log`; then
    echo "[+] Frontend build - Success";
else
    cat /tmp/front-end-lint.tmp.log;
fi


