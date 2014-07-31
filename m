Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 146767F94
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 12:14:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02C8B30405F
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 10:14:04 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id navXWV589sggJlms (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Jul 2014 10:14:01 -0700 (PDT)
Date: Thu, 31 Jul 2014 10:14:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: kill VN_MAPPED
Message-ID: <20140731171400.GC22173@infradead.org>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
	<1406791995-14723-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406791995-14723-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 31, 2014 at 05:33:14PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Only one user, no longer needed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
