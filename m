Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CF3A37F56
	for <xfs@oss.sgi.com>; Fri,  1 Nov 2013 07:51:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BBF838F8074
	for <xfs@oss.sgi.com>; Fri,  1 Nov 2013 05:51:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 9LX3uFpOzdEbmnnM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 01 Nov 2013 05:51:40 -0700 (PDT)
Date: Fri, 1 Nov 2013 05:51:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/30] db: separate out straight buffer IO from map based
	IO.
Message-ID: <20131101125138.GA14898@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-16-git-send-email-david@fromorbit.com>
	<20131031145609.GO22359@infradead.org>
	<20131031215020.GN4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131031215020.GN4446@dastard>
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

On Fri, Nov 01, 2013 at 08:50:20AM +1100, Dave Chinner wrote:
> > The patch description is a little too short, there's not real
> > explanation of what it actually does.
> 
> I can fix that.

Thanks.  I think all the answers you gave to my comments make a good
enough explanation for this patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
