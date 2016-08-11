Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 745847CA3
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 05:45:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 381B4304039
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 03:45:01 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id huU7Jaj4MALKpf0h (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 03:44:58 -0700 (PDT)
Date: Thu, 11 Aug 2016 12:44:59 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Question on migrating data between PVs in xfs
Message-ID: <20160811124459.57f9a352@harpe.intellique.com>
In-Reply-To: <20160810215149.GM19025@dastard>
References: <20160809145046.GB5583@ic> <20160809223503.GJ19025@dastard>
	<20160810092313.GA16193@ic> <20160810105639.GR16044@dastard>
	<20160810183132.0b9ae8e4@harpe.intellique.com>
	<20160810215149.GM19025@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Wei Lin <lin.wei15@imperial.ac.uk>

TGUgVGh1LCAxMSBBdWcgMjAxNiAwNzo1MTo0OSArMTAwMApEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IMOpY3JpdmFpdDoKCj4gT24gV2VkLCBBdWcgMTAsIDIwMTYgYXQgMDY6MzE6
MzJQTSArMDIwMCwgRW1tYW51ZWwgRmxvcmFjIHdyb3RlOgo+ID4gTGUgV2VkLCAxMCBBdWcgMjAx
NiAyMDo1NjozOSArMTAwMAo+ID4gRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPiDD
qWNyaXZhaXQ6Cj4gPiAgIAo+ID4gPiBIYXZlIHlvdSBsb29rZCBhdCB1c2luZyBkbS1jYWNoZSBp
bnN0ZWFkIG9mIG1vZGlmeWluZyB0aGUKPiA+ID4gZmlsZXN5c3RlbT8KPiA+ID4gICAKPiA+IAo+
ID4gT3IgYmNhY2hlLCBmY2FjaGUsIG9yIEVuaGFuY2VJTy4gU28gZmFyIGZyb20gbXkgb3duIHRl
c3RpbmcgYmNhY2hlCj4gPiBpcyBzaWduaWZpY2FudGx5IGZhc3RlciBhbmQgZG0tY2FjaGUgYnkg
ZmFyIHRoZSBzbG93ZXN0IG9mIHRoZQo+ID4gYnVuY2gsIGJ1dCBiY2FjaGUgbmVlZHMgc29tZSBt
b3JlIGxvdmluZyAoaGlzIG1haW4gZGV2ZWxvcGVyIGlzCj4gPiBidXN5IHdyaXRpbmcgc29tZSBu
ZXcgdGllcmVkLCBjYWNoaW5nIGZpbGVzeXN0ZW0gaW5zdGVhZCkuICAKPiAKPiBZZWFoLCB0aGUg
cHJvYmxlbSB3aXRoIGJjYWNoZSBpcyB0aGF0IGl0IGlzIGVmZmVjdGl2ZWx5IGFuIG9ycGhhbmVk
Cj4gZHJpdmVyLiBJZiB0aGVyZSBhcmUgb2J2aW91cyBhbmQgcmVwcm9kdWNhYmxlIHBlcmZvcm1h
bmNlCj4gZGlmZmVyZW50aWFscyBiZXR3ZWVuIGJjYWNoZSBhbmQgZG0tY2FjaGUsIHlvdSBzaG91
bGQgYnJpbmcgdGhlbSB0bwo+IHRoZSBhdHRlbnRpb24gb2YgdGhlIGRtIGRldmVsb3BlcnMgdG8g
c2VlIGlmIHRoZXkgY2FuIGZpeCB0aGVtLi4uCgpHb29kIGlkZWEuIFdlbGwgYmNhY2hlIG1heSBi
ZSBvcnBoYW5lZCBvZiBpdHMgbWFpbiBkZXZlbG9wZXIsIGhvd2V2ZXIKb3RoZXJzIHN0aWxsIHN1
Ym1pdCBxdWl0ZSBhIGxvdCBvZiBzdGFiaWxpdHkgcGF0Y2hlcyAoYW1vbmcgdGhlbQpDaHJpc3Rv
cGggSGVsbHdpZyB3aGljaCBpcyBhbHNvIGFjdGl2ZSBoZXJlIElJUkMpLgoKLS0gCi0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQpFbW1hbnVlbCBGbG9yYWMgICAgIHwgICBEaXJlY3Rpb24gdGVjaG5pcXVlCiAgICAg
ICAgICAgICAgICAgICAgfCAgIEludGVsbGlxdWUKICAgICAgICAgICAgICAgICAgICB8CTxlZmxv
cmFjQGludGVsbGlxdWUuY29tPgogICAgICAgICAgICAgICAgICAgIHwgICArMzMgMSA3OCA5NCA4
NCAwMgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Mu
c2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
