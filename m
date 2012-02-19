Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1JMRiSW031073 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 16:27:44 -0600
Date: Sun, 19 Feb 2012 17:27:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] xfs: fix buffer flushing during log unmount
Message-ID: <20120219222735.GA19971@infradead.org>
References: <1329306980-17997-1-git-send-email-amit.sahrawat83@gmail.com>
	<20120217191522.GB13870@infradead.org>
	<CADDb1s35zgur9SGHR_9r=tSr8ZnC-+DTtTXYgc6H_K68Eb_QEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADDb1s35zgur9SGHR_9r=tSr8ZnC-+DTtTXYgc6H_K68Eb_QEQ@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Nam-Jae Jeon <linkinjeon@gmail.com>, Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>

Hi Amit,

thanks, your explanation makes sense.  Can you resend the patch with
the full description of what is going on? (or if Ben wants to edit it in
place before applying it's also fine with me).

Thanks a lot for tracking this down.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
