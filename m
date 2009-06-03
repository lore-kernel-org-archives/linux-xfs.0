Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n53GhcXg184041 for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 11:43:38 -0500
Date: Wed, 3 Jun 2009 12:43:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add -x mode to include/install-sh; add build hints to
	doc/INSTALL.
Message-ID: <20090603164354.GB30759@infradead.org>
References: <1243979080-5665-1-git-send-email-rherndon@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1243979080-5665-1-git-send-email-rherndon@sgi.com>
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
To: Robert Herndon <rherndon@sgi.com>
Cc: xfs@oss.sgi.com

Should be two separate patches/commits, please.

It would be useful to mention what package this is again in the
subject line:

	[PATCH] xfsprogs: add -x mode to include/install-sh
	[PATCH] xfsprogs: add build hints to doc/INSTALL

(also note that commit subject lines after the prefix are not
capitalized.

>  	# make install-dev
> +	[and optionally, for the development libraries and full headers;
> +         this is required to build xfstests]
> +	# make install-qa

It's not actually required anymore.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
