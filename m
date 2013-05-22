Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C165C7F63
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 03:06:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6DC3DAC003
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 01:06:54 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.8])
	by cuda.sgi.com with ESMTP id Kmtl4x5RZUHZJpwH (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 01:06:49 -0700 (PDT)
Message-ID: <519C7C91.2080005@open-e.com>
Date: Wed, 22 May 2013 10:06:41 +0200
From: =?UTF-8?B?QXJrYWRpdXN6IEJ1YmHFgmE=?= <arkadiusz.bubala@open-e.com>
MIME-Version: 1.0
Subject: Re: [BUG] XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0,
	file:	fs/xfs/xfs_mount.c, line: 272
References: <519B6738.9030603@open-e.com> <519B6915.2010407@open-e.com>
	<20130521182630.GJ20028@sgi.com>
In-Reply-To: <20130521182630.GJ20028@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

SGVsbG8gQmVuLAoKT24gMjEuMDUuMjAxMyAyMDoyNiwgQmVuIE15ZXJzIHdyb3RlOgo+IEhleSBB
cmthZGl1c3osCj4KPiBBbnkgJ3hsb2dfc3BhY2VfbGVmdCcgbWVzc2FnZXMgYXMgd2VyZSByZXBv
cnRlZCB3aXRoIHRoZSBjb21taXQgeW91IG1lbnRpb25lZD8KPiBIYXZlIHlvdSBhdHRlbXB0ZWQg
dG8gYmFja3BvcnQgdGhlIHBhdGNoIHlldD8KPiAgICAKU29ycnkgSSd2ZSBjb3BpZWQgd3Jvbmcg
bGluay4gQ29ycmVjdCBvbmUgaXM6IApodHRwOi8vcGF0Y2h3b3JrLnhmcy5vcmcvcGF0Y2gvNDQx
NS8uClBhdGNoIGZyb20gbWVudGlvbmVkIGNvbW1pdCBmaXhlZCBjYWxsIHRyYWNlIHdoaWNoIEkg
aGFkIHByZXZpb3VzbHkuCgo+IFJlZ2FyZHMsCj4gCUJlbgo+Cj4gX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiB4ZnMgbWFpbGluZyBsaXN0Cj4geGZzQG9z
cy5zZ2kuY29tCj4gaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCj4gICAg
CgoKLS0gCkJlc3QgcmVnYXJkcwpBcmthZGl1c3ogQnViYcWCYQoKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5z
Z2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
