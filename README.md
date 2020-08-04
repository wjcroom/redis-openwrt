7# redis-openwrt
makefile  for  openwrt    compile 

下载openwrt 或lean的lede。都是19.07.推荐后者不清楚旧版怎么弄。make基本正常后。最好试试helloworld 生成ipk

Makefile使用方法：在package目录建立redis目录，将Makefile放入，再redis下建立src目录。放入解压后在redis源码。
运行命令 make package/redis/complile j1  V=s 
结束。
本redis编译主要借鉴这个网址
https://blog.csdn.net/mxgsgtc/article/details/53054737

错误列表：
1、 Compile error : undefined reference to‘__atomic_fetch_add_4’
redis6.04，redis5.0 都有的错，决办法 在本平台gcc后加入 -latomic 参数。
加入方法Makefile中覆盖了 CC这个参数，这样就都正常了，我还想知道其他办法，请高手提示。
参考网址https://stackoverflow.com/questions/35884832/compile-error-undefined-reference-to-atomic-fetch-add-4

2、missing separator(did you mean TAB instead of 8 spaces?). Stop.
这是配置文件语法问题，Makefile直接复制的代码TAB偶尔不表示，所以需要找方法解决，所以我全文上传了Makefile。这个文件亲测有效。不知为啥这个网址复制的内容合法。
参考网址https://www.it1352.com/624924.html 
3、   找不到 jamlloc 文件
 添加 MALLOC=libc 
参考网址https://blog.csdn.net/mxgsgtc/article/details/53054737

下面是其中最关键的定义：
[code]
define Build/Compile
$(MAKE) -C $(PKG_BUILD_DIR)    $(TARGET_CONFIGURE_OPTS)  CC="mips-openwrt-linux-musl-gcc  -latomic "   CFLAGS="$(TARGET_CFLAGS)  -I$(LINUX_DIR)/include" MALLOC=libc 
endef
[/code]
bin使用说明：
提供一个 ar71XX   mips的bin文件6.0.4  ，可执行文件及ipk安装文件。
使用说明，ipk安装后，被放入bin目录，ssh，控制台直接输入指令，redis-server，可以运行，按照默认参数。redis-cli  set h h。可以调试。
出过一个。libatomic依赖的错，可以opkg install ibatomic。
二进制文件是19.07的openwrt，mips24k版本，拷贝到路由，修改权限 chmon 755 。ln -s  path   bin 
起到同样作用。

