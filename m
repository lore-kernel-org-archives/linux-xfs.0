Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AC4967F85
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 19:01:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A49EF8F8054
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 17:01:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YFO7cZgfHDR5K223 for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 17:01:03 -0700 (PDT)
Date: Wed, 16 Jul 2014 10:00:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Detect strto* failures based on errno.
Message-ID: <20140716000049.GN22339@dastard>
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
YWRpdXN6IE1pxZtraWV3aWN6IDxhcmVrbUBtYXZlbi5wbD4KCkFya2FkaXVzeiwgd2h5IGRpZCBn
aXQtc2VuZC1lbWFpbCBlbmNvZGUgdGhpcyBlbnRpcmUgY29tbWl0IGluCmJhc2U2ND8gQ2FuIHlv
dSBjb25maWd1cmUgZ2l0IHRvIHNlbmQgcGF0Y2hlcyBpbiBwbGFpbiB0ZXh0PyBldmVuClVURi04
IGVuY29kaW5nIGlzIGZpbmUuCgpZZXMsIEkga25vdyBnaXQgYW0gaGFuZGxlcyBiYXNlNjQgZW5j
b2RlZCBlbWFpbHMsIGJ1dCBodW1hbnMKZG9uJ3QuLi4uIDovCgpBcyBpdCBpcywgdGhlIHBhdGNo
IGlzIGZpbmUuCgpSZXZpZXdlZC1ieTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29t
PgoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGlu
ZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5m
by94ZnMK
