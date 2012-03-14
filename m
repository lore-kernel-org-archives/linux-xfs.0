Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2EK9ZJi236734 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 15:09:35 -0500
Received: from MMS3.broadcom.com (mms3.broadcom.com [216.31.210.19]) by
	cuda.sgi.com with ESMTP id ASHdo30rCl5wqhct for
	<xfs@oss.sgi.com>; Wed, 14 Mar 2012 13:09:34 -0700 (PDT)
From: "Kamal Dasu" <kdasu.kdev@gmail.com>
Subject: [PATCH 0/1] : xfsprogs: Use Posix signal API sigprocmask V2
Date: Wed, 14 Mar 2012 16:09:27 -0400
Message-ID: <1331755768-14681-1-git-send-email-kdasu.kdev@gmail.com>
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
To: xfs@oss.sgi.com, cernekee@gmail.com

[PATCH 1/1] xfsprogs: Use Posix signal API sigprocmask instead of sigrelse/sighold in xfs_copy.c


Kamal

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
