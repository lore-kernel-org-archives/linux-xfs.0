Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n63CuWh8167569 for <xfs@oss.sgi.com>; Fri, 3 Jul 2009 07:56:33 -0500
Received: from mail-yx0-f203.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AEBD1D48B89
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2009 05:57:05 -0700 (PDT)
Received: from mail-yx0-f203.google.com (mail-yx0-f203.google.com
	[209.85.210.203]) by cuda.sgi.com with ESMTP id
	GEszB6By3o3AvsHg for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2009 05:57:05 -0700 (PDT)
Received: by yxe41 with SMTP id 41so3121348yxe.20
	for <xfs@oss.sgi.com>; Fri, 03 Jul 2009 05:57:05 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Jul 2009 18:27:05 +0530
Message-ID: <7778c60e0907030557j357f88e5g4ab3ce0d3377bb41@mail.gmail.com>
Subject: Clustered version of XFS
From: Tharindu Rukshan Bamunuarachchi <tharindu@sentstory.com>
Reply-To: tharindu@sentstory.com
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
To: xfs@oss.sgi.com

we are using XFS high speed transaction processing system.

we are very happy with XFS performance compared to ZFS, EXT3, JFS etc.

i have two questions regarding XFS ...

1. Is there any cluster version of XFS. (e.g. like GFS, Luste, GPFS)
2. I am currently using my root partition as XFS. but i need to modify
XFS source code and reload module without rebooting machine.
    Is there anyway to play with XFS source/module while using XFS
module for mounted file system ....?


cheers
__
tharindu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
