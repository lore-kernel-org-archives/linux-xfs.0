Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AE6227F9F
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 22:01:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3BB1DAC002
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 20:01:48 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dD3fvur2Tya3UfCU for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 20:01:46 -0700 (PDT)
Date: Wed, 16 Jul 2014 13:01:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Detect strto* failures based on errno.
Message-ID: <20140716030132.GB20518@dastard>
References: <20140713230406.GE22339@dastard>
	<1405324619-25515-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1405324619-25515-1-git-send-email-arekm@maven.pl>
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
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

T24gTW9uLCBKdWwgMTQsIDIwMTQgYXQgMDk6NTY6NTlBTSArMDIwMCwgQXJrYWRpdXN6IE1pxZtr
aWV3aWN6IHdyb3RlOgo+IENvZGUgd2FzIHRlc3RpbmcgZm9yIEVSQU5HRSBlcnJubyBvbmx5IGlu
IHNvbWUgcGxhY2VzLiBJbiBvdGhlciBwbGFjZXMKPiBpdCBkaWRuJ3QgZG8gYW55IGVycm5vIGNo
ZWNraW5nIGF0IGFsbC4KPiAKPiBVbmlmeSBzdHJ0byogcmVzdWx0IHRlc3RpbmcgYnkgdHJlYXRp
bmcgYW55IG5vbiB6ZXJvIGVycm5vIGFzIGZhaWx1cmUuCj4gCj4gU2lnbmVkLW9mZi1ieTogQXJr
YWRpdXN6IE1pxZtraWV3aWN6IDxhcmVrbUBtYXZlbi5wbD4KClRoaXMgcGF0Y2ggYXBwZWFycyB0
byBjYXVzZSB4ZnMvMDcxIHRvIGZhaWw6CgoKCiAgICAgV3JpdGluZyA1MTIgYnl0ZXMsIG9mZnNl
dCBpcyArMCAoZGlyZWN0PWZhbHNlKQogICAgLXB3cml0ZTY0OiBGaWxlIHRvbyBsYXJnZQogICAg
K25vbi1udW1lcmljIG9mZnNldCBhcmd1bWVudCAtLSA8T0ZGU0VUPgogICAgIFJlYWRpbmcgNTEy
IGJ5dGVzIChkaXJlY3Q9ZmFsc2UpCiAgICAgcmVhZCAwLzUxMiBieXRlcyBhdCBvZmZzZXQgPE9G
RlNFVD4KICAgIC4uLgogICAgKFJ1biAnZGlmZiAtdSB0ZXN0cy94ZnMvMDcxLm91dCAvaG9tZS9k
YXZlL3NyYy94ZnN0ZXN0cy1kZXYvcmVzdWx0cy8veGZzLzA3MS5vdXQuYmFkJyAgdG8gc2VlIHRo
ZSBlbnRpcmUgZGlmZikKCkNhbiB5b3UgaGF2ZSBhIGxvb2sgaW50byB0aGlzPwoKQ2hlZXJzLAoK
RGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bv
c3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
