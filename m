Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6D29E7CB9
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 02:57:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3F36AC001
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 00:57:52 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id XF2Fr4u2cS5nqjXS (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Mar 2016 00:57:50 -0700 (PDT)
Date: Tue, 15 Mar 2016 00:57:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: collapse cases in xfs_attr3_leaf_list_int
Message-ID: <20160315075750.GD25971@infradead.org>
References: <56E3425E.40509@redhat.com>
 <56E342D5.7000900@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56E342D5.7000900@sandeen.net>
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
Cc: xfs@oss.sgi.com

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
