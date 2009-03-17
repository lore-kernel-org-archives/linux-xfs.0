Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2HHT0nq171581 for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 12:29:19 -0500
Received: from mo-p05-ob.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF72A1A33DB
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 10:28:39 -0700 (PDT)
Received: from mo-p05-ob.rzone.de (mo-p05-ob.rzone.de [81.169.146.181]) by
	cuda.sgi.com with ESMTP id BjSHOU5RR2CgUgGd for
	<xfs@oss.sgi.com>; Tue, 17 Mar 2009 10:28:39 -0700 (PDT)
Received: from [10.1.1.65] ([213.39.240.61])
	by post.strato.de (fruni mo42) (RZmta 18.26)
	with ESMTP id J022b4l2HHLxaK for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2009 18:28:37 +0100 (MET)
Message-ID: <49BFDD80.1060401@renderforce.de>
Date: Tue, 17 Mar 2009 18:27:28 +0100
From: Steffen Knauf <Steffen.Knauf@renderforce.de>
MIME-Version: 1.0
Subject: Lost files + indentical Foldernames on XFS Partition
Reply-To: Steffen.Knauf@liga01.de
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

today i have a strange behavior. I have a a directory which contains 
lots of indentical Folders with the same Name and Inode.
I don't create Hardlinks or something else. On the other side some files 
are suddenly vanished. A "ls -al" result in the following error: 
"Access  to bla not possible: File or Directory not found."
I don't find some Errormessages in the logfile. I don't know whether a 
xfs_check make sense.

greets

Steffen



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
