Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 807407CA2
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2016 11:27:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01332AC003
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2016 09:27:02 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id XUtWr5LOLpHbpIdf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 19 Sep 2016 09:27:01 -0700 (PDT)
Date: Mon, 19 Sep 2016 09:26:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS reflink and development tip git trees updated
Message-ID: <20160919162623.GC10172@birch.djwong.org>
References: <20160905053317.GA15302@birch.djwong.org>
	<20160919161100.GA19849@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160919161100.GA19849@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Sep 19, 2016 at 09:11:00AM -0700, Christoph Hellwig wrote:
> Can you rebase (and repost the series) on top of the preparations
> in for-next that Dave just pushed out?
> 
> That should make reviewing a whole lot easier.

Porting is underway, though the delalloc refactoring banged things up a bit. :)

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
