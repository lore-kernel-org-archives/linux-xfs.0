Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6757D7F4E
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 18:23:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 54BE830408A
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 16:23:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	LJNIW5PqEY6BDMAL for <xfs@oss.sgi.com>;
	Tue, 22 Oct 2013 16:23:53 -0700 (PDT)
Date: Wed, 23 Oct 2013 10:23:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 1/4] xfsprog: add xfs sb v4 support for dirent
	filetype field
Message-ID: <20131022232333.GF2797@dastard>
References: <20131017152804.204045257@sgi.com>
	<20131017152955.415393417@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131017152955.415393417@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 17, 2013 at 10:28:05AM -0500, Mark Tinguely wrote:
> Add xfsprog superblock v4 support for the inode type information
> in the xfs directory feature in xfs_sb.h.
> 
> This support adds a feature bit for version 4 superblocks and
> leaves the original superblock 5 incompatibility bit.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
