Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53868 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbfD1MCX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Apr 2019 08:02:23 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] iomap: convert to SPDX identifier
Date: Sun, 28 Apr 2019 14:01:46 +0200
Message-Id: <20190428120146.14559-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Use SPDX-License-Identifier instead of GPLv2 boilerplate.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index abdd18e404f8..bfb1c74b16d3 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1,15 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2010 Red Hat, Inc.
  * Copyright (c) 2016-2018 Christoph Hellwig.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
  */
 #include <linux/module.h>
 #include <linux/compiler.h>
-- 
2.20.1
