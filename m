Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Jul 2006 06:07:45 -0700 (PDT)
Received: from orca.ele.uri.edu (orca.ele.uri.edu [131.128.51.63])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6QD7WDW002357
	for <linux-xfs@oss.sgi.com>; Wed, 26 Jul 2006 06:07:34 -0700
Subject: [patch]typo
From: Ming Zhang <mingz@ele.uri.edu>
Reply-To: mingz@ele.uri.edu
Content-Type: text/plain
Date: Wed, 26 Jul 2006 09:06:57 -0400
Message-Id: <1153919217.2658.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs <linux-xfs@oss.sgi.com>

A typo in xfs_fsr man page.

Ming


--- xfs_fsr.8.old       2006-07-26 09:05:06.000000000 -0400
+++ xfs_fsr.8   2006-07-26 09:05:38.000000000 -0400
@@ -107,7 +107,7 @@
 file to a temporary location and then interchanging the data extents
 of the target and temporary files in an atomic manner.
 This method requires that enough free disk space be available to copy
-any given file and that the space be less fragmented then the original
+any given file and that the space be less fragmented than the original
 file.
 It also requires the owner of the file to have enough remaining
 filespace quota to do the copy on systems running quotas.
