Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4EC927CA4
	for <xfs@oss.sgi.com>; Thu, 19 May 2016 09:57:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1FD4C8F8052
	for <xfs@oss.sgi.com>; Thu, 19 May 2016 07:57:16 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [206.12.19.147]) by
	cuda.sgi.com with ESMTP id 8KymweMFSF1UVx8S (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 19 May 2016 07:57:09 -0700 (PDT)
Subject: Bug#822369: fixed in qemu 1:2.6+dfsg-1
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.822369.B822369.14636696225294@bugs.debian.org>
References: <573DCFAA.8000500@physik.fu-berlin.de>
From: Michael Tokarev <mjt@tls.msk.ru>
Message-ID: <573DD225.5040502@msgid.tls.msk.ru>
Date: Thu, 19 May 2016 17:48:05 +0300
MIME-Version: 1.0
In-Reply-To: <573DCFAA.8000500@physik.fu-berlin.de>
Reply-To: Michael Tokarev <mjt@tls.msk.ru>, 822369@bugs.debian.org
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
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: 822369@bugs.debian.org

MTkuMDUuMjAxNiAxNzozNywgSm9obiBQYXVsIEFkcmlhbiBHbGF1Yml0eiDQv9C40YjQtdGCOgo+
IENvbnRyb2w6IHJlb3BlbiAtMQo+IAo+IEhpIE1pY2hhZWwhCj4gCj4gWW91IGNsb3NlZCBhIGJ1
ZyBpbiBzcmM6eGZzcHJvZ3Mgd2l0aCBhIG5ldyB2ZXJzaW9uIG9mIHFlbXUsIEkgZG9uJ3QKPiB0
aGluayB0aGlzIGlzIGNvcnJlY3QgYW5kIHRoaXMgYnVnIHNob3VsZCB0aGVyZWZvcmUgYmUgcmVv
cGVuZWQuCj4gCj4gV2hpbGUgcWVtdSBkb2Vzbid0IHNlZW0gdG8gYmUgYWZmZWN0ZWQgYnkgdGhp
cyBwYXJ0aWN1bGFyIGlzc3VlIGFueW1vcmUsCj4gSSBkb24ndCB0aGluayB0aGUgYnVnIGluIHNy
Yzp4ZnNwcm9ncyBpdHNlbGYgaGFzIGJlZW4gZml4ZWQgc2luY2UgdGhlcmUKPiBoYXNuJ3QgYmVl
biBhIG5ldyB1cGxvYWQgb2YgeGZzcHJvZ3Mgc2luY2UgRmVicnVhcnkuCj4gCj4gUGxlYXNlIGJl
IG1vcmUgY2FyZWZ1bCB3aGVuIGhhbmRsaW5nIG9mIGJ1ZyByZXBvcnRzIQoKQWN0dWFsbHkgaXQg
aXMgbW9yZSBpbnRlcmVzdGluZy4gIFRoaXMgYnVnIGlzIGxpc3RlZCBpbiBxZW11IGJ1ZyBsaXN0
LApzZWUgaHR0cHM6Ly9idWdzLmRlYmlhbi5vcmcvY2dpLWJpbi9wa2dyZXBvcnQuY2dpP3NyYz1x
ZW11ICwgQU5EIGluCnhmc3Byb2dzIGJ1ZyBsaXN0LCBzZWUKaHR0cHM6Ly9idWdzLmRlYmlhbi5v
cmcvY2dpLWJpbi9wa2dyZXBvcnQuY2dpP3NyYz14ZnNwcm9ncwoKSSBjbG9zZWQgaXQgdGhpbmtp
bmcgaXQgaXMgaW4gcWVtdS4gIEJ1dCBJIGNsb3NlZCBpdCB3cm9uZ2x5IGFueXdheSwKYW5kIHRo
YXQncyB3aGVyZSBJIHNob3VsZCd2ZSBiZWVuIG1vcmUgY2FyZWZ1bC4gIEluIHFlbXUgdGhlcmUg
d2FzCmEgd29ya2Fyb3VuZCBwcm9wb3NlZCBmb3IgdGhpcyBpc3N1ZSwgYnV0IGl0IGhhc24ndCBi
ZWVuIGFwcGxpZWQsCmFuZCBJIHRob3VnaHQgaXQgaGFzIGJlZW4uICBTbyBpdCBoYXMgYWxyZWFk
eSBiZWVuIHJlb3BlbmVkIG1lYW53aGlsZS4KCkhvdyBpdCBpcyBwcmVzZW50IGluIGJvdGggcWVt
dSBhbmQgeGZzcHJvZ3MgYnVnIGxpc3RzLCBJJ3ZlIG5vIGlkZWEgOikKCi9tanQKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QK
eGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
