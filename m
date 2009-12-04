Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB4GDuZe231492 for <xfs@oss.sgi.com>; Fri, 4 Dec 2009 10:13:57 -0600
Date: Fri, 4 Dec 2009 11:14:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: User Space Releases
Message-ID: <20091204161426.GA21499@infradead.org>
References: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AF34@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AF34@cf--amer001e--3.americas.sgi.com>
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
Cc: Nathan Scott <nathans@debian.org>, xfs@oss.sgi.com

So I think we're almost reading to get xfsprogs 3.1.0 and xfsdump 3.0.4
out of the door.

As far as I'm concerned this is the todo list:

xfsprogs:
 - get my pending repair btree checking patches reviewed and in
 - update the changelog and possibly any other documentation
 - update the Debian packaging

xfsdump:
 - get my configure defaults patch (just posted) in
 - update the changelog and possibly any other documentation
 - update the Debian packaging, possibly including the new source
   generation using the hardlinked package directory.

Nathan, what's the time frame to get the Debian release bits done?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
