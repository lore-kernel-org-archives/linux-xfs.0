Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5TNr4we098287 for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 18:53:05 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD6761171B28
	for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 17:00:41 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id ZcecmuaJVBgzyzk5
	for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 17:00:41 -0700 (PDT)
Received: from moonwalker.lan.dermichi.com
	([2001:15c0:6679:1:218:8bff:feb1:c9e8])
	by firestarter.dermichi.com with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.72)
	(envelope-from <mw@dermichi.com>) id 1OTkeZ-0006rH-0N
	for xfs@oss.sgi.com; Wed, 30 Jun 2010 01:55:47 +0200
Message-ID: <4C2A87FF.7090804@dermichi.com>
Date: Wed, 30 Jun 2010 01:55:43 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: xfs file system in process of becoming corrupt; though	xfs_repair
	thinks it's fine! ;-/ (was xfs_dump problem...)
References: <4C26A51F.8020909@tlinx.org>
	<20100628022744.GX6590@dastard>	<4C2A749E.4060006@tlinx.org>
	<20100629232532.GA24712@dastard>
In-Reply-To: <20100629232532.GA24712@dastard>
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

SGkhCj4+IDIzNTkxMDEgPz8/Pz8/Pz8/PyA/ID8gPyA/ICAgICAgICAgICAgICAgID8gMzAtT21v
aWRlIHRvIFlha3Vzb2t1IChUViBzYWl6de+9nFJlaW5hyrxzIFZlci4pLm1wMwo+PiAyMzU0OTQ2
ID8/Pz8/Pz8/Pz8gPyA/ID8gPyAgICAgICAgICAgICAgICA/IDMxLU9tb2lkZSB0byBZYWt1c29r
dSAoVFYgc2FpenXvvZxUb21vZcq8cyBWZXIuKS5tcDMKPj4gMjM1NDk0OSA/Pz8/Pz8/Pz8/ID8g
PyA/ID8gICAgICAgICAgICAgICAgPyAzMi1PbW9pZGUgdG8gWWFrdXNva3UgKFRWIHNhaXp1772c
TmFudWFsyrxzIFZlci4pLm1wMwo+PiBsczogY2Fubm90IGFjY2VzcyBiYWQyLzMwLU9tb2lkZSB0
byBZYWt1c29rdSAoVFYgc2FpenXvvZxSZWluYcq8cyBWZXIuKS5tcDM6IE5vIHN1Y2ggZmlsZSBv
ciBkaXJlY3RvcnkKPj4gbHM6IGNhbm5vdCBhY2Nlc3MgYmFkMi8zMS1PbW9pZGUgdG8gWWFrdXNv
a3UgKFRWIHNhaXp1772cVG9tb2XKvHMgVmVyLikubXAzOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0
b3J5Cj4+IGxzOiBjYW5ub3QgYWNjZXNzIGJhZDIvMzItT21vaWRlIHRvIFlha3Vzb2t1IChUViBz
YWl6de+9nE5hbnVhbMq8cyBWZXIuKS5tcDM6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKPiAK
PiAuLi4KPgo+IElmIHRoZXJlIGFyZSBubyBwcm9ibGVtcyByZXBvcnRlZCBieSByZXBhaXIsIHRo
ZW4gSSBzdXNwZWN0IHRoYXQKPiBpdCdzIGEgdGVybWluYWwgbGV2ZWwgcHJvYmxlbS4uLgo+IApM
b29raW5nIGF0IHRoaXMgaSByZW1lbWJlciBoYXZpbmcgc2ltaWxhciBwcm9ibGVtcyB3aGVuIG15
IGZpbGVzeXN0ZW1zCndhcyBtb3VudGVkIHdpdGggaW5vZGU2NCBiZWZvcmUgYW5kIGFmdGVyIGkg
bGVmdCBvdXQgdGhhdCBwYXJhbWV0ZXIuIFNvCkxpbmRhLCBjb3VsZCB5b3UgcmUtdHJ5IG1vdW50
aW5nIHRoZSBmcyB3aXRoICJpbm9kZTY0Ii4KCmNoZWVycywKTWljaGFlbAoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNA
b3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
