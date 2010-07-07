Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o675rtZ7223174 for <xfs@oss.sgi.com>; Wed, 7 Jul 2010 00:53:55 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B51715982CA
	for <xfs@oss.sgi.com>; Tue,  6 Jul 2010 22:56:45 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id TbiojSRbctQxKubn for
	<xfs@oss.sgi.com>; Tue, 06 Jul 2010 22:56:45 -0700 (PDT)
Message-ID: <4C341712.5030202@tlinx.org>
Date: Tue, 06 Jul 2010 22:56:34 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs file system in process of becoming corrupt;
	though	xfs_repair	thinks it's fine! ; -/ (was xfs_dump problem...)
References: <4C26A51F.8020909@tlinx.org>
	<20100628022744.GX6590@dastard>	<4C2A749E.4060006@tlinx.org>
	<20100629232532.GA24712@dastard>	<4C2A87FF.7090804@dermichi.com>
	<4C2A92DA.1020202@tlinx.org>	<20100630011647.GD24712@dastard>
	<4C2AAFC1.9080708@tlinx.org>	<20100701235802.GW24712@dastard>
	<4C33F20F.4040905@tlinx.org>
In-Reply-To: <4C33F20F.4040905@tlinx.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Rm9yIHdoYXQgaXQncyB3b3J0aCwgbXkgJ3VuZGVsZXRhYmxlJyBmaWxlcyBnaXZlIGV2ZXJ5IGFw
cGVhcmFuY2Ugb2YKYmVpbmcgJ3BsYWluJyBVVEYtOCBlbmNvZGVkIGZpbGUgbmFtZXMuICBXcm90
ZSBhIHBlcmwgc2NyaXB0IHRoYXQgbG9vcGVkCnRocm91Z2ggYW5kIHVzZWQgdGhlICdieXRlcycg
cHJhZ21hIHRvIGxvb2sgYXQgdGhlIGJ5dGVzLiAgTG9va3MgbGlrZQp2YWxpZCBVVEYtOC4gIEFs
c28gaGFkIGl0IHRyeSB0byByZW1vdmUgdGhlIGZpbGVzLiAgRGlkbid0IHdvcmsuCgoKClJlYWQg
OSBmaWxlcwogMTogMmUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICA+fC4gICAgICAgICAgICAgICB8PAogMjogMmUgMmUgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICA+fC4uICAgICAgICAgICAgICB8PAogMzogNDIgNmYgNzIg
NjQgNzUgNzIgNjUgMjAgIDcwIDZmIDY5IDZlIDc0IDY5IDZjIDZjICA+fEJvcmR1cmUgcG9pbnRp
bGx8PAogICAgYzMgYTkgNjUgMjAgMmQgMjAgNDIgNmMgIDYxIDZlIDYzIDJkIDZlIDZmIDY5IDcy
ICA+fC4uZSAtIEJsYW5jLW5vaXJ8PAoKVW5saW5rIG9mICJCb3JkdXJlIHBvaW50aWxsw6llIC0g
QmxhbmMtbm9pciIgZmFpbGVkOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5CgogNDogNDIgNmYg
NzIgNjQgNzUgNzIgNjUgMjAgIDcwIDZmIDY5IDZlIDc0IDY5IDZjIDZjICA+fEJvcmR1cmUgcG9p
bnRpbGx8PAogICAgYzMgYTkgNjUgMjAgMmQgMjAgNGUgNmYgIDY5IDcyIDJkIDYyIDZjIDYxIDZl
IDYzICA+fC4uZSAtIE5vaXItYmxhbmN8PAoKVW5saW5rIG9mICJCb3JkdXJlIHBvaW50aWxsw6ll
IC0gTm9pci1ibGFuYyIgZmFpbGVkOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5CgogNTogNDMg
NjEgNjQgNzIgNjUgMjAgNjMgNjUgIDZlIDc0IDcyIGMzIGE5IDIwIDMxIDIwICA+fENhZHJlIGNl
bnRyLi4gMSB8PAogICAgMmQgMjAgNDIgNjEgNzMgNjUgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICA+fC0gQmFzZSAgICAgICAgICB8PAoKVW5saW5rIG9mICJDYWRyZSBjZW50csOpIDEg
LSBCYXNlIiBmYWlsZWQ6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKLi4uLnJlc3Qgb2Ygb3V0
cHV0IHRydW5jYXRlZC4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
