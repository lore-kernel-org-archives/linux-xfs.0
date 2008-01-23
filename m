Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jan 2008 09:15:40 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0NHFXVo010539
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 09:15:38 -0800
Received: from rv-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87C405502AD
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 09:15:50 -0800 (PST)
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.191]) by cuda.sgi.com with ESMTP id Z6dpJOs6LXLXmvm3 for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 09:15:50 -0800 (PST)
Received: by rv-out-0910.google.com with SMTP id k20so2112761rvb.32
        for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 09:15:49 -0800 (PST)
Message-ID: <4f52331f0801230915p1d3c4c3ala010d9066addb411@mail.gmail.com>
Date: Wed, 23 Jan 2008 09:15:49 -0800
From: "Fong Vang" <sudoyang@gmail.com>
Subject: XFS file system corrupted beyond repair?
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

One of our servers cannot mount an XFS file system after reboot.  xfs_check
and xfs_repair cannot fix the problem.  Both indicate that there are no
valid superblock can be found.  Are there any tool that can help reconstruct
the file system.  Doing a hexdump of the partition, it appears there are
valid filenames still on there.  Also, the disk has no bad block or hardware
issues.

Is there anyone on the XFS development team that we can hire to examine the
file system more closely and see if it can be reconstructed?


[[HTML alternate version deleted]]
