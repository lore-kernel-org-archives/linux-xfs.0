Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33222 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbeGBO6b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:58:31 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/22] xfs: update my copyrights for the writeback and iomap code
Date: Mon,  2 Jul 2018 08:58:13 -0600
Message-Id: <20180702145813.22496-23-hch@lst.de>
In-Reply-To: <20180702145813.22496-1-hch@lst.de>
References: <20180702145813.22496-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  | 1 +
 fs/xfs/xfs_iomap.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index bae88ac1101d..f4d3252236c1 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2016-2018 Christoph Hellwig.
  * All Rights Reserved.
  */
 #include "xfs.h"
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 778b8c850de3..fb9746cc7338 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
- * Copyright (c) 2016 Christoph Hellwig.
+ * Copyright (c) 2016-2018 Christoph Hellwig.
  * All Rights Reserved.
  */
 #include <linux/iomap.h>
-- 
2.18.0

