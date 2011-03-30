Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2UIh39S069234 for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 13:43:05 -0500
Date: Wed, 30 Mar 2011 14:46:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs: update CHANGES file for release
Message-ID: <20110330184613.GA32141@infradead.org>
References: <1301507600.2953.13.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1301507600.2953.13.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

Note that you'll also need to update debian/changelog for the release,
just copy an old one that says upstream update and mention that it fixes
bug 618730.


> +	- Polish translation update

please credit this one to Jakub Bogusz

> +	- xfs_io now supports the "fpunch" command, as well as a
> +	  "-p" flag to the "fallocate command.  Both implement hole
> +	  punching.

please credit this Josef Bacik

> +	- A number of other bug fixes

please credit these to Ajeet Yadav and 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
