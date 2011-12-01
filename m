Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB1NXBJa034125 for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 17:33:12 -0600
Received: from out4.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43DCE29221A
	for <xfs@oss.sgi.com>; Thu,  1 Dec 2011 15:33:11 -0800 (PST)
Received: from out4.smtp.messagingengine.com (out4.smtp.messagingengine.com
	[66.111.4.28]) by cuda.sgi.com with ESMTP id bbuhXqaJ2YegUwtn
	for <xfs@oss.sgi.com>; Thu, 01 Dec 2011 15:33:11 -0800 (PST)
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id AA80E21AFE
	for <xfs@oss.sgi.com>; Thu,  1 Dec 2011 18:33:10 -0500 (EST)
Date: Thu, 1 Dec 2011 15:33:02 -0800
From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/6] XFS update for 3.1-stable (again)
Message-ID: <20111201233302.GA5573@kroah.com>
References: <1322782064-1723-1-git-send-email-bpm@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1322782064-1723-1-git-send-email-bpm@sgi.com>
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

On Thu, Dec 01, 2011 at 05:27:38PM -0600, Ben Myers wrote:
> This is a series of XFS fixes from current mainline which is important for
> 3.1-stable.  Note that it is the same patch set that Christoph submitted for
> 3.0-stable, minus the first three patches which are already included in 3.1.
> 
> My QA came out ok with these six patches atop 3.1.y.  I've been having trouble
> getting mail out to stable@vger, but it seems to be working now.  Apologies to
> those who are getting this mail yet again.

Nice, I got all of these, thanks.  I'll queue them up in a few days when
I get caught up on the stable patch queue.

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
