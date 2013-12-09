Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7BB7E7F8E
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 17:07:47 -0600 (CST)
Date: Mon, 9 Dec 2013 17:07:44 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2 2/3] xfs: fix infinite loop by detaching the
	group/project hints from user dquot
Message-ID: <20131209230744.GA1935@sgi.com>
References: <5294A469.1060000@oracle.com>
	<20131128104336.GE26927@infradead.org>
	<52986001.9040101@oracle.com> <20131206210137.GT1935@sgi.com>
	<52A2B75C.3040803@oracle.com> <20131209012642.GO31386@dastard>
	<20131209023655.GQ31386@dastard>
	<20131209071003.GA2736@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131209071003.GA2736@infradead.org>
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
Cc: Jeff Liu <jeff.liu@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Dec 08, 2013 at 11:10:03PM -0800, Christoph Hellwig wrote:
> The hint removal gets my vote.  I actually had it written up the last
> time I touch the quota code, but for some reasons I stopped before
> sumitting it.

Sounds good to me too.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
