Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44646 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbeEMRAm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 May 2018 13:00:42 -0400
Subject: [PATCH 1/4] design: rename disk structures book
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 13 May 2018 10:00:30 -0700
Message-ID: <152623083064.10242.12457966241178588063.stgit@magnolia>
In-Reply-To: <152623082465.10242.9458731018482450171.stgit@magnolia>
References: <152623082465.10242.9458731018482450171.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, azarus@posteo.net

From: Darrick J. Wong <darrick.wong@oracle.com>

Since the book already has chapters describing fundamental XFS
algorithms, update the title to reflect this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../xfs_filesystem_structure.asciidoc              |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 5dba1c7..8d54935 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -6,8 +6,8 @@
 // and we really need an area to set up various docbook sections like copyright
 // and legal notice sections.
 //
-XFS Filesystem Disk Structures
-==============================
+XFS Algorithms & Data Structures
+================================
 :doctype: book
 :docinfo1:
 

