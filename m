Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21589 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932600AbcKWG7b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2016 01:59:31 -0500
Subject: [PATCH 1/2] docs: fix a typo in the AGF section of the disk format
 doc
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 22 Nov 2016 22:59:26 -0800
Message-ID: <147988436636.12225.3639807183440429674.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 38d7357..51ca57d 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -636,7 +636,7 @@ The size of the reference count B+tree in this allocation group, in blocks.
 *agf_refcount_root*::
 Block number for the root of the reference count B+tree, if enabled.
 
-*agf_refcount_root*::
+*agf_refcount_level*::
 Depth of the reference count B+tree, if enabled.
 
 *agf_spare64*::

