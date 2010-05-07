Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o47GOJkY167996 for <xfs@oss.sgi.com>; Fri, 7 May 2010 11:24:19 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A963137E390
	for <xfs@oss.sgi.com>; Fri,  7 May 2010 09:26:29 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id YM75OmmeHcfO46OK for
	<xfs@oss.sgi.com>; Fri, 07 May 2010 09:26:29 -0700 (PDT)
Message-ID: <4BE43F34.40309@sandeen.net>
Date: Fri, 07 May 2010 11:26:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: posix_fallocate
References: <201005071022.37863.kb@sysmikro.com.pl>
In-Reply-To: <201005071022.37863.kb@sysmikro.com.pl>
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
To: =?UTF-8?B?S3J6eXN6dG9mIELFgmFzemtvd3NraQ==?= <kb@sysmikro.com.pl>
Cc: xfs@oss.sgi.com

S3J6eXN6dG9mIELFgmFzemtvd3NraSB3cm90ZToKPiBIZWxsbywKPiAKPiBJIHVzZSB0aGlzIHRv
IHByZWFsbG9jYXRlIGxhcmdlIHNwYWNlIGJ1dCBmb3VuZCBhbiBpc3N1ZS4gUG9zaXhfZmFsbG9j
YXRlIAo+IHdvcmtzIHJpZ2h0IHdpdGggc2l6ZXMgbGlrZSAxMDBHLCAxVCBhbmQgZXZlbiAxMFQg
b24gc29tZSBib3hlcyAob24gc29tZSAKPiBvdGhlciBjYW4gZmFpbCBhZnRlciBlLmcuIDdUIHRo
cmVzaG9sZCkgYnV0IGlmIGkgdHJpZWQgZS5nLiAxNlQgdGhlIHVzZXIgCj4gc3BhY2UgcHJvY2Vz
cyB3b3VsZCBiZSAiUiJ1bm5pbmcgZm9yZXZlciBhbmQgaXQgaXMgbm90IGludGVycnVwdGlibGUu
IAo+IEZ1cnRoZXJtb3JlIHNvbWUgb3RoZXIgbm90IHJlbGF0ZWQgcHJvY2Vzc2VzIGxpa2Ugc3No
ZCwgYmFzaCBlbnRlciBEIHN0YXRlLiAKPiBUaGVyZSBpcyBub3RoaW5nIGluIGtlcm5lbCBsb2cu
Cj4gCj4gSSBtYWRlIHNvIGZhciBhIGZldyBsb2dzIHdpdGggZnRyYWNlIGZhY2lsaXR5IGZvciAx
RywgMTAwRywgMVQgYW5kIDEwVCBzaXplcy4gCj4gSSBub3RpY2VkIHRoYXQgZm9yIDFzdCB0aHJl
ZSBzaXplcyB0aGUgbG9nIGlzIGFzIGxvbmcgYXMgYWJ0IDEuNU0gKDJNIHBlYWspIAo+IHdoaWxl
IDEwVCBnZW5lcmF0ZXMgOTRNIGxvbmcgbG9nLiBJIGNvdWxkbid0IHJldHJpZXZlIGEgbG9nIGZv
ciAxN1QgY2FzZSAKPiBiZWNhdXNlICJjYXQgL3N5cyAuLi4gL3RyYWNlIiBlbnRlcnMgRC4KPiAK
PiBJIHdvdWxkIGFwcHJlY2lhdGUgYW55IGhlbHAgYmVjYXVzZSBpIGdhdmUgdXAgd2l0aCBmdHJh
Y2UgbG9ncyBhbmFseXNpcy4gVGhlIAo+IHhmc192bl9mYWxsb2NhdGUgaXMgY292ZXJlZCBpbiBh
YnQgMTFrIGxpbmVzIGZvciBhIDEuNU0gbG9nIGNhc2Ugd2hpbGUgdGhlcmUgCj4gYXJlIGFidCAx
NjNrIGxpbmVzIGluIDk0TSBsb2cuIEFuZCBhbGwgaSBjb3VsZCBzZWUgaXMgcG9zcyBzb21lIHJl
bGF0aW9uc2hpcCAKPiBiZXR3ZWVuIHRpbWUgc3BlbnQgaW4geGZzX3ZuX2ZhbGxvY2F0ZSBzdWJm
dW5jdGlvbnMgdnMgcmVxdWVzdGVkIHNwYWNlLgo+IAo+IEJveCBkZXRhaWxzOgo+IDE2IEhpdGFj
aGkgMlRCIGRyaXZlcyAoYmFja3BsYW5lIGNvbm5lY3RlZCksIGRtLCAxIGx2bSBsdW4gb2YgMjVU
IHNpemUsCj4ga2VybmVsIDIuNi4zMS41LCBtb3JlIHJlY2VudCBrZXJuZWxzIG5laXRoZXIgeGZz
IHdlcmUgbm90IHRlc3RlZC4KCkl0J2QgYmUgZ3JlYXQgaWYgeW91IGNvdWxkIHRlc3QgYSBtb3Jl
IHJlY2VudCBrZXJuZWwuCgpzeXNycS10IHdvdWxkIGdpdmUgdXMgYWxsIHRoZSBiYWNrdHJhY2Vz
LCBleGNlcHQgSSBzdXBwb3NlIG5vdCBmb3IgdGhlCnJ1bm5pbmcgcHJvY2Vzcy4uLgoKSSBjYW4g
dHJ5IHRvIHNjcmFwZSB1cCA+MTZUIHRvIHRlc3Qgb24gYXQgc29tZSBwb2ludCAuLi4KCi1Fcmlj
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFp
bGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0
aW5mby94ZnMK
