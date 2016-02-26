#!/bin/bash
if docker-compose run web rake cane; then
    echo "[+] CANE - Success";
else
    exit 1;
fi
if `docker-compose run web rake tailor > /tmp/tailor.tmp.log`; then
    echo "[+] TAILOR - Success";
else
    cat /tmp/tailor.tmp.log;
    exit 1;
fi
if `docker-compose run frontend npm run-script build > /tmp/frontend-lint.tmp.log`; then
    echo "[+] Frontend build - Success";
else
    cat /tmp/frontend-lint.tmp.log;
    exit 1;
fi
