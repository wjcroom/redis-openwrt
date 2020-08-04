# redis-openwrt
makefile  for  openwrt    compile 

下载openwrt 或lean的lede。都是19.07.推荐后者不清楚旧版怎么弄。make基本正常后。最好试试helloworld 生成ipk

使用方法，在package目录建立redis目录，将Makefile放入，再redis下建立src目录。放入解压后在redis源码。
运行命令 make package/redis/complile j1  V=s 
结束。


注意点。对我来说报了，某个常量不存在的错误，redis6.04就只有这一个错。 搜索解决办法 是加入 -latomic 。我在Makefile中覆盖了 CC这个参数。这样就都正常了。其他办法我不知怎么用。

define Build/Compile

	$(MAKE) -C $(PKG_BUILD_DIR)    $(TARGET_CONFIGURE_OPTS)  CC="mips-openwrt-linux-musl-gcc  -latomic "   CFLAGS="$(TARGET_CFLAGS)  -I$(LINUX_DIR)/include" MALLOC=libc 

endef
随后提供一个 ar71XX   mips的bin文件6.0.有需要可拿走，我折腾了好久，没找到。
