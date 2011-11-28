Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASLqaJD257037 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 15:52:37 -0600
Received: from out3.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A192619E276C
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 13:43:00 -0800 (PST)
Received: from out3.smtp.messagingengine.com (out3.smtp.messagingengine.com
	[66.111.4.27]) by cuda.sgi.com with ESMTP id k7DphGgEAFdwk8mD
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 13:43:00 -0800 (PST)
Received: from compute4.internal (compute4.nyi.mail.srv.osa [10.202.2.44])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 554E321155
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 16:43:00 -0500 (EST)
Date: Tue, 29 Nov 2011 06:40:18 +0900
From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/6] XFS update for 3.1-stable
Message-ID: <20111128214018.GB1650@kroah.com>
References: <1322084293-23557-1-git-send-email-bpm@sgi.com>
	<20111128110043.GA13766@infradead.org>
	<20111128134829.GC21041@kroah.com> <20111128165418.GR29840@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128165418.GR29840@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 28, 2011 at 10:54:18AM -0600, Ben Myers wrote:
> Hey Greg,
> 
> On Mon, Nov 28, 2011 at 10:48:29PM +0900, Greg KH wrote:
> > On Mon, Nov 28, 2011 at 06:00:43AM -0500, Christoph Hellwig wrote:
> > > On Wed, Nov 23, 2011 at 03:38:07PM -0600, Ben Myers wrote:
> > > > This is a series of XFS fixes from current mainline which is important for
> > > > 3.1-stable.  Note that it is the same patch set that Christoph submitted for
> > > > 3.0-stable, minus the first three patches which are already included in 3.1.
> > > > 
> > > > My QA came out ok with these six patches atop 3.1.y.  Apologies to those who
> > > > got this mail twice. 
> > > 
> > > The updates looks good to me.
> > 
> > I never saw this series once, can someone please resend them as I don't
> > see them anywhere.
> 
> The first time I sent this 3.1.y series you were not on the --to=, which
> is why some people got the series twice but you didn't.  Sorry for the
> confusion. 

Was stable@vger.kernel.org on the to: line?  If so, I should have seen
them through that, but I don't, which is worrysome to me.

> Do you need the series for 3.0 to be resubmitted?

The 3.0 series is already in the last 3.0.11 release, so I don't need
them, I think I need the 3.1 patches, right?

thanks,

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
