Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F0E897F3F
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 14:49:38 -0600 (CST)
Date: Tue, 7 Jan 2014 14:49:38 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2 0/3] xfs: add O_TMPFILE support
Message-ID: <20140107204938.GE1935@sgi.com>
References: <1387326161-24530-1-git-send-email-zwu.kernel@gmail.com>
	<20131226085134.GA32660@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131226085134.GA32660@infradead.org>
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
Cc: Zhi Yong Wu <zwu.kernel@gmail.com>, linux-api@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfs@oss.sgi.com

Hey Christoph,

On Thu, Dec 26, 2013 at 12:51:34AM -0800, Christoph Hellwig wrote:
> Both patches looks good to me,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But now we need to make sure we can exercise it, which will need
> support for tmpfile and flink commands in xfs_io.

Are you suggesting that we hold off on this until such time as the tests are
completed?
 
Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
