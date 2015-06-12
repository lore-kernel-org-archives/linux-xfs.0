Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1217C7F55
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 07:33:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E69DF8F8039
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 05:33:01 -0700 (PDT)
Received: from mail.ixserver.net (mail.ixserver.net [94.143.114.23]) by
	cuda.sgi.com with ESMTP id 2TBC5sKBu1vang4A for
	<xfs@oss.sgi.com>; Fri, 12 Jun 2015 05:32:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.ixserver.net (Postfix) with ESMTP id A95F8792E53
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 14:32:52 +0200 (CEST)
Received: from mail.ixserver.net ([127.0.0.1])
	by localhost (mail.ixserver.net [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id UXnxI3HEtSCT for <xfs@oss.sgi.com>;
	Fri, 12 Jun 2015 14:32:52 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mail.ixserver.net (Postfix) with ESMTP id 2768C792E5F
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 14:32:52 +0200 (CEST)
Received: from mail.ixserver.net ([127.0.0.1])
	by localhost (mail.ixserver.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id XANBH1lYX0iW for <xfs@oss.sgi.com>;
	Fri, 12 Jun 2015 14:32:52 +0200 (CEST)
Received: from sg_8ntryz1.ixblue.corp (61-3.83-90.static-ip.oleane.fr
	[90.83.3.61])
	by mail.ixserver.net (Postfix) with ESMTPSA id 04A49792E53
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 14:32:52 +0200 (CEST)
Message-ID: <557AD178.8090500@ixblue.com>
Date: Fri, 12 Jun 2015 14:32:56 +0200
From: =?UTF-8?B?Q8OpZHJpYyBMZW1hcmNoYW5k?= <cedric.lemarchand@ixblue.com>
MIME-Version: 1.0
Subject: Re: Formating options for large partition/files
References: <557ACD23.3020601@ixblue.com>
In-Reply-To: <557ACD23.3020601@ixblue.com>
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
To: xfs@oss.sgi.com

UmVwbGF5aW5nIHRvIG15c2VsZiwgaXQgc2VlbXMgZGVmYXVsdCB2YWx1ZXMgd2lsbCBjb3ZlciBh
bGwgbXkgbmVlZHMgOgoKLSBibG9ja3NpemUgPSA0ayAobWF4IHZhbHVlIGZvciBhZG02NCBhcmNo
KQotIHNlY3RvciBzaXplID0gNTEyICggaGFyZCBkcml2ZXMgYXJlIHZpcnR1YWwsIHNvIG5vdCA0
aykKCkFueSBhZHZpY2VzIG9uIG1vdW50IG9wdGlvbnMgPwoKQ2hlZXJzCgoKTGUgMTIvMDYvMTUg
MTQ6MTQsIEPDqWRyaWMgTGVtYXJjaGFuZCBhIMOpY3JpdCA6Cj4gSSBwbGFuZSB0byB1c2UgWEZT
IG9uIGEgPjUwVEIgcGFydGl0aW9uLCB0aGF0IHdpbGwgaG9zdCBhIGZldyBiaWcKPiAoYmFja3Vw
L2FyY2hpdmVzKSBmaWxlcy4gUmVhZGluZyB0aGUgY2hhcHRlciA0IG9mIHRoZSBvbmxpbmUKPiBk
b2N1bWVudGF0aW9uLCBJIGZpbmQgMiBmb3JtYXRpbmcgb3B0aW9ucyB0aGF0IGNvdWxkIGZpdCA6
Cj4KPiAtIG1heCBvdXQgdGhlIGFsbG9jYXRpb24gYmxvY2sgOiAtYiBzaXplPSA2NEtCCj4gLSBt
YXggb3V0IHRoZSBzZWN0b3Igc2l6ZSA6IC1zIHNpemU9MzJLQgo+Cj4gSSBhbSBub3QgYW4gZXhw
ZXJ0LCBzbyBhbnkgbGlnaHQgd2lsbCBiZSBhcHByZWNpYXRlZC4KPgo+IENoZWVycywKPgo+IEPD
qWRyaWMKPgo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cj4geGZzIG1haWxpbmcgbGlzdAo+IHhmc0Bvc3Muc2dpLmNvbQo+IGh0dHA6Ly9vc3Muc2dpLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL3hmcwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29z
cy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
