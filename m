Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Nov 2007 20:11:18 -0800 (PST)
Received: from itchy (dhcp17.melbourne.sgi.com [134.14.55.17])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAD4B2Yp012296
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2007 20:11:05 -0800
From: xaiki@sgi.com
Subject: RESEND(2)
Date: Tue, 13 Nov 2007 15:10:51 +1100
Message-Id: <1194927057-26415-1-git-send-email-xaiki@sgi.com>
In-Reply-To: <20071029075657.GA84369978@melbourne.sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Added descriptions to first patches,
Added extended description for unwritten extents, updated manpages.
Refactored XFS_DFL_SB_VERSION_BITS as suggested by dave.
Added in-code description for reduced imaxpct for big filesystems.
      made calc_default_imaxpct stati, as suggested by dave.
Removed mention to cleaning typos ;)
      implemented new logics as suggested by dave.
