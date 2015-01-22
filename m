Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 624427F60
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 05:11:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E639DAC009
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 03:11:14 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id MmFeM0oYo0r1S83E (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 03:11:12 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/20] nfs: add LAYOUT_TYPE_MAX enum value
Date: Thu, 22 Jan 2015 12:09:47 +0100
Message-Id: <1421925006-24231-2-git-send-email-hch@lst.de>
In-Reply-To: <1421925006-24231-1-git-send-email-hch@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

VGhpcyBnaXZlcyB1cyBhIG5pY2UgdXBwZXIgYm91bmQgZm9yIGxhdGVyIHVzZSBpbiBuZtGVZC4K
ClNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgotLS0KIGluY2x1
ZGUvbGludXgvbmZzNC5oIHwgMSArCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKCmRp
ZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L25mczQuaCBiL2luY2x1ZGUvbGludXgvbmZzNC5oCmlu
ZGV4IDAyMmI3NjEuLjhhMzU4OWMgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvbmZzNC5oCisr
KyBiL2luY2x1ZGUvbGludXgvbmZzNC5oCkBAIC01MTYsNiArNTE2LDcgQEAgZW51bSBwbmZzX2xh
eW91dHR5cGUgewogCUxBWU9VVF9ORlNWNF8xX0ZJTEVTICA9IDEsCiAJTEFZT1VUX09TRDJfT0JK
RUNUUyA9IDIsCiAJTEFZT1VUX0JMT0NLX1ZPTFVNRSA9IDMsCisJTEFZT1VUX1RZUEVfTUFYCiB9
OwogCiAvKiB1c2VkIGZvciBib3RoIGxheW91dCByZXR1cm4gYW5kIHJlY2FsbCAqLwotLSAKMS45
LjEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBt
YWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL3hmcwo=
