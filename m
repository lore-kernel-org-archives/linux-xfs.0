Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3I0bKGu221373 for <xfs@oss.sgi.com>; Sun, 17 Apr 2011 19:37:20 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55A971D5CB9B
	for <xfs@oss.sgi.com>; Sun, 17 Apr 2011 17:40:44 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	cnNl1ZDkDBAzrTHe for <xfs@oss.sgi.com>;
	Sun, 17 Apr 2011 17:40:44 -0700 (PDT)
Date: Mon, 18 Apr 2011 10:40:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110418004040.GS21395@dastard>
References: <20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<20110414225904.GK21395@dastard> <4DA7836A.5040604@draigBrady.com>
	<20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
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
To: Theodore Tso <tytso@MIT.EDU>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

T24gU2F0LCBBcHIgMTYsIDIwMTEgYXQgMDg6MjE6MjhBTSAtMDQwMCwgVGhlb2RvcmUgVHNvIHdy
b3RlOgo+IAo+IE9uIEFwciAxNiwgMjAxMSwgYXQgMToxMSBBTSwgQW5kcmVhcyBEaWxnZXIgd3Jv
dGU6Cj4gCj4gPiBJbiB0aGF0IGNhc2UsIGl0IG1lYW5zIGNwIHNob3VsZCBqdXN0IGFsd2F5cyB1
c2UgRklFTUFQX0ZMQUdfU1lOQywgd2hpY2ggaXMgZmluZS4gCj4gCj4gRXhjZXB0IHRoYXQgaWYg
c29tZW9uZSBpcyBjb3B5aW5nIGEgbGFyZ2UgZGVsYXkgYWxsb2NhdGVkIGZpbGUsIGl0IHdpbGwg
Y2F1c2UgCj4gdGhlIGZpbGUgdG8gaW1tZWRpYXRlbHkgc25hcHBlZCB0byBkaXNrLCB3aGljaCBt
aWdodCBub3QgYmUgdGhlIGdyZWF0ZXN0Cj4gdGhpbmcgaW4gdGhlIHdvcmxkLiAKCk9idmlvdXMg
d29ya2Fyb3VuZCAtIGlmIHRoZSBpbml0aWFsIGZpZW1hcCBjYWxsIHNob3dzIHVud3JpdHRlbgpl
eHRlbnRzLCByZWRvIGl0IHdpdGggdGhlIHN5bmMgZmxhZyBzZXQuIFRob3VnaCB0aGF0IGFzc3Vt
ZdGVIHRoYXQKeW91IGNhbiB0cnVzdCB0aGluZ3MgbGlrZSBkZWxhbGxvYyBleHRlbnRzIHRvIG9u
bHkgY292ZXIgdGhlIHJhbmdlCnRoYXQgdmFsaWQgZGF0YSBleGlzdHMgaW4uIFdoaWNoLCBvZiBj
b3Vyc2UsIHlvdSBjYW4ndCBhc3N1bWUsCmVpdGhlci4gOi8KCj4gQ2hyaXN0b3BoIGlzIHdyaXRl
LCBTRUVLX0hPTEUgYW5kIFNFRUtfREFUQSBhcmUKPiBhIG11Y2ggYmV0dGVyIEFQSSBmb3Igd2hh
dCBjcCB3b3VsbGQgbGtlIHRvIGRvLiAgVW5mb3J0dW5hdGVseSBpdCBoYXNuJ3QKPiBiZWVuIGlt
cGxlbWVudGVkIHlldCBpbiB0aGUgVkZTLi4uCgpBZ3JlZWQsIFNFRUtfSE9MRS9TRUVLX0RBVEEg
aXMgdGhlIHJpZ2h0IHdheSB0byBzb2x2ZSB0aGlzIHByb2JsZW0uCgpDaGVlcnMsCgpEYXZlLgot
LSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2ku
Y29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
