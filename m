Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MNdbfU117491 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 18:39:37 -0500
Received: from e6.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B805F1D8BC60
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:39:36 -0700 (PDT)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146]) by
	cuda.sgi.com with ESMTP id KcbdYqTmRmgq2sBY for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:39:36 -0700 (PDT)
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6MNFSLf019099
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 19:15:28 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6MNdYrc456556 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 19:39:35 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6MNdYxn025157 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 20:39:34 -0300
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 22 Jul 2011 16:39:33 -0700
Message-Id: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 00/12 v3] Remove number of macros from xfs_buf.h
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Hello All,

Here are few patchset to remove some of the macro definitions from 
fs/xfs/linux-2.6/xfs_buf.h.

Please review and comment.

This set is version 3:
Incorporated changes suggested by Alex Elder in patches 3/12, 8/12,
9/12 and 12/12

Version 2:
Incorporated changes suggested by hristoph Hellwig in patches 2/12, 3/12,
7/12 and 10/12.

Thanks & Regards,

chandra

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
