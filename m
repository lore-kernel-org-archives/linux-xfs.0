Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 16:52:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m66NqEGl000777
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 16:52:15 -0700
Received: from smtp.sauce.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 841C011DBF4F
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 16:53:18 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by cuda.sgi.com with ESMTP id lZEoFBWDFqPJUVZG for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 16:53:18 -0700 (PDT)
Message-ID: <48715CEF.8010008@sauce.co.nz>
Date: Mon, 07 Jul 2008 12:01:51 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: XFS Recovery
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

If the following log entry appears after mounting an XFS fs, is it safe 
to assume that whatever issue initiated the recovery has been repaired, 
or is further checking/repair required?

XFS mounting filesystem md5
Starting XFS recovery on filesystem: md5 (logdev: /dev/md0)
Ending XFS recovery on filesystem: md5 (logdev: /dev/md0)


Regards,

Richard
