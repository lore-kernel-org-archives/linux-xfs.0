Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D9C3F7CBF
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 12:03:38 -0500 (CDT)
Message-ID: <521CDC22.1020507@sgi.com>
Date: Tue, 27 Aug 2013 12:04:34 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests/btrfs/308: add snapshot-aware defrag for
	partial extents testcases
References: <1374740102-9687-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1374740102-9687-1-git-send-email-bo.li.liu@oracle.com>
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
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Ben Myers <bpm@sgi.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Thanks for the patch Liu Bo, it has been committed as test number 10.

commit d943515bbcb8893c5d4ae21340a6022235d9e643
Author: Liu Bo <bo.li.liu@oracle.com>
Date:   Thu Jul 25 08:15:02 2013 +0000

     xfstests/btrfs/010: add snapshot-aware defrag for partial extents 
testcases

     This is to test whether snapshot-aware defrag can work well on 
partial extents.

     Reviewed-by: Ben Myers <bpm@sgi.com>
     Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
