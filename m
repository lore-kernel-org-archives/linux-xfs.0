Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q658aHUR046454 for <xfs@oss.sgi.com>; Thu, 5 Jul 2012 03:36:17 -0500
Received: from mail-bk0-f53.google.com (mail-bk0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id p7KcCWJ0awCqh8xv
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Jul 2012 01:36:16 -0700 (PDT)
Received: by bkwj4 with SMTP id j4so1898481bkw.26
	for <xfs@oss.sgi.com>; Thu, 05 Jul 2012 01:36:14 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: bug? "directory flags set on non-directory inode 2877105"
Date: Thu, 5 Jul 2012 10:36:11 +0200
References: <201207041759.05259.arekm@maven.pl>
	<20120704212310.GJ19223@dastard>
In-Reply-To: <20120704212310.GJ19223@dastard>
MIME-Version: 1.0
Message-Id: <201207051036.11766.arekm@maven.pl>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

T24gV2VkbmVzZGF5IDA0IG9mIEp1bHkgMjAxMiwgRGF2ZSBDaGlubmVyIHdyb3RlOgo+IE9uIFdl
ZCwgSnVsIDA0LCAyMDEyIGF0IDA1OjU5OjA1UE0gKzAyMDAsIEFya2FkaXVzeiBNacWba2lld2lj
eiB3cm90ZToKPiA+IEhpLgo+ID4gCj4gPiBPbiB0d28gc2VydmVycyB1c2luZyAzLjAueCBrZXJu
ZWxzIEkndmUgZ290IGxpa2UgMTAgbWxuIG9mICJkaXJlY3RvcnkKPiA+IGZsYWdzIHNldCBvbiBu
b24tZGlyZWN0b3J5IGlub2RlIHh4eCIgZXJyb3JzIHdoZW4gZG9pbmcgeGZzX3JlcGFpci4KPiA+
IERvZXNuJ3QgbG9vayBsaWtlIGEgY29ycnVwdGlvbiBpc3N1ZSwgcmlnaHQ/Cj4gCj4gQ2FuIHlv
dSBydW4gYSB4ZnNfaW8gc3RhdCBjb21tYW5kIG9uIG9uZSBvZnRoZSBmaWxlcyBzbyB3ZSBjYW4g
c2VlCj4gd2hhdCBmbGFnIGlzIHNldD8gaS5lLgo+IAo+ICQgeGZzX2lvIC1jIHN0YXQgJGZpbGUK
ClRoaXJkIG1hY2hpbmUgYW5kIFAgZmxhZyBpcyB0aGVyZSBvbiByZWd1bGFyIGZpbGU6CgojIExD
X0FMTD1DIHhmc19pbyAtYyBzdGF0IC9ob21lL3NvbWVmaWxlLnR4dApmZC5wYXRoID0gIi9ob21l
L3NvbWVmaWxlLnR4dCIKZmQuZmxhZ3MgPSBub24tc3luYyxub24tZGlyZWN0LHJlYWQtd3JpdGUK
c3RhdC5pbm8gPSAyMTY5MDMxNjQzCnN0YXQudHlwZSA9IHJlZ3VsYXIgZmlsZQpzdGF0LnNpemUg
PSA0OTM0CnN0YXQuYmxvY2tzID0gMTYKZnN4YXR0ci54ZmxhZ3MgPSAweDIwMCBbLS0tLS0tLS1Q
LS0tLS1dCmZzeGF0dHIucHJvamlkID0gNDUwMzkKZnN4YXR0ci5leHRzaXplID0gMApmc3hhdHRy
Lm5leHRlbnRzID0gMQpmc3hhdHRyLm5hZXh0ZW50cyA9IDAKZGlvYXR0ci5tZW0gPSAweDIwMApk
aW9hdHRyLm1pbmlvc3ogPSA1MTIKZGlvYXR0ci5tYXhpb3N6ID0gMjE0NzQ4MzEzNgoKPiAKPiA+
IFdhcyB0aGVyZSBhIGJ1ZyBpbiAyLjYuM3ggb3IgMy4wLngga2VybmVscyB0aGF0IGNvdWxkIGdl
dCB0aGVzZSBmbGFncyBzZXQKPiA+IGluIHN1Y2ggd3Jvbmcgd2F5Pwo+IAo+IE5vdCB0aGF0IEkg
a25vdyBvZi4KPiAKPiA+IHBzLiB1c2luZyBwcm9qZWN0IHF1b3RhIG9uIGJvdGggc2VydmVycy9m
c2VzCj4gCj4gV2hpY2ggbWFrZXMgbWUgdGhpbmsgdGhhdCB0aGUgcHJvamVjdCBxdW90YSBpbmhl
cml0YW5jZSBmbGFnIGhhcwo+IGJlZW4gcmVjdXJzaXZlbHkgc2V0IG9uIGFsbCBmaWxlcywgbm90
IGp1c3QgZGlyZWN0b3JpZXMuIFRoZSBjb2RlCj4gYWxsb3dzIHRoYXQgdG8gb2NjdXIsIGV2ZW4g
dGhvdWdoIGl0IG9ubHkgaGFzIG1lYW5pbmcgZm9yIGRpcmVjdG9yeQo+IGlub2Rlcy4gSWYgdGhp
cyBpcyB0aGUgY2FzZSwgdGhlbiB0aGUgYWJvdmUgd2FybmluZyBhbmQgcmVtb3ZhbCBvZgo+IHRo
ZSBmbGFnIGlzIGhhcm1sZXNzLgoKU2VlbXMgdG8gYmUgaXQuCgp4ZnNfcXVvdGEgcHJvYmFibHkg
bmVlZHMgYSBmaXggdG8gZG9uJ3QgZG8gdGhhdCB0aGVuIHdoZW4gaW4gcmVjdXJzaXZlIG1vZGUu
Cgo+IENoZWVycywKPiAKPiBEYXZlLgoKLS0gCkFya2FkaXVzeiBNacWba2lld2ljeiwgYXJla20g
LyBtYXZlbi5wbAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21h
aWxtYW4vbGlzdGluZm8veGZzCg==
