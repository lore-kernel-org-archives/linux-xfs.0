Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p22Gspoi033274
	for <linux-xfs@oss.sgi.com>; Wed, 2 Mar 2011 10:54:51 -0600
Received: from sam.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CABD13333B1
	for <linux-xfs@oss.sgi.com>; Wed,  2 Mar 2011 08:57:41 -0800 (PST)
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id xCtfXM4kk2b7J0GA for
	<linux-xfs@oss.sgi.com>; Wed, 02 Mar 2011 08:57:41 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.69)
	(envelope-from <lists@nabble.com>) id 1PupMq-0002bt-Rc
	for linux-xfs@oss.sgi.com; Wed, 02 Mar 2011 08:57:40 -0800
Message-ID: <31051172.post@talk.nabble.com>
Date: Wed, 2 Mar 2011 08:57:40 -0800 (PST)
From: tramper <michael.weingartner@tuwien.ac.at>
Subject: xfs 14TB - check
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com


Hallo Forum,

i formated a storage with 16 disks (Raid5  and sparedrive) with xfs. The
volume is 14TB big. There where circuit Problems and we had several server
shutdowns and Problems.
The Server is a ubuntu 8.04 32bit.

Now I want to check my xfs Partition.

i used xfs_repair /dev/cciss/c0...p1 and got the following error message:

fatal error -- couldn't allocate block map, size XXXXXXX

I have 2 GB of Ram in the machine.

What should I do and how to check my volume?

with kind regards
traper
-- 
View this message in context: http://old.nabble.com/xfs-14TB---check-tp31051172p31051172.html
Sent from the linux-xfs mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
