Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C15D7F37
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 13:52:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C7A9AC006
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 11:52:08 -0800 (PST)
Received: from mail1.bemta5.messagelabs.com (mail1.bemta5.messagelabs.com
	[195.245.231.137]) by cuda.sgi.com with ESMTP id
	MLT49roFxHsH7HKH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2015 11:52:06 -0800 (PST)
From: Sandeep Patel <spatel@omnifone.com>
Subject: RE: XFS corruptions
Date: Thu, 10 Dec 2015 19:51:58 +0000
Message-ID: <558408F298C8CE4C89D93BD56AB474E801861855CC@EXBE1IS02.omnifone.com>
References: <558408F298C8CE4C89D93BD56AB474E8018617B2B3@EXBE1IS02.omnifone.com>
	<20151130184048.3fa123e0@harpe.intellique.com>
	<558408F298C8CE4C89D93BD56AB474E8018617B3A6@EXBE1IS02.omnifone.com>
	<20151130194554.6140bf30@harpe.intellique.com>
	<558408F298C8CE4C89D93BD56AB474E8018617C636@EXBE1IS02.omnifone.com>
	<20151201145011.6df02063@harpe.intellique.com>
	<558408F298C8CE4C89D93BD56AB474E8018618503B@EXBE1IS02.omnifone.com>
	<20151210164640.78a13865@harpe.intellique.com>
In-Reply-To: <20151210164640.78a13865@harpe.intellique.com>
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

SGkgRW1tYW51ZWwsCgpTb21lIGV4dHJhIGluZm9ybWF0aW9uIGZvciB0aGUgdm9sdW1lIHdoaWNo
IG1heSBiZSByZWxhdGVkLiBXZSBkbyBub3QgcGFydGl0aW9uIG9yIGFsaWduIHRoZSB4ZnMgZm9y
bWF0dGVkIHZvbHVtZS4gV2UgbW91bnQgaXQgZGlyZWN0bHkgdXNpbmcgL2Rldi9zZGEuIFRoZSBm
c3RhYiBpbmZvIGJlbG93LgoKTEFCRUw9YnJpY2sxICAgICAgICAgICAgL2V4cG9ydC9icmljazEg
ICAgICAgICAgeGZzICAgICBub2JhcnJpZXIsaW5vZGU2NCAxIDIKTEFCRUw9YnJpY2syICAgICAg
ICAgICAgL2V4cG9ydC9icmljazIgICAgICAgICAgeGZzICAgICBub2JhcnJpZXIsaW5vZGU2NCAx
IDIKClRoYW5rcwpTYW5kZWVwCgotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQpGcm9tOiBFbW1h
bnVlbCBGbG9yYWMgW21haWx0bzplZmxvcmFjQGludGVsbGlxdWUuY29tXSAKU2VudDogMTAgRGVj
ZW1iZXIgMjAxNSAxNTo0NwpUbzogU2FuZGVlcCBQYXRlbApDYzogeGZzQG9zcy5zZ2kuY29tClN1
YmplY3Q6IFJlOiBYRlMgY29ycnVwdGlvbnMKCkxlIFRodSwgMTAgRGVjIDIwMTUgMTU6MDc6MzIg
KzAwMDAKU2FuZGVlcCBQYXRlbCA8c3BhdGVsQG9tbmlmb25lLmNvbT4gw6ljcml2YWl0OgoKPiBB
bnkgbHVjayB3aXRoIHRoZSB0ZXN0aW5nLiBJIGFtIGF0dGFjaGluZyBhIGNvcHkgb2YgbXkgZG1l
c2cgb3V0cHV0IAo+IHdoaWNoIGtlZXBzIG9uIHJlcGVhdGluZy4gSW4gdGhpcyBjYXNlLCB0aGUg
ZXJyb3Igc2VlbXMgdG8gYmUgd2l0aCBvbmUgCj4gZGlub2RlLgo+IAoKSSd2ZSBydW4gc29tZSB0
ZXN0cyBvbiBhIDE4eDYgVEIgYXJyYXksIGFuZCBubyBlcnJvciBvY2N1cnJlZC4gSG93ZXZlciBJ
J20gcnVubmluZyBhIG11Y2ggbmV3ZXIga2VybmVsLCAzLjE4LjI0LgoKQ291bGQgeW91IG1heWJl
IHRyeSBpbnN0YWxsaW5nIGEgZGlmZmVyZW50IGtlcm5lbCBvbiBzb21lIG1hY2hpbmVzIGFuZCBz
ZWUgaWYgaXQgcGVyZm9ybXMgZGlmZmVyZW50bHk/CgotLQotLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KRW1tYW51
ZWwgRmxvcmFjICAgICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQogICAgICAgICAgICAgICAgICAg
IHwgICBJbnRlbGxpcXVlCiAgICAgICAgICAgICAgICAgICAgfAk8ZWZsb3JhY0BpbnRlbGxpcXVl
LmNvbT4KICAgICAgICAgICAgICAgICAgICB8ICAgKzMzIDEgNzggOTQgODQgMDIKLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fClRoaXMgZW1haWwgaGFzIGJlZW4gc2Nhbm5lZCBieSB0aGUg
U3ltYW50ZWMgRW1haWwgU2VjdXJpdHkuY2xvdWQgc2VydmljZS4KRm9yIG1vcmUgaW5mb3JtYXRp
b24gcGxlYXNlIHZpc2l0IGh0dHA6Ly93d3cuc3ltYW50ZWNjbG91ZC5jb20gX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
XwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpUaGlzIGVtYWlsIGhhcyBiZWVuIHNjYW5uZWQgYnkgdGhlIFN5bWFu
dGVjIEVtYWlsIFNlY3VyaXR5LmNsb3VkIHNlcnZpY2UuCkZvciBtb3JlIGluZm9ybWF0aW9uIHBs
ZWFzZSB2aXNpdCBodHRwOi8vd3d3LnN5bWFudGVjY2xvdWQuY29tCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcg
bGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8v
eGZzCg==
