Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FBWeGv006956 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 06:33:01 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C8431C43843
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:32:17 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail02.adl2.internode.on.net
	[203.16.214.66]) by cuda.sgi.com with ESMTP id YmqwwLUFwJYMp4HM
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:32:17 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5, RESEND] [XFS] Spurious ENOSPC fixes
Date: Sun, 15 Mar 2009 22:31:42 +1100
Message-Id: <1237116707-25793-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: mpatocka@redhat.com

This series fix the spurious ENOSPC problems reported by and
partially solved by Mikulas Patocka. This series makes the recently
posted QA tests 203 and 204 pass.

Mikulas, if I've got any of the attributions wrong for the
bits of your code I used, let me know and I'll fix them.

This is a resend with the correct sign-offs on it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
