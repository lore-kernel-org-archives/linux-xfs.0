Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p044mPKv176239 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 22:48:26 -0600
Received: from web31912.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id F12AF230B7C
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 20:50:32 -0800 (PST)
Received: from web31912.mail.mud.yahoo.com (web31912.mail.mud.yahoo.com
	[68.142.207.92]) by cuda.sgi.com with SMTP id NHZUgYwqSQBLgyBJ
	for <xfs@oss.sgi.com>; Mon, 03 Jan 2011 20:50:32 -0800 (PST)
Message-ID: <41292.59911.qm@web31912.mail.mud.yahoo.com>
Date: Mon, 3 Jan 2011 20:50:32 -0800 (PST)
From: Dean Burrows <dkburrows@yahoo.com>
Subject: Accidentally deleted an external log, any recovery options?
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

Hello,


I was trying a different distro and in doing so deleted a partition that held an 
xfs external log. Now I can't mount or repair the drive that was using that 
external log. Is there a way to get the data off, or to create an internal log 
without losing the data?


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
