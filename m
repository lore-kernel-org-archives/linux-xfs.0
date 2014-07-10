Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0B85B7F3F
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 15:50:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0997AC004
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 13:50:16 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HNvDapnC8WsGcBnj for <xfs@oss.sgi.com>;
	Thu, 10 Jul 2014 13:50:14 -0700 (PDT)
Date: Fri, 11 Jul 2014 06:50:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfstests: Check fs consistency on TEST_DEV only when
	needed
Message-ID: <20140710205011.GL4453@dastard>
References: <1403617014-17870-1-git-send-email-lczerner@redhat.com>
	<1403617014-17870-2-git-send-email-lczerner@redhat.com>
	<20140710010711.GJ4453@dastard>
	<alpine.LFD.2.00.1407101031150.2659@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1407101031150.2659@localhost.localdomain>
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
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

T24gVGh1LCBKdWwgMTAsIDIwMTQgYXQgMTA6Mzg6NDVBTSArMDIwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+IE9uIFRodSwgMTAgSnVsIDIwMTQsIERhdmUgQ2hpbm5lciB3cm90ZToKPiBJIGxp
a2UgdGhlIGlkZWEgRXJpYyBwcm9wb3NlZCB3aXRoIHRoZSBfcmVxdWlyZV90ZXN0IGNoZWNrIGZv
ciB0aGUKPiB0ZXN0IHRoYXQgYWN0dWFsbHkgcmVxdWlyZSB0ZXN0IGRldmljZSBhbmQgdGhlbiBh
Y3R1YWxseSBjaGVjayB0aGUKPiBkZXZpY2Ugb25seSBhZnRlciBzdWNoIHRlc3QuIFdpbGwgdGhh
dCBiZSBhY2NlcHRhYmxlID8gSWYgc28gSSdsbAo+IHJld29yayB0aGUgcGF0Y2hlcy4KCldvcmtz
IGZvciBtZS4gRG9uJ3QgZm9yZ2V0IHRvIGFkZCBpdCB0byB0aGUgIm5ldyIgc2NyaXB0IGFzIHdl
bGwKc28gdGhlIGRlZmF1bHQgaXMgdG8gY2hlY2sgdGhlIHRlc3QgZGV2aWNlLiBUaGF0IHdpbGwg
dHJpZ2dlciB1cyB0bwpjaGVjayBpZiBpdCBpcyBuZWNlc3NhcnkgZHVyaW5nIHRlc3QgZGV2ZWxv
cG1lbnQgcmV2aWV3LCByYXRoZXIgdGhhbgpmb3JnZXR0aW5nIHdlIG5lZWQgdG8gYWRkIGl0LiA7
KQoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGlu
ZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5m
by94ZnMK
