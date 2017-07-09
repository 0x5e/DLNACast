# DLNACast
DLNA screen mirror application in macOS.(In progress)

## 踩过的坑

在`[TV] Samsung 6 Series (65)`上踩到的坑：

1. SOAP HTTP Header 的 `SOAPACTION`字段值需要用双引号扩上，否则报`UPnPError: 402`错误。例：`SOAPACTION: "urn:schemas-upnp-org:service:AVTransport:1#SetAVTransportURI"`
 
2. SOAP Action 的参数是有顺序的，`SetAVTransportURI`参数需要按照`InstanceID`，`CurrentURI`，`CurrentURIMetaData`的顺序来，否则也报`UPnPError: 402`错误。

## 参考资料

[iOS 实现基于 DLNA 的本机图片，视频投屏](https://eliyar.biz/iOS_DLNA_with_local_image_and_video/)

[OSX下面用ffmpeg抓取桌面以及摄像头推流进行直播](http://www.cnblogs.com/damiao/p/5233431.html)

[dlnap](https://github.com/cherezov/dlnap)

[DLNA_UPnP](https://github.com/ClaudeLi/DLNA_UPnP)

[AVCaptureScreenInput - AVFoundation | Apple Developer Documentation](https://developer.apple.com/documentation/avfoundation/avcapturescreeninput)

[iOS如何实现TCP、UDP抓包](https://www.coder4.com/archives/5273)
