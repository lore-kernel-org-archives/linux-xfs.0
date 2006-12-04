Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Dec 2006 08:20:49 -0800 (PST)
Received: from mcvs4.priv.usm.edu (smtp.usm.edu [131.95.82.201])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB4GKdaG027896
	for <xfs@oss.sgi.com>; Mon, 4 Dec 2006 08:20:41 -0800
Received: from anakin ([131.95.175.215])
	by mcvs4.priv.usm.edu (8.12.11/8.12.11) with ESMTP id kB4GVdwV031915
	for <xfs@oss.sgi.com>; Mon, 4 Dec 2006 10:31:39 -0600
Message-Id: <200612041631.kB4GVdwV031915@mcvs4.priv.usm.edu>
From: "Robert Johnson" <robert.e.johnson@usm.edu>
Subject: Xfs errors:
Date: Mon, 4 Dec 2006 09:47:46 -0600
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I have just installed and configured a xfs file system on Redhat AS4 server,
running on IBM eServer 366 platform.  The file system was carved out of our
EMC SAN, with Qlogic HBA dual port fiber channel cards. The error message is
as follows:

Dec  4 09:43:11 mail kernel: XFS: possible memory allocation deadlock in
kmem_alloc (mode:0x250)
Dec  4 09:43:14 mail kernel: XFS: possible memory allocation deadlock in
kmem_alloc (mode:0x250)
Dec  4 09:43:15 mail kernel: XFS: possible memory allocation deadlock in
kmem_alloc (mode:0x250)
Dec  4 09:44:44 mail kernel: XFS: possible memory allocation deadlock in
kmem_alloc (mode:0x2d0)


--------------------------------------------
R.E. Johnson, Linux Systems Administrator
Disaster Recovery Administrator
University of Southern Mississippi
iTech, Technology Infrastructure Unit
robert.e.johnson@usm.edu
 
-------------------------------------------
