百度定位
=================


#### [感谢]你们观看！

### 集成说明

	1. 需要先成为百度开发者
	
	2. 然后获取到百度的AppKey
	
	3. 由于iOS9改用更安全的https，为了能够在iOS9中正常使用地图SDK，请在"Info.plist"中进行如下配置，否则影响SDK的使用。
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
    
	4. 如果在iOS9中使用了调起百度地图客户端功能，必须在"Info.plist"中进行如下配置，否则不能调起百度地图客户端。
    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>baidumap</string>
    </array>
	
	5. 使用情况请看代码


### 功能特性

	1. 百度定位当前位置，已经大头针显示
	
	2. 输入经纬度百度地理编码
	
	3. 输入地址百度反地理编码


### 需导入一些库才能正常使用:

	1. libstdc++.6.0.9.tbd

	2. AVFoundation.framework
	
	3. MediaPlayer.framework
	
	4. CoreTelephony.framework
	
	5. CoreMotion.framework
	
	6. ImageIO.framework
	
	7. AudioToolbox.framework
	
	8. Security.framework
	
	9. CoreGraphics.framework
	
	10. SystemConfiguration.framework
	
	11. OpenGLES.framework
	
	12. QuartzCore.framework
	
	13. CoreLocation.framework
	
	14. libbaiduNaviSDK.a
	
	15. libBaiduMobStatForSDK.a
	
	16. 导入百度地图的库: BaiduMapAPI.framework、BaiduNaviSDK

	17. 导入mapapi.bundle
	