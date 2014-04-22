Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E78CC7F4E
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 04:42:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D234F8F8040
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 02:42:00 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id DFBkHZFnaZQpqnnX (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 02:42:00 -0700 (PDT)
Date: Tue, 22 Apr 2014 02:41:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] repair: detect CRC errors in AG headers
Message-ID: <20140422094159.GB17700@infradead.org>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-6-git-send-email-david@fromorbit.com>
	<20140421071106.GF20384@infradead.org>
	<20140421233512.GE18672@dastard>
	<20140422064737.GA32026@infradead.org>
	<20140422091043.GF15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140422091043.GF15995@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Apr 22, 2014 at 07:10:43PM +1000, Dave Chinner wrote:
> Right now I ijust want to keep the change as small as possible and
> get a release out.

Oh well.  I'll probably ACK it next time it comes around.  I think the
series needs enough changes for a resend anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
