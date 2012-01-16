Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9803W59091397 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 19:03:33 -0500
MIME-Version: 1.0
In-Reply-To: <20120111113507.GB14423@infradead.org>
References: <1325848338-6063-1-git-send-email-amit.sahrawat83@gmail.com>
	<20120111113507.GB14423@infradead.org>
Date: Mon, 16 Jan 2012 17:49:00 +0530
Message-ID: <CADDb1s110TS6STfV9f6t+W4h5Bo21PXLu=nhHgDojkGhT03Kag@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs: cleanup XFS_BB_FSB_OFFSET
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs masters <xfs-masters@oss.sgi.com>, Ben Myers <bpm@sgi.com>, xfs <xfs@oss.sgi.com>, linux kernel <linux-kernel@vger.kernel.org>, Alex Elder <aelder@sgi.com>

thanks Christoph,

Resent the patch after the subject change.

Regards,
Amit Sahrawat

On Wed, Jan 11, 2012 at 5:05 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jan 06, 2012 at 04:42:18PM +0530, Amit Sahrawat wrote:
>> Removing the macro, as this is no more needed in the code.
>> Tried to find the reference when it was last used - but the usage
>> for this seemed to have been dropped long time ago.
>>
>> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>
> This looks good, but the subject should be something like:
>
> "xfs: kill the unused XFS_BB_FSB_OFFSET macro"
>
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
