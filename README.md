# iFish 木鱼的LEDE编译脚本

> 推荐编译环境为 **Ubuntu 20.04**，但其实木鱼本鱼用 **Ubuntu 21.04** 也能编译成功。差别在于安装的组件会有些差别，在21中部分组件使用了别的名字。具体哪些忘记了，安装的时候会有提示的。

## 编译案例脚本

### 首次编译

```shell
# 安装依赖库
sudo apt-get update
sudo apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf wget curl swig rsync

# 准备LEDE仓库
git clone https://github.com/coolsnowwolf/lede
cd lede
# 后续编译：更新LEDE
git pull

# 配置好源
cp feeds.conf.default feeds.conf
echo 'src-git lede_ifish https://github.com/iccfish/lede-ifish-package.git' >>feeds.conf.default
# 更新源
./scripts/feeds update -a
./scripts/feeds install -a -f

# 选择编译脚本，本仓库自带了AX6、AX3600和AX9000的，参数跟上型号即可
bash ./feeds/lede_ifish/cpconfig.sh ax6
# 如果需要打包京东签到，执行以下脚本
#bash ./feeds/lede_ifish/app_jd.sh

# 更新配置
make defconfig
# 下载，建议挂梯子，否则可能有失败的情况
make download -j$(($(nproc) + 1))

# 部分优化选项
sed -i 's/net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=65535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
sed -i 's/192.168.1.1/172.16.1.1/g' package/base-files/files/bin/config_generate

# 编译。首次编译时间较长，需要联网下载源码，建议挂梯子；偶有失败可重试
make -j1 V=s
# 如出现错误类似“po2lmo: command not found”的错误可能是编译顺序的问题，可在出现错误后手动运行以下编译命令：
make package/feeds/luci/luci-base/compile V=99
# 后再重试上面的编译。不要用root账号
```

编译完成后，输出的内容在 `bin/targets/` 下面。

### 更新编译

```shell
cd lede

# 更新LEDE
git pull

# 更新源
./scripts/feeds update -a
./scripts/feeds install -a -f

# 更新缓存hash。lede源中的部分缓存hash不正确，导致每次都要联网下载，更新后可避免联网更新的出现
bash ./feeds/lede_ifish/fixhash.sh

# 编译
make -j$(($(nproc) + 1)) V=s
```

### 更新配置

```shell
# 重新更新配置
make defconfig

# 下载，建议挂梯子，否则可能有失败的情况
make download -j$(($(nproc) + 1))

# 尝试并行编译，如果失败则回滚为单线程编译
make download -j$(($(nproc) + 1)) | make -j1 | make -j1 V=s
```

## 相关链接

相关引用的模块请参考本仓库子模块。

1. 编译配置及命令可参考 [OpenWrt-AX6-duochajian](https://github.com/jingleijack/OpenWrt-AX6-duochajian)