Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0N03dBf028915 for <xfs@oss.sgi.com>; Sun, 22 Jan 2012 18:03:39 -0600
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com
	[66.111.4.27]) by cuda.sgi.com with ESMTP id ADIiO1BkJp2DYkrl
	for <xfs@oss.sgi.com>; Sun, 22 Jan 2012 16:03:38 -0800 (PST)
Received: from compute2.internal (compute2.nyi.mail.srv.osa [10.202.2.42])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 57D1520F58
	for <xfs@oss.sgi.com>; Sun, 22 Jan 2012 19:03:37 -0500 (EST)
Date: Sun, 22 Jan 2012 14:13:40 -0700
From: Greg KH <greg@kroah.com>
Subject: Re: XFS update for 3.2-stable
Message-ID: <20120122211340.GC3224@kroah.com>
References: <1326919305-2753-1-git-send-email-bpm@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1326919305-2753-1-git-send-email-bpm@sgi.com>
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
To: bpm@sgi.com
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jan 18, 2012 at 02:41:44PM -0600, bpm@sgi.com wrote:
> Here's a fix for 3.2-stable related to trim support in xfs.

Applied, thanks.  Is it also needed for the 3.0-stable tree?

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
