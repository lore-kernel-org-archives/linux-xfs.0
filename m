Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 238A57F81
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 05:09:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0D679304043
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 03:09:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id V6KocPpFgBSD0hxM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Mar 2014 03:09:33 -0700 (PDT)
Date: Thu, 13 Mar 2014 03:09:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs_io: add support for flink
Message-ID: <20140313100933.GA25703@infradead.org>
References: <20140220220000.GA17541@infradead.org>
	<20140221004933.GA9445@infradead.org>
	<20140225195218.GA14110@infradead.org>
	<20140225233556.GI13647@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140225233556.GI13647@dastard>
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

On Wed, Feb 26, 2014 at 10:35:57AM +1100, Dave Chinner wrote:
> Looks like some noise got into that hunk. Other than that:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> I'll remove that extra line when I commit it.

ping?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
