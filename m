Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 79AC07F5D
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 08:12:40 -0600 (CST)
Message-ID: <52823762.4040704@sgi.com>
Date: Tue, 12 Nov 2013 08:12:50 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfstests: add regression test for running btrfs balance
	and defrag concurrently
References: <1383212062-30153-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1383212062-30153-1-git-send-email-bo.li.liu@oracle.com>
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
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Cc: xfs@oss.sgi.com

This has been committed.

Thanks
--Rich

commit 6bd85c0a995af4df28b354450e6df658257b559b
Author: Liu Bo <bo.li.liu@oracle.com>
Date:   Thu Oct 31 09:34:22 2013 +0000

     xfstests: add regression test for running btrfs balance and defrag 
concurrently

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
