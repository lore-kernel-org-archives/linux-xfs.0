Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0EDA97F3F
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 10:46:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DDF538F804C
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 08:46:44 -0700 (PDT)
Received: from st11p01mm-asmtp002.mac.com (st11p01mm-asmtpout002.mac.com
	[17.172.204.237]) by cuda.sgi.com with ESMTP id
	LS3bcJt0qS4jsHCS (version=TLSv1 cipher=RC4-MD5 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Oct 2014 08:46:43 -0700 (PDT)
Received: from [192.168.142.67] ([82.71.189.231]) by st11p01mm-asmtp002.mac.com
	(Oracle Communications Messaging Server 7u4-27.10(7.0.4.27.9) 64bit
	(built Jun
	6 2014)) with ESMTPSA id <0NDF000YKYHR7900@st11p01mm-asmtp002.mac.com>
	for xfs@oss.sgi.com; Tue, 14 Oct 2014 15:46:43 +0000 (GMT)
References: <4ddef393-ad9e-49a1-80d7-9c29bcd74c8f@me.com>
	<20141013220940.GE17506@dastard>
	<EC9978C1-65B4-48B8-9C3D-980341A752E8@me.com>
	<20141014125506.4bbeaefd@harpe.intellique.com>
MIME-version: 1.0 (1.0)
In-reply-to: <20141014125506.4bbeaefd@harpe.intellique.com>
Message-id: <7630F174-D8AF-412D-8BBA-C3B1F7E05B9F@me.com>
From: Tom Mason <tom_mason@me.com>
Subject: Re: Mount: Structure needs cleaning
Date: Tue, 14 Oct 2014 16:46:39 +0100
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

CgoKCj4gT24gMTQgT2N0IDIwMTQsIGF0IDExOjU1LCBFbW1hbnVlbCBGbG9yYWMgPGVmbG9yYWNA
aW50ZWxsaXF1ZS5jb20+IHdyb3RlOgo+IAo+IExlIE1vbiwgMTMgT2N0IDIwMTQgMjM6Mzg6MzQg
KzAxMDAKPiBUb20gTWFzb24gPHRvbV9tYXNvbkBtZS5jb20+IMOpY3JpdmFpdDoKPiAKPj4gQnR3
IC0gYmVmb3JlIEkgZ2V0IHJpZCBvZiB0aGlzIG9sZCBzYW1zdW5nIDF0YiBkcml2ZSwgdGhlIGZv
bGRlcidzCj4+IHByb3BlcnRpZXMgaW4gdGhlIGZhaWxlZCBkcml2ZSBhY3R1YWxseSByZXBvcnQg
YSBsb3QgaGlnaGVyIGZvciBmaWxlCj4+IG51bWJlcnMgYW5kIHNpemVzIHRoYW4gZXZlbnR1YWxs
eSBnZXQgY29waWVkIC0gaXQgcmVwb3J0czogIkVycm9yCj4+IHdoaWxlIGNvcHlpbmcgVGhlcmUg
d2FzIGFuIGVycm9yIGdldHRpbmcgaW5mb3JtYXRpb24gYWJvdXQgdGhlIGZpbGVzCj4+IGluIHRo
ZSBmb2xkZXIgJ3h4eHh4JyBubyBkYXRhIGF2YWlsYWJsZSIgLi4uaXMgdGhlcmUgYSB3YXkgYXJv
dW5kCj4+IHRoaXMgb3IgaXMgdGhpcyBteSBsb3N0IGRhdGE/Cj4gCj4gVGhlIG1ldGFkYXRhIGlu
Zm9ybWF0aW9uIGZyb20gdGhlIGRyaXZlIG1heSBiZSBpbmFjY3VyYXRlIGJlY2F1c2UgdGhlCj4g
bG9nIGlzIGNvcnJ1cHRlZC4gVGhlbiBzb21lIGZvbGRlciBkYXRhIG1heSBoYXZlIGJlZW4gbG9z
dCBhbmQgcHJldmVudAo+IHlvdSBmcm9tIHJlY292ZXJpbmcgdGhlIGZpbGVzIHRoYXQgYXJlIGlu
IHNvbWUgZm9sZGVycy4KPiAKPiBBZnRlciB5b3UncmUgZG9uZSBjb3B5aW5nIGFsbCBmaWxlcyB5
b3UgY2FuIGZyb20gdGhlIGRpc2ssIHlvdSBjYW4gdHJ5Cj4gdG8gbWFrZSBhIG1pcnJvciBpbWFn
ZSBvbiBhbm90aGVyIGRyaXZlIGF0IGxlYXN0IGFzIGJpZyBhcyB0aGlzIG9uZSwKPiBhbmQgcnVu
IHhmc19yZXBhaXIgb24gdGhlIGltYWdlLiBBZnRlciB0aGF0IHlvdSBjb3VsZCBldmVudHVhbGx5
IGdldAo+IG1vcmUgZGF0YSBiYWNrIChpdCBkZXBlbmRzIHVwb24gdGhlIGV4dGVudCBvZiB0aGUg
ZGFtYWdlIHRvIHRoZSBhY3R1YWwKPiBkYXRhIGFuZCBmaWxlIHN0cnVjdHVyZSkuCj4gCj4gVG8g
Y29weSB0aGUgZGlzayBvbiBhbm90aGVyIG9uZSwgeW91IGNhbiB1c2UgZGRyZXNjdWUgb3IgZGQg
d2l0aAo+ICJub2Vycm9yIiBvcHRpb24uCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0KVGhhbmtzIGFnYWluIQpDYW4gSSBjcmVhdGUgYW4gaW1hZ2Ugb24gYSBuZXcg
TkFTIGRyaXZlIHN1Y2ggYXMgYSBzZWFnYXRlIDN0YiAnQ2VudHJhbCBuZXR3b3JrIGF0dGFjaGVk
IHN0b3JhZ2UgTkFTJyBTVENHMzAwMDIwMCB3aXRob3V0IGludGVyZmVyaW5nIHdpdGggaXRzIGNh
cGFiaWxpdGllcyBhcyBhIE5BUyBkcml2ZT8KVG9tCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0
dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
