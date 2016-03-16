Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BD7A47D01
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 08:16:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 877C5304043
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 06:16:15 -0700 (PDT)
Received: from mail1.bemta3.messagelabs.com (mail1.bemta3.messagelabs.com
	[195.245.230.176]) by cuda.sgi.com with ESMTP id
	q3h3pwd9Flp1rPxN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 06:16:12 -0700 (PDT)
From: Sandeep Patel <spatel@omnifone.com>
Subject: RE: XFS corruptions
Date: Wed, 16 Mar 2016 13:15:59 +0000
Message-ID: <558408F298C8CE4C89D93BD56AB474E8018621BE9E@EXBE1IS02.omnifone.com>
References: <558408F298C8CE4C89D93BD56AB474E8018617B2B3@EXBE1IS02.omnifone.com>
	<20151130184048.3fa123e0@harpe.intellique.com>
	<558408F298C8CE4C89D93BD56AB474E8018617B3A6@EXBE1IS02.omnifone.com>
	<20151130194554.6140bf30@harpe.intellique.com>
	<558408F298C8CE4C89D93BD56AB474E8018617C636@EXBE1IS02.omnifone.com>
	<20151201145011.6df02063@harpe.intellique.com>
	<558408F298C8CE4C89D93BD56AB474E8018618503B@EXBE1IS02.omnifone.com>
	<20151210164640.78a13865@harpe.intellique.com>
	<558408F298C8CE4C89D93BD56AB474E801861CBD2B@EXBE1IS02.omnifone.com>
	<20160111161602.0c8413ca@harpe.intellique.com>
In-Reply-To: <20160111161602.0c8413ca@harpe.intellique.com>
Content-Language: en-US
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

SGkgRW1tYW51ZWwsCgpJdCBzZWVtcyB5b3Ugd2VyZSBjb3JyZWN0LiBPdXIgY2x1c3RlciBzZWVt
cyB0byBiZSBtdWNoIG1vcmUgc3RhYmxlIHNpbmNlIHRoZSBrZXJuZWwgdXBncmFkZS4KClRoYW5r
IHlvdSB2ZXJ5IG11Y2ggZm9yIHlvdXIgaGVscC4gUmVhbGx5IGFwcHJlY2lhdGUgaXQuCgpLaW5k
IFJlZ2FyZHMKU2FuZGVlcAoKLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0KRnJvbTogRW1tYW51
ZWwgRmxvcmFjIFttYWlsdG86ZWZsb3JhY0BpbnRlbGxpcXVlLmNvbV0gClNlbnQ6IDExIEphbnVh
cnkgMjAxNiAxNToxNgpUbzogU2FuZGVlcCBQYXRlbApDYzogeGZzQG9zcy5zZ2kuY29tClN1Ympl
Y3Q6IFJlOiBYRlMgY29ycnVwdGlvbnMKCkxlIE1vbiwgMTEgSmFuIDIwMTYgMTQ6MjA6MTIgKzAw
MDAKU2FuZGVlcCBQYXRlbCA8c3BhdGVsQG9tbmlmb25lLmNvbT4gw6ljcml2YWl0OgoKPiBIaSBF
bW1hbnVlbCwKPiAKPiBJIGhhdmUgbWFuYWdlZCB0byB1cGdyYWRlIG91ciBrZXJuZWwgdG8gMy44
LjEzLTExOC4yLjIuZWw2dWVrLng4Nl82NCAKPiB3aGljaCB3YXMgdGhlIGxhdGVzdCBhdmFpbGFi
bGUgb24gb3VyIHJlcG8uIEkgd2lsbCBsZXQgeW91IGtub3cgaG93IEkgCj4gZ2V0IG9uLgo+IAoK
T0suIEknbSBwcmV0dHkgY29uZmlkZW50IGl0IHNob3VsZCBlbmhhbmNlIHRoZSBzaXR1YXRpb24g
OikKCi0tCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpFbW1hbnVlbCBGbG9yYWMgICAgIHwgICBEaXJlY3Rpb24g
dGVjaG5pcXVlCiAgICAgICAgICAgICAgICAgICAgfCAgIEludGVsbGlxdWUKICAgICAgICAgICAg
ICAgICAgICB8CTxlZmxvcmFjQGludGVsbGlxdWUuY29tPgogICAgICAgICAgICAgICAgICAgIHwg
ICArMzMgMSA3OCA5NCA4NCAwMgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KVGhpcyBl
bWFpbCBoYXMgYmVlbiBzY2FubmVkIGJ5IHRoZSBTeW1hbnRlYyBFbWFpbCBTZWN1cml0eS5jbG91
ZCBzZXJ2aWNlLgpGb3IgbW9yZSBpbmZvcm1hdGlvbiBwbGVhc2UgdmlzaXQgaHR0cDovL3d3dy5z
eW1hbnRlY2Nsb3VkLmNvbSBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClRoaXMgZW1haWwg
aGFzIGJlZW4gc2Nhbm5lZCBieSB0aGUgU3ltYW50ZWMgRW1haWwgU2VjdXJpdHkuY2xvdWQgc2Vy
dmljZS4KRm9yIG1vcmUgaW5mb3JtYXRpb24gcGxlYXNlIHZpc2l0IGh0dHA6Ly93d3cuc3ltYW50
ZWNjbG91ZC5jb20KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
