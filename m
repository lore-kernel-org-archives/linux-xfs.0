Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC5B229DFB
	for <xfs@oss.sgi.com>; Thu, 12 Sep 2013 09:50:45 -0500 (CDT)
Date: Thu, 12 Sep 2013 09:50:42 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch] xfs: = vs == typo in ASSERT()
Message-ID: <20130912145042.GB1935@sgi.com>
References: <20130911211731.GA10527@elgon.mountain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130911211731.GA10527@elgon.mountain>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: xfs@oss.sgi.com, Alex Elder <elder@kernel.org>, kernel-janitors@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Thu, Sep 12, 2013 at 12:17:31AM +0300, Dan Carpenter wrote:
> There is a '=' vs '==' typo so the ASSERT()s are always true.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
