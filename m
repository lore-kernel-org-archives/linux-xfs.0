Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E65F7F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 03:35:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5E08F304053
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 01:35:42 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id UtHcA0kguCq85GAN (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Mar 2014 01:35:41 -0700 (PDT)
Date: Mon, 10 Mar 2014 01:35:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: shared/051: update golden output to match the
	XFS max acl return errno
Message-ID: <20140310083540.GA30458@infradead.org>
References: <531D7897.2030800@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <531D7897.2030800@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Mar 10, 2014 at 04:32:23PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Update the golden output to match the recently XFS return errno
> changes if hit the limits of maximum number of ACLs.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Thanks!

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
