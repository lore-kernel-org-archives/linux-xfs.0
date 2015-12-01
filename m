Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C1BE87F59
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 08:01:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A1A028F804C
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 06:01:34 -0800 (PST)
Received: from mail1.bemta5.messagelabs.com (mail1.bemta5.messagelabs.com
	[195.245.231.143]) by cuda.sgi.com with ESMTP id
	qM1s6f1zguW1Tsw7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 06:01:32 -0800 (PST)
From: Sandeep Patel <spatel@omnifone.com>
Subject: RE: XFS corruptions
Date: Tue, 1 Dec 2015 14:01:29 +0000
Message-ID: <558408F298C8CE4C89D93BD56AB474E8018617C74C@EXBE1IS02.omnifone.com>
References: <558408F298C8CE4C89D93BD56AB474E8018617B2B3@EXBE1IS02.omnifone.com>
	<20151130184048.3fa123e0@harpe.intellique.com>
	<558408F298C8CE4C89D93BD56AB474E8018617B3A6@EXBE1IS02.omnifone.com>
	<20151130194554.6140bf30@harpe.intellique.com>
	<558408F298C8CE4C89D93BD56AB474E8018617C636@EXBE1IS02.omnifone.com>
	<20151201145011.6df02063@harpe.intellique.com>
In-Reply-To: <20151201145011.6df02063@harpe.intellique.com>
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

VGhlIGZpcm13YXJlIGZvciB0aGUgcmFpZCBjYXJkIGlzIDEyLjE1LjAtMDIwNQoKVGhhbmtzIGZv
ciB0aGlzLiBMZXQgbWUga25vdyBpZiB5b3UgbmVlZCBhbnkgbW9yZSBkZXRhaWxzLgoKU2FuZGVl
cAoKLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0KRnJvbTogRW1tYW51ZWwgRmxvcmFjIFttYWls
dG86ZWZsb3JhY0BpbnRlbGxpcXVlLmNvbV0gClNlbnQ6IDAxIERlY2VtYmVyIDIwMTUgMTM6NTAK
VG86IFNhbmRlZXAgUGF0ZWwKQ2M6IHhmc0Bvc3Muc2dpLmNvbQpTdWJqZWN0OiBSZTogWEZTIGNv
cnJ1cHRpb25zCgpMZSBUdWUsIDEgRGVjIDIwMTUgMTI6MTg6MjEgKzAwMDAKU2FuZGVlcCBQYXRl
bCA8c3BhdGVsQG9tbmlmb25lLmNvbT4gw6ljcml2YWl0OgoKPiBZZXMsIHRoZXkgb25seSB0aGlu
ZyB3ZSBjaGFuZ2VkIGZyb20gZGVmYXVsdCBpcyB0aGUgaXNpemUuCj4gCj4gV2UgYXJlIHJ1bm5p
bmcgdGhlIGxhdGVzdCB2ZXJzaW9uIG9uIHRoZSBmaXJtd2FyZS4gV2UgcHJldmlvdXNseSAKPiB1
cGdyYWRlZCB0aGUgZmlybXdhcmUgb24gdGhlc2UgdGhpbmtpbmcgaXQgd291bGQgc29sdmUgdGhl
IHByb2JsZW0uCj4gCj4gVGhlIHByb2JsZW1zIHNlZW0gdG8gb2NjdXIgYXQgcmFuZG9tLiBUaGUg
bG9hZCB0byB0aGVzZSB1bml0cyBhcmUgCj4gcXVpdGUgbWluaW1hbCBhdCB0aGUgbW9tZW50IGFu
ZCB3ZSBhcmUgc3RpbGwgaGF2aW5nIGlzc3Vlcy4KPiAKCkkganVzdCByZWNlaXZlZCBhIG5ldyBz
ZXJ2ZXIgd2l0aCBhbiBMU0kgY29udHJvbGxlciBzaW1pbGFyIHRvIHlvdXJzLCBJJ2xsIHJ1biBz
b21lIHRlc3RzIGJ1dCBJJ2Qgc3VzcGVjdCB0aGUga2VybmVsIG1heSBiZSBhdCBmYXVsdC4gV2hh
dCBpcyB5b3VyIGZpcm13YXJlIHZlcnNpb24gZXhhY3RseT8KCgoKLS0KLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
CkVtbWFudWVsIEZsb3JhYyAgICAgfCAgIERpcmVjdGlvbiB0ZWNobmlxdWUKICAgICAgICAgICAg
ICAgICAgICB8ICAgSW50ZWxsaXF1ZQogICAgICAgICAgICAgICAgICAgIHwJPGVmbG9yYWNAaW50
ZWxsaXF1ZS5jb20+CiAgICAgICAgICAgICAgICAgICAgfCAgICszMyAxIDc4IDk0IDg0IDAyCi0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpUaGlzIGVtYWlsIGhhcyBiZWVuIHNjYW5uZWQg
YnkgdGhlIFN5bWFudGVjIEVtYWlsIFNlY3VyaXR5LmNsb3VkIHNlcnZpY2UuCkZvciBtb3JlIGlu
Zm9ybWF0aW9uIHBsZWFzZSB2aXNpdCBodHRwOi8vd3d3LnN5bWFudGVjY2xvdWQuY29tIF9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KVGhpcyBlbWFpbCBoYXMgYmVlbiBzY2FubmVkIGJ5IHRo
ZSBTeW1hbnRlYyBFbWFpbCBTZWN1cml0eS5jbG91ZCBzZXJ2aWNlLgpGb3IgbW9yZSBpbmZvcm1h
dGlvbiBwbGVhc2UgdmlzaXQgaHR0cDovL3d3dy5zeW1hbnRlY2Nsb3VkLmNvbQpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBt
YWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL3hmcwo=
