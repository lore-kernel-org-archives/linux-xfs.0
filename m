Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2BBXLYE108631 for <xfs@oss.sgi.com>; Sun, 11 Mar 2012 06:33:22 -0500
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id W7L2fTGcX1SSq7xE for
	<xfs@oss.sgi.com>; Sun, 11 Mar 2012 04:33:20 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Safe to use XFS in production in Linux 3.2.9?
Date: Sun, 11 Mar 2012 12:33:18 +0100
References: <20120308140600.77406b8zzy2zggkc@web.mail.umich.edu>
	<CAGpXXZLQp+m_soTBw8Zq-M0cyKqVTASSAXMt6YV07ntfqJhMag@mail.gmail.com>
	(sfid-20120309_180335_585519_1302BD3B)
In-Reply-To: <CAGpXXZLQp+m_soTBw8Zq-M0cyKqVTASSAXMt6YV07ntfqJhMag@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201203111233.18986.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com
Cc: Sean Thomas Caron <scaron@umich.edu>, Greg Freemyer <greg.freemyer@gmail.com>

QW0gRnJlaXRhZywgOS4gTcOkcnogMjAxMiBzY2hyaWViIEdyZWcgRnJlZW15ZXI6Cj4gT24gVGh1
LCBNYXIgOCwgMjAxMiBhdCAyOjA2IFBNLCBTZWFuIFRob21hcyBDYXJvbiA8c2Nhcm9uQHVtaWNo
LmVkdT4gCndyb3RlOgo+ID4gSGkgYWxsLAo+ID4gCj4gPiBXZSdyZSBjdXJyZW50bHkgdXNpbmcg
TGludXggMy4wLjEyIHdpdGggQ3Jpc3RvcGgncwo+ID4geGZzLWJ1bGxldHByb29mLXN5bmMgcGF0
Y2ggYW5kIGl0IHNlZW1zIHRvIGJlIHdvcmtpbmcgdmVyeSB3ZWxsIGZvcgo+ID4gdXMuIFVuZm9y
dHVuYXRlbHkgdGhpcyBrZXJuZWwgaXMgdnVsbmVyYWJsZSB0byB0aGUgcmVjZW50Cj4gPiBDVkUt
MjAxMi0wMDU2IG5vIHBlcm1pc3Npb24gY2hlY2tpbmcgb24gd3JpdGVzIHRvIC9wcm9jLyhwaWQp
L21lbQo+ID4gbG9jYWwgcm9vdCBleHBsb2l0LCBzbyB3ZSd2ZSBnb3QgdG8gbGVhdmUgaXQgYmVo
aW5kLgo+ID4gCj4gPiBJIHNlZSB0aGF0IHRoZSBuZXdlc3QgcmVjb21tZW5kZWQgc3RhYmxlIGtl
cm5lbCBvbiBrZXJuZWwub3JnIGlzCj4gPiAzLjIuOS4KPiAKPiBTZWFuLAo+IAo+IFlvdSBkbyBh
cHByZWNpYXRlIDMuMCBoYXMgYmVlbiBkZXNpZ25hdGVkIGEgbG9uZy10ZXJtIGtlcm5lbCBieSB0
aGUKPiBrZXJuZWwub3JnIHRlYW0gYW5kIHdpbGwgZ2V0IGtlcm5lbC5vcmcgc3VwcG9ydCBmb3Ig
MiB5ZWFycy4gIDMuMiBpcwo+IG5vdCBhIGxvbmctdGVybSBrZXJuZWwsIHNvIHN1cHBvcnQgZHJv
cHMgZnJvbSBrZXJuZWwub3JnIG1vcmUgb3IgbGVzcwo+IHdoZW4gMy4zIGNvbWVzIG91dC4KPiAK
PiAzLjIgc3VwcG9ydCB3aWxsIGNvbWUgZnJvbSB0aGUgZGlzdHJpYnV0b3JzIG9mIGNvdXJzZSwg
YnV0IEkgZG9uJ3Qga25vdwo+IGlmIGFueSBvZiB0aGUgbWFqb3IgcmVsZWFzZXMgYXJlIGJhc2Vk
IG9uIDMuMi4KCkFGQUlSIFVidW50dSAxMi4wNCBhcyB3ZWxsIGFzIERlYmlhbiBXaGVlenkgd2ls
bCB1c2Uga2VybmVsIDMuMi4KCi0tIApNYXJ0aW4gJ0hlbGlvcycgU3RlaWdlcndhbGQgLSBodHRw
Oi8vd3d3LkxpY2h0dm9sbC5kZQpHUEc6IDAzQjAgMEQ2QyAwMDQwIDA3MTAgNEFGQSAgQjgyRiA5
OTFCIEVBQUMgQTU5OSA4NEM3CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNn
aS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
