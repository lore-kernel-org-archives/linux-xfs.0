Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 831C67CA7
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 07:51:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 07D31AC001
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 05:51:17 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id LO1qdEyZZuq5eWGe (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 05:51:13 -0700 (PDT)
Date: Tue, 31 May 2016 05:51:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/7] xfs/122: don't break on old xfsprogs
Message-ID: <20160531125109.GA17018@infradead.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
	<20160527180231.GB5050@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160527180231.GB5050@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Xiao Yang <yangx.jy@cn.fujitsu.com>, fstests@vger.kernel.org, xfs@oss.sgi.com

Looks fine, but can't we also remove the workaround at the end of the
the test as well?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
