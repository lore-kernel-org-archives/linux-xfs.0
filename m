Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E66DF7F78
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 16:32:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B81248F8033
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 14:32:08 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BwU1dVHOTmVOsnBi for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 14:32:06 -0800 (PST)
Date: Wed, 12 Nov 2014 09:32:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Enforcing quota for root user
Message-ID: <20141111223203.GS28565@dastard>
References: <67EDE14C-CCFB-4B42-8B78-FC6C813CD19A@free.fr>
	<5461B333.8050609@hardwarefreak.com>
	<F7ACFF71-460D-40E7-999C-BFC8D232EA81@free.fr>
	<54622CE8.7050508@hardwarefreak.com>
	<631A9090-F9FE-4B8E-88CD-1B30CAFC65B7@colorremedies.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <631A9090-F9FE-4B8E-88CD-1B30CAFC65B7@colorremedies.com>
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
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

T24gVHVlLCBOb3YgMTEsIDIwMTQgYXQgMTE6MDA6MjVBTSAtMDcwMCwgQ2hyaXMgTXVycGh5IHdy
b3RlOgo+IAo+IE9uIE5vdiAxMSwgMjAxNCwgYXQgODozNiBBTSwgU3RhbiBIb2VwcG5lciA8c3Rh
bkBoYXJkd2FyZWZyZWFrLmNvbT4gd3JvdGU6Cj4gCj4gPiBPbiAxMS8xMS8yMDE0IDA0OjIyIEFN
LCBDeXJpbCBTY2V0Ym9uIHdyb3RlOgo+ID4+IFRoYXQncyB3aGF0IEkndmUgcmVhZCBmaXJzdCwg
YnV0IHNvbWVvbmUgc2hvd2VkIG1lIGEgc2FtcGxlIHdoZXJlIGl0IHdvcmtzLiBIZSBqdXN0IHRv
bGQgbWUgaGUgd2FzIHVzaW5nIHByb2plY3QgcXVvdGEuIEhvd2V2ZXIsIGRvZXMgaXQgbWFrZSBz
ZW5zZSA/IAo+ID4+IEkndmUgYWxzbyByZWFkIHNvbWV3aGVyZSBlbHNlIHRoYXQgcXVvdGEgaXMg
bmV2ZXIgZW5mb3JjZWQgZm9yIHJvb3QgdXNlciAoaWQsZ2lkPTApIHRoYXQncyB3aHkgSSB3YXMg
dGVzdGluZyBpdCAuLi4uCj4gPiAKPiA+IE5vLCBpdCBkb2Vzbid0IG1ha2Ugc2Vuc2UuICBXaHkg
d291bGQgeW91IHdhbnQgdG8gZW5mb3JjZSBxdW90YXMgZm9yIHJvb3Q/Cj4gCj4gQSB3ZWVrIGFn
byBJIHRyaWVkIHRoaXMgYW5kIHByb2plY3QgcXVvdGFzIGFwcGVhciB0byBhcHBseSB0byByb290
LgoKQnkgaW50ZW50IGFuZCBkZXNpZ24uIFByb2plY3QgcXVvdGFzIGFyZSBub3QgYSB1c2VyL2dy
b3VwIGJhc2VkCnF1b3RhIGFuZCBzbyB0aGVyZSBpcyBubyBleGVtcHRpb24gZm9yIGFueSB1c2Vy
LgoKPiBbcm9vdEBsb2NhbGhvc3QgcHJvamVjdF9xdW90YV90ZXN0MV0jIHhmc19xdW90YSAtYyBk
Zgo+IEZpbGVzeXN0ZW0gICAgICAgICAgIDFLLWJsb2NrcyAgICAgICBVc2VkICBBdmFpbGFibGUg
IFVzZSUgUGF0aG5hbWUKPiAvZGV2L3NkYiAgICAgICAgICAgICAgODM4NDUxMjAgICAgIDE1Nzk4
MCAgIDgzNjg3MTQwICAgIDAlIC94ZnNfbG9jYWwKPiAvZGV2L3NkYiAgICAgICAgICAgICAgICAx
MDI0MDAgICAgIDEyNDkyOCA5MjIzMzcyMDM2ODU0NzUzMjgwICAxMjIlIC94ZnNfbG9jYWwvcHJv
amVjdF9xdW90YV90ZXN0MQo+IFtyb290QGxvY2FsaG9zdCBwcm9qZWN0X3F1b3RhX3Rlc3QxXSMg
ZGQgaWY9L2Rldi96ZXJvIG9mPXRlc3QxMDBNQiBicz0xTSBjb3VudD0xMDAKPiBkZDogZXJyb3Ig
d3JpdGluZyDigJh0ZXN0MTAwTULigJk6IE5vIHNwYWNlIGxlZnQgb24gZGV2aWNlCj4gNzkrMCBy
ZWNvcmRzIGluCj4gNzgrMCByZWNvcmRzIG91dAo+IDgxNzg4OTI4IGJ5dGVzICg4MiBNQikgY29w
aWVkLCAwLjE2Mzg0OSBzLCA0OTkgTUIvcwo+IFtyb290QGxvY2FsaG9zdCBwcm9qZWN0X3F1b3Rh
X3Rlc3QxXSMgeGZzX3F1b3RhIC1jIGRmCj4gRmlsZXN5c3RlbSAgICAgICAgICAgMUstYmxvY2tz
ICAgICAgIFVzZWQgIEF2YWlsYWJsZSAgVXNlJSBQYXRobmFtZQo+IC9kZXYvc2RiICAgICAgICAg
ICAgICA4Mzg0NTEyMCAgICAgMjM3NzQ4ICAgODM2MDczNzIgICAgMCUgL3hmc19sb2NhbAo+IC9k
ZXYvc2RiICAgICAgICAgICAgICAgIDEwMjQwMCAgICAgMjA0ODAwIDkyMjMzNzIwMzY4NTQ2NzM0
MDggIDIwMCUgL3hmc19sb2NhbC9wcm9qZWN0X3F1b3RhX3Rlc3QxCgpJdCdzIGdvbmUgbmVnYXRp
dmUuIFRoYXQgbnVtYmVyIGluIGhleDogMHg3RkZGRkZGRkZGRkU3MDAwCgpXaGF0IGtlcm5lbCBh
cmUgeW91IHVzaW5nLCBhbmQgY2FuIHlvdSBvdXRsaW5lIGFsbCB0aGUgd2F5IHlvdSBzZXQKZXZl
cnl0aGluZyB1cCB0byBjYXVzZSB0aGF0IHRvIG9jY3VyPyBBbHNvLCB3aGF0IGlzIHRoZSBvdXRw
dXQgb2YgYQpwbGFpbiAnZGYgLWgnIHdoZW4gaXQgaXMgaW4gdGhhdCBzdGF0ZT8KCkNoZWVycywK
CkRhdmUuCgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZz
QG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
