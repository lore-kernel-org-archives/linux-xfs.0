Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Mar 2007 03:10:50 -0800 (PST)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.173])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l26BAh6p018947
	for <linux-xfs@oss.sgi.com>; Tue, 6 Mar 2007 03:10:45 -0800
Received: by ug-out-1314.google.com with SMTP id a2so138217ugf
        for <linux-xfs@oss.sgi.com>; Tue, 06 Mar 2007 03:10:43 -0800 (PST)
Message-ID: <5d96567b0703060214n45838ceh9375545613a1557c@mail.gmail.com>
Date: Tue, 6 Mar 2007 12:14:47 +0200
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: xfs_repair and extents size
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hello.
I am having some problems with extents sizes and xfs_repair.
Problem is that my files and directories are not real time files
and i am setting the extent size to 1MB. I have managed to
set the extent size to 1M by setting parent directory extent
to 1M and setting the inherit flag on.
But if I am running xfs_repair all extents on all directories in
the file system are being reset to zero.
I am using last xfsprogs 2.8.18 downloaded from sgi web
site.

thank you
-- 
Raz


[[HTML alternate version deleted]]
