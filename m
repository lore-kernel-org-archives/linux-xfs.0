Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C47D7F4E
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 10:12:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 021E7AC003
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 08:12:07 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id Q0PRFFobHB6IhF7S (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 May 2014 08:12:06 -0700 (PDT)
Subject: Bug#748483: xfsprogs: Let's add a watch file
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.748483.B.14006849045275@bugs.debian.org>
Date: Wed, 21 May 2014 07:47:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20140521144701.GA3580@infradead.org>
References: <20140517175957.5232.71552.reportbug@lamella>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140517175957.5232.71552.reportbug@lamella>
Reply-To: Christoph Hellwig <hch@infradead.org>, 748483@bugs.debian.org
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Vincent Blut <vincent.debian@free.fr>, 748483@bugs.debian.org
Cc: Debian Bug Tracking System <submit@bugs.debian.org>

On Sat, May 17, 2014 at 07:59:57PM +0200, Vincent Blut wrote:
> Source: xfsprogs
> Version: 3.1.9
> Severity: wishlist
> 
> Hey guys,
> 
> Even if it doesn't necessarily improve your workflow, the watch file could 
> improve some Debian tools that check it (e.g. UDD). 
> Could you please apply the attached one in your next upload?

I'll assume this should go into debian/watch?

It's probably best if you simply submit a patch that adds it with
proper From:, Subject: and Signed-off-by: tags so it can be applied
as-is.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
