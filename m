Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FAwrek004539 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 05:59:13 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AD4B19A04E
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 03:58:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail08.adl2.internode.on.net
	[203.16.214.72]) by cuda.sgi.com with ESMTP id PkgYHjaDA4BNjYMS
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 03:58:29 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] [XFS] Spurious ENOSPC fixes
Date: Sun, 15 Mar 2009 21:57:54 +1100
Message-Id: <1237114679-18808-1-git-send-email-david@fromorbit.com>
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
