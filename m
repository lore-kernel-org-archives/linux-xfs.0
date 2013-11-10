Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4C7117F76
	for <xfs@oss.sgi.com>; Sat,  9 Nov 2013 19:07:34 -0600 (CST)
Message-ID: <527EDC50.1010708@sgi.com>
Date: Sat, 9 Nov 2013 19:07:28 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: posix_memalign and io_submit do not set errno
References: <20131107170045.GA6599@infradead.org>
In-Reply-To: <20131107170045.GA6599@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

This has been committed.

Thanks
--Rich

commit a16f0cfe3ad2f02109f31333703ca6f78ed6127d
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Nov 7 17:00:45 2013 +0000

     xfstests: posix_memalign and io_submit do not set errno

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
