# LocationARTest
###测试环境：Xcode 6，iOS 7.0(真机)以上。
基于Metaio的demo修改出来的，查看周边的美食

![GIF](1.gif)

##注意
本demo不能直接运行

* 需要修改JHKey.h中的JH_ID(修改为你的聚合id，并到聚合数据网站申请数据)

		聚合数据账号注册：http://www.juhe.cn/
		数据申请：http://www.juhe.cn/docs/api/id/45
		
* 需要修改Info.plist中的MetaioLicenseString

		MetaioLicense申请：http://metaio.com/

* 由于MetaioSDK.framework有300+M，github限制单文件100M，所以无法上传

		请自行到Metaio官网下载http://metaio.com/

###用到的其他工具
[JsonToModule](https://github.com/skytoup/JsonToModule):一个命令行工具，能把json文件转换成java或者objc的模型类

###用到的第三方库
* [metaioSDK.framework](http://metaio.com/)
* [JuheApisSDK](http://www.juhe.cn/)

-----
##关于我
* 一枚普通的即将大三的珠海大学生
* 希望在大三实习、毕业的工作地方都在珠海

-----
##联系方式
* QQ：875766917，请备注
* Mail：875766917@qq.com
 
-----
##开源协议（License）
The MIT License (MIT)

Copyright (c) 2015 skytoup

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.