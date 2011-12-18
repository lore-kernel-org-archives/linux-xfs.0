Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBIKRbtp243603 for <xfs@oss.sgi.com>; Sun, 18 Dec 2011 14:27:37 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	G3BDEvbL0Zmvt4uy for <xfs@oss.sgi.com>;
	Sun, 18 Dec 2011 12:27:36 -0800 (PST)
Date: Sun, 18 Dec 2011 15:27:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs-trace-ilock-more
Message-ID: <20111218202734.GB20799@infradead.org>
References: <20111214024040.GA17780@infradead.org>
	<20111214182750.GH11114@wotan.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111214182750.GH11114@wotan.suse.de>
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
To: Mark Fasheh <mfasheh@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Mahoney <jeffm@suse.com>, xfs@oss.sgi.com

On Wed, Dec 14, 2011 at 10:27:50AM -0800, Mark Fasheh wrote:
> Hey Christoph,
> 
> On Tue, Dec 13, 2011 at 09:40:40PM -0500, Christoph Hellwig wrote:
> > Can you explain the story behid this patch in SLES11SP1?
> 
> We were looking at some performance issues and needed a bit more information
> on the amount of time spent in ilock. I can give you more specifics if you
> want, I just have to dig up the e-mails (it's been a while).

Given that the patch is fairly clean can you send it to us for
inclusion?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
