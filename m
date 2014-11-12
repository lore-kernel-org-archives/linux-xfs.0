Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5903F7F9A
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 18:10:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47363304062
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 16:10:05 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	VGNzkMYBmjJOqCLp for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 16:10:00 -0800 (PST)
Date: Wed, 12 Nov 2014 11:09:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Enforcing quota for root user
Message-ID: <20141112000927.GY28565@dastard>
References: <67EDE14C-CCFB-4B42-8B78-FC6C813CD19A@free.fr>
	<5461B333.8050609@hardwarefreak.com>
	<F7ACFF71-460D-40E7-999C-BFC8D232EA81@free.fr>
	<54622CE8.7050508@hardwarefreak.com>
	<631A9090-F9FE-4B8E-88CD-1B30CAFC65B7@colorremedies.com>
	<20141111223203.GS28565@dastard>
	<256C65FE-C757-4457-9F68-1F35FE37968D@colorremedies.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <256C65FE-C757-4457-9F68-1F35FE37968D@colorremedies.com>
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
To: Chris Murphy <lists@colorremedies.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gVHVlLCBOb3YgMTEsIDIwMTQgYXQgMDQ6MzU6MzFQTSAtMDcwMCwgQ2hyaXMgTXVycGh5IHdy
b3RlOgo+IAo+IE9uIE5vdiAxMSwgMjAxNCwgYXQgMzozMiBQTSwgRGF2ZSBDaGlubmVyIDxkYXZp
ZEBmcm9tb3JiaXQuY29tPgo+IHdyb3RlOgo+IAo+ID4gT24gVHVlLCBOb3YgMTEsIDIwMTQgYXQg
MTE6MDA6MjVBTSAtMDcwMCwgQ2hyaXMgTXVycGh5IHdyb3RlOgo+ID4+IAo+ID4+IE9uIE5vdiAx
MSwgMjAxNCwgYXQgODozNiBBTSwgU3RhbiBIb2VwcG5lcgo+ID4+IDxzdGFuQGhhcmR3YXJlZnJl
YWsuY29tPiB3cm90ZToKPiA+PiAKPiA+Pj4gT24gMTEvMTEvMjAxNCAwNDoyMiBBTSwgQ3lyaWwg
U2NldGJvbiB3cm90ZToKPiA+Pj4+IFRoYXQncyB3aGF0IEkndmUgcmVhZCBmaXJzdCwgYnV0IHNv
bWVvbmUgc2hvd2VkIG1lIGEgc2FtcGxlCj4gPj4+PiB3aGVyZSBpdCB3b3Jrcy4gSGUganVzdCB0
b2xkIG1lIGhlIHdhcyB1c2luZyBwcm9qZWN0IHF1b3RhLgo+ID4+Pj4gSG93ZXZlciwgZG9lcyBp
dCBtYWtlIHNlbnNlID8gIEkndmUgYWxzbyByZWFkIHNvbWV3aGVyZSBlbHNlCj4gPj4+PiB0aGF0
IHF1b3RhIGlzIG5ldmVyIGVuZm9yY2VkIGZvciByb290IHVzZXIgKGlkLGdpZD0wKSB0aGF0J3MK
PiA+Pj4+IHdoeSBJIHdhcyB0ZXN0aW5nIGl0IC4uLi4KPiA+Pj4gCj4gPj4+IE5vLCBpdCBkb2Vz
bid0IG1ha2Ugc2Vuc2UuICBXaHkgd291bGQgeW91IHdhbnQgdG8gZW5mb3JjZQo+ID4+PiBxdW90
YXMgZm9yIHJvb3Q/Cj4gPj4gCj4gPj4gQSB3ZWVrIGFnbyBJIHRyaWVkIHRoaXMgYW5kIHByb2pl
Y3QgcXVvdGFzIGFwcGVhciB0byBhcHBseSB0bwo+ID4+IHJvb3QuCj4gPiAKPiA+IEJ5IGludGVu
dCBhbmQgZGVzaWduLiBQcm9qZWN0IHF1b3RhcyBhcmUgbm90IGEgdXNlci9ncm91cCBiYXNlZAo+
ID4gcXVvdGEgYW5kIHNvIHRoZXJlIGlzIG5vIGV4ZW1wdGlvbiBmb3IgYW55IHVzZXIuCj4gCj4g
SXTigJlzIHdoYXQgSeKAmWQgZXhwZWN0LiBJIGNvbnNpZGVyZWQgdGhlIGRvY3VtZW50YXRpb24g
dG8gYmUKPiBzbGlnaHRseSBtaXNsZWFkaW5nIHdoZXJlIGlzIHNheXMgc29mdCBhbmQgaGFyZCBs
aW1pdHMgYXJlIG5ldmVyCj4gYXBwbGllZCB0byB0aGUgcm9vdCB1c2VyLiBUaGUgcHJvamVjdCBx
dW90YSBkb2VzIGhhdmUgYSBzb2Z0IGFuZAo+IGhhcmQgbGltaXQuIFRoZSBzb2Z0IGxpbWl0LCBz
ZWVtZWQgbm90IHRvIGFwcGx5IHRvIHRoZSByb290IHVzZXIgLQo+IGF0IGxlYXN0IHRoZXJlIHdh
cyBubyBzb2Z0IGxpbWl0IHdhcm5pbmcgYW55d2hlcmUgd2hlbiBpdCB3YXMKPiBidXN0ZWQuIEJ1
dCB0aGUgaGFyZCBsaW1pdCBkZWZpbml0ZWx5IGFwcGxpZWQuCj4gCj4gaHR0cDovL3hmcy5vcmcv
ZG9jcy94ZnNkb2NzLXhtbC1kZXYvWEZTX1VzZXJfR3VpZGUvdG1wL2VuLVVTL2h0bWwvY2gwOHMw
NC5odG1sCgpTbyB3cml0ZSBhIHBhdGNoIHRvIGZpeCB0aGUgZG9jdW1lbnRhdGlvbi4gUmVwbyBp
cyBoZXJlOgoKZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9mcy94ZnMveGZzZG9jcy14bWwt
ZGV2LmdpdAoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQu
Y29tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMg
bWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9s
aXN0aW5mby94ZnMK
