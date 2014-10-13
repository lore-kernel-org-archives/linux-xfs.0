Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5776D7F4E
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 05:40:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 39ABE8F804B
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 03:40:56 -0700 (PDT)
Received: from st11p01mm-asmtp001.mac.com (st11p01mm-asmtp001.mac.com
	[17.172.204.239]) by cuda.sgi.com with ESMTP id
	0gmLz0xbzDVpWtG7 (version=TLSv1 cipher=RC4-MD5 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Oct 2014 03:40:55 -0700 (PDT)
Received: from [192.168.142.67] (unknown [82.71.189.231])
	by st11p01mm-asmtp001.mac.com
	(Oracle Communications Messaging Server 7u4-27.10(7.0.4.27.9) 64bit
	(built Jun
	6 2014)) with ESMTPSA id <0NDD00H4RPNMVH80@st11p01mm-asmtp001.mac.com>
	for xfs@oss.sgi.com; Mon, 13 Oct 2014 10:40:36 +0000 (GMT)
References: <1413103408756-35026.post@n7.nabble.com>
	<20141012142008.GB35667@bfoster.bfoster>
	<DUB113-W9BCC0D296AF7CD5D9D02FB6AF0@phx.gbl>
	<DUB113-W8015EC9E74D26138852F2FB6AF0@phx.gbl>
	<20141012231001.GC5267@dastard>
	<A78F010F-2624-465E-8D16-0D89D39FD093@me.com>
	<20141013121951.6daa8652@harpe.intellique.com>
MIME-version: 1.0 (1.0)
In-reply-to: <20141013121951.6daa8652@harpe.intellique.com>
Message-id: <7053E9A9-ABEF-441B-85F9-AFAE7C97C7F5@me.com>
From: Tom Mason <tom_mason@me.com>
Subject: Re: Mount: Structure needs cleaning
Date: Mon, 13 Oct 2014 11:40:33 +0100
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

PiBPbiAxMyBPY3QgMjAxNCwgYXQgMTE6MTksIEVtbWFudWVsIEZsb3JhYyA8ZWZsb3JhY0BpbnRl
bGxpcXVlLmNvbT4gd3JvdGU6Cj4gCj4gTGUgTW9uLCAxMyBPY3QgMjAxNCAxMTowNTo0OSArMDEw
MAo+IFRvbSBNYXNvbiA8dG9tX21hc29uQG1lLmNvbT4gw6ljcml2YWl0Ogo+IAo+Pj4gV2hpY2gg
bWVhbnMgdGhlIGZpbGVzeXN0ZW0gdHJpZWQgdG8gcmVhZCB0aGUgb2Zmc2V0IGF0IDYyR0IgYW5k
IHRoZQo+Pj4gdW5kZXJseWluZyBkZXZpY2UgZmFpbGVkIGl0IHdpdGggRUlPLiBUaGF0J3Mgbm90
IGFuIFhGUyBmYWlsdXJlLgo+Pj4gV2hhdCBlcnJvciBpcyB0aGVyZSBpbiBkbWVzZyB3aGVuIHlv
dSBydW4gdGhhdCB4ZnNfcmVwYWlyIGNvbW1hbmQ/ICAKPj4gCj4+IFdoYXQncyBFSU8/Cj4+ICdF
cnJvciBpbiBkbWVzZycgSG93IHdvdWxkIEkgcmVwb3J0IHRoaXMgaW5mbyB0byB5b3U/Cj4gCj4g
IklucHV0L091dHB1dCBFcnJvciIgLiBSdW4gdGhlICJkbWVzZyIgY29tbWFuZCBpbW1lZGlhdGVs
eSBhZnRlcgo+IHRoaXMgZXJyb3IsIGFuZCBzZWUgd2hhdCBpdCByZXBvcnRzIGxhc3QgKGVuZCBv
ZiBjb21tYW5kIG91dHB1dCkuCj4gCj4+PiBUaGlzIGFza3MgeW91IHRvIHBvc3QgdGhlIGNvbnRl
bnRzIG9mIC9wcm9jL3BhcnRpdGlvbnMsIHdoaWNoIGlzCj4+PiB3aGF0IHRoZSBrZXJuZWwgdGhp
bmtzIGFyZSB0aGUgcGFydGl0aW9uIHNpemVzLiAgCj4+IAo+PiBIb3cgZG8gSSBkbyB0aGlzPwo+
IAo+IGNhdCAvcHJvYy9wYXJ0aXRpb25zCj4gCj4+Pj4gWWVzIGl0J3MgYSBOQVMgZHJpdmUgYW5k
IHNvIEkgYXNzdW1lIGhhZCBzb21lIGtpbmQgb2YgcHJvcHJpZXRhcnkKPj4+PiBPUyBvbiB0aGUg
b3RoZXIgcGFydGl0aW9ucyAodGhpcyBpcyB3aGVyZSBpIG1pZ2h0IGhhdmUgbWVzc2VkIHVwCj4+
Pj4gYnkgZGVsZXRpbmc/ISkgSSdtIHByZXR0eSBzdXJlIHRoYXQgdGhlIGRyaXZlIGluIGJvbGQg
YmVsb3cgKHNkYzIpCj4+Pj4gaXMgdGhlIG9uZSBJJ20gYWZ0ZXIgd2hpY2ggaXMgeGZzLi4uICAK
Pj4+IAo+Pj4gVW1tbSwgZXhhY3RseSB3aGF0IGFyZSB5b3UgdHJ5aW5nIHRvIGRvIHdpdGggdGhp
cyBkcml2ZS9maWxlc3lzdGVtPwo+Pj4gV2hhdCBkZXZpY2UgZGlkIHRoZSBkcml2ZSBjb21lIGZy
b20gaW4gdGhlIGZpcnN0IHBsYWNlPyAgCj4+IAo+PiBJdCdzIGEgbGFjaWUgJ05laWwgcG91bHRv
bicgbmV0d29yayBzcGFjZTEgMXRiIE5BUyBkcml2ZSAoc2VlIGZpcnN0Cj4+IHBhcmFncmFwaCBv
ZiBwb3N0KSAtIGl0IHJlY2VudGx5IHN0b3BwZWQgd29ya2luZyBhbmQgd2FzIHN0dWNrIGluIGEK
Pj4gJ3NwaW4gY3ljbGUnIC0gaXQgY29udGFpbnMgbXkgbXVzaWMgYW5kIHZpZGVvIGJhY2t1cHMu
IEknbSB0cnlpbmcgdG8KPj4gcmVjb3ZlciB0aGUgZmlsZXMuLi4KPiAKPiBNb3N0IHByb2JhYmx5
IGRpc2sgaXMgYmFkbHkgZGFtYWdlZCwgZGVhZCBvciBkeWluZy4gSXQncyBhZHZpc2FibGUgdG8K
PiB0cnkgdG8gY3JlYXRlIGFuIGltYWdlIG9mIHRoZSBkaXNrIG9uIGFub3RoZXIgb25lLCBhbmQg
d29yayBmb3IgdGhpcwo+IGltYWdlLCBiZWNhdXNlIHRoaXMgZGlzayB3aWxsIHByb2JhYmx5IGRp
ZSBhbnkgdGltZSBub3cuIEl0J3Mgbm8gdXNlCj4gdHJ5aW5nIHRvIHJlcGFpciBhIGZpbGVzeXN0
ZW0gb24gYSBiYWQgZHJpdmUsIHdoaWNoIGlzIHRoZSBjYXVzZSBvZiB0aGUKPiBlcnJvcnMgZnJv
bSB0aGUgYmVnaW5uaW5nLiAKPiAKPiBJZiBhbGwgeW91IGNhcmUgaXMgdG8gZ2V0IHlvdXIgZmls
ZXMgYmFjaywganVzdCB0cnkgdG8gbW91bnQgdGhlIHZvbHVtZQo+IGluIHJlYWQtb25seSwgbm9u
LXJlY292ZXJ5IG1vZGUgOgo+IAo+IG1vdW50IC1vIHJvLG5vcmVjb3ZlcnkgL2Rldi9zZGMyIC90
bXAvbW91bnQKPiAKPiBUaGVuIHByb2NlZWQgYnkgY29weWluZyB3aGF0ZXZlciB5b3UgY2FuIGdl
dC4gQ29uc2lkZXIgdGhhdCBhbnkgZmlsZQo+IHRoYXQgZ2l2ZXMgYW4gZXJyb3IgaXMgbG9zdC4K
PiAKPiBUaGUgb3RoZXIgb3B0aW9uIGlzIEtyb2xsIE9udHJhY2sgb3Igc2ltaWxhciBzZXJ2aWNl
cywgb2YgY291cnNlLgo+IAo+IEVtbWFudWVsIEZsb3JhYyAgICAgCgpUaGFua3MgZXZlcnlvbmUg
LSBJJ20gYXdheSBmcm9tIHRoZSBkZXZpY2UgYXQgdGhlIG1vbWVudCBzbyB3aWxsIHJlcG9ydCBi
YWNrIHdoZW4gSSBnZXQgaG9tZSwgaW4gYWJvdXQgOCBob3VycyBvciBzby4uClRvbQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0
Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
