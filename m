Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C974B29DF8
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 16:07:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BC3808F8033
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 14:07:04 -0700 (PDT)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
	[209.85.212.171]) by cuda.sgi.com with ESMTP id
	hFU5C9B1VknZoOSK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Jun 2014 14:07:03 -0700 (PDT)
Received: by mail-wi0-f171.google.com with SMTP id n15so4783839wiw.4
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 14:07:02 -0700 (PDT)
Message-ID: <539F5C6F.4060402@gmail.com>
Date: Mon, 16 Jun 2014 23:06:55 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] [RFC] xfs: wire up aio_fsync method
References: <1402562047-31276-1-git-send-email-david@fromorbit.com>
	<20140612141329.GA11676@infradead.org>
	<20140612234441.GT9508@dastard>
	<20140613162352.GB23394@infradead.org>
In-Reply-To: <20140613162352.GB23394@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-man@vger.kernel.org, mtk.manpages@gmail.com, xfs@oss.sgi.com

Hi Christoph,

On 06/13/2014 06:23 PM, Christoph Hellwig wrote:

> Talking about documentation:  The kernel aio manpages (io_*.2) seems
> to not really be very useful, mostly because they don't explain how
> to set up the iocbs.  Michael, any idea how to get started to improve
> this?

Well, it just needs someone knowledgeable to fill the gaps, and
perhaps add an example program. I don't have that knowledge 
offhand myself...

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
