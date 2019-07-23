Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35090 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbfGWLsv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 07:48:51 -0400
Date: Tue, 23 Jul 2019 12:48:13 +0100
From: Sheriff Esseson <sheriffesseson@gmail.com>
Subject: [PATCH] Documentation: filesystem: fix "Removed Sysctls" table
Message-ID: <20190723114813.GA14870@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: skhan@linuxfoundation.org
Cc: linux-kernel-mentees@lists.linuxfoundation.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

the "Removed Sysctls" section is a table - bring it alive with ReST.

Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
---
 Documentation/admin-guide/xfs.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index e76665a8f2f2..fb5b39f73059 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -337,11 +337,12 @@ None at present.
 Removed Sysctls
 ===============
 
+=============================	=======
   Name				Removed
-  ----				-------
+=============================	=======
   fs.xfs.xfsbufd_centisec	v4.0
   fs.xfs.age_buffer_centisecs	v4.0
-
+=============================	=======
 
 Error handling
 ==============
-- 
2.22.0
