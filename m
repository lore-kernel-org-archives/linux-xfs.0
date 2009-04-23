Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3NHL0IX016739 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 12:21:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D15F2369FD
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 10:20:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bCdrT6xAm6NPm5Ky for
	<xfs@oss.sgi.com>; Thu, 23 Apr 2009 10:20:58 -0700 (PDT)
Date: Thu, 23 Apr 2009 13:20:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: add aio-dio-regress tests
Message-ID: <20090423171937.GE11391@infradead.org>
References: <49EFB75B.5030700@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49EFB75B.5030700@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 22, 2009 at 07:33:31PM -0500, Eric Sandeen wrote:
> Think it's worth pulling this in?
> Also not sure where to put it, under the top dir or under src ...
> 
> Takes about 250s to run them all.  Could break out the longer
> one into a separate test so the rest could be in quick.

I would prefer to have a separate test for each of the programs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
