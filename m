Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 93C047CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 20:10:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F252AC002
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 18:10:41 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Fat17B8bSOfHDAxh for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 18:10:36 -0700 (PDT)
Date: Fri, 8 Apr 2016 11:03:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/19] mkfs: unit conversions are case insensitive
Message-ID: <20160408010318.GA567@dastard>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-19-git-send-email-jtulak@redhat.com>
	<57057B2A.3000100@sandeen.net>
	<CACj3i736w-nnDzBDOiBf39cJ3AUHqeVL9_Y8EbUgaMa9S7PToA@mail.gmail.com>
	<5706FE56.7060308@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5706FE56.7060308@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

T24gVGh1LCBBcHIgMDcsIDIwMTYgYXQgMDc6NDE6NThQTSAtMDUwMCwgRXJpYyBTYW5kZWVuIHdy
b3RlOgo+IE9uIDQvNy8xNiA1OjUwIEFNLCBKYW4gVHVsYWsgd3JvdGU6Cj4gPiBPbiBXZWQsIEFw
ciA2LCAyMDE2IGF0IDExOjEwIFBNLCBFcmljIFNhbmRlZW4gPHNhbmRlZW5Ac2FuZGVlbi5uZXQg
PG1haWx0bzpzYW5kZWVuQHNhbmRlZW4ubmV0Pj53cm90ZToKPiA+ICAgICAoaG0sIHdoeSBkbyB3
ZSBoYXZlIDMgY29waWVzIG9mIGN2dG51bT8pCj4gPiAKPiA+IAo+ID4g4oCLV2hlcmU/IOKAiwo+
ID4gIOKAiwo+ID4gCj4gPiDigIskIHB3ZAo+ID4g4oCLL3NvbWUvcGF0aC94ZnNwcm9ncy1kZXYK
PiA+IAo+ID4gJCBncmVwIC1yICJjdnRudW0oc2l6ZV90IiAuIHxncmVwIC12ICJeQmluYXJ5Igo+
ID4g4oCLLi9pbmNsdWRlL2lucHV0Lmg6ZXh0ZXJuIGxvbmcgbG9uZyBjdnRudW0oc2l6ZV90IGJs
b2Nrc2l6ZSwgc2l6ZV90IHNlY3RvcnNpemUsIGNoYXIgKnMpOwo+ID4gLi9pby9pbml0Lmg6ZXh0
ZXJuIHZvaWQgaW5pdF9jdnRudW0oc2l6ZV90ICpibG9ja3NpemUsIHNpemVfdCAqc2VjdHNpemUp
Owo+IAo+ICAgRmlsZSAgICAgICAgICAgICAgCUxpbmUKPiAwIGVzdGltYXRlL3hmc19lc3RpbWF0
ZS5jICAgMjkgY3Z0bnVtKGNoYXIgKnMpCj4gMSBsaWJ4Y21kL2lucHV0LmMgICAgICAgICAgMTQ3
IGN2dG51bSgKPiAyIG1rZnMveGZzX21rZnMuYyAgICAgICAgIDM2MTggY3Z0bnVtKAoKRldJVywg
aGVyZSdzIHdoeSB3ZSBwdXQgdGhlIGZ1bmN0aW9uIG5hbWUgYXQgdGhlIHN0YXJ0IG9mIHRoZSBs
aW5lLApyYXRoZXIgdGhhbiB0aGUgd2F5IHRoYXQgaXQgaXMgdHlwaWNhbGx5IGRvbmUgaW4gdGhl
IGtlcm5lbCBjb2RlCihpLmUuIGFmdGVyIHRoZSByZXR1cm4gdHlwZSBzcGVjaWZpY2F0aW9uKToK
CiQgZ2l0IGdyZXAgXmN2dG51bQplc3RpbWF0ZS94ZnNfZXN0aW1hdGUuYzpjdnRudW0oY2hhciAq
cykKbGlieGNtZC9pbnB1dC5jOmN2dG51bSgKbWtmcy94ZnNfbWtmcy5jOmN2dG51bSgKCkNoZWVy
cywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4
ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
