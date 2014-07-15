Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5D90C7F92
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 05:21:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B1AE8F804C
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 03:21:46 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HSNvcenWVx1AOgtl (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 03:21:45 -0700 (PDT)
Date: Tue, 15 Jul 2014 03:21:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] dump: fix translation build errors
Message-ID: <20140715102143.GF30363@infradead.org>
References: <1405403106-3084-1-git-send-email-david@fromorbit.com>
	<1405403106-3084-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1405403106-3084-3-git-send-email-david@fromorbit.com>
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
Cc: Jakub Bogusz <qboosh@pld-linux.org>, xfs@oss.sgi.com

On Tue, Jul 15, 2014 at 03:45:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The translations fail to build because of duplicate message strings.
> Remove the duplicate.
> 
> Also, fix the missing "language" tag from the german translation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Btw, Jakub are you still interested in xfsdump translations?  We might
do another release soon so it might be a good time to start work on it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
