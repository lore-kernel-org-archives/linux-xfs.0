Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 035047F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:42:07 -0500 (CDT)
Message-ID: <526172EC.2030209@sgi.com>
Date: Fri, 18 Oct 2013 12:42:04 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: avoid segfault if reporting progress early
	in repair
References: <52602358.1050300@redhat.com>
In-Reply-To: <52602358.1050300@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

This has been committed.

Thanks
--Rich

commit 7f2d6b811755b6b91f18aa5bd9d5980848a81267
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu Oct 17 17:50:16 2013 +0000

     xfs_repair: avoid segfault if reporting progress early in repair

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
