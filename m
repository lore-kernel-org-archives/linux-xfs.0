Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2HHQGng171391 for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 12:26:38 -0500
Received: from mo-p00-ob.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BE251C4CA23
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 10:25:55 -0700 (PDT)
Received: from mo-p00-ob.rzone.de (mo-p00-ob.rzone.de [81.169.146.161]) by
	cuda.sgi.com with ESMTP id Bcs5t66aNNXfzoVX for
	<xfs@oss.sgi.com>; Tue, 17 Mar 2009 10:25:55 -0700 (PDT)
Received: from [10.1.1.65] ([213.39.240.61])
	by post.strato.de (fruni mo7) (RZmta 18.26)
	with ESMTP id 6032cdl2HHD5KL for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2009 18:24:03 +0100 (MET)
Message-ID: <49BFDC6E.6050607@liga01.de>
Date: Tue, 17 Mar 2009 18:22:54 +0100
From: Steffen Knauf <Steffen.Knauf@liga01.de>
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
