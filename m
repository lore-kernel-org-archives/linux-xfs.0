Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GEJ4mg094945 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 09:19:24 -0500
Received: from mo-p05-ob.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76DDD19D655
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 07:18:22 -0700 (PDT)
Received: from mo-p05-ob.rzone.de (mo-p05-ob.rzone.de [81.169.146.181]) by
	cuda.sgi.com with ESMTP id KAERm8tBToZqm0Jj for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 07:18:22 -0700 (PDT)
Received: from [10.1.1.65] ([213.39.240.61])
	by post.strato.de (mrclete mo56) (RZmta 18.26)
	with ESMTP id 500ecbl2GDtNBh for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2009 15:07:09 +0100 (MET)
Message-ID: <49BE5CC9.9000605@renderforce.de>
Date: Mon, 16 Mar 2009 15:06:01 +0100
From: Steffen Knauf <Steffen.Knauf@renderforce.de>
MIME-Version: 1.0
Subject: Multiple Mounting of one XFS Partition
Reply-To: steffen.knauf@renderforce.de
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

i have 2 Servers which are connected with a raid via FibreChannel.
Both of them have mounted the same XFS-Partition. But if i change a 
Filepermission
or add some Files at the Partition of server1, the partition of server2 
don't show the modifications
until i remount the Partitions. I don't know how whether it is a cache 
Option or something else.
Perhaps someone have an idea.
Thanks!

greets

Steffen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
