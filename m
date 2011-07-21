Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6L4RWYN004944 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 23:27:32 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B49D1E682DC
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 21:27:31 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id DhwPXaaLyXEBjpFJ for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2011 21:27:31 -0700 (PDT)
Date: Thu, 21 Jul 2011 00:27:29 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: Problems building xfsprogs
Message-ID: <20110721042729.GC3304@thunk.org>
References: <20110720175918.GB17971@thunk.org>
	<20110721041903.GB3304@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110721041903.GB3304@thunk.org>
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
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 21, 2011 at 12:19:03AM -0400, Ted Ts'o wrote:
> Another problem with xfsprogs.  "make install" iterates into the
> debian subdirectory, for no good reason I can see other than to cause
> the build to explode in a million pieces.... 

Sorry, never mind, false alarm.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
