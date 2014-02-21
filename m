Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B72C7FC8
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 18:17:03 -0600 (CST)
From: Shaun Gosse <sgosse@sgi.com>
Subject: RE: [PATCH] xfs_io: add support for O_TMPFILE opens
Date: Fri, 21 Feb 2014 00:16:58 +0000
Message-ID: <8D3FA7645C1CFC4E9E783D22B4C708644B2AF1@P-EXMB2-DC21.corp.sgi.com>
References: <20140220220000.GA17541@infradead.org>
In-Reply-To: <20140220220000.GA17541@infradead.org>
Content-Language: en-US
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Very minor point, but you've got a typo in the documentation portion of your patch.

+create a temporary file not linked into the filesystem namepspace 

Should be "namespace" of course.

Cheers,
-Shaun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
