Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C4E677CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 05:23:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D44AAC005
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 03:23:17 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id J5mVrkhY1dmrBgU2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 03:23:14 -0700 (PDT)
Date: Thu, 26 May 2016 12:23:15 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: LVM snapshot and log record CRC mismatch
Message-ID: <20160526122315.4112f713@harpe.intellique.com>
In-Reply-To: <57455645.5040608@assyoma.it>
References: <ab81e19cd6fce41f9d63cdd3695c80f7@assyoma.it>
	<20160524221205.GM21200@dastard> <57455645.5040608@assyoma.it>
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
To: Gionatan Danti <g.danti@assyoma.it>
Cc: xfs@oss.sgi.com

TGUgV2VkLCAyNSBNYXkgMjAxNiAwOTozNzo0MSArMDIwMApHaW9uYXRhbiBEYW50aSA8Zy5kYW50
aUBhc3N5b21hLml0PiDDqWNyaXZhaXQ6Cgo+IFRoZSBzbmFwc2hvdCBpcyBhY2NvbXBsaXNoZWQg
dXNpbmcgdGhlIGZvbGxvd2luZyBjb21tYW5kczoKPiAKPiBsdmNyZWF0ZSAtcyBoeXBlcnZpc29y
L0tWTV9TdG9yYWdlIC0tbmFtZSBCYWNrdXBfU05BUAo+IGx2Y2hhbmdlIC1heSAtSyBoeXBlcnZp
c29yL0JhY2t1cF9TTkFQCj4gbW91bnQgLW8gbm91dWlkIC9kZXYvaHlwZXJ2aXNvci9CYWNrdXBf
U05BUCAvbW50L2x2bS8KPiAKCllvdSBuZWVkIHRvIHVzZSB4ZnNfZnJlZXplIHRvIG1ha2UgdGhl
IGZpbGVzeXN0ZW0gY29oZXJlbnQgYmVmb3JlCnNuYXBzaG90OgoKeGZzX2ZyZWV6ZSAvZGV2L2h5
cGVydmlzb3IvS1ZNX1N0b3JhZ2UKbHZjcmVhdGUgLXMgaHlwZXJ2aXNvci9LVk1fU3RvcmFnZSAt
LW5hbWUgQmFja3VwX1NOQVAKeGZzX2ZyZWV6ZSAtdSAvZGV2L2h5cGVydmlzb3IvS1ZNX1N0b3Jh
Z2UKbHZjaGFuZ2UgLWF5IC1LIGh5cGVydmlzb3IvQmFja3VwX1NOQVAKCi0tIAotLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0KRW1tYW51ZWwgRmxvcmFjICAgICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQogICAgICAg
ICAgICAgICAgICAgIHwgICBJbnRlbGxpcXVlCiAgICAgICAgICAgICAgICAgICAgfAk8ZWZsb3Jh
Y0BpbnRlbGxpcXVlLmNvbT4KICAgICAgICAgICAgICAgICAgICB8ICAgKzMzIDEgNzggOTQgODQg
MDIKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNn
aS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
