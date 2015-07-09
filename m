Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 18B507F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 08:29:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 08B73304039
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 06:29:22 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id rGpNTD7s7WyxdGFy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 06:29:21 -0700 (PDT)
Date: Thu, 9 Jul 2015 15:29:24 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Proper SU/SW values for nested raids RAID50/RAID60
Message-ID: <20150709152924.21ca4669@harpe.intellique.com>
In-Reply-To: <trinity-35b666d3-ff9b-4764-9962-bf376c678994-1436381694787@3capp-mailcom-bs09>
References: <trinity-35b666d3-ff9b-4764-9962-bf376c678994-1436381694787@3capp-mailcom-bs09>
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
To: Mark Noon <mnoon@gmx.com>
Cc: xfs@oss.sgi.com

TGUgV2VkLCA4IEp1bCAyMDE1IDIwOjU0OjU0ICswMjAwCiJNYXJrIE5vb24iIDxtbm9vbkBnbXgu
Y29tPiDDqWNyaXZhaXQ6Cgo+IEknbSB0cnlpbmcgdG8gdW5kZXJzdGFuZCB0aGUgcHJvcGVyIHZh
bHVlcyB3aGVuIGZvcm1hdHRpbmcgYW4geGZzCj4gZmlsZXN5c3RlbSB1bmRlciBhIGhhcmR3YXJl
IHJhaWQgY29udHJvbGxlciBhbmQgc2VlbSB0byBnZXQKPiBjb25mbGljdGluZyBpbmZvcm1hdGlv
biBiZXR3ZWVuIHdoYXRzIG9uIHRoZSB3aWtpIGFuZCB2YXJpb3VzIG1haWxpbmcKPiBsaXN0aW5n
cyBhbmQgZm9ydW0gcG9zdHMgd2hlbiBzZWFyY2hpbmcgZ29vZ2xlLiBJIGhhdmUgYSBzeXN0ZW0g
dGhhdAo+IHdpbGwgYmUgc3RvcmluZyBpbWFnZXMgYW5kIG90aGVyIHN0YXRpYyBjb250ZW50IGZp
bGVzIGFjY3Jvc3MgYQo+IFJBSUQ1MC4gVGhlIHBsYW4gaXMgdG8gZG8gMyByYWlkNSBhcnJheXMg
ZWFjaCB3aXRoIDUgZGlza3Mgd2l0aCBhCj4gc3RyaXBlIHNpemUgb2YgMTI4SyBzdHJpcGVkIGFj
Y3Jvc3MgYSByYWlkMC4gSSB3aWxsIHRoZW4gYnVpbGQgYQo+IGxvZ2ljYWwgdm9sdW1lIG9uIHRv
cCBvZiB0aGlzLiBXaGVuIHJ1bm5pbmcgbWtmcy54ZnMgc2hvdWxkIHRoZQo+IGNvcnJlY3Qgc2V0
dGluZ3MgYmUgc3U9MTI4ayBzdz0xMiAoLTEgcGFyaXR5ICdkaXNrJyBmb3IgZWFjaCBvZiB0aGUg
Mwo+IGFycmF5cykgb3Igc3U9MTI4ayBzdz00IChvbmx5IGNvbnNpZGVyIG9uZSBvZiB0aGUgYXJy
YXlzKT8gQWxzbyBpZiBJCj4gZXZlciBhZGQgYSBKQk9EIGFuZCBleHRlbmQgdGhlIHN0b3JhZ2Ug
aG93IGRvZXMgdGhpcyBjaGFuZ2UgdGhpbmdzCj4gZXNzcGVjaWFsbHkgZ2l2ZW4gdGhhdCBpdCB3
aWxsIGJlIG9uIGEgY29tcGxldGVseSBkaWZmZXJlbnQgcmFpZAo+IHZvbHVtZSBqdXN0IG1lcmdl
ZCB0b2dldGhlciB2aWEgTFZNPyBUaGFua3MgZm9yIHRoZSBhc3NpdGFuY2UhIAoKWW91IHNob3Vs
ZCBwcm9iYWJseSBnbyB3aXRoIHRoZSAxMjhLIHN1LzEyIHN3IHZhbHVlLiBJdCBwcm9iYWJseSB3
b24ndAptYWtlIG11Y2ggZGlmZmVyZW5jZS4KV2hlbiB5b3UnbGwgZXh0ZW5kIHlvdXIgRlMgd2l0
aCBMVk0sIHlvdXIgYXR0ZW1wdCBhdCBvcHRpbWlzYXRpb24gd2lsbApiZSBjb21wbGV0ZWx5IG51
bGxpZmllZCBhbnl3YXkgOikKCi0tIAotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KRW1tYW51ZWwgRmxvcmFjICAg
ICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQogICAgICAgICAgICAgICAgICAgIHwgICBJbnRlbGxp
cXVlCiAgICAgICAgICAgICAgICAgICAgfAk8ZWZsb3JhY0BpbnRlbGxpcXVlLmNvbT4KICAgICAg
ICAgICAgICAgICAgICB8ICAgKzMzIDEgNzggOTQgODQgMDIKLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBs
aXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94
ZnMK
