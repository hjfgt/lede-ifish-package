#!/bin/bash

correct_hash() {
	echo 正在处理 $1
	
	pkgdate=$(grep -Po '(?<=PKG_SOURCE_DATE:=)([\d-]+)' $1)
	pkghash=$(grep -Po '(?<=PKG_SOURCE_VERSION:=)([a-f\d]+)' $1)
	pkgname=$(grep -Po '(?<=PKG_NAME:=)([-\w]+)' $1)
	pkgmirror=$(grep -Po '(?<=PKG_MIRROR_HASH:=)([a-f\d]+)' $1)
	
	local="dl/$pkgname-$pkgdate-${pkghash:0:8}.tar.xz"
	
	if [ -e "$local" ]; then
		echo 文件 $local 存在，正在计算SHA256...
		sha256=$(sha256sum $local | awk '{print $1}')
		
		echo SHA256:$sha256
		
		if [ "$sha256" != "$pkgmirror" ]; then
			echo HASH不匹配，期望：$pkgmirror，正在更新...
			sed -i "s#$pkgmirror#$sha256#" $1
		else
			echo HASH匹配
		fi
	else
		echo cache文件 $local 不存在
	fi
}

correct_hash package/firmware/ath11k-firmware/Makefile
correct_hash package/qca/nss/qca-nss-drv/Makefile
correct_hash package/qca/nss/qca-nss-drv-64/Makefile
correct_hash package/qca/nss/qca-nss-ecm/Makefile
correct_hash package/qca/nss/qca-nss-ecm-64/Makefile
correct_hash package/qca/nss/qca-ssdk/Makefile
correct_hash package/qca/nss/qca-nss-dp/Makefile
correct_hash package/qca/nss/qca-nss-clients/Makefile
correct_hash package/qca/nss/qca-nss-clients-64/Makefile