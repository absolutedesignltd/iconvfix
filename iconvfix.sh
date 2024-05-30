#!/bin/bash
echo "Checking vuln"
ISVULN=$(curl -sO https://sansec.io/downloads/cve-2024-2961.c && gcc cve-2024-2961.c -o poc && ./poc)
echo "Initial check: $ISVULN"
if [[ "system is vulnerable" == "$ISVULN" ]]; then
        echo "Proceeding to fix"
        . /etc/os-release
        echo "$PRETTY_NAME"
        case $PRETTY_NAME in
                "CentOS Linux 7 (Core)")
                        echo "Centos7 found"
                        cp /usr/lib64/gconv/gconv-modules /usr/lib64/gconv/gconv-modules.bak
                        sed -i -e 's/alias	ISO2022CNEXT/#alias	ISO2022CNEXT/g' /usr/lib64/gconv/gconv-modules
                        sed -i -e 's/module	ISO-2022-CN-EXT/#module	ISO-2022-CN-EXT/g' /usr/lib64/gconv/gconv-modules
                        sed -i -e 's/module	INTERNAL		ISO-2022-CN-EXT/#module	INTERNAL		ISO-2022-CN-EXT/g' /usr/lib64/gconv/gconv-modules
                        iconvconfig
                        echo "Patched and rechecking"
                        ;;
                *)
                        echo "Not match $PRETTY_NAME"
                        ;;
        esac
elif [[ "system is safe" == "$ISVULN" ]]; then
        echo "Already fixed, exiting"
	exit
else
        echo "Script issue, check manually"
	exit
fi

ISVULN=$(curl -sO https://sansec.io/downloads/cve-2024-2961.c && gcc cve-2024-2961.c -o poc && ./poc)
echo "Initial check: $ISVULN"
if [[ "system is safe" == "$ISVULN" ]]; then
        echo "Successfully patched"
else
        echo "Error in patching, check manually"
fi
