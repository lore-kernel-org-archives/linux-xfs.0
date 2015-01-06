Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 653CD7F54
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 10:29:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 42A1A304043
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 08:29:33 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 0SfPShzfjuGV8HHG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 08:29:31 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/18] nfs: add LAYOUT_TYPE_MAX enum value
Date: Tue,  6 Jan 2015 17:28:24 +0100
Message-Id: <1420561721-9150-2-git-send-email-hch@lst.de>
In-Reply-To: <1420561721-9150-1-git-send-email-hch@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
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
