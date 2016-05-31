Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5862B7CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 07:52:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B3BB8F8033
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 05:52:15 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id v58DdCTgN1OQ4Ov1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 05:52:13 -0700 (PDT)
Date: Tue, 31 May 2016 05:52:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 6/7] xfs: test rmap behavior when multiple bmbt
	records map to a single rmapbt record
Message-ID: <20160531125210.GC17018@infradead.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
	<146424226290.6278.15051221437554845000.stgit@birch.djwong.org>
	<20160527032851.GB9418@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160527032851.GB9418@birch.djwong.org>
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
Cc: hch@infradead.org, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
