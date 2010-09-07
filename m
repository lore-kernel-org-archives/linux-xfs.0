Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8762rea226160 for <xfs@oss.sgi.com>; Tue, 7 Sep 2010 01:02:54 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4903CD95E4E
	for <xfs@oss.sgi.com>; Mon,  6 Sep 2010 23:14:40 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	hKETdi5lGD1tjKFY for <xfs@oss.sgi.com>;
	Mon, 06 Sep 2010 23:14:40 -0700 (PDT)
Date: Tue, 7 Sep 2010 16:03:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs on armv5 still with erroneous log in kernel 2.6.35.4
Message-ID: <20100907060331.GK705@dastard>
References: <4C835A34.9080008@googlemail.com> <20100906005230.GX7362@dastard>
	<4C845EDE.3010806@sandeen.net> <4C8534D0.3050003@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C8534D0.3050003@googlemail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Marcus Osdoba <marcus.osdoba@googlemail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

T24gTW9uLCBTZXAgMDYsIDIwMTAgYXQgMDg6Mzc6MDRQTSArMDIwMCwgTWFyY3VzIE9zZG9iYSB3
cm90ZToKPiAgQW0gMDYuMDkuMjAxMCAwNToyNCwgc2NocmllYiBFcmljIFNhbmRlZW46Cj4gPgo+
ID5JIGRvLCBhbmQgb3dlIHRoZWlyIGRvbm9ycyBzb21lIHRlc3Rpbmc7IGlmIHRoaXMgaXMgc3Rp
bGwgZmFpbGluZwo+ID5vbiBhIGtlcm5lbCB3aXRoIHRoZSB2aXB0IHN0dWZmIGluIHBsYWNlIEkn
bGwgaGF1bCB0aGVtIG91dCBhbmQKPiA+ZG8gc29tZSB0ZXN0aW5nLi4KPiA+Cj4gPi1FcmljCj4g
SGkgRXJpYywKPiBUaGFuayB5b3UgYm90aCBmb3IgeW91ciBhbnNlcnMuCj4gCj4gSSdtIHVzaW5n
IHRoZSBsYXRlc3Qgc3RhYmxlIGtlcm5lbCAyLjYuMzUuNC4gVGhlIGZpbGVzeXN0ZW0gd2FzCj4g
Y3JlYXRlZCBvbiB0aGUgdGFyZ2V0IGRldmljZSB3aXRoIGEgY3Jvc3MgY29tcGlsZWQgeGZzcHJv
Z3MgMy4xLjMuCj4gVGhlIHN5c3RlbXMgcnVucyBvbiBhbiBhcm12NXRlIGFyY2hpdGVjdHVyZSAo
c2hlZXZhcGx1ZyBkZXJpdmF0aXZlKS4KPiBBZnRlciBjcmVhdGluZywgbW91bnRpbmcgYW5kIHdy
aXRpbmcgc29tZSBkYXRhIG9uIGl0LCByZS1tb3VudGluZwo+IHdhcyBub3QgcG9zc2libGUgd2l0
aCB0aGUgYWJvdmUgbWVudGlvbmVkIGVycm9yLiBJJ3ZlIGZvdW5kIHRoaXMKPiBtZXNzYWdlIGlu
IHRoZSBtYWlsaW5nbGlzdGFyY2hpdmUgYW5kIHRob3VnaHQgdGhlIHBhdGNoZXMgd2VyZQo+IGlu
dGVncmF0ZWQgaW50byBtYWlubGluZS4KPiAKPiBIb3cgY2FuIEkgaGVscD8gV2hhdCBhZGRpdGlv
bmFsIGluZm9ybWF0aW9uIGRvIHlvdSBuZWVkPwoKY2FuIHlvdSBzZWUgaWYgeGZzX2xvZ3ByaW50
IGNhbiBwYXJzZSB0aGUgbG9nPyBwcm9iYWJseSBiZXN0IHRvCnVzZSB0aGUgIi10IiBvcHRpb24g
Zm9yIHRyYW5zYWN0aW9uYWwgb3V0cHV0IGFzIHRoYXQgc2hvdWxkIGJlIHRoZQplcXVpdmFsZW50
IG9mIGxvZyByZWNvdmVyeSBwYXJzaW5nIHRoZSBsb2cuCgpGdXJ0aGVyLCBjYW4geW91IG1ha2Ug
c3VyZSB5b3UgYXJlIG1vdW50aW5nIGEgY2xlYW4gZmlsZXN5c3RlbQpieSBydW5uaW5nIHN5bmMg
YSBjb3VwbGUgb2YgdGltZdGVIGJlZm9yZSB5b3UgdW5tb3VudD8gSWYgdGhlIGxvZyBpcwpjbGVh
biBhbmQgeW91IGFyZSBzZWVpbmcgdGhlIHByb2JsZW0sIGl0IHdpbGwgbmFycm93IGRvd24gdGhl
CnBvc3NpYmxlIGNhdXNlcyBvZiB0aGUgcHJvYmxlbS4geGZzX2xvZ3ByaW50IHNob3VsZCB0ZWxs
IHlvdSBpZiB0aGUKbG9nIGlzIGNsZWFuIG9yIGRpcnR5Li4uLgoKQ2hlZXJzLAoKRGF2ZS4KLS0g
CkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNv
bQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
