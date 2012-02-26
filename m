Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1Q3FlMx202286 for <xfs@oss.sgi.com>; Sat, 25 Feb 2012 21:15:48 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id EXY2DJHzXisCrqRy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 Feb 2012 19:15:46 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1S1UaQ-0000r3-9C
	for xfs@oss.sgi.com; Sat, 25 Feb 2012 19:15:46 -0800
Message-ID: <33393100.post@talk.nabble.com>
Date: Sat, 25 Feb 2012 19:15:46 -0800 (PST)
From: MikeJeezy <forums@mgaccess.net>
Subject: mount: Structure needs cleaning
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
To: xfs@oss.sgi.com


I have two 2TB xfs volumes and earlier today the /var/log/messages shows
"xfs_force_shutdown" after many errors (attached) 
http://old.nabble.com/file/p33393100/var-log-message.txt var-log-message.txt
.  Are there any options to try before running "xfs_repair -L"?   The
volumes contain several millions files so that I my last resort.  I'm a
novice at best in Linux.
-- 
View this message in context: http://old.nabble.com/mount%3A-Structure-needs-cleaning-tp33393100p33393100.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
