Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60076 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbdE1KWB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2017 06:22:01 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/22] MAINTAINERS: add uuid entry
Date: Sun, 28 May 2017 13:20:08 +0300
Message-Id: <20170528102008.30276-23-hch@lst.de>
In-Reply-To: <20170528102008.30276-1-hch@lst.de>
References: <20170528102008.30276-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org

I'll keep maintaining whatever little changed we need here, with Andy as
my designated reviewer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 053c3bdd1fe5..660c14729205 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13463,6 +13463,17 @@ W:	http://en.wikipedia.org/wiki/Util-linux
 T:	git git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git
 S:	Maintained
 
+UUID HELPERS
+M:	Christoph Hellwig <hch@lst.de>
+R:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+L:	linux-kernel@vger.kernel.org
+T:	git git://git.infradead.org/users/hch/uuid.git
+F:	lib/uuid.c
+F:	lib/test_uuid.c
+F:	include/linux/uuid.h
+F:	include/uapi/linux/uuid.h
+S:	Maintained
+
 UVESAFB DRIVER
 M:	Michal Januszewski <spock@gentoo.org>
 L:	linux-fbdev@vger.kernel.org
-- 
2.11.0

