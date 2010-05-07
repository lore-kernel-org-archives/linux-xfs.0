Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o479JBOR156614 for <xfs@oss.sgi.com>; Fri, 7 May 2010 04:19:12 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 271BC1BD5AC9
	for <xfs@oss.sgi.com>; Fri,  7 May 2010 02:21:21 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id gtbSYdUG0x4szXtU
	for <xfs@oss.sgi.com>; Fri, 07 May 2010 02:21:21 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id A56466C04C
	for <xfs@oss.sgi.com>; Fri,  7 May 2010 04:21:20 -0500 (CDT)
Message-ID: <4BE3DC2D.3000607@hardwarefreak.com>
Date: Fri, 07 May 2010 04:23:57 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
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
To: xfs@oss.sgi.com

S3J6eXN6dG9mIELFgmFzemtvd3NraSBwdXQgZm9ydGggb24gNS83LzIwMTAgMzoyMiBBTToKPiBI
ZWxsbywKPiAKPiBJIHVzZSB0aGlzIHRvIHByZWFsbG9jYXRlIGxhcmdlIHNwYWNlIGJ1dCBmb3Vu
ZCBhbiBpc3N1ZS4gUG9zaXhfZmFsbG9jYXRlIAo+IHdvcmtzIHJpZ2h0IHdpdGggc2l6ZXMgbGlr
ZSAxMDBHLCAxVCBhbmQgZXZlbiAxMFQgb24gc29tZSBib3hlcyAob24gc29tZSAKPiBvdGhlciBj
YW4gZmFpbCBhZnRlciBlLmcuIDdUIHRocmVzaG9sZCkgYnV0IGlmIGkgdHJpZWQgZS5nLiAxNlQg
dGhlIHVzZXIgCj4gc3BhY2UgcHJvY2VzcyB3b3VsZCBiZSAiUiJ1bm5pbmcgZm9yZXZlciBhbmQg
aXQgaXMgbm90IGludGVycnVwdGlibGUuIAo+IEZ1cnRoZXJtb3JlIHNvbWUgb3RoZXIgbm90IHJl
bGF0ZWQgcHJvY2Vzc2VzIGxpa2Ugc3NoZCwgYmFzaCBlbnRlciBEIHN0YXRlLiAKPiBUaGVyZSBp
cyBub3RoaW5nIGluIGtlcm5lbCBsb2cuCj4gCj4gSSBtYWRlIHNvIGZhciBhIGZldyBsb2dzIHdp
dGggZnRyYWNlIGZhY2lsaXR5IGZvciAxRywgMTAwRywgMVQgYW5kIDEwVCBzaXplcy4gCj4gSSBu
b3RpY2VkIHRoYXQgZm9yIDFzdCB0aHJlZSBzaXplcyB0aGUgbG9nIGlzIGFzIGxvbmcgYXMgYWJ0
IDEuNU0gKDJNIHBlYWspIAo+IHdoaWxlIDEwVCBnZW5lcmF0ZXMgOTRNIGxvbmcgbG9nLiBJIGNv
dWxkbid0IHJldHJpZXZlIGEgbG9nIGZvciAxN1QgY2FzZSAKPiBiZWNhdXNlICJjYXQgL3N5cyAu
Li4gL3RyYWNlIiBlbnRlcnMgRC4KPiAKPiBJIHdvdWxkIGFwcHJlY2lhdGUgYW55IGhlbHAgYmVj
YXVzZSBpIGdhdmUgdXAgd2l0aCBmdHJhY2UgbG9ncyBhbmFseXNpcy4gVGhlIAo+IHhmc192bl9m
YWxsb2NhdGUgaXMgY292ZXJlZCBpbiBhYnQgMTFrIGxpbmVzIGZvciBhIDEuNU0gbG9nIGNhc2Ug
d2hpbGUgdGhlcmUgCj4gYXJlIGFidCAxNjNrIGxpbmVzIGluIDk0TSBsb2cuIEFuZCBhbGwgaSBj
b3VsZCBzZWUgaXMgcG9zcyBzb21lIHJlbGF0aW9uc2hpcCAKPiBiZXR3ZWVuIHRpbWUgc3BlbnQg
aW4geGZzX3ZuX2ZhbGxvY2F0ZSBzdWJmdW5jdGlvbnMgdnMgcmVxdWVzdGVkIHNwYWNlLgo+IAo+
IEJveCBkZXRhaWxzOgo+IDE2IEhpdGFjaGkgMlRCIGRyaXZlcyAoYmFja3BsYW5lIGNvbm5lY3Rl
ZCksIGRtLCAxIGx2bSBsdW4gb2YgMjVUIHNpemUsCj4ga2VybmVsIDIuNi4zMS41LCBtb3JlIHJl
Y2VudCBrZXJuZWxzIG5laXRoZXIgeGZzIHdlcmUgbm90IHRlc3RlZC4KCjMyIG9yIDY0IGJpdCBr
ZXJuZWw/ICBXaGF0IGlzIHRoZSBzaXplIG9mIHRoZSBYRlMgZmlsZXN5c3RlbSBvbiB0aGUgMjVU
QiBMVk0KTFVOIGFnYWluc3Qgd2hpY2ggeW91J3JlIHJ1bm5pbmcgcG9zaXhfZmFsbG9jYXRlPyAg
VGhlIHJlYXNvbiBJIGFzayBpcyB0aGF0ClhGUyBoYXMgYSAxNlRCIHBlciBmaWxlc3lzdGVtIGxp
bWl0YXRpb24gb24gMzIgYml0IGtlcm5lbHMuICBJIGNhbiBvbmx5CmFzc3VtZSB0aGF0IHlvdXIg
WEZTIGZpbGVzeXN0ZW0gaXMgbGFyZ2VyIHRoYW4gMTZUQiBzaW5jZSB5b3UncmUgYXR0ZW1wdGlu
Zwp0byBwb3NpeF9mYWxsb2NhdGUgMTZUQi4gIEJ1dCwgaXQncyBiZXN0IHRvIGFzayBmb3IgY29u
ZmlybWF0aW9uIHJhdGhlciB0aGFuCmFzc3VtZSwgZXNwZWNpYWxseSBnaXZlbiB0aGF0IHlvdXIg
cHJvYmxlbSBpcyBhcHBlYXJpbmcgbmVhciB0aGF0IG1hZ2ljYWwKMTZUQiBib3VuZGFyeS4KCi0t
IApTdGFuCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4
ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1h
bi9saXN0aW5mby94ZnMK
