Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B2C607F3F
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 04:34:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80EDB304279
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 02:34:42 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id iWGB5rzwJAZSua4J (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Jun 2014 02:34:41 -0700 (PDT)
Date: Mon, 16 Jun 2014 02:34:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs/279: use MKFS_XFS_PROG, not hardcoded path
Message-ID: <20140616093440.GA26172@infradead.org>
References: <539B68D2.2000300@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <539B68D2.2000300@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: fstests@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 13, 2014 at 04:10:42PM -0500, Eric Sandeen wrote:
> I'm really not sure why this wasn't this way from the start.
> On some systems it's in /usr/sbin, and the test fails.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
