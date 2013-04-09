Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5A1F729E17
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 10:23:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 487508F8068
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 08:23:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id s4nbTLdHZUkJSFv8 for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 08:23:41 -0700 (PDT)
Message-ID: <5164327C.6060808@sandeen.net>
Date: Tue, 09 Apr 2013 10:23:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<51642E5E.3040403@sandeen.net>
	<CADFMGuL7968v6L-3=j3FY3YYjeA_XH1CyuLgnL88u-abxiwHvg@mail.gmail.com>
In-Reply-To: <CADFMGuL7968v6L-3=j3FY3YYjeA_XH1CyuLgnL88u-abxiwHvg@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
Cc: xfs@oss.sgi.com

T24gNC85LzEzIDEwOjE4IEFNLCC3+9PAzM4gd3JvdGU6Cj4gVGhlIHNlcnZlcnMgYXJlIGJhY2sg
dG8gc2VydmljZSBub3cgYW5kIEl0J3MgaGFyZCB0byBydW4geGZzX3JlcGFpci4KPiBJdCBhbHdh
eXMgaGFwcGVuIGJlbGxvdyBpcyB0aGUgeGZzX3JlcGFpciBsb2cgd2hlbiBpdCBoYXBwZW5zIG9u
Cj4gYW5vdGhlciBzZXJ2ZXIgc2V2ZXJhbCBkYXlzIGFnby4KCj4gIC1zaC00LjEkIHN1ZG8geGZz
X3JlcGFpciAtbiAvZGV2L2dsdXN0ZXJ2Zy9nbHVzdGVybHYKCk9rOyBqdXN0IGZvciB3aGF0IGl0
cyB3b3J0aCwgaWYgeW91IGRvbid0IG1vdW50L3Vtb3VudCBmaXJzdCwKeW91IG1heSBiZSBydW5u
aW5nIHJlcGFpciAtbiB3aXRoIGEgZGlydHkgbG9nLCBhbmQgaXQgd2lsbApmaW5kICJtb3JlIiBj
b3JydXB0aW9uIHRoYW4gaXQgc2hvdWxkLCBzaW5jZSB0aGUgbG9nIGlzIG5vdApyZXBsYXllZC4g
IAoKSSBzZWUgdGhhdCB5b3UgaW5jbHVkZWQgYSBub24gIi1uIiByZXBhaXIgbG9nIGFzIHdlbGws
IHdhcwp0aGF0IGFmdGVyIGEgbW91bnQvdW1vdW50PyAgSnVzdCB0byBiZSBzdXJlLi4uCgpUaGFu
a3MsCi1FcmljCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21h
aWxtYW4vbGlzdGluZm8veGZzCg==
