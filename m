Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 939AF7F54
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 09:00:54 -0600 (CST)
Message-ID: <529DF220.9060208@sgi.com>
Date: Tue, 3 Dec 2013 09:00:48 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstest generic/280: wait for setquota to finish before
	umount
References: <1382637381-4847-1-git-send-email-guangyu.sun@oracle.com>
In-Reply-To: <1382637381-4847-1-git-send-email-guangyu.sun@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Guangyu Sun <guangyu.sun@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

This has been committed.

Thanks
--Rich

commit 527eeb43e5c7cfd642d81bc3c12e746d2a3733ff
Author: Guangyu Sun <guangyu.sun@oracle.com>
Date:   Thu Oct 24 17:56:21 2013 +0000

     xfstest generic/280: wait for setquota to finish before umount

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
