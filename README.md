7# redis-openwrt
makefile  for  openwrt    compile 




### 大致过程

1. 准备操作系统，网上很多ubuntu的，我使用的阿里云centos7 ,某个免费镜像，yum是阿里的地址，全部依赖几乎可以。 
2. 下载openwrt 或lean的lede  。都是19.07.推荐[gitee lede 最新](https://gitee.com/ewewgit/lean-lede)
更新feed src 查看文件feeds.conf.default ：[package src sample](https://gitee.com/tqizhe/ledepackages?_from=gitee_search)
make基本正常。需要若干小时，第一次make -j1  V=s 很慢很慢。
3. 试试helloworld 生成ipk

4. redis Makefile使用方法：在package目录建立redis目录，将Makefile放入，再redis下建立src目录。放入解压后在redis源码。
运行命令 make package/redis/complile -j1  V=s 

感谢 本redis编译主要[借鉴这个网址]
(https://blog.csdn.net/mxgsgtc/article/details/53054737)

### 错误列表
1. Compile error : undefined reference to‘__atomic_fetch_add_4’
redis6.04，redis5.0 都有的错，决办法 在本平台gcc后加入 -latomic 参数。
加入方法Makefile中覆盖了 CC这个参数，这样就都正常了，我还想知道其他办法，请高手提示。
[参考网址](https://stackoverflow.com/questions/35884832/compile-error-undefined-reference-to-atomic-fetch-add-4)

2. missing separator(did you mean TAB instead of 8 spaces?). Stop.
这是配置文件语法问题，Makefile直接复制的代码TAB偶尔不表示，所以需要找方法解决，所以我全文上传了Makefile。这个文件亲测有效。不知为啥这个网址复制的内容合法。
[参考网址](https://www.it1352.com/624924.html)
3. 找不到 jamlloc 文件
 添加 MALLOC=libc 
[参考网址](https://blog.csdn.net/mxgsgtc/article/details/53054737)

### 最关键的定义
```sh
define Build/Compile
 $(MAKE) -C $(PKG_BUILD_DIR)    $(TARGET_CONFIGURE_OPTS)  CC="mips-openwrt-linux-musl-gcc  -latomic " \
CFLAGS="$(TARGET_CFLAGS)  -I$(LINUX_DIR)/include" MALLOC=libc 
endef
```

## bin使用说明：
1. ipk 平台ar71XX   mips  openwrt 19.07， 版本号 6.0.4  
使用说明，ipk安装后，被放入bin目录，ssh，控制台直接输入指令，redis-server，可以运行，按照默认参数，可以使用redid.conf定制。redis-cli  set h h。可以调试。
如果有libatomic依赖的报错，可以opkg install ibatomic。
2. 二进制文件是19.07的openwrt，mips24k版本，拷贝到路由，修改权限 chmon 755 。ln -s  path/file   bin/file 
起到同样作用。

