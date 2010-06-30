Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5TNwXVH098495 for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 18:58:34 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E6FB419361
	for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 17:01:19 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id dLIVfh5HTHbEj4Yn for
	<xfs@oss.sgi.com>; Tue, 29 Jun 2010 17:01:19 -0700 (PDT)
Message-ID: <4C2A8948.3030008@tlinx.org>
Date: Tue, 29 Jun 2010 17:01:12 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs file system in process of becoming corrupt;
	though xfs_repair thinks it's fine! ; -/ (was xfs_dump problem...)
References: <4C26A51F.8020909@tlinx.org> <20100628022744.GX6590@dastard>
	<4C2A749E.4060006@tlinx.org> <20100629232532.GA24712@dastard>
In-Reply-To: <20100629232532.GA24712@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs-oss <xfs@oss.sgi.com>

CgpEYXZlIENoaW5uZXIgd3JvdGU6Ci0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQo+PiBJc2h0YXI6L1RvcnJlbnRzPiAnbHMnIC1uaSBiYWQqICAgICBsczogY2Fubm90
IGFjY2VzcyBiYWQvMzAtT21vaWRlCj4+IHRvIFlha3Vzb2t1IChUViBzYWl6de+9nFJlaW5hyrxz
IFZlci4pLm1wMzogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQo+PiBsczogY2Fubm90IGFjY2Vz
cyBiYWQvMzEtT21vaWRlIHRvIFlha3Vzb2t1IChUViBzYWl6de+9nFRvbW9lyrxzIFZlci4pLm1w
MzogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQo+PiBsczogY2Fubm90IGFjY2VzcyBiYWQvMzIt
T21vaWRlIHRvIFlha3Vzb2t1IChUViBzYWl6de+9nE5hbnVhbMq8cyBWZXIuKS5tcDM6IE5vIHN1
Y2ggZmlsZSBvciBkaXJlY3RvcnkKPj4gYmFkOgo+PiB0b3RhbCAwCj4+IDIzNTkxMDEgPz8/Pz8/
Pz8/PyA/ID8gPyA/ICAgICAgICAgICAgICAgID8gMzAtT21vaWRlIHRvIFlha3Vzb2t1IChUViBz
YWl6de+9nFJlaW5hyrxzIFZlci4pLm1wMwo+PiAyMzU0OTQ2ID8/Pz8/Pz8/Pz8gPyA/ID8gPyAg
ICAgICAgICAgICAgICA/IDMxLU9tb2lkZSB0byBZYWt1c29rdSAoVFYgc2FpenXvvZxUb21vZcq8
cyBWZXIuKS5tcDMKPj4gMjM1NDk0OSA/Pz8/Pz8/Pz8/ID8gPyA/ID8gICAgICAgICAgICAgICAg
PyAzMi1PbW9pZGUgdG8gWWFrdXNva3UgKFRWIHNhaXp1772cTmFudWFsyrxzIFZlci4pLm1wMwo+
PiBsczogY2Fubm90IGFjY2VzcyBiYWQyLzMwLU9tb2lkZSB0byBZYWt1c29rdSAoVFYgc2FpenXv
vZxSZWluYcq8cyBWZXIuKS5tcDM6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKPj4gbHM6IGNh
bm5vdCBhY2Nlc3MgYmFkMi8zMS1PbW9pZGUgdG8gWWFrdXNva3UgKFRWIHNhaXp1772cVG9tb2XK
vHMgVmVyLikubXAzOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5Cj4+IGxzOiBjYW5ub3QgYWNj
ZXNzIGJhZDIvMzItT21vaWRlIHRvIFlha3Vzb2t1IChUViBzYWl6de+9nE5hbnVhbMq8cyBWZXIu
KS5tcDM6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKPiAKPiBUaG9zZSBmaWxlIG5hbWVzIGhh
dmUgYSB3ZWlyZCBjaGFyYWN0ZXIgaW4gdGhlbSAtIGFyZSB5b3Ugc3VyZSB0aGF0Cj4gdGhlIHRl
cm1pbmFsIHN1cHBvcnRzIHRoYXQgY2hhcmFjdGVyIHNldCBhbmQgaXMgbm90IG1hbmdsaW5nIGl0
IGFuZAo+IGhlbmNlIG5vdCBtYXRjaGluZyB3aGF0IGlzIGFjdHVhbGx5IHN0b3JlZCBvbiBkaXNr
PwotLS0tLQpUaG9zZSBmaWxlcyB3ZXJlICdmaW5lJyBiZWZvcmUgdG9kYXkuCgpJIGtub3cgaXQg
aXMgbm90IGEgdGVybWluYWwgcHJvYmxlbSAtLQpJIHRvbGQgbHMgdG8gbGlzdCBhbGwgZmlsZXMg
aW4gdGhlIGRpcmVjdG9yeSAtLSB0aGVuIGl0IHNheXMgIm5vIHN1Y2ggZmlsZSIuCgpDYW4geW91
IHNheSB0aGF0ICIqIiBzaG91bGRuJ3QgbWF0Y2ggZXZlcnl0aGluZz8KClRob3NlIHF1ZXN0aW9u
IG1hcmtzIGFyZSBpbiB0aGUgcGxhY2UgZm9yIHRoZSBzaXplIQoKVGhlcmUgYXJlIG5vIHdlaXJk
IGNoYXJhY3RlcnMgaW4gdGhvc2UgZmlsZSBuYW1lcy4KCkhlcmUgYXJlIHRoZSBzYW1lIGZpbGVz
IGluIGFub3RoZXIgZGlyZWN0b3J5OgptcDM+IGxsIDMqCi1yd3gtLS0tLS0gMSAzMjU1NzAyIDIw
MTAtMDYtMTQgMTA6NTQgMzAtT21vaWRlIHRvIFlha3Vzb2t1IChUViBzYWl6de+9nFJlaW5hyrxz
IFZlci4pLm1wMyoKLXJ3eC0tLS0tLSAxIDMyNzIwMDQgMjAxMC0wNi0xNCAxMDo1NCAzMS1PbW9p
ZGUgdG8gWWFrdXNva3UgKFRWIHNhaXp1772cVG9tb2XKvHMgVmVyLikubXAzKgotcnd4LS0tLS0t
IDEgMzIzNDg3NiAyMDEwLTA2LTE0IDEwOjU0IDMyLU9tb2lkZSB0byBZYWt1c29rdSAoVFYgc2Fp
enXvvZxOYW51YWzKvHMgVmVyLikubXAzKgoKClRoZSBmaWVsZHMgaXQgY2FuJ3QgZGlzcGxheSBh
cmUgdGhlIGZpbGUgc2l6ZSwgdGltZSBhbmQgZGF0ZXMhICBUaGUgbmFtZXMgZGlzcGxheSBvayEK
CkhvdyBjYW4gZmlsZSBzaXplLCB0aW1lIGFuZCBkYXRlIGJlIGluIHVucHJpbnRhYmxlIGNoYXJh
Y3RlcnMgdGhhdCAibHMiIGNhbid0IGRpc3BsYXk/CgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpo
dHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
