Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 083FE7CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 11:42:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC53E304048
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 09:42:43 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id LY3hF25GqPtxkVpH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 09:42:41 -0700 (PDT)
Date: Tue, 31 May 2016 09:41:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/7] xfs/122: don't break on old xfsprogs
Message-ID: <20160531164138.GB5053@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
	<20160527180231.GB5050@birch.djwong.org>
	<20160531125109.GA17018@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160531125109.GA17018@infradead.org>
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
Cc: fstests@vger.kernel.org, Xiao Yang <yangx.jy@cn.fujitsu.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, May 31, 2016 at 05:51:09AM -0700, Christoph Hellwig wrote:
> Looks fine, but can't we also remove the workaround at the end of the
> the test as well?

Oh, heh, yes, those can go.  The whitespace is wrong on them anyway.

--D

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
