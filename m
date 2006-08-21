Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Aug 2006 18:56:40 -0700 (PDT)
Received: from rwcrmhc11.comcast.net (rwcrmhc11.comcast.net [204.127.192.81])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7L1uNDW020391
	for <xfs@oss.sgi.com>; Sun, 20 Aug 2006 18:56:24 -0700
From: bridavis@comcast.net
Subject: Differences in su/sw values for hw vs. sw RAID 5?
Date: Mon, 21 Aug 2006 01:55:48 +0000
Message-Id: <082120060155.2003.44E912A400010D0F000007D322058864429C07900E0B079D0D@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I getting conflicting reports as to how I should generate my sunit/swidth vaules for hardware RAID 5.

Setup: hardware RAID 5, 3 disks at 300 GBs each, 64k stripe size.

Originally, following the man page and the mailing list archives, I came up sw=2,su=64k. 

However, I read a reply to an earlier question I sent to the list, and it indicated that the hardward RAID should be treated as a single disk, so I came up with sw=1,su=128k.

Which one is correct for my setup?

Thanks!

[[HTML alternate version deleted]]
