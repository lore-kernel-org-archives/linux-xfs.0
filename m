Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2BB157F47
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 01:17:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 255768F8035
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 23:17:50 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id q8gCMWjXtvDIe9lA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Sep 2015 23:17:47 -0700 (PDT)
Date: Thu, 17 Sep 2015 08:17:57 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: easily reproducible filesystem crash on rebuilding array
Message-ID: <20150917081757.48aaf891@galadriel.home>
In-Reply-To: <CAH-PCH7W4yTDRhAiKQwN_wQJMx2sTitQYrLNPcLYHvJRucXBjA@mail.gmail.com>
References: <CAH-PCH7W4yTDRhAiKQwN_wQJMx2sTitQYrLNPcLYHvJRucXBjA@mail.gmail.com>
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
To: Ferenc Kovacs <tyra3l@gmail.com>, xfs@oss.sgi.com

TGUgV2VkLCAxNiBTZXAgMjAxNSAxNTo1MDoxMyArMDIwMCB2b3VzIMOpY3JpdmllejoKCj4gSGks
Cj4gCj4gaGF2ZSB5b3UgZm91bmQgYSByZXNvbHV0aW9uIHRvIHlvdXIgcHJvYmxlbT8KPiB3ZSBh
cmUgZmFjaW5nIGEgc2ltaWxhciBpc3N1ZShmcyBjb3JydXB0aW9uIGV2ZXJ5IHRpbWUgd2hlbgo+
IHJlYnVpbGRpbmcgdGhlIGFycmF5KSB3aXRoIGFuIEFkYXB0ZWMgU2VyaWVzIDggUmFpZCBjb250
cm9sbGVyLgoKVGhlIHByb2JsZW0gZGlkbid0IG9jY3VyIGFueW1vcmUgYWZ0ZXIgSSBkZWFjdGl2
YXRlZAppbmRpdmlkdWFsIGRpc2tzIHdyaXRlIGNhY2hpbmcgaW4gdGhlICJjb250cm9sbGVyIHNl
dHRpbmdzIi4gVGhpcyBpcwpvbmx5IGFkanVzdGFibGUgdGhyb3VnaCB0aGUgUkFJRCBCSU9TIHRo
b3VnaCwgbm90IHRocm91Z2ggYXJjY29uZgphcHBhcmVudGx5LgpUaGlzIHNlZW1zIHRvIGFwcGx5
IHRvIGFsbCBvZiA1eHg1LCA2eHg1LCA3eHg1IHNlcmllcy4gSSBuZXZlciByZWJ1aWx0CmFuIGFy
cmF5IHdpdGggYSA4eHg1IHlldCAodGhvdWdoIEkgaGF2ZSBzb21lKS4gSSBkb24ndCBrbm93IHdo
eSB0aGlzIGlzCm5vdCB0aGUgZGVmYXVsdCBzZXR0aW5ncyAoZGVmYXVsdCBrZWVwcyB0aGUgZGlz
a3Mgd3JpdGUgY2FjaGUgYWN0aXZlCmluc3RlYWQpLiBBZGFwdGVjIHN1cHBvcnQgYW5kIGVuZ2lu
ZWVyaW5nIGRlbnkgdGhhdCB0aGUgcHJvYmxlbSBleGlzdHMsCnRob3VnaCBJJ3ZlIHNlbnQgbWFu
eSBsb2dzIGFuZCBkZWZpbmVkIGEgdGVzdCBwcm9jZWR1cmUgdGhhdCBhbGxvdyB0bwpyZXByb2R1
Y2UgdGhlIHByb2JsZW0gcmVsaWFibHkgZW5vdWdoLgpUaGFua3MgZ29kIGZvciBYRlMuIGV4dDQg
aXMgY29tcGxldGVseSB1bmF3YXJlIG9mIHRoZSBjb3JydXB0aW9ucywgYnV0CnRoZXkncmUgcHJl
c2VudCBub25ldGhlbGVzcyAobWQ1c3VtbWluZyBmaWxlcyBiZWZvcmUsIGR1cmluZyBhbmQKYWZ0
ZXIgcmVidWlsZCkuLi4KCkJUVyBJJ20gY3VyaW91cywgd2hlcmUgZGlkIHlvdSBmaW5kIHRoaXMg
YWRkcmVzcz8gVGhpcyBpc24ndCB0aGUgb25lCkknbSB1c2luZyBvbiB0aGUgWEZTIG1haWxpbmcg
bGlzdC4uLgoKY2hlZXJzCi0tIAotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KRW1tYW51ZWwgRmxvcmFjICAgICB8
ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQogICAgICAgICAgICAgICAgICAgIHwgICBJbnRlbGxpcXVl
CiAgICAgICAgICAgICAgICAgICAgfAk8ZWZsb3JhY0BpbnRlbGxpcXVlLmNvbT4KICAgICAgICAg
ICAgICAgICAgICB8ICAgKzMzIDEgNzggOTQgODQgMDIKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0
Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
