Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EE9087F3F
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 08:31:47 -0500 (CDT)
Message-ID: <537DFC42.8080100@sgi.com>
Date: Thu, 22 May 2014 08:31:46 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch] [XFS] indent an if statement
References: <20140521122746.GD23396@mwanda>
	<20140521142909.GA22281@infradead.org>
	<20140521143550.GC15585@mwanda> <537CD96D.2090901@bfs.de>
	<20140522100134.GA23071@infradead.org>
In-Reply-To: <20140522100134.GA23071@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, kernel-janitors@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, walter harms <wharms@bfs.de>

On 05/22/14 05:01, Christoph Hellwig wrote:
> On Wed, May 21, 2014 at 06:50:53PM +0200, walter harms wrote:
>> This looks like a ffsll() maybe there are other implemantions and we can
>> make a generic version (acualy i found only a ffsll() in nouvou, NTL).
>
> All the helper in xfs_bit.[ch] are probably candidates for generic
> library functions.


Discussed in the thread:

  http://oss.sgi.com/archives/xfs/2014-01/msg00542.html

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
