Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F0707F37
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 20:22:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A00CEAC001
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 18:22:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id NGGrevsim2pg54VQ for <xfs@oss.sgi.com>;
	Fri, 30 Aug 2013 18:22:15 -0700 (PDT)
References: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
	<521FF8F4.9040009@hardwarefreak.com>
	<DD759368-581C-4C94-BC5E-E6EC3A83FC61@colorremedies.com>
	<20130830025819.GB23571@dastard>
	<B40ABF48-E2CB-4C02-9DF9-B68BB84341C3@colorremedies.com>
	<20130830033800.GX12779@dastard>
	<F4A27AB5-EDCA-42A3-8D9D-D5F0B992630A@colorremedies.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <F4A27AB5-EDCA-42A3-8D9D-D5F0B992630A@colorremedies.com>
Message-Id: <D8EFEFFB-55C1-4332-B9FF-95110D9708F0@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: higher agcount on LVM2 thinp volumes
Date: Fri, 30 Aug 2013 20:22:11 -0500
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
Cc: "stan@hardwarefreak.com" <stan@hardwarefreak.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gQXVnIDMwLCAyMDEzLCBhdCAxMjo1NSBQTSwgQ2hyaXMgTXVycGh5IDxsaXN0c0Bjb2xvcnJl
bWVkaWVzLmNvbT4gd3JvdGU6Cgo+IAo+IE9uIEF1ZyAyOSwgMjAxMywgYXQgOTozOCBQTSwgRGF2
ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPiB3cm90ZToKPj4gCj4+IFNvLCB3aGF0IGRt
LXRoaW5wIGlzIHRyeWluZyB0byB0ZWxsIHVzIGlzIHRoYXQgdGhlIG1pbmltdW0KPj4gKnBoeXNp
Y2FsKiBJTyBzaXplIGlzIDUxMiBieXRlcyAoaS5lLiAvc3lzLy4uLi9waHlzaWNhbF9ibG9ja19z
aXplKQo+PiBidXQgdGhlIGVmZmljaWVudCBJTyBzaXplIGlzIDI1NmsuIFNvIGRtLXRoaW5wIGlz
IGV4cG9zaW5nIHRoZQo+PiBpbmZvcm1hdGlvbiBpbmNvcnJlY3RseS4gV2hhdCBpdCBzaG91bCBk
YmUgZG9pbmcgaXMgc2V0dGluZyBib3RoIHRoZQo+PiBtaW5pbXVtX2lvX3NpemUgYW5kIHRoZSBv
cHRpbWFsX2lvX3NpemUgdG8gdGhlIHNhbWUgdmFsdWUgb2YgMjU2a+KApgo+IAo+IFNob3VsZCBJ
IGZpbGUgYSBidWc/IEFnYWluc3QgbHZtMj8KPiAKPiAKSSB0aGluayBzby4gIFRoZXkgbWF5IGFs
cmVhZHkgYmUgYXdhcmUgb2YgaXQgYnV0IGJldHRlciB0byBub3QgbG9zZSBpdC4uLgoKRXJpYwoK
PiAKPiBDaHJpcyBNdXJwaHkKPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwo+IHhmcyBtYWlsaW5nIGxpc3QKPiB4ZnNAb3NzLnNnaS5jb20KPiBodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMKPiAKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2ku
Y29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
