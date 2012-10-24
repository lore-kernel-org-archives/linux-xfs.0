Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OM4Z00058191 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 17:04:35 -0500
Date: Wed, 24 Oct 2012 17:06:17 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/3] rename configure.in to configure.ac
Message-ID: <20121024220616.GT1377@sgi.com>
References: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: xfs@oss.sgi.com

On Mon, Sep 24, 2012 at 07:39:36PM -0400, Mike Frysinger wrote:
> Newer autotools warn and start to error with the older name.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

I have pulled this series into xfsdump and xfsprogs repos on oss.  xfstests has
a little hiccup that I need to sort through first:

~/xfstests # make
make: *** No rule to make target `configure.in', needed by `configure'.  Stop.

I haven't forgotten dmapi.

Thanks Mike!

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
