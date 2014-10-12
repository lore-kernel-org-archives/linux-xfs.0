Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4EDDC7F4E
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 15:39:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D57D304067
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 13:39:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id rERPFHsb2scFjEia for <xfs@oss.sgi.com>;
	Sun, 12 Oct 2014 13:39:05 -0700 (PDT)
Message-ID: <543AE6E8.3040202@sandeen.net>
Date: Sun, 12 Oct 2014 15:39:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Filesystem is broken and cant repair and mount!
References: <trinity-79914db3-a491-4219-a68e-72c1d21f16cc-1413145560730@3capp-gmx-bs13>
In-Reply-To: <trinity-79914db3-a491-4219-a68e-72c1d21f16cc-1413145560730@3capp-gmx-bs13>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dragon <Sunghost@gmx.de>, xfs@oss.sgi.com

T24gMTAvMTIvMTQgMzoyNiBQTSwgRHJhZ29uIHdyb3RlOgo+IAo+IEhlbGxvLAo+IGkgY2hhbmdl
ZCB0aGUgc2F0YSBjYWJsZSBhbmQgdXBncmFkZSBrZXJuZWwgdG8gbGF0ZXN0LiBJZiBpIG5vdyBj
b3B5IGZpbGVzIGkgZ290IGEgbmV3IGZhaWx1cmU6Cj4gIFhGUzogSW50ZXJuYWwgZXJyb3IgWEZT
X1dBTlRfQ09SUlVQVEVEX1JFVFVSTiBhdCBsaW5lIDM0OCBvZiBmaWxlIC9idWlsZC9saW51eC1u
Qm9EVjkvbGludXgtMy4xNi4zL2ZzL3hmcy94ZnNfYWxsb2MuYy4gIENhbGxlciB4ZnNfYWxsb2Nf
YWdfdmV4dGVudF9zaXplKzB4NTY5LzB4NmMwIFt4ZnNdCj4gLS0tLS0tLS0tLS0tLS0KPiAgCj4g
SSBmb3VuZCBhIGZvcnVtIHRocmVhZCBpbiB3aGljaCBhbm90aGVyIHNvbHZlZCB0aGUgcHJvYmxl
bSBhbmQgaSBhbSBub3Qgc3VyZSwgYnV0IHBlcmhhcHMgaSBoYXZlIHRoZSBzYW1lIHByb2JsZW0u
IE15IGluaXRpYWwgcmFpZCB3YXMgYXByb3guIDZUQiBhbmQgcmlzZWQgc3RlcCBieSBzdGVwIHRv
IDIwVEIuCj4gbXkgeGZzX2luZm86Cj4gTWV0YWRhdGVuID0vZGV2L21kMiAgICAgICAgICAgICAg
IGlzaXplPTI1NiAgICBhZ2NvdW50PTExMiwgYWdzaXplPTQ1NTk4ODQ4IGJsa3MKPiAgICAgICAg
ICAgPSAgICAgICAgICAgICAgICAgICAgICAgc2VjdHN6PTQwOTYgIGF0dHI9Mgo+IERhdGVuICAg
ICA9ICAgICAgICAgICAgICAgICAgICAgICBic2l6ZT00MDk2ICAgQmzDtmNrZT01MTA3MDU3NTM2
LCBpbWF4cGN0PTUKPiAgICAgICAgICAgPSAgICAgICAgICAgICAgICAgICAgICAgc3VuaXQ9MTI4
ICAgIHN3aWR0aD0yNTYgYmxrcwo+IEJlbmVubnVuZyA9VmVyc2lvbiAyICAgICAgICAgICAgICBi
c2l6ZT00MDk2ICAgYXNjaWktY2k9MAo+IFByb3Rva29sbCA9SW50ZXJuICAgICAgICAgICAgICAg
ICBic2l6ZT00MDk2ICAgQmzDtmNrZT01MjE3MjgsIFZlcnNpb249Mgo+ICAgICAgICAgICA9ICAg
ICAgICAgICAgICAgICAgICAgICBzZWN0c3o9NDA5NiAgc3VuaXQ9MSBibGtzLCBsYXp5LWNvdW50
PTEKPiBFY2h0emVpdCAgPWtlaW5lICAgICAgICAgICAgICAgICAgZXh0c3o9NDA5NiAgIEJsw7Zj
a2U9MCwgcnRleHRlbnRzPTAKPiAgCj4gQ291bGQgaSBoYXZlIGEgcHJvYmxlbSB3aXRoIHRoZSBn
cm91cF9zaXplPwoKbm8uCgoKCllvdSBjaGFuZ2VkIHRoZSBjYWJsZSAmIHVwZ3JhZGVkIHlvdXIg
a2VybmVsLiAgRGlkIHlvdSBydW4geGZzX3JlcGFpciB0byBmaXggdGhlIHByZXZpb3VzIHByb2Js
ZW0gd2hpY2ggZXhpc3RlZCBvbiBkaXNrPwoKLUVyaWMKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29t
Cmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
