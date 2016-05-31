Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7771A7CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 14:33:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4DFAAC001
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 12:33:10 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id c66rZaNGvs3wghB2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 12:33:08 -0700 (PDT)
Date: Tue, 31 May 2016 12:33:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 8/7] xfs/122: don't break on old xfsprogs
Message-ID: <20160531193306.GA28680@infradead.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
	<20160527180231.GB5050@birch.djwong.org>
	<20160531164352.GC5053@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160531164352.GC5053@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, Xiao Yang <yangx.jy@cn.fujitsu.com>, linux-btrfs@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
