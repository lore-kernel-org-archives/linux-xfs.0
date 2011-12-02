Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2NMc1e109441 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 17:22:38 -0600
Received: from out4.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 963221F40230
	for <xfs@oss.sgi.com>; Fri,  2 Dec 2011 15:22:37 -0800 (PST)
Received: from out4.smtp.messagingengine.com (out4.smtp.messagingengine.com
	[66.111.4.28]) by cuda.sgi.com with ESMTP id IXxARhcRCHFTNFuD
	for <xfs@oss.sgi.com>; Fri, 02 Dec 2011 15:22:37 -0800 (PST)
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id CC3CD2112D
	for <xfs@oss.sgi.com>; Fri,  2 Dec 2011 18:22:36 -0500 (EST)
Date: Fri, 2 Dec 2011 15:12:19 -0800
From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/6] XFS update for 3.1-stable (again)
Message-ID: <20111202231219.GA6016@kroah.com>
References: <1322782064-1723-1-git-send-email-bpm@sgi.com>
	<20111201233302.GA5573@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111201233302.GA5573@kroah.com>
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
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

On Thu, Dec 01, 2011 at 03:33:02PM -0800, Greg KH wrote:
> On Thu, Dec 01, 2011 at 05:27:38PM -0600, Ben Myers wrote:
> > This is a series of XFS fixes from current mainline which is important for
> > 3.1-stable.  Note that it is the same patch set that Christoph submitted for
> > 3.0-stable, minus the first three patches which are already included in 3.1.
> > 
> > My QA came out ok with these six patches atop 3.1.y.  I've been having trouble
> > getting mail out to stable@vger, but it seems to be working now.  Apologies to
> > those who are getting this mail yet again.
> 
> Nice, I got all of these, thanks.  I'll queue them up in a few days when
> I get caught up on the stable patch queue.

All applied.

Any reason why you only signed off on the last patch, and not the others
you sent me?  Just curious.

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
